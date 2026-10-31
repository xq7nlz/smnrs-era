--- @class DefenseAnimConfig
DefenseAnimConfig = Class(DefenseAnimConfig)

function DefenseAnimConfig:Ctor(parsedData)
    ---@type number
    self.land = tonumber(parsedData.land)
    ---@type number
    self.frame = tonumber(parsedData.frame)
    ---@type number
    self.effectType = parsedData.effect_type
    ---@type number
    self.effectName = parsedData.effect_name
    ---@type number
    self.impactType = parsedData.impact_type
    ---@type number
    self.impactName = parsedData.impact_name
    ---@type number
    self.explosionType = parsedData.explosion_type
    ---@type number
    self.explosionName = parsedData.explosion_name
end

---@return Dictionary
---@param path string
function DefenseAnimConfig.GetDictByCsvPath(path)
    local dict = Dictionary()
    local data = CsvReaderUtils.ReadAndParseLocalFile(path)
    for _, v in ipairs(data) do
        local config = DefenseAnimConfig(v)
        dict:Add(config.land, config)
    end
    return dict
end