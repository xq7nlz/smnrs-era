--- @class ArtifactDataEntry
ArtifactDataEntry = Class(ArtifactDataEntry)

--- @return void
--- @param data table
function ArtifactDataEntry:Ctor(data)
    --- @type number
    self.id = tonumber(data.id)

    --- @type number
    self.star = tonumber(data.star)

    --- @type number
    self.rarity = tonumber(data.rarity)

    --- @type number
    self.expRequired = tonumber(data.exp_required)

    --- @type number
    self.expGain = tonumber(data.exp_gain)

    --- @type List<BaseItemOption>
    self.optionList = List()
end

--- @return void
function ArtifactDataEntry:Validate()
    if MathUtils.IsInteger(self.id) == false then
        assert(false)
    end

    if MathUtils.IsInteger(self.star) == false then
        assert(false)
    end

    if MathUtils.IsInteger(self.rarity) == false then
        assert(false)
    end

    if MathUtils.IsInteger(self.expRequired) == false then
        assert(false)
    end

    if MathUtils.IsInteger(self.expGain) == false then
        assert(false)
    end
end

--- @return void
--- @param itemOption BaseItemOption
function ArtifactDataEntry:AddOption(itemOption)
    self.optionList:Add(itemOption)
end

--- @return void
--- @param hero BaseHero
function ArtifactDataEntry:ApplyToHero(hero)
    for i = 1, self.optionList:Count() do
        ---@type BaseItemOption
        local option = self.optionList:Get(i)
        option:ApplyToHero(hero)
    end
end