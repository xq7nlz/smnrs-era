--- @class Hero50022_Skill3 Elf
Hero50022_Skill3 = Class(Hero50022_Skill3, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @param hero BaseHero
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50022_Skill3:CreateInstance(id, hero)
    return Hero50022_Skill3(id, hero)
end

--- @return void
function Hero50022_Skill3:Init()
    PowerUtils.GainPower(self.myHero, self.myHero, self.data.powerGainStartBattle, true)
end

return Hero50022_Skill3