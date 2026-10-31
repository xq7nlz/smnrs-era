--- @class IdleEffectDataEntry
IdleEffectDataEntry = Class(IdleEffectDataEntry)

--- @return void
--- @param data table
function IdleEffectDataEntry:Ctor(data)
    --- @type number
    self.id = tonumber(data.id)

    --- @type number
    self.rarity = tonumber(data.rarity)

    --- @type List<BaseItemOption>
    self.optionList = List()
end

--- @return void
function IdleEffectDataEntry:Validate()
    if MathUtils.IsInteger(self.id) == false then
        assert(false)
    end

    if MathUtils.IsInteger(self.rarity) == false then
        assert(false)
    end
end

--- @return void
--- @param itemOption BaseItemOption
function IdleEffectDataEntry:AddOption(itemOption)
    self.optionList:Add(itemOption)
end

--- @return void
--- @param hero BaseHero
function IdleEffectDataEntry:ApplyToHero(hero)
    for i = 1, self.optionList:Count() do
        ---@type BaseItemOption
        local option = self.optionList:Get(i)
        option:ApplyToHero(hero)
    end
end