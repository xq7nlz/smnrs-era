require("lua.client.data.FeatureLock.FeatureLockData")

local ACCOUNT_MINOR_FEATURE_LOCK = "csv/account/account_minor_feature_lock.csv"

--- @class MinorFeatureLock
MinorFeatureLock = Class(MinorFeatureLock)

function MinorFeatureLock:Ctor()
    --- @type Dictionary  --<FeatureType, FeatureLockData>
    self.dict = nil
    self:ReadData()
end

function MinorFeatureLock:ReadData()
    self.dict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(ACCOUNT_MINOR_FEATURE_LOCK)
    for i = 1, #parsedData do
        local data = parsedData[i]
        ---@type FeatureLockData
        local featureLock = FeatureLockData(tonumber(data.minor_feature_type))
        featureLock:ParseCsv(data)
        self.dict:Add(featureLock.feature, featureLock)
    end
end

---@return FeatureLockData
---@param feature FeatureType
function MinorFeatureLock:GetQuestDataByStar(feature)
    return self.dict:Get(feature)
end

return MinorFeatureLock