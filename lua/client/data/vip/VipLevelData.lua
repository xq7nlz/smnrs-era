require "lua.client.data.Vip.VipData"

--- @class VipLevelData
VipLevelData = Class(VipLevelData)

function VipLevelData:Ctor()
    --- @type Dictionary  --<vipLevel, VipData>
    self.vipDict = nil
    ---@type number
    self.maxVip = 0

    self:ReadData()
end

function VipLevelData:ReadData()
    self.vipDict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.VIP_CONFIG_PATH)
    for i = 1, #parsedData do
        local data = VipData()
        data:ParseCsv(parsedData[i])
        self.vipDict:Add(data.vipLevel, data)
        if self.maxVip < data.vipLevel then
            self.maxVip = data.vipLevel
        end
    end
end

--- @return VipData
--- @param level number
function VipLevelData:GetCount()
    local data = self.vipDict
    if data == nil then
        XDebug.Warning(string.format("level vip is not exist: %s", tostring(level)))
    end
    return data:Count()
end

--- @return VipData
--- @param level number
function VipLevelData:GetBenefits(level)
    local data = self.vipDict:Get(level)
    if data == nil then
        XDebug.Warning(string.format("level vip is not exist: %s", tostring(level)))
    end
    return data
end

--- @return VipData
function VipLevelData:GetCurrentBenefits()
    local level = 0
    --- @type BasicInfoInBound
    local basicInfo = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    if basicInfo ~= nil then
        level = basicInfo.vipLevel
    else
        XDebug.Error("Basic info is nil")
    end
    return self:GetBenefits(level)
end


--- @param point number
function VipLevelData:GetVipLevel(point)
    local vip = 0
    ---@param vipData VipData
    for _, vipData in pairs(self.vipDict:GetItems()) do
        if vipData.vipPointRequired <= point and vip < vipData.vipLevel then
            vip = vipData.vipLevel
        end
    end
    return vip
end

--- @param method string
function VipLevelData:RequireLevelUnlock(method)
    local levelUnlock
    ---@param v VipData
    for level, v in pairs(self.vipDict:GetItems()) do
        if v[method] == true and (levelUnlock == nil or levelUnlock > level) then
            levelUnlock = level
        end
    end
    if levelUnlock == nil then
        XDebug.Error(string.format("level unlock %s can't be nil: %s", method, tostring(levelUnlock)))
    end
    return levelUnlock
end

--- @param method string
function VipLevelData:RequireLevelUnlockNextBonus(method)
    local currentCampaignBonusAutoTrainSlot = self:GetCurrentBenefits().campaignBonusAutoTrainSlot or 0
    ---@param v VipData
    for level, v in pairs(self.vipDict:GetItems()) do
        if v[method] ~= nil and v[method] > currentCampaignBonusAutoTrainSlot then
            return level
        end
    end
    return nil
end

--- @return number
function VipLevelData:RequireLevelUnlockSpeedUp()
    return self:RequireLevelUnlock("battleUnlockSpeedUp")
end

--- @return number
function VipLevelData:RequireLevelUnlockSummonAccumulate()
    return self:RequireLevelUnlock("summonUnlockAccumulate")
end

--- @return number
function VipLevelData:RequireLevelUnlockCasinoPremium()
    return self:RequireLevelUnlock("casinoUnlockPremiumSpin")
end

--- @return number
function VipLevelData:RequireLevelUnlockMultipleSpin()
    return self:RequireLevelUnlock("casinoUnlockMultipleSpin")
end

--- @return number
function VipLevelData:RequireLevelAutoNextBattle()
    return self:RequireLevelUnlock("autoNextBattle")
end

--- @return number
function VipLevelData:RequireLevelUnlockSkipArea()
    return self:RequireLevelUnlock("battleUnlockSkipArena")
end

--- @return number
function VipLevelData:RequireLevelUnlockNextBonusAutoTrainSlot()
    return self:RequireLevelUnlockNextBonus("campaignBonusAutoTrainSlot")
end

return VipLevelData