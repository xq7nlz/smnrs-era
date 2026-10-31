--- @class Hero60023_Skill4 Tauren
Hero60023_Skill4 = Class(Hero60023_Skill4, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60023_Skill4:CreateInstance(id, hero)
    return Hero60023_Skill4(id, hero)
end

--- @return void
function Hero60023_Skill4:Init()
    self.effectChance = self.data.effectChance
    self.effectType = self.data.effectType
    self.effectDuration = self.data.effectDuration

    self.myHero.attackListener:BindingWithSkill_4(self)
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero60023_Skill4:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        if self.myHero.randomHelper:RandomRate(self.effectChance) then
            local ccEffect = EffectUtils.CreateCCEffect(self.myHero, enemyDefender, self.effectType, self.effectDuration)
            enemyDefender.effectController:AddEffect(ccEffect)
        end
    end
end

return Hero60023_Skill4