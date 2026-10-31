--- @class TeamItemPredefine
TeamItemPredefine = Class(TeamItemPredefine)

--- @return void
function TeamItemPredefine:Ctor(id)
    --- @type number
    self.teamItemId = id

    --- @type Dictionary<number, Dictionary<number, number>> key: heroSlot, value: Dictionary<itemType, itemId>
    self.heroItems = Dictionary()
end

--- @return number itemId
function TeamItemPredefine:GetItem(heroSlot)
    return self.heroItems:Get(heroSlot)
end

--- @return void
--- @param data string
function TeamItemPredefine:ParseCsv(data)
    self:ValidateBeforeParseCsv(data)

    local itemType = tonumber(data.item_type)
    assert(MathUtils.IsInteger(itemType))

    for i = 1, FormationConstants.NUMBER_SLOT do
        local itemDict = self.heroItems:Get(i)
        if itemDict == nil then
            itemDict = Dictionary()
            self.heroItems:Add(i, itemDict)
        end

        local itemId = tonumber(data[PredefineConstants.HERO_SLOT .. i])
        assert(MathUtils.IsInteger(itemId))

        itemDict:Add(itemType, itemId)
    end
end

--- @return void
function TeamItemPredefine:ValidateBeforeParseCsv(data)
    if data.item_type == nil then
        assert(false)
    end
end