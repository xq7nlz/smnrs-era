require "lua.client.data.DefenseMode.Land.LandIdleRewardConfig"
require "lua.client.data.DefenseMode.Land.LandStageConfig"
require "lua.client.data.DefenseMode.Land.MainConstructionLevelConfig"
require "lua.client.data.DefenseMode.Land.TowerDefenseLevelConfig"
require "lua.client.data.DefenseMode.Land.DefenseFormationConfig"
require "lua.client.data.DefenseMode.Land.AttackerTeamStageConfig"

local CSV_IDLE_REWARD_PATH = "csv/defense_mode/land_%s/idle_reward.csv"
local CSV_STAGE_CONFIG_PATH = "csv/defense_mode/land_%s/instant_reward.csv"
local CSV_MAIN_CONSTRUCTION_LEVEL_PATH = "csv/defense_mode/land_%s/main_construction_level_config.csv"
local CSV_TOWER_LEVEL_PATH = "csv/defense_mode/land_%s/tower_level_config.csv"
local CSV_DEFENSE_FORMATION_PATH = "csv/defense_mode/land_%s/stage_%s/tower_config.csv"
local CSV_ATTACKER_CONFIG_PATH = "csv/defense_mode/land_%s/defender_team.csv"

--- @class LandConfig
LandConfig = Class(LandConfig)

function LandConfig:Ctor(id)
    ---@type number
    self.land = id
    ---@type Dictionary  --<stage, LandIdleRewardConfig>
    self.dictLandIdleRewardConfig = nil
    ---@type Dictionary  --<stage, LandStageConfig>
    self.dictLandStageConfig = nil
    ---@type List  --<level, MainConstructionLevelConfig>
    self.listMainConstructionLevelConfig = nil
    ---@type List  --<level, ListMoney>
    self.listTowerLevelConfig = nil
    ---@type Dictionary  --<stage, Dictionary <tower, DefenseFormationConfig>>
    self.dictDefenseFormationConfig = Dictionary()
    ---@type Dictionary  --<stage, Dictionary <tower List<AttackerTeamStageConfig>>>
    self.dictAttackerTeamStageConfig = nil
end

--- @return LandIdleRewardConfig
---@param stage number
function LandConfig:GetLandIdleRewardConfig(stage)
    if self.dictLandIdleRewardConfig == nil then
        self.dictLandIdleRewardConfig = Dictionary()
        local data = CsvReaderUtils.ReadAndParseLocalFile(string.format(CSV_IDLE_REWARD_PATH, self.land))
        ---@type LandIdleRewardConfig
        local cacheLandIdleRewardConfig = nil
        for _, v in ipairs(data) do
            if v.stage ~= nil then
                cacheLandIdleRewardConfig = LandIdleRewardConfig(v)
                self.dictLandIdleRewardConfig:Add(cacheLandIdleRewardConfig.stage, cacheLandIdleRewardConfig)
            end
            cacheLandIdleRewardConfig:AddReward(v)
        end
    end
    return self.dictLandIdleRewardConfig:Get(stage)
end

--- @return LandStageConfig
---@param stage number
function LandConfig:GetLandStageConfig(stage)
    if self.dictLandStageConfig == nil then
        self.dictLandStageConfig = Dictionary()
        local data = CsvReaderUtils.ReadAndParseLocalFile(string.format(CSV_STAGE_CONFIG_PATH, self.land))
        ---@type LandStageConfig
        local cacheLandStageConfig = nil
        for _, v in ipairs(data) do
            if v.stage ~= nil then
                cacheLandStageConfig = LandStageConfig(v)
                self.dictLandStageConfig:Add(cacheLandStageConfig.stage, cacheLandStageConfig)
            end
            cacheLandStageConfig:AddReward(v)
        end
    end
    return self.dictLandStageConfig:Get(stage)
end

--- @return MainConstructionLevelConfig
---@param level number
function LandConfig:GetMainConstructionLevelConfig(level)
    if self.listMainConstructionLevelConfig == nil then
        self.listMainConstructionLevelConfig = List()
        local data = CsvReaderUtils.ReadAndParseLocalFile(string.format(CSV_MAIN_CONSTRUCTION_LEVEL_PATH, self.land))
        ---@type MainConstructionLevelConfig
        local cache = nil
        for _, v in ipairs(data) do
            if v.level ~= nil then
                cache = MainConstructionLevelConfig(v)
                self.listMainConstructionLevelConfig:Add(cache)
            end
            cache:AddMoney(v)
        end
    end
    return self.listMainConstructionLevelConfig:Get(level)
end

--- @return TowerDefenseLevelConfig
---@param level number
function LandConfig:GetTowerDefenseLevelConfig(level)
    if self.listTowerLevelConfig == nil then
        self.listTowerLevelConfig = List()
        local data = CsvReaderUtils.ReadAndParseLocalFile(string.format(CSV_TOWER_LEVEL_PATH, self.land))
        ---@type List
        local cache = nil
        for _, v in ipairs(data) do
            if v.level ~= nil then
                cache = TowerDefenseLevelConfig(v)
                self.listTowerLevelConfig:Add(cache)
            end
            cache:AddMoney(v)
        end
    end
    return self.listTowerLevelConfig:Get(level)
end

--- @return List : AttackerTeamStageConfig
--- @param stage number
function LandConfig:GetDictAttackerTeamStageConfigAndMaxWave(stage)
    ---@type List
    local list = self.dictAttackerTeamStageConfig:Get(stage)
    if list == nil then
        list = List()
        local data = CsvReaderUtils.ReadAndParseLocalFile(string.format(CSV_ATTACKER_CONFIG_PATH, self.land))
        local cacheTower = nil
        for _, v in ipairs(data) do
            local config = AttackerTeamStageConfig(v)
            if config.tower ~= nil then
                cacheTower = config.tower
            else
                config.tower = cacheTower
            end
            ---@type List
            local listTower = list:Get(cacheTower)
            if listTower == nil then
                listTower = List()
                list:Add(cacheTower, listTower)
            end
            list:Add(config)
        end
        self.dictAttackerTeamStageConfig:Add(stage, list)
    end
    return list
end

--- @return AttackerTeamStageConfig
--- @param stage number
--- @param road number
--- @param wave number
function LandConfig:GetAttackerTeamStageConfig(stage, wave)
    return self:GetListAttackerTeamStageConfig(stage):Get(wave)
end

--- @return List
---@param stage number
function LandConfig:GetListAttackerTeamStageConfig(stage)
    if self.dictAttackerTeamStageConfig == nil then
        self.dictAttackerTeamStageConfig = Dictionary()
        local data = CsvReaderUtils.ReadAndParseLocalFile(string.format(CSV_ATTACKER_CONFIG_PATH, self.land))
        for _, v in ipairs(data) do
            local config = AttackerTeamStageConfig(v)
            local stage = config:GetStage()
            ---@type List
            local list = self.dictAttackerTeamStageConfig:Get(stage)
            if list == nil then
                list = List()
                self.dictAttackerTeamStageConfig:Add(stage, list)
            end
            list:Add(config)
        end
    end
    local list = self.dictAttackerTeamStageConfig:Get(stage)
    if list == nil then
        XDebug.Log("Null stage " .. stage)
    end
    return list
end

--- @return List
---@param stage number
function LandConfig:GetMaxWaveStageConfig(stage)
    return self:GetListAttackerTeamStageConfig(stage):Count()
end