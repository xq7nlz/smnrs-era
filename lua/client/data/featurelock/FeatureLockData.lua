--- @class FeatureLockData
FeatureLockData = Class(FeatureLockData)

--- @return void
function FeatureLockData:Ctor(feature, level, stage,server_open_day)
    --- @type number
    self.feature = feature
    --- @type number
    self.level = level
    --- @type number
    self.stage = stage
    --- @type number
    self.serverOpenDay = server_open_day
    --- @type boolean
    self.isShow = nil
end

--- @return void
--- @param data string
function FeatureLockData:ParseCsv(data)
    self.level = tonumber(data.level)
    self.stage = tonumber(data.stage)
    self.serverOpenDay = tonumber(data.server_open_day)
    if data.is_show ~= nil then
        self.isShow = MathUtils.ToBoolean(data.is_show)
    end
end