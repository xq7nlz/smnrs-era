require "lua.client.core.network.playerData.common.MoneyInBound"
require "lua.client.core.network.playerData.AvatarData"

--- @class BasicInfoInBound
BasicInfoInBound = Class(BasicInfoInBound)

--- @return void
function BasicInfoInBound:Ctor()
    
    self:InitListener()
    self.level = 1
end

--- @param buffer UnifiedNetwork_ByteBuf
function BasicInfoInBound:ReadBuffer(buffer)
    self.name = buffer:GetString()
    self.country = buffer:GetString()
    self.language = buffer:GetString()
    self.avatar = buffer:GetInt()
    self.avatarId, self.borderId = ClientConfigUtils.GetAvatarId(self.avatar)
    self.level = buffer:GetShort()
    self.lastLevel = self.level

    self.sizeOfMoney = buffer:GetByte()
    self.moneyList = List()
    for _ = 1, self.sizeOfMoney do
        self.moneyList:Add(MoneyInBound(buffer))
    end

    self.createdTime = buffer:GetLong()
    self.lastLoginTime = buffer:GetLong()
    self.role = buffer:GetByte()
    self.numberChangeName = buffer:GetShort()
    self.vipLevel = buffer:GetByte()
    --- @type AvatarData
    self.avatarData = AvatarData(buffer)

    self:InitMoney()
    self:InitTracking()

    NetworkUtils.CheckRequestChangeLanguage()

    FeatureConfigInBound.VISUAL_UPDATED = false
end

function BasicInfoInBound:InitTracking()
    TrackingUtils.SetSummonerLevel(self.level)
    TrackingUtils.AddFirebaseProperty(FBProperties.VIP, self.vipLevel)
    TrackingUtils.AddFirebaseProperty(FBProperties.SERVER_ID, PlayerSettingData.serverId)
    TrackingUtils.AddFirebaseProperty(FBProperties.PLAYER_ID, PlayerSettingData.playerId)
end

--- @return void
function BasicInfoInBound:InitMoney()
    ---@type ClientResourceDict
    local moneyDict = zg.playerData:GetInventoryData():Get(ResourceType.Money)
    local lastFriendStamina = moneyDict:Get(MoneyType.FRIEND_STAMINA)
    moneyDict:Clear()
    --- @param money MoneyInBound
    for _, money in ipairs(self.moneyList:GetItems()) do
        moneyDict:InitResource(money.moneyType, money.value)
    end
    -- TODO need check in future
    ---@type PlayerFriendInBound
    --local playerFriendInBound = zg.playerData:GetMethod(PlayerDataMethod.FRIEND)
    --if lastFriendStamina ~= nil and lastFriendStamina ~= moneyDict:Get(MoneyType.FRIEND_STAMINA) and playerFriendInBound ~= nil then
    --    playerFriendInBound.timeOfStaminaRegen = nil
    --    playerFriendInBound.needRequest = true
    --end
end

--- @return void
function BasicInfoInBound:InitListener()
    self.listener = RxMgr.changeResource:Subscribe(RxMgr.CreateFunction(self, self._OnChangeResource))
end

--- @return void
function BasicInfoInBound:RemoveListener()
    if self.listener ~= nil then
        self.listener:Unsubscribe()
        self.listener = nil
    end
end

--- @return void
--- @param data table
---{['resourceType'] = self.type, ['resourceId'] = resourceId, ['quantity'] = quantity, ['result'] = self._resourceDict:Get(resourceId)})
function BasicInfoInBound:_OnChangeResource(data)
    if data.resourceType == ResourceType.SummonerExp then
        self:OnExpChange(data.result)
    elseif data.resourceType == ResourceType.Money then
        if data.resourceId == MoneyType.VIP_POINT then
            self:OnVipCoinChange(data.result)
        end
    end
end

function BasicInfoInBound:OnExpChange(exp)
    local loop = true
    local subExp = 0
    local currentLevel = self.level
    while loop and self.level < ResourceMgr.GetMainCharacterConfig().mainCharacterExpDictionary:Count() do
        ---@type MainCharacterExpConfig
        local mainCharacterExp = ResourceMgr.GetMainCharacterConfig().mainCharacterExpDictionary:Get(self.level + 1)
        if exp - subExp >= mainCharacterExp.exp and self.level < ResourceMgr.GetMainCharacterConfig().mainCharacterExpDictionary:Count() then
            self.level = self.level + 1
            subExp = subExp + mainCharacterExp.exp
        else
            loop = false
        end
    end
    if subExp > 0 then
        InventoryUtils.Sub(ResourceType.SummonerExp, 0, subExp)
    end
    if currentLevel ~= self.level then
        TrackingUtils.SetSummonerLevel(self.level)
        zg.playerData:UpdatePlayerInfoOnOthersUI("level", self.level)
        RxMgr.levelUp:Next(self.level)
    end
end

function BasicInfoInBound:OnVipCoinChange(value)
    local vip = ResourceMgr.GetVipConfig():GetVipLevel(value)
    if self.vipLevel < vip then
        self.vipLevel = vip
        RxMgr.vipLevelUp:Next(self.vipLevel)
        TrackingUtils.AddFirebaseProperty(FBProperties.VIP, self.vipLevel)
    end
end

--- @return string
function BasicInfoInBound:ToString()
    return string.format("All[%s] Money[%s]", LogUtils.ToDetail(self), LogUtils.ToDetail(self.moneyList:GetItems()))
end