--- @class Hero50008_Skill4 Fanar
Hero50008_Skill4 = Class(Hero50008_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50008_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- Damage
    --- @type SubActiveSkillHelper
    self.subActiveSkillHelper = nil

    --- @type BaseTargetSelector
    self.damageTargetSelector = nil

    --- Buff
    ------ @type BaseTargetSelector
    self.buffTargetSelector = nil

    --- @type EffectType
    self.statBuffType = nil

    --- @type number
    self.statBuffAmount = nil

    --- @type number
    self.statBuffDuration = nil

    --- @type boolean
    self.isTrigger = false
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50008_Skill4:CreateInstance(id, hero)
    return Hero50008_Skill4(id, hero)
end

--- @return void
function Hero50008_Skill4:Init()
    self.statBuffType = self.data.statBuffType
    self.statBuffDuration = self.data.statBuffDuration
    self.statBuffAmount = self.data.statBuffAmount

    self.damageTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    self.buffTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPositionBuff,
            TargetTeamType.ALLY, self.data.targetNumberBuff)

    self.subActiveSkillHelper = SubActiveSkillHelper(self)
    self.subActiveSkillHelper:SetInfo(self.data.damage)

    local listener = EventListener(self.myHero, self, self.OnHeroDead)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_DEAD, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData table
function Hero50008_Skill4:OnHeroDead(eventData)
    if eventData.target == self.myHero then
        if self.isTrigger == false then
            self.isTrigger = true
            local targetList = self.damageTargetSelector:SelectTarget(self.myHero.battle)
            self.subActiveSkillHelper:UseSubActiveSkill(targetList)

            self:BuffStat()
        end
    end
end

--- @return void
function Hero50008_Skill4:BuffStat()
    local targetList = self.buffTargetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)

        local statChangerEffect = StatChanger(true)
        statChangerEffect:SetInfo(self.statBuffType, StatChangerCalculationType.PERCENT_ADD, self.statBuffAmount)

        local effect = StatChangerEffect(self.myHero, target, true)
        effect:SetDuration(self.statBuffDuration)
        effect:AddStatChanger(statChangerEffect)

        target.effectController:AddEffect(effect)
        i = i + 1
    end
end

return Hero50008_Skill4