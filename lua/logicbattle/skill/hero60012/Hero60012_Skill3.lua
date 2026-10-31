--- @class Hero60012_Skill3 Juan
Hero60012_Skill3 = Class(Hero60012_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60012_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    ---@type EffectType
    self.effectDotType = nil
    ---@type number
    self.effectDotAmount = nil
    ---@type number
    self.effectDotDuration = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60012_Skill3:CreateInstance(id, hero)
    return Hero60012_Skill3(id, hero)
end

--- @return void
function Hero60012_Skill3:Init()
    self.effectDotType = self.data.effectDotType
    self.effectDotAmount = self.data.effectDotAmount
    self.effectDotDuration = self.data.effectDotDuration

    self.myHero.attackListener:BindingWithSkill_3(self)
    self.myHero.skillListener:BindingWithSkill_3(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
function Hero60012_Skill3:OnDealCritDamage(enemyDefender, totalDamage)
    self:InflictEffect(enemyDefender, totalDamage)
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
function Hero60012_Skill3:OnDealSkillCritDamage(enemyDefender, totalDamage)
    self:InflictEffect(enemyDefender, totalDamage)
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
function Hero60012_Skill3:InflictEffect(enemyDefender, totalDamage)
    local dotEffect = EffectUtils.CreateDotEffect(self.myHero, enemyDefender, self.effectDotType,
            self.effectDotDuration, self.effectDotAmount)
    enemyDefender.effectController:AddEffect(dotEffect)
end

return Hero60012_Skill3