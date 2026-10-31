--- @class Hero40012_Skill3 Lothiriel
Hero40012_Skill3 = Class(Hero40012_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40012_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    ---@type number
    self.silenceDuration = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40012_Skill3:CreateInstance(id, hero)
    return Hero40012_Skill3(id, hero)
end

--- @return void
function Hero40012_Skill3:Init()
    self.silenceDuration = self.data.silenceDuration
    self.silenceChance = self.data.silenceChance
    self.myHero.attackListener:BindingWithSkill_3(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
function Hero40012_Skill3:OnDealCritDamage(enemyDefender, totalDamage)
    self:InflictEffect(enemyDefender, totalDamage)
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
function Hero40012_Skill3:InflictEffect(enemyDefender, totalDamage)
    if self.myHero.randomHelper:RandomRate(self.silenceChance) then
        local silenceEffect = SilenceEffect(self.myHero, enemyDefender, self.silenceDuration)
        enemyDefender.effectController:AddEffect(silenceEffect)
    end

end

return Hero40012_Skill3