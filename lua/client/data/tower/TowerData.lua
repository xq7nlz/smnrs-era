require "lua.client.data.Tower.TowerRewardConfig"
require "lua.client.data.Tower.TowerLevelConfig"

--- @class TowerData
TowerData = Class(TowerData)

function TowerData:Ctor()
    --- @type number
    self.maxStamina = nil
    --- @type number
    self.staminaGemPrice = nil
    --- @type number
    self.staminaRefreshInterval = nil
    --- @type TowerLevelConfig
    self.levelConfig = nil
    --- @type TowerRewardConfig
    self.rewardConfig = nil
    --- @type number
    self.maxFloor = nil
    --- @type Dictionary
    self.towerBgConfig = nil

    self:InitData()
end

function TowerData:InitData()
    self:_InitConfig()
    self:_InitLevelConfig()
    self:_InitBackgroundConfig()
end

function TowerData:_InitConfig()
    local parseData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.TOWER_CONFIG_PATH)
    self.maxStamina = tonumber(parseData[1]['max_stamina'])
    self.staminaGemPrice = tonumber(parseData[1]['stamina_gem_price'])
    self.staminaRefreshInterval = tonumber(parseData[1]['stamina_regen_interval'])
end

function TowerData:_InitLevelConfig()
    local parseData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.TOWER_LEVEL_DESIGN_PATH)
    self.levelConfig = TowerLevelConfig()
    self.levelConfig:ParseCsv(parseData)
    self.maxFloor = #parseData
end

function TowerData:_InitBackgroundConfig()
    self.towerBgConfig = Dictionary()
    local parseData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.TOWER_BACKGROUND_CONFIG_PATH)
    for i = 1, #parseData do
        local floor = tonumber(parseData[i].floor)
        local backgroundId = tonumber(parseData[i].background_id)
        if MathUtils.IsNumber(backgroundId) then
            self.towerBgConfig:Add(floor, backgroundId)
        end
    end
end

--- @return DefenderTeamData
--- @param levelId number
function TowerData:GetLevelConfig(levelId)
    return self.levelConfig:GetTowerLevelConfigById(levelId)
end

--- @return boolean,number
--- @param levelId number
function TowerData:IsValidLevel(levelId)
    local playerLevel = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).level
    local isValid,levelRequire = self.levelConfig:IsValidTower(playerLevel,levelId)
    return isValid,levelRequire
end

--- @return List<ItemIconData>
--- @param levelId number
function TowerData:GetReward(levelId)
    if self.rewardConfig == nil then
        local rewardContent = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.TOWER_REWARD_PATH)
        self.rewardConfig = TowerRewardConfig()
        self.rewardConfig:ParseCsv(rewardContent)
    end
    return self.rewardConfig:GetTowerRewardById(levelId)
end

--- @return boolean
function TowerData:CanRegain()
    local moneyValue = InventoryUtils.GetMoney(MoneyType.TOWER_STAMINA)
    return moneyValue < self.maxStamina
end

--- @return string, string
function TowerData:GetBackgroundByFloor(floorId)
    local bgAnchorTop
    local bgAnchorBot
    local bgId = self.towerBgConfig:Get(floorId)
    if bgId ~= nil then
        bgAnchorTop = "background_" .. bgId
        bgAnchorBot = "back_anchor_bot_" .. bgId
    else
        bgAnchorTop = "tower_anchor_top"
        bgAnchorBot = "tower_anchor_bot"
    end
    return bgAnchorTop, bgAnchorBot
end

return TowerData