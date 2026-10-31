--- @class Hero60022_Skill4 Dead Servant
Hero60022_Skill4 = Class(Hero60022_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60022_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60022_Skill4:CreateInstance(id, hero)
    return Hero60022_Skill4(id, hero)
end

--- @return void
function Hero60022_Skill4:Init()
    self.effectChance = self.data.effectChance
    self.effectType = self.data.effectType
    self.effectDuration = self.data.effectDuration
    self.effectAmount = self.data.effectAmount

    self.myHero.attackListener:BindingWithSkill_4(self)
    self.myHero.skillListener:BindingWithSkill_4(self)
end

--- @return void
--- @param enemyTarget BaseHero
--- @param totalDamage number
function Hero60022_Skill4:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    if self.myHero.randomHelper:RandomRate(self.effectChance) then
        local dotEffect = EffectUtils.CreateDotEffect(self.myHero, enemyTarget, self.effectType, self.effectDuration, self.effectAmount)
        enemyTarget.effectController:AddEffect(dotEffect)
    end
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero60022_Skill4:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        if self.myHero.randomHelper:RandomRate(self.effectChance) then
            local dotEffect = EffectUtils.CreateDotEffect(self.myHero, enemyDefender, self.effectType, self.effectDuration, self.effectAmount)
            enemyDefender.effectController:AddEffect(dotEffect)
        end
    end
end

return Hero60022_Skill4