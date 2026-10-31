--- @class Hero30015_Skill4 Fang
Hero30015_Skill4 = Class(Hero30015_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30015_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.effectChance = 0

    --- @type number
    self.effectType = 0

    --- @type number
    self.effectDuration = 0

    --- @type number
    self.effectAmount = 0
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30015_Skill4:CreateInstance(id, hero)
    return Hero30015_Skill4(id, hero)
end

--- @return void
function Hero30015_Skill4:Init()
    self.effectType = self.data.effectType
    self.effectChance = self.data.effectChance
    self.effectDuration = self.data.effectDuration
    self.effectAmount = self.data.effectAmount

    self.myHero.attackListener:BindingWithSkill_4(self)
end

---------------------------------------- BATTLE -----------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero30015_Skill4:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        if self.myHero.randomHelper:RandomRate(self.effectChance) then
            local dotEffect = EffectUtils.CreateDotEffect(self.myHero, enemyDefender, self.effectType,
                    self.effectDuration, self.effectAmount)
            enemyDefender.effectController:AddEffect(dotEffect)
        end
    end
end

return Hero30015_Skill4