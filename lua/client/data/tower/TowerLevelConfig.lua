require "lua.client.data.DefenderTeamData"
require "lua.client.data.Tower.TowerLockConfig"
--- @class TowerLevelConfig
TowerLevelConfig = Class(TowerLevelConfig)

function TowerLevelConfig:Ctor()
    --- @type Dictionary<number, table>
    self._dataDictionary = Dictionary()
    --- @type List --<number, table>
    self.levelLockConfig = List()
    ---- @type number
    self.maxLevelRequire = 0
end

--- @data string
function TowerLevelConfig:ParseCsv(parsedData)
    for k, v in ipairs(parsedData) do
        local levelId = tonumber(v[PredefineConstants.STAGE_TAG])
        if MathUtils.IsInteger(levelId) then
            local data = DefenderTeamData(v)
            self._dataDictionary:Add(data.stage, data)
        end
    end
    self:_InitPowerTeam()
    self:_InitLevelLock()
end

--- @return void
function TowerLevelConfig:_InitPowerTeam()
    local data = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.TOWER_DEFENDER_POWER_PATH)
    for i = 1, #data do
        local v = data[i]
        self._dataDictionary:Get(tonumber(v.stage)).powerTeam = v.power
    end
end

--- @return DefenderTeamData
function TowerLevelConfig:GetTowerLevelConfigById(levelId)
    if self._dataDictionary:IsContainKey(levelId) == true then
        return self._dataDictionary:Get(levelId)
    end
    XDebug.Error(string.format("No tower level config: %d", levelId))
    return 0
end
--- @return boolean,number
--- @param currentPlayerLevel number
function TowerLevelConfig:IsValidTower(currentPlayerLevel,level)
    if self.levelLockConfig:Count() <= 0 then
         self:_InitLevelLock()
    end
    if currentPlayerLevel >= self.maxLevelRequire then
        return true
    end
    for i = 1, self.levelLockConfig:Count() do
        --- @type TowerLockConfig
        local lockConfig = self.levelLockConfig:Get(i)
        if level <= lockConfig.max then
            if currentPlayerLevel >= lockConfig.levelRequire  then
                return true,lockConfig.levelRequire
            else
                return false,lockConfig.levelRequire
            end
        end
    end
    return false,self.maxLevelRequire
end

--- @return void
function TowerLevelConfig:_InitLevelLock()
    local data = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.TOWER_LOCK_CONFIG_PATH)
    for i = 1, #data do
        local v = data[i]
        local level = tonumber(v.summoner_require_level)
        self.levelLockConfig:Add(TowerLockConfig(
                level,
                tonumber(v.tower_stage_min),
                tonumber(v.tower_stage_max)))
        self.maxLevelRequire = level
    end
end