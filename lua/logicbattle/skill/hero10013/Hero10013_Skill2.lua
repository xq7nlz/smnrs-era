--- @class Hero10013_Skill2 Oceanee
Hero10013_Skill2 = Class(Hero10013_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10013_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type EffectType
    self.effectType = nil
    --- @type number
    self.effectDuration = nil
    --- @type StatType
    self.effectAffectStat = nil
    --- @type number
    self.effectAmount = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10013_Skill2:CreateInstance(id, hero)
    return Hero10013_Skill2(id, hero)
end

--- @return void
function Hero10013_Skill2:Init()
    self.bonusBasicAttack = self.data.bonusBasicAttack
    self.effectTriggerClass = self.data.effectTriggerClass
    self.effectType = self.data.effectType
    self.effectChance = self.data.effectChance
    self.effectDuration = self.data.effectDuration

    self.myHero.attackListener:BindingWithSkill_2(self)
    self.myHero.battleHelper:SetBasicAttackMultiplier(self.myHero.battleHelper.basicAttackMultiplier * (1 + self.bonusBasicAttack))
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero10013_Skill2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        self:InflictEffect(enemyDefender)
    end
end

--- @return void
--- @param target BaseHero
function Hero10013_Skill2:InflictEffect(target)
    if target.originInfo.class == self.effectTriggerClass and self.myHero.randomHelper:RandomRate(self.effectChance) then
        local ccEffect = EffectUtils.CreateCCEffect(self.myHero, target, self.effectType, self.effectDuration)
        target.effectController:AddEffect(ccEffect)
    end
end

return Hero10013_Skill2