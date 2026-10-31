--- @class Hero10012_Skill3 Assassiren
Hero10012_Skill3 = Class(Hero10012_Skill3, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10012_Skill3:CreateInstance(id, hero)
    return Hero10012_Skill3(id, hero)
end

function Hero10012_Skill3:Init()
    PowerUtils.GainPower(self.myHero, self.myHero, self.data.powerStat, true)
end

return Hero10012_Skill3