--- @class Hero50023_Skill3 Dancer
Hero50023_Skill3 = Class(Hero50023_Skill3, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @param hero BaseHero
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50023_Skill3:CreateInstance(id, hero)
    return Hero50023_Skill3(id, hero)
end

--- @return void
function Hero50023_Skill3:Init()
    self.myHero.attackListener:BindingWithSkill_3(self)
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero50023_Skill3:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        if self.myHero.randomHelper:RandomRate(self.data.effectChance) then
            local ccEffect = EffectUtils.CreateCCEffect(self.myHero, enemyDefender, self.data.effectType, self.data.effectDuration)
            enemyDefender.effectController:AddEffect(ccEffect)
        end
    end
end

return Hero50023_Skill3