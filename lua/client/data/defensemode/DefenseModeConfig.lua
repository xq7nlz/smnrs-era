require "lua.client.data.DefenseMode.LandUnlockConfig"
require "lua.client.data.DefenseMode.Land.LandConfig"
require "lua.client.data.DefenseMode.DefenseAnimConfig"

--- @class DefenseModeConfig
DefenseModeConfig = Class(DefenseModeConfig)

function DefenseModeConfig:Ctor()
    --- @type {numberRoadMax : number}
    self._baseConfig = nil
    ---@type Dictionary  --<id, LandUnlockConfig>
    self.dictLandUnlockConfig = nil
    ---@type Dictionary  --<id, LandConfig>
    self.dictLandConfig = nil
    --- @type Dictionary
    self._defenseLandConfigDict = Dictionary()
    ---@type Dictionary  --<id, DefenderHeroStatConfig>
    self.dictDefenderHeroStatConfig = nil
    ---@type Dictionary  --<id, DefenseAnimConfig>
    self.dictShipAnimConfig = nil
    ---@type Dictionary  --<id, DefenseAnimConfig>
    self.dictTurretAnimConfig = nil
    ---@type Dictionary  --<id, DefenseAnimConfig>
    self.dictTownCenterAnimConfig = nil
end

--- @return LandUnlockConfig
---@param id number
function DefenseModeConfig:GetLandUnlockConfig(id)
    if self.dictLandUnlockConfig == nil then
        self.dictLandUnlockConfig = Dictionary()
        local data = CsvReaderUtils.ReadAndParseLocalFile("csv/defense_mode/land_config.csv")
        for _, v in ipairs(data) do
            local landUnlockConfig = LandUnlockConfig(v)
            self.dictLandUnlockConfig:Add(landUnlockConfig.id, landUnlockConfig)
        end
    end
    return self.dictLandUnlockConfig:Get(id)
end

--- @return LandConfig
---@param id number
function DefenseModeConfig:GetLandConfig(id)
    if self.dictLandConfig == nil then
        self.dictLandConfig = Dictionary()
    end
    local landConfig = self.dictLandConfig:Get(id)
    if landConfig == nil then
        landConfig = LandConfig(id)
        self.dictLandConfig:Add(id, landConfig)
    end
    return landConfig
end

--- @return Dictionary
function DefenseModeConfig:GetAllStageConfig()
    if self.dictLandConfig == nil then
        self.dictLandConfig = Dictionary()
    end
    return self.dictLandConfig
end

--- @return DefenseLandConfig
function DefenseModeConfig:GetDefenseLandConfig(land)
    --local defenseLandConfig = self._defenseLandConfigDict:Get(land)
    --if defenseLandConfig == nil then
    --    require "lua.client.data.DefenseMode.defenseBattle.DefenseLandConfig"
    --    defenseLandConfig = DefenseLandConfig(land)
    --    self._defenseLandConfigDict:Add(land, defenseLandConfig)
    --end
    return nil
end

--- @return DefenderHeroStatConfig
function DefenseModeConfig:GetDefenderHeroStatConfig(id)
    --if self.dictDefenderHeroStatConfig == nil then
    --    self.dictDefenderHeroStatConfig = Dictionary()
    --    require "lua.client.data.DefenseMode.DefenderHeroStatConfig"
    --    local data = CsvReaderUtils.ReadAndParseLocalFile(CSV_DEFENDER_HERO_PATH)
    --    for _, v in ipairs(data) do
    --        local config = DefenderHeroStatConfig(v)
    --        self.dictDefenderHeroStatConfig:Add(config.id, config)
    --    end
    --end
    return nil
end

--- @return {numberRoadMax : number}
function DefenseModeConfig:GetBaseConfig()
    if self._baseConfig == nil then
        self._baseConfig = {}
        self._baseConfig.numberRoadMax = 1
    end
    return 1
end

--- @return DefenseAnimConfig
--- @param land number
function DefenseModeConfig:GetShipAnimConfig(land)
    --if self.dictShipAnimConfig == nil then
    --    self.dictShipAnimConfig = DefenseAnimConfig.GetDictByCsvPath("csv/defense_mode/ship_anim_config.csv")
    --end
    return nil
end

--- @return DefenseAnimConfig
--- @param land number
function DefenseModeConfig:GetTurretAnimConfig(land)
    --if self.dictTurretAnimConfig == nil then
    --    self.dictTurretAnimConfig = DefenseAnimConfig.GetDictByCsvPath("csv/defense_mode/turret_anim_config.csv")
    --end
    return nil
end

--- @return DefenseAnimConfig
--- @param land number
function DefenseModeConfig:GetTowerCenterAnimConfig(land)
    --if self.dictTownCenterAnimConfig == nil then
    --    self.dictTownCenterAnimConfig = DefenseAnimConfig.GetDictByCsvPath("csv/defense_mode/tower_center_anim_config.csv")
    --end
    return nil
end

return DefenseModeConfig