require "lua.client.data.Tower.TowerRewardConfig"
require "lua.client.data.Tower.TowerLevelConfig"
require "lua.client.data.KazetsuTower.KazetsuTowerLevelConfig"
--- @class KazetsuTowerData
KazetsuTowerData = Class(KazetsuTowerData)

function KazetsuTowerData:Ctor()
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

function KazetsuTowerData:InitData()
    self:_InitConfig()
    self:_InitLevelConfig()
    self:_InitBackgroundConfig()
end

function KazetsuTowerData:_InitConfig()
    local parseData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.KAZETSU_TOWER_CONFIG_PATH)
    self.maxStamina = tonumber(parseData[1]['max_stamina'])
    self.staminaGemPrice = tonumber(parseData[1]['stamina_gem_price'])
    self.staminaRefreshInterval = tonumber(parseData[1]['stamina_regen_interval'])
end

function KazetsuTowerData:_InitLevelConfig()
    local parseData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.KAZETSU_TOWER_LEVEL_DESIGN_PATH)
    self.levelConfig = KazetsuTowerLevelConfig()
    self.levelConfig:ParseCsv(parseData)
    self.maxFloor = #parseData
end

function KazetsuTowerData:_InitBackgroundConfig()
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
function KazetsuTowerData:GetLevelConfig(levelId)
    return self.levelConfig:GetTowerLevelConfigById(levelId)
end

--- @return List<ItemIconData>
--- @param levelId number
function KazetsuTowerData:GetReward(levelId)
    if self.rewardConfig == nil then
        local rewardContent = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.TOWER_REWARD_PATH)
        self.rewardConfig = TowerRewardConfig()
        self.rewardConfig:ParseCsv(rewardContent)
    end
    return self.rewardConfig:GetTowerRewardById(levelId)
end

--- @return boolean
function KazetsuTowerData:CanRegain()
    local moneyValue = InventoryUtils.GetMoney(MoneyType.TOWER_STAMINA)
    return moneyValue < self.maxStamina
end

--- @return string, string
function KazetsuTowerData:GetBackgroundByFloor(floorId)
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

return KazetsuTowerData