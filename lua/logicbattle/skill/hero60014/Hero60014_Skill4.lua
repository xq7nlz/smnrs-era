--- @class Hero60014_Skill4 ShiShil
Hero60014_Skill4 = Class(Hero60014_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60014_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type EffectType
    self.effectType = nil
    --- @type number
    self.effectChance = nil
    --- @type number
    self.effectDuration = nil
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60014_Skill4:CreateInstance(id, hero)
    return Hero60014_Skill4(id, hero)
end

--- @return void
function Hero60014_Skill4:Init()
    self.effectType = self.data.effectType
    self.effectChance = self.data.effectChance
    self.effectDuration = self.data.effectDuration

    self.myHero.attackListener:BindingWithSkill_4(self)
end

----------------------------------- Calculate -------------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero60014_Skill4:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        if self.myHero.randomHelper:RandomRate(self.effectChance) then
            local ccEffect = EffectUtils.CreateCCEffect(self.myHero, enemyDefender, self.effectType, self.effectDuration)
            enemyDefender.effectController:AddEffect(ccEffect)
        end
    end
end

return Hero60014_Skill4