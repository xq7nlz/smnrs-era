--- @class Hero30018_Skill3 DeathJester
Hero30018_Skill3 = Class(Hero30018_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30018_Skill3:Ctor(id, hero)
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
function Hero30018_Skill3:CreateInstance(id, hero)
    return Hero30018_Skill3(id, hero)
end

--- @return void
function Hero30018_Skill3:Init()
    self.effectType = self.data.effectType
    self.effectChance = self.data.effectChance
    self.effectDuration = self.data.effectDuration
    self.effectAmount = self.data.effectAmount

    self.myHero.attackListener:BindingWithSkill_3(self)
end

---------------------------------------- BATTLE -----------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero30018_Skill3:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        if self.myHero.randomHelper:RandomRate(self.effectChance) then
            local dotEffect = EffectUtils.CreateDotEffect(self.myHero, enemyDefender, self.effectType,
                    self.effectDuration, self.effectAmount)
            enemyDefender.effectController:AddEffect(dotEffect)
        end
    end
end

return Hero30018_Skill3