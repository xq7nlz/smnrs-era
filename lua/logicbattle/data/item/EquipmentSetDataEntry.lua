--- @class EquipmentSetDataEntry
EquipmentSetDataEntry = Class(EquipmentSetDataEntry)

--- @return void
--- @param data table
function EquipmentSetDataEntry:Ctor(data)
    --- @type number
    self.id = tonumber(data.id)

    --- @type Dictionary<number, List<BaseItemOption>>
    --- key: set pieces count
    self.optionDict = Dictionary()

    --- @type Dictionary<number, List<BaseItemOption>>
    --- key: set pieces count
    self.optionPassiveDict = Dictionary()
end

--- @return void
function EquipmentSetDataEntry:Validate()
    if MathUtils.IsInteger(self.id) == false then
        assert(false)
    end
end

--- @return void
--- @param pieceCount number
--- @param itemOption BaseItemOption
function EquipmentSetDataEntry:AddOption(pieceCount, itemOption)
    ---@type  List<BaseItemOption>>
    local currentOptions = self.optionDict:Get(pieceCount)
    if currentOptions == nil then
        currentOptions = List()
        self.optionDict:Add(pieceCount, currentOptions)
    end

    currentOptions:Add(itemOption)
end

--- @return void
--- @param hero BaseHero
--- @param pieceCount number
function EquipmentSetDataEntry:ApplyToHero(hero, pieceCount)
    for i = 1, pieceCount do
        local optionList = self.optionDict:Get(i)
        if optionList ~= nil then
            for j = 1, optionList:Count() do
                ---@type BaseItemOption
                local option = optionList:Get(j)
                option:ApplyToHero(hero)
            end
        end
    end
end