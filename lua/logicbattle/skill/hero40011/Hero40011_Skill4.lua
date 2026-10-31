--- @class Hero40011_Skill4 Neutar
Hero40011_Skill4 = Class(Hero40011_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40011_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.statBuffChance = nil
    --- @type EffectType
    self.statBuffType = nil
    --- @type number
    self.statBuffAmount = nil
    --- @type number
    self.healAmount = nil

    --- @type HeroClassType
    self.ccTriggerClass = nil
    --- @type number
    self.ccTriggerChance = 0
    --- @type EffectType
    self.ccTriggerType = nil
    --- @type number
    self.ccTriggerDuration = 0
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40011_Skill4:CreateInstance(id, hero)
    return Hero40011_Skill4(id, hero)
end

--- @return void
function Hero40011_Skill4:Init()
    self.statBuffChance = self.data.statBuffChance
    self.statBuffType = self.data.statBuffType
    self.statBuffDuration = self.data.statBuffDuration
    self.statBuffAmount = self.data.statBuffAmount
    self.healAmount = self.data.healAmount

    self.ccTriggerClass = self.data.ccTriggerClass
    self.ccTriggerChance = self.data.ccTriggerChance
    self.ccTriggerType = self.data.ccTriggerType
    self.ccTriggerDuration = self.data.ccTriggerDuration

    self.myHero.attackListener:BindingWithSkill_4(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero40011_Skill4:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    self:BuffStat()
    self:Heal()
    if dodgeType ~= DodgeType.MISS then
        self:CCTargetConditionClass(enemyDefender)
    end
end

--- @return void
function Hero40011_Skill4:BuffStat()
    local statChangerEffect = StatChanger(true)
    statChangerEffect:SetInfo(self.statBuffType, StatChangerCalculationType.PERCENT_ADD, self.statBuffAmount)

    local effect = StatChangerEffect(self.myHero, self.myHero, true)
    effect:SetDuration(self.statBuffDuration)
    effect:AddStatChanger(statChangerEffect)
    self.myHero.effectController:AddEffect(effect)
end

--- @return void
function Hero40011_Skill4:Heal()
    local amount = self.healAmount * self.myHero.attack:GetValue()
    HealUtils.Heal(self.myHero, self.myHero, amount, HealReason.HEAL_SKILL)
end

--- @return void
--- @param enemyDefender BaseHero
function Hero40011_Skill4:CCTargetConditionClass(enemyDefender)
    if enemyDefender.originInfo.class == self.ccTriggerClass and self.myHero.randomHelper:RandomRate(self.ccTriggerChance) then
        local ccEffect = EffectUtils.CreateCCEffect(self.myHero, enemyDefender, self.ccTriggerType, self.ccTriggerDuration)
        enemyDefender.effectController:AddEffect(ccEffect)
    end
end

return Hero40011_Skill4