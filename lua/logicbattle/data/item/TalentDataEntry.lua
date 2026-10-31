--- @class TalentDataEntry
TalentDataEntry = Class(TalentDataEntry)

--- @return void
--- @param data table
function TalentDataEntry:Ctor(data)
    --- @type number
    self.id = tonumber(data.id)

    --- @type number
    self.tier = tonumber(data.tier)

    --- @type number
    self.level = tonumber(data.level)

    --- @type List<BaseItemOption>
    self.optionList = List()
end

--- @return void
function TalentDataEntry:Validate()
    if MathUtils.IsInteger(self.id) == false then
        assert(false)
    end

    if MathUtils.IsInteger(self.tier) == false then
        assert(false)
    end

    if MathUtils.IsInteger(self.level) == false then
        assert(false)
    end
end

--- @return void
--- @param itemOption BaseItemOption
function TalentDataEntry:AddOption(itemOption)
    self.optionList:Add(itemOption)
end

--- @return void
--- @param hero BaseHero
function TalentDataEntry:ApplyToHero(hero)
    for i = 1, self.optionList:Count() do
        ---@type BaseItemOption
        local option = self.optionList:Get(i)
        option:ApplyToHero(hero)
    end
end