--- @class Hero20012_Skill4 Sharon
Hero20012_Skill4 = Class(Hero20012_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20012_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.effectChance = 0

    --- @type EffectType
    self.effectType = 0

    --- @type number
    self.effectDuration = 0

    --- @type number
    self.effectAmount = 0
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20012_Skill4:CreateInstance(id, hero)
    return Hero20012_Skill4(id, hero)
end

--- @return void
function Hero20012_Skill4:Init()
    self.effectChance = self.data.effectChance
    self.effectType = self.data.effectType
    self.effectAmount = self.data.effectAmount
    self.effectDuration = self.data.effectDuration

    self.myHero.attackListener:BindingWithSkill_4(self)
end

----------------------------------- Battle ---------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero20012_Skill4:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS and self.myHero.randomHelper:RandomRate(self.effectChance) then
        local dotEffect = EffectUtils.CreateDotEffect(self.myHero, enemyDefender, self.effectType, self.effectDuration, self.effectAmount)
        enemyDefender.effectController:AddEffect(dotEffect)
    end
end

return Hero20012_Skill4