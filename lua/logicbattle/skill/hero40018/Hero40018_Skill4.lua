--- @class Hero40018_Skill4 Oakroot
Hero40018_Skill4 = Class(Hero40018_Skill4, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero40018_Skill4:CreateInstance(id, hero)
    return Hero40018_Skill4(id, hero)
end

--- @return void
function Hero40018_Skill4:Init()
    self.myHero.attackListener:BindingWithSkill_4(self)
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero40018_Skill4:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        if self.myHero.randomHelper:RandomRate(self.data.effectChance) then
            local ccEffect = EffectUtils.CreateCCEffect(self.myHero, enemyDefender, self.data.effectType, self.data.effectDuration)
            enemyDefender.effectController:AddEffect(ccEffect)
        end
    end
end

return Hero40018_Skill4