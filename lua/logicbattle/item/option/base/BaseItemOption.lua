--- @class BaseItemOption
BaseItemOption = Class(BaseItemOption)

--- @return void
--- @param type ItemOptionType
--- @param data table
function BaseItemOption:Ctor(type, data)
    --- @type ItemOptionType
    self.type = type

    --- @type List<string>
    self.params = List()

    self:ParseCsv(data)
end

--- @return void
--- @param data table
function BaseItemOption:ParseCsv(data)
    for i = 1, ItemConstants.ITEM_OPTION_MAX_PARAM do
        local tag = "option_param_" .. i
        if TableUtils.IsContainKey(data, tag) then
            self.params:Add(data[tag])
        else
            self.params:Add(nil)
        end
    end
end

--- @return string
--- @param paramId number
function BaseItemOption:GetOptionParam(paramId)
    if paramId >= 1 and paramId <= self.params:Count() then
        return self.params:Get(paramId)
    end

    return nil
end

--- @return void
function BaseItemOption:Validate()
    assert(false, "this method should be overridden by child class")
end

--- @return boolean
--- @param hero BaseHero
function BaseItemOption:IsCanApplyToHero(hero)
    assert(false, "this method should be overridden by child class")
end

--- @return void
--- @param hero BaseHero
function BaseItemOption:ApplyToHero(hero)
    assert(false, "this method should be overridden by child class")
end

--- @return string
function BaseItemOption:ToString()
    local result = string.format("type = %s", self.type)
    result = result .. self.params:ToString()

    return result
end