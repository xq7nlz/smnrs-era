--- @class Hero40024_Skill3 Wugushi
Hero40024_Skill3 = Class(Hero40024_Skill3, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero40024_Skill3:CreateInstance(id, hero)
    return Hero40024_Skill3(id, hero)
end

--- @return void
function Hero40024_Skill3:Init()
    self.myHero.attackListener:BindingWithSkill_3(self)
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero40024_Skill3:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        local dotRate
        if enemyDefender.originInfo.class == self.data.affectedHeroClass then
            dotRate = self.data.effectChanceSpecial
        else
            dotRate = self.data.effectChanceNormal
        end

        if self.myHero.randomHelper:RandomRate(dotRate) then
            local dotEffect = EffectUtils.CreateDotEffect(self.myHero, enemyDefender, self.data.effectType,
                    self.data.effectDuration, self.data.effectAmount)
            enemyDefender.effectController:AddEffect(dotEffect)
        end
    end
end

return Hero40024_Skill3