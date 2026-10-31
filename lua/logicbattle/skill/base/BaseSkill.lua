--- @class BaseSkill
BaseSkill = Class(BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function BaseSkill:Ctor(id, hero)
    --- @type number
    self.id = id

    --- @type BaseHero
    self.myHero = hero

    --- @type BaseSkillData
    self.data = nil

    --- @type number
    self.skillLevel = nil
end

---------------------------------------- Initialization ----------------------------------------
--- Order of method call: CreateInstance -> SetData -> Init

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function BaseSkill:CreateInstance(id, hero)
    assert(false, "this method should be overridden by child class")
end

--- @return void
--- @param skillLevel number
--- @param data BaseSkillData
function BaseSkill:SetData(skillLevel, data)
    self.skillLevel = skillLevel
    self.data = data

    self.skillName = data.name
end

--- @return void
--- this method is called after all stats of hero is calculated
function BaseSkill:Init()
    --- override this method if needed
end

---------------------------------------- Calculate Active skill ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function BaseSkill:UseActiveSkill()
    assert(false, "this method should be overridden by child class")
end

--- @return string
function BaseSkill:ToString()
    return string.format("Skill [Hero: %s, id: %s, data: %s]",
            self.myHero:ToString(), self.id, LogUtils.ToDetail(self.data))
end