--- @class StoneDataEntry
StoneDataEntry = Class(StoneDataEntry)

--- @return void
--- @param data table
function StoneDataEntry:Ctor(data)
    --- @type number
    self.id = tonumber(data.id)

    --- @type number
    self.group = tonumber(data.group)

    --- @type number
    self.subId = tonumber(data.sub_id)

    --- @type number
    self.rate = tonumber(data.rate)

    --- @type number
    self.rarity = tonumber(data.rarity)

    --- @type number
    self.star = tonumber(data.star)

    --- @type List<BaseItemOption>
    self.optionList = List()
end

--- @return void
function StoneDataEntry:Validate()
    if MathUtils.IsInteger(self.id) == false then
        assert(false)
    end

    if MathUtils.IsInteger(self.group) == false then
        assert(false)
    end

    if MathUtils.IsInteger(self.subId) == false then
        assert(false)
    end

    if MathUtils.IsInteger(self.rate) == false then
        assert(false)
    end

    if MathUtils.IsInteger(self.rarity) == false then
        assert(false)
    end

    if MathUtils.IsInteger(self.star) == false then
        assert(false)
    end
end

--- @return void
--- @param itemOption BaseItemOption
function StoneDataEntry:AddOption(itemOption)
    self.optionList:Add(itemOption)
end

--- @return void
--- @param hero BaseHero
function StoneDataEntry:ApplyToHero(hero)
    for i = 1, self.optionList:Count() do
        ---@type BaseItemOption
        local option = self.optionList:Get(i)
        option:ApplyToHero(hero)
    end
end