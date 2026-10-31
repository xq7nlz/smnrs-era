--- @class BaseSkillData
BaseSkillData = Class(BaseSkillData)

--- @return void
function BaseSkillData:Ctor()
    --- Override if needed

    --- @type string
    self.skillName = nil
end

--- @return BaseSkillData
function BaseSkillData:CreateInstance()
    assert(false, "this method should be overridden by child class")
end

--- @return void
--- @param skillName string
function BaseSkillData:SetName(skillName)
    self.skillName = skillName
end

--- @return void
--- @param parsedData table
function BaseSkillData:ValidateBeforeParseCsv(parsedData)
    assert(false, "this method should be overridden by child class")
end

--- @return void
--- @param parsedData table
function BaseSkillData:ParseCsv(parsedData)
    assert(false, "this method should be overridden by child class")
end

return BaseSkillData
