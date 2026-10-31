require "lua.client.data.Equipment.StoneCostConfig"

local ITEM_STONE_COST_PATH = "csv/item/stone_cost.csv"

--- @class EquipmentConfig
EquipmentConfig = Class(EquipmentConfig)

--- @return void
function EquipmentConfig:Ctor()
    --- @type Dictionary --<groupId, StoneCostConfig>
    self.stoneCostDictionary = self:GetStoneCostDictionary()
    --- @type number
    self.maxGroupStone = 1
    for i, v in pairs(ResourceMgr.GetServiceConfig():GetItems().stoneDataEntries:GetItems()) do
        if v.group > self.maxGroupStone then
            self.maxGroupStone = v.group
        end
    end
end

--- @return Dictionary<key, value>
function EquipmentConfig:GetStoneCostDictionary()
    local dict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(ITEM_STONE_COST_PATH)
    for i = 1, #parsedData do
        ---@type StoneCostConfig
        local data = StoneCostConfig()
        data:ParseCsv(parsedData[i])
        dict:Add(data.group, data)
    end
    return dict
end

return EquipmentConfig