--- @class Hero30027_Skill2 : BaseSkill
Hero30027_Skill2 = Class(Hero30027_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30027_Skill2:Ctor(id, hero)
    --- @type Hero30027_Skill2
    self.data = nil
    BaseSkill.Ctor(self, id, hero)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30027_Skill2:CreateInstance(id, hero)
    return Hero30027_Skill2(id, hero)
end

--- @return void
function Hero30027_Skill2:Init()
    self.deductPowerAmount = self.data.deductPowerAmount
    self.maxExchangeAmount = self.data.maxExchange

    self.myHero.attackListener:BindingWithSkill_2(self)
    self.myHero.skillListener:BindingWithSkill_2(self)

    self.myHero.attack:BindingWithSkill_2(self)
    self.myHero.battleHelper:BindingWithSkill_2(self)
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero30027_Skill2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        PowerUtils.GainPower(self.myHero, enemyDefender, -self.deductPowerAmount, false)
    end
end

--- @return void
--- @param enemyTarget BaseHero
--- @param totalDamage number
function Hero30027_Skill2:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    PowerUtils.GainPower(self.myHero, enemyTarget, -self.deductPowerAmount, false)
end

--- @return Number
--- @param originAttack number
function Hero30027_Skill2:CalculateExchangeAttack(originAttack)
    local percentBonus = self.myHero.critRate:GetValue() / self.data.exchangePercent * self.data.targetPercent
    if percentBonus > self.maxExchangeAmount then
        percentBonus = self.maxExchangeAmount
    end

    return originAttack * percentBonus
end

return Hero30027_Skill2