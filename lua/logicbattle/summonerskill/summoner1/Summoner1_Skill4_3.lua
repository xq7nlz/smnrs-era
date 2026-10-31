--- @class Summoner1_Skill4_3 : BaseSkill Mage
Summoner1_Skill4_3 = Class(Summoner1_Skill4_3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner1_Skill4_3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    ---@type BaseTargetSelector
    self.buffTargetSelector = nil
    ---@type BaseTargetSelector
    self.damageTargetSelector = nil

    --- @type MainSubActiveSkillHelper
    self.mainSubActiveSkillHelper = nil

    ---@type Dictionary<BaseHero,number>
    self.dictCountTrigger = Dictionary()

    ---@type boolean
    self.isChooseTarget = false
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner1_Skill4_3:CreateInstance(id, hero)
    return Summoner1_Skill4_3(id, hero)
end

--- @return void
function Summoner1_Skill4_3:Init()
    self.buffTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.buffTargetPosition,
            TargetTeamType.ALLY, self.data.buffTargetNumber)
    self.damageTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.damageTargetPosition,
            TargetTeamType.ENEMY, self.data.damageTargetNumber)

    self.statBuffType = self.data.statBuffType
    self.statBuffCalculation = self.data.statBuffCalculation
    self.statBuffAmount = self.data.statBuffAmount
    self.damage = self.data.damage
    self.countTrigger = self.data.countTrigger

    local listenerSkill = EventListener(self.myHero, self, self.OnHeroUseSkill)
    self.myHero.battle.eventManager:AddListener(EventType.USE_ACTIVE_SKILL, listenerSkill)

    local listenerBasicAttack = EventListener(self.myHero, self, self.OnHeroBasicAttack)
    self.myHero.battle.eventManager:AddListener(EventType.DO_BASIC_ATTACK, listenerBasicAttack)

    self.mainSubActiveSkillHelper = MainSubActiveSkillHelper(self)
    self.myHero.battleListener:BindingWithSkill_4(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param round BattleRound
function Summoner1_Skill4_3:OnStartBattleRound(round)
    if self.isChooseTarget == false then
        self.isChooseTarget = true
        local targetList = self.buffTargetSelector:SelectTarget(self.myHero.battle)
        local i = 1
        while i <= targetList:Count() do
            local ally = targetList:Get(i)
            local statBuff = StatChanger(true)
            statBuff:SetInfo(self.statBuffType, self.statBuffCalculation, self.statBuffAmount)

            --- @type BaseEffect
            local effectChanger = StatChangerEffect(self.myHero, ally, true)
            effectChanger:SetPersistentType(EffectPersistentType.PERMANENT)
            effectChanger:AddStatChanger(statBuff)
            ally.effectController:AddEffect(effectChanger)
            self.dictCountTrigger:Add(ally, 0)
            i = i + 1
        end
    end
end

--- @return void
--- @param eventData table
function Summoner1_Skill4_3:OnHeroBasicAttack(eventData)
    --- @type BaseHero
    local attacker = eventData.initiator
    self:CountTrigger(attacker)
end

--- @return void
--- @param eventData table
function Summoner1_Skill4_3:OnHeroUseSkill(eventData)
    --- @type BaseHero
    local attacker = eventData.initiator
    self:CountTrigger(attacker)
end

---@return void
---@param attacker BaseHero
function Summoner1_Skill4_3:CountTrigger(attacker)
    if self.dictCountTrigger:IsContainKey(attacker) then
        local number = self.dictCountTrigger:Get(attacker) + 1
        if number >= self.countTrigger then
            local listTarget = self.damageTargetSelector:SelectTarget(self.myHero.battle)
            local damageMulti = self.damage * attacker.attack:GetValue() / self.myHero.attack:GetValue()
            self.mainSubActiveSkillHelper:SetInfo(damageMulti)
            self.mainSubActiveSkillHelper:UseMainSubActiveSkill(listTarget)
            number = 0
        end
        self.dictCountTrigger:Add(attacker, number)
    end
end

return Summoner1_Skill4_3