require("lua.client.data.FeatureLock.FeatureLockData")

local ACCOUNT_MAJOR_FEATURE_LOCK = "csv/account/account_major_feature_lock.csv"

--- @class MajorFeatureLock
MajorFeatureLock = Class(MajorFeatureLock)

function MajorFeatureLock:Ctor()
    --- @type Dictionary  --<FeatureType, FeatureLockData>
    self.dict = nil
    self:ReadData()
end

function MajorFeatureLock:ReadData()
    self.dict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(ACCOUNT_MAJOR_FEATURE_LOCK)
    for i = 1, #parsedData do
        local data = parsedData[i]
        ---@type FeatureLockData
        local featureLock = FeatureLockData(tonumber(data.feature_type))
        featureLock:ParseCsv(data)
        self.dict:Add(featureLock.feature, featureLock)
    end
end

---@return FeatureLockData
---@param feature FeatureType
function MajorFeatureLock:GetFeatureLockConfig(feature)
    return self.dict:Get(feature)
end

return MajorFeatureLock