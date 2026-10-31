--- @class BaseSkillHelper
BaseSkillHelper = Class(BaseSkillHelper)

--- @return void
--- @param skill BaseSkill
function BaseSkillHelper:Ctor(skill)
    --- @type BaseSkill
    self.skill = skill

    --- @type BaseHero
    self.myHero = skill.myHero

    --- @type BaseSkillData
    self.data = skill.data

    --- @type string
    self.skillName = skill.data.skillName
end