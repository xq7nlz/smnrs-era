--- @class Summoner2_Skill4_3 : BaseSkill Warrior
Summoner2_Skill4_3 = Class(Summoner2_Skill4_3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner2_Skill4_3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    ---@type BaseTargetSelector
    self.buffTargetSelector = nil
    ---@type BaseTargetSelector
    self.damageTargetSelector = nil

    ---@type boolean
    self.isChooseTarget = false
    ---@type Dictionary<BaseHero,number>
    self.countTrigger = Dictionary()
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner2_Skill4_3:CreateInstance(id, hero)
    return Summoner2_Skill4_3(id, hero)
end

--- @return void
function Summoner2_Skill4_3:Init()
    self.damagePercentHp = self.data.damagePercentHp
    self.maxTrigger = self.data.maxTrigger

    self.statBuffType = self.data.statBuffType
    self.statBuffCalculation = self.data.statBuffCalculation
    self.statBuffAmount = self.data.statBuffAmount

    self.buffTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.buffTargetPosition,
            TargetTeamType.ALLY, self.data.buffTargetNumber)

    self.damageTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.damageTargetPosition,
            TargetTeamType.ENEMY, self.data.damageTargetNumber)

    local listener = EventListener(self.myHero, self, self.OnHeroTakeDamage)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_TAKE_DAMAGE, listener)

    self.mainSubActiveSkillHelper = MainSubActiveSkillHelper(self)
    self.myHero.battleListener:BindingWithSkill_4(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param round BattleRound
function Summoner2_Skill4_3:OnStartBattleRound(round)
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
            self.countTrigger:Add(ally, 0)
            i = i + 1
        end
    end
end

--- @return void
--- @param eventData table
function Summoner2_Skill4_3:OnHeroTakeDamage(eventData)
    local reason = eventData.reason
    if reason == TakeDamageReason.ATTACK_DAMAGE or reason == TakeDamageReason.SKILL_DAMAGE then
        self:CountTrigger(eventData.target)
    end
end

---@return void
---@param target BaseHero
function Summoner2_Skill4_3:CountTrigger(target)
    if self.countTrigger:IsContainKey(target) then
        if target:IsBoss() == false then
            local number = self.countTrigger:Get(target) + 1
            if number >= self.maxTrigger then
                local listTarget = self.damageTargetSelector:SelectTarget(self.myHero.battle)
                local damageMulti = self.damagePercentHp * target.hp:GetValue() / self.myHero.attack:GetValue()
                self.mainSubActiveSkillHelper:SetInfo(damageMulti)
                self.mainSubActiveSkillHelper:UseMainSubActiveSkill(listTarget)
                number = 0
            end
            self.countTrigger:Add(target, number)
        else
            self.countTrigger:Add(target, 0)
        end
    end
end

return Summoner2_Skill4_3