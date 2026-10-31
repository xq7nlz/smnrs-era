require "lua.client.data.Raid.RaidConfig"
require "lua.client.data.Raid.RaidRewardConfig"
require "lua.client.data.DefenderTeamData"

--- @class RaidDataConfig
RaidDataConfig = Class(RaidDataConfig)

--- @return void
function RaidDataConfig:Ctor()
    ---@type RaidConfig
    self.raidConfig = RaidConfig()
    ---@type Dictionary --<RaidRewardConfig>
    self.rewardDict = Dictionary()
    --- @type Dictionary
    self.defenderDict = Dictionary()
    --- @type table<mode, stage>
    self.power = nil
    --- @type Dictionary
    self.raidBgConfig = nil
    ---@type Dictionary  --<stage, Dictionary <tower List<AttackerTeamStageConfig>>>
    self.dictDefenderTeamStageConfig = nil

   self:InitData()
end

--- @return void
function RaidDataConfig:InitData()
    local data = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.RAID_CONFIG_PATH)
    self.raidConfig:ParseCsv(data)

    self.rewardPathDict = Dictionary()
    self.rewardPathDict:Add(1, CsvPathConstants.RAID_REWARD_GOLD_PATH)
    self.rewardPathDict:Add(2, CsvPathConstants.RAID_REWARD_MAGIC_POTION_PATH)
    self.rewardPathDict:Add(3, CsvPathConstants.RAID_REWARD_FRAGMENT_PATH)

    self.defenderPathDict = Dictionary()
    self.defenderPathDict:Add(1, CsvPathConstants.RAID_DEFENDER_GOLD_PATH)
    self.defenderPathDict:Add(2, CsvPathConstants.RAID_DEFENDER_MAGIC_POTION_PATH)
    self.defenderPathDict:Add(3, CsvPathConstants.RAID_DEFENDER_FRAGMENT_PATH)
end

function RaidDataConfig:GetDefenderMode(mode)
    local data = self.defenderDict:Get(mode)
    if data == nil then
        data = self:_GetDefenderByPath(self.defenderPathDict:Get(mode))
        self:_SetPowerMode(self:_GetPowerMode(mode), data)
        self.defenderDict:Add(mode, data)
    end
    return data
end

function RaidDataConfig:GetRewardMode(mode)
    local data = self.rewardDict:Get(mode)
    if data == nil then
        data = self:_GetRewardByPath(self.rewardPathDict:Get(mode))
        self.rewardDict:Add(mode, data)
    end
    return data
end

--- @return void
--- @param mode number
function RaidDataConfig:_GetPowerMode(mode)
    if self.power == nil then
        self.power = {}
        local data = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.RAID_DEFENDER_POWER_PATH)
        for i = 1, #data do
            local v = data[i]
            local tempMode = tonumber(v.mode)
            if self.power[tempMode] == nil then
                self.power[tempMode] = {}
            end
            self.power[tempMode][tonumber(v.stage)] = v.power
        end
    end
    return self.power[mode]
end

--- @return void
function RaidDataConfig:_SetPowerMode(powerMode, list)
    for i, v in ipairs(list:GetItems()) do
        v.powerTeam = powerMode[v.stage]
    end
end

--- @return void
--- @param path string
function RaidDataConfig:_GetRewardByPath(path)
    local list = List()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    ---@type RaidRewardConfig
    local rewardStage
    for _, v in ipairs(parsedData) do
        local stageId = tonumber(v['stage'])
        if MathUtils.IsInteger(stageId) and stageId > list:Count() then
            if list:Count() < stageId then
                rewardStage = RaidRewardConfig()
                list:Add(rewardStage)
                rewardStage:ParseCsv(v)
            else
                rewardStage = list:Get(stageId)
                rewardStage:AddReward(v)
            end
        else
            rewardStage:AddReward(v)
        end
    end
    return list
end

--- @return void
--- @param path string
function RaidDataConfig:_GetDefenderByPath(path)
    local list = List()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)

    for _, v in ipairs(parsedData) do
        local stageId = tonumber(v['stage'])
        if MathUtils.IsInteger(stageId) then
            local data = DefenderTeamData(v)
            list:Add(data)
        end
    end
    return list
end

--- @return List
---@param stage number
function RaidDataConfig:GetListDefenderTeamFragmentStageConfig(stage)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(self.defenderPathDict:Get(3))
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s", path))
        return
    end

    local defenderTeamDict = nil
    --- @type Dictionary
    self.stageDataDict = Dictionary()

    for _,v in ipairs(parsedData) do
        if v.stage ~= nil then
            local stage = tonumber(v.stage)
            ---@type Dictionary
            defenderTeamDict = Dictionary()
            self.stageDataDict:Add(stage, defenderTeamDict)
        end

        if v.wave ~= nil then
            local wave = tonumber(v.wave)
            local data = DefenderTeamData(v)
            defenderTeamDict:Add(wave, data)
        end
    end

    return self.stageDataDict:Get(stage)
end

--- @return List
---@param stage number
function RaidDataConfig:GetMaxWaveStageConfig(stage)
    return 3
end

--- @return number
--- @param mode number
--- @param stage number
function RaidDataConfig:GetBattleRaidBg(mode, stage)
    local defaultBgId = 101
    if self.raidBgConfig == nil then
        self.raidBgConfig = Dictionary()
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.RAID_BACKGROUND_CONFIG_PATH)
        local currentMode = 1
        local currentStage = 1
        for i = 1, #parsedData do
            local type = tonumber(parsedData[i].type)
            if MathUtils.IsNumber(type) == true then
                self.raidBgConfig:Add(type, Dictionary())
                currentMode = type
            end
            local stageData = tonumber(parsedData[i].stage_id)
            if MathUtils.IsNumber(stageData) == true then
                local stageBgDict = self.raidBgConfig:Get(currentMode)
                stageBgDict:Add(stageData, List())
                currentStage = stageData
                self.raidBgConfig:Add(currentMode, stageBgDict)
            end
            local bgId = tonumber(parsedData[i].background_id)
            if MathUtils.IsNumber(bgId) == true then
                local stageBgDict = self.raidBgConfig:Get(currentMode)
                --- @type List
                local listBgOfStage = stageBgDict:Get(currentStage)
                listBgOfStage:Add(bgId)
                stageBgDict:Add(currentStage, listBgOfStage)
                self.raidBgConfig:Add(currentMode, stageBgDict)
            end
        end
    end
    local modeBgDict = self.raidBgConfig:Get(mode)
    if modeBgDict ~= nil then
        --- @type List
        local listBg = modeBgDict:Get(stage)
        if listBg:Count() == 0 then
            XDebug.Error("Raid background ", mode, stage, " was not set")
            return defaultBgId
        end
        return listBg:Get(math.random(1, listBg:Count()))
    end
    return defaultBgId
end

return RaidDataConfig