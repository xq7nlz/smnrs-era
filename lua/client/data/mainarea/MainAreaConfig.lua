BUILDING_PERSPECTIVE_CONFIG = "csv/client/perspective_building_config.csv"

--- @class MainAreaConfig
MainAreaConfig = Class(MainAreaConfig)

function MainAreaConfig:Ctor()
    --- @type table
    self.building = nil
    self:InitBuilding()
end

function MainAreaConfig:InitBuilding()
    self.building = {}
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(BUILDING_PERSPECTIVE_CONFIG)
    for i = 1, #parsedData do
        --- @type {offsetX, mul}
        local config = {}
        config.offsetX = tonumber(parsedData[i].offset_x)
        config.mul = tonumber(parsedData[i].mul)
        self.building[parsedData[i].building] = config
    end
end

function MainAreaConfig:GetBuilding()
    return self.building
end

return MainAreaConfig