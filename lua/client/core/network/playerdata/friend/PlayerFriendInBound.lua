require "lua.client.core.network.playerData.friend.FriendData"
require "lua.client.core.network.playerData.friend.FriendRequestData"
require "lua.client.core.network.playerData.friend.SupportHeroData"

--- @class PlayerFriendInBound
PlayerFriendInBound = Class(PlayerFriendInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function PlayerFriendInBound:ReadBuffer(buffer)
    self.listFriendData = NetworkUtils.GetListDataInBound(buffer, FriendData.CreateByBuffer)

    ---@type List
    self.listFriendId = List()
    self:Sort()

    local size = buffer:GetByte()
    ---@type Dictionary
    self.listFriendStates = Dictionary()
    for _ = 1, size do
        local friendId = buffer:GetLong()
        local friendState = buffer:GetBool()           -- true: chua send, false: da send
        self.listFriendStates:Add(friendId, friendState)
    end

    size = buffer:GetByte()
    self.supportHeroList = List()
    for i = 1, size do
        local data = SupportHeroData()
        data:ReadBuffer(buffer)
        self.supportHeroList:Add(data)
    end
    ---@type Dictionary
    self.sentFriendPoint = buffer:GetByte()
    ---@type Dictionary
    self.receivedFriendPoint = buffer:GetByte()

    ---@type List
    self.listFriendRequestData = NetworkUtils.GetListDataInBound(buffer, FriendRequestData.CreateByBuffer, buffer:GetShort())
    ---@type boolean
    self.needRequest = false
    ---@type boolean
    self.isNotificationFriendList = false
    self:_CheckNotificationFriendList()
    ---@type boolean
    self.isNotificationFriendRequest = (self.listFriendRequestData:Count() > 0)

    ---@type boolean
    self.lastRequest = zg.timeMgr:GetServerTime()

    RxMgr.notificationUiFriend:Next()
end

--- @return void
function PlayerFriendInBound:Sort()
    self.listFriendData:SortWithMethod(PlayerFriendInBound.SortByTimeLogin)
    if self.listFriendId == nil then
        self.listFriendId = List()
    else
        self.listFriendId:Clear()
    end

    ---@param v FriendData
    for i, v in ipairs(self.listFriendData:GetItems()) do
        self.listFriendId:Add(v.friendId)
    end
end

--- @return void
---@param friendId number
function PlayerFriendInBound:IsContainFriend(friendId)
    return self.listFriendId:IsContainValue(friendId)
end

--- @return void
---@param friendId number
function PlayerFriendInBound:IsContainFriendRequest(friendId)
    ---@param v FriendRequestData
    for _, v in pairs(self.listFriendRequestData:GetItems()) do
        if v.friendId == friendId then
            return true
        end
    end
    return false
end

--- @return void
---@param friendData FriendData
function PlayerFriendInBound:RemoveFriend(friendData)
    self.listFriendId:RemoveByReference(friendData.friendId)
    self.listFriendData:RemoveByReference(friendData)
end

--- @return void
---@param friendId number
function PlayerFriendInBound:BlockFriendId(friendId)
    ---@param v FriendData
    for _, v in pairs(self.listFriendData:GetItems()) do
        if v.friendId == friendId then
            self:RemoveFriend(v)
            break
        end
    end

    ---@param v FriendRequestData
    for _, v in pairs(self.listFriendRequestData:GetItems()) do
        if v.friendId == friendId then
            self.listFriendRequestData:RemoveOneByReference(v)
            break
        end
    end
end

--- @return void
function PlayerFriendInBound:ToString()
    local str = "PlayerFriendInBound \n"
    ---@param v FriendData
    for _, v in ipairs(self.listFriendData:GetItems()) do
        str = str .. "listFriendData \n" .. LogUtils.ToDetail(v)
    end
    ---@param v boolean
    for _, v in ipairs(self.listFriendStates:GetItems()) do
        str = str .. "listFriendStates \n" .. LogUtils.ToDetail(v)
    end
    ---@param v FriendRequestData
    for _, v in ipairs(self.listFriendRequestData:GetItems()) do
        str = str .. "listFriendRequestData \n" .. LogUtils.ToDetail(v)
    end
    return str
end

--- @return void
function PlayerFriendInBound:_CheckNotificationFriendList()
    self.isNotificationFriendList = false
    ---@type FriendConfig
    local friendConfig = ResourceMgr.GetFriendConfig()
    if self.receivedFriendPoint < friendConfig.friendPointDailyLimit then
        ---@param v FriendData
        for _, v in pairs(self.listFriendData:GetItems()) do
            if v.stateClaimFriendPoint == RewardState.AVAILABLE_TO_CLAIM then
                self.isNotificationFriendList = true
                break
            end
        end
    end
    if self.isNotificationFriendList == false and self.sentFriendPoint < friendConfig.friendPointDailyLimit then
        ---@param v FriendData
        for _, v in pairs(self.listFriendData:GetItems()) do
            if self.listFriendStates:Get(v.friendId) ~= false then
                self.isNotificationFriendList = true
                break
            end
        end
    end
end

--- @return void
function PlayerFriendInBound:CheckNotificationFriendList()
    self:_CheckNotificationFriendList()
    RxMgr.notificationUiFriend:Next()
    return self.isNotificationFriendList
end

--- @return void
function PlayerFriendInBound:AddSupportHero(inventoryId)
    local data = SupportHeroData()
    ---@type HeroResource
    local heroResource = InventoryUtils.GetHeroResourceByInventoryId(inventoryId)
    data.inventoryId = inventoryId
    data.heroId = heroResource.heroId
    data.star = heroResource.heroStar
    data.registerTime = zg.timeMgr:GetServerTime()

    self.supportHeroList:Add(data)
end

--- @return FriendData
function PlayerFriendInBound:GetFriendDataByFriendId(friendId)
    for i = 1, self.listFriendData:Count() do
        --- @type FriendData
        local friendData = self.listFriendData:Get(i)
        if friendData.friendId == friendId then
            return friendData
        end
    end
    return nil
end

--- @return void
function PlayerFriendInBound:RemoveSupportHero(inventoryId)
    for i = 1, self.supportHeroList:Count() do
        ---@type SupportHeroData
        local supportHero = self.supportHeroList:Get(i)
        if supportHero.inventoryId == inventoryId then
            self.supportHeroList:RemoveByIndex(i)
            return
        end
    end
end

--- @return SupportHeroData
function PlayerFriendInBound:GetSupportHeroWithInventoryId(inventoryId)
    for i = 1, self.supportHeroList:Count() do
        ---@type SupportHeroData
        local supportHero = self.supportHeroList:Get(i)
        if supportHero.inventoryId == inventoryId then
            return supportHero
        end
    end
    return nil
end

--- @return SupportHeroData
function PlayerFriendInBound:IsInHeroSupport(inventoryId)
    for i = 1, self.supportHeroList:Count() do
        ---@type SupportHeroData
        local supportHero = self.supportHeroList:Get(i)
        if supportHero.inventoryId == inventoryId then
            return true
        end
    end
    return false
end

--- @return void
function PlayerFriendInBound:CheckNotificationFriendRequest()
    self.isNotificationFriendRequest = (self.listFriendRequestData:Count() > 0)
    RxMgr.notificationUiFriend:Next()
    return self.isNotificationFriendRequest
end

function PlayerFriendInBound:IsActiveNotification()
    return self.needRequest or self.isNotificationFriendList or self.isNotificationFriendRequest
end

function PlayerFriendInBound.Validate(callback)
    --- @type PlayerFriendInBound
    local inbound = zg.playerData:GetMethod(PlayerDataMethod.FRIEND)
    if inbound == nil or inbound.needRequest == true or zg.timeMgr:GetServerTime() - inbound.lastRequest > 10then
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.FRIEND }, function()
            callback()
        end)
    else
        callback()
    end
end

--- @return number
---@param x FriendData
---@param y FriendData
function PlayerFriendInBound.SortByTimeLogin(x, y)
    if y.lastLoginTime < x.lastLoginTime then
        return 1
    else
        return -1
    end
end
