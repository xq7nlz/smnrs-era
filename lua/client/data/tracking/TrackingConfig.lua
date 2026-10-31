--- @class TrackingConfig
TrackingConfig = Class(TrackingConfig)

local TRACKING_PATH = "csv/client/tracking/tracking.csv"

--- @return void
function TrackingConfig:Ctor()
    ---@type List
    self.listPVE = List()
    --- @type List
    self.listPack = List()
    --- @type List
    self.listLevel = List()

    self:Init()
end

function TrackingConfig:Init()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(TRACKING_PATH)
    for i = 1, #parsedData do
        if parsedData[i].stage_id ~= nil then
            self.listPVE:Add(tonumber(parsedData[i].stage_id))
        end

        if parsedData[i].pack_id ~= nil then
            self.listPack:Add(parsedData[i].pack_id)
        end

        if parsedData[i].level ~= nil then
            self.listLevel:Add(tonumber(parsedData[i].level))
        end
    end

    --XDebug.Log(self:ToString())
end

--- @return boolean
---@param stageId number
function TrackingConfig:IsContainPVE(stageId)
    return self.listPVE:IsContainValue(stageId)
end

--- @return boolean
---@param packId string
function TrackingConfig:IsContainPack(packId)
    return self.listPack:IsContainValue(packId)
end

--- @return boolean
---@param level number
function TrackingConfig:IsContainLevel(level)
    return self.listLevel:IsContainValue(level)
end

function TrackingConfig:ToString()
    local str = "pve: "
    for i, v in ipairs(self.listPVE:GetItems()) do
        str = string.format("%s ,%s", str, v)
    end
    str = str .. "\npack: "
    for i, v in ipairs(self.listPack:GetItems()) do
        str = string.format("%s ,%s", str, v)
    end
    str = str .. "\nlevel: "
    for i, v in ipairs(self.listLevel:GetItems()) do
        str = string.format("%s ,%s", str, v)
    end
    return str
end

return TrackingConfig