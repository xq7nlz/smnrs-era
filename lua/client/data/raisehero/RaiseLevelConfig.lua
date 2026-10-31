require "lua.client.data.RaiseHero.BaseRaiseHeroData"
require "lua.client.data.RaiseHero.SlotRaiseData"

local RAISE_LEVEL_BASE_PATH = "csv/raise_hero/base_config.csv"
local RAISE_LEVEL_SLOT_PATH = "csv/raise_hero/slot_config.csv"
local RAISE_LEVEL_UNLOCK_SLOT_PATH = "csv/raise_hero/unlock_slot_price.csv"

--- @class RaiseLevelConfig
RaiseLevelConfig = Class(RaiseLevelConfig)

function RaiseLevelConfig:Ctor()
    ---@type BaseRaiseHeroData
    self.baseRaiseData = nil
    ---@type SlotRaiseData
    self.slotRaiseData = nil

    ---@type Dictionary
    self.unlockDic = nil
end

--- @return BaseRaiseHeroData
function RaiseLevelConfig:GetBaseConfig()
    if self.baseRaiseData == nil then
        local parseData = CsvReaderUtils.ReadAndParseLocalFile(RAISE_LEVEL_BASE_PATH)
        local data = parseData[1]
        self.baseRaiseData = BaseRaiseHeroData(data)
    end
    return self.baseRaiseData
end
--- @return SlotRaiseData
function RaiseLevelConfig:GetSlotConfig()
    if self.slotRaiseData == nil then
        local parseData = CsvReaderUtils.ReadAndParseLocalFile(RAISE_LEVEL_SLOT_PATH)
        local data = parseData[1]
        self.slotRaiseData = SlotRaiseData(data)
    end
    return self.slotRaiseData
end

---@type Dictionary
function RaiseLevelConfig:GetUnlockPriceConfig()
    if self.unlockDic == nil then
        self.unlockDic = Dictionary()
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(RAISE_LEVEL_UNLOCK_SLOT_PATH)
        local listReward
        for i = 1, #parsedData do
            local slot = tonumber(parsedData[i].slot)
            if slot == nil then
                listReward:Add(RewardInBound.CreateBySingleParam(ResourceType.Money,parsedData[i].money_type, parsedData[i].money_value))
            else
                listReward = List()
                listReward:Add(RewardInBound.CreateBySingleParam(ResourceType.Money,parsedData[i].money_type, parsedData[i].money_value))
                self.unlockDic:Add(slot, listReward)
            end
        end
    end
    return self.unlockDic
end

---@return List
function RaiseLevelConfig:GetUnLockPriceWithId(id)
    local priceDict = self:GetUnlockPriceConfig()
    if priceDict:IsContainKey(id) then
        return priceDict:Get(id)
    end
    return nil
end
return RaiseLevelConfig