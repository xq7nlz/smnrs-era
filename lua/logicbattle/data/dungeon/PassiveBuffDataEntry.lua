--- @class PassiveBuffDataEntry
PassiveBuffDataEntry = Class(PassiveBuffDataEntry)

--- @return void
--- @param data table
function PassiveBuffDataEntry:Ctor(data)
    --- @type number
    self.id = tonumber(data.id)

    --- @type number
    self.limit = tonumber(data.limit)

    --- @type number
    self.rarity = tonumber(data.rarity)

    --- @type List --<BaseItemOption>
    self.optionList = List()

end

--- @return void
function PassiveBuffDataEntry:Validate()
    if MathUtils.IsInteger(self.id) == false then
        assert(false)
    end

    if MathUtils.IsInteger(self.limit) == false then
        assert(false)
    end

    if MathUtils.IsInteger(self.rarity) == false then
        assert(false)
    end
end

--- @return void
--- @param buffOption BaseItemOption
function PassiveBuffDataEntry:AddOption(buffOption)
    self.optionList:Add(buffOption)
end

--- @return void
--- @param hero BaseHero
function PassiveBuffDataEntry:ApplyToHero(hero, buffNumber)
    for i = 1, self.optionList:Count() do
        ---@type BaseItemOption
        local option = TableUtils.Clone(self.optionList:Get(i))
        option.amount = option.amount * buffNumber
        option:ApplyToHero(hero)
    end
end