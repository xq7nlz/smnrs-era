--- @class Hero60003_Skill2 ShadowBlade
Hero60003_Skill2 = Class(Hero60003_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60003_Skill2:Ctor(id, hero)
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
function Hero60003_Skill2:CreateInstance(id, hero)
    return Hero60003_Skill2(id, hero)
end

--- @return void
function Hero60003_Skill2:Init()
    self.effectType = self.data.effectType
    self.effectChance = self.data.effectChance
    self.effectDuration = self.data.effectDuration
    self.effectAmount = self.data.effectAmount

    self.myHero.attackListener:BindingWithSkill_2(self)
    self.myHero.skillListener:BindingWithSkill_2(self)
end

---------------------------------------- BATTLE -----------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero60003_Skill2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        if self.myHero.randomHelper:RandomRate(self.effectChance) then
            local dotEffect = EffectUtils.CreateDotEffect(self.myHero, enemyDefender, self.effectType, self.effectDuration, self.effectAmount)
            enemyDefender.effectController:AddEffect(dotEffect)
        end
    end
end

--- @return void
--- @param enemyTarget BaseHero
--- @param totalDamage number
function Hero60003_Skill2:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    if self.myHero.randomHelper:RandomRate(self.effectChance) then
        local dotEffect = EffectUtils.CreateDotEffect(self.myHero, enemyTarget, self.effectType, self.effectDuration, self.effectAmount)
        enemyTarget.effectController:AddEffect(dotEffect)
    end
end

return Hero60003_Skill2