require "lua.client.core.network.playerData.friend.FriendRequestData"
require "lua.client.core.network.otherPlayer.OtherPlayerData"

--- @class PlayerFriendRecommendedInBound
PlayerFriendRecommendedInBound = Class(PlayerFriendRecommendedInBound)

function PlayerFriendRecommendedInBound:Ctor()
    --- @type List
    self.listFriendData = List()
    --- @type number
    self.lastRequest = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function PlayerFriendRecommendedInBound:ReadBuffer(buffer)
    --- @type PlayerFriendInBound
    local inbound = zg.playerData:GetMethod(PlayerDataMethod.FRIEND)
    local size = buffer:GetByte()
    ---@type List
    self.listFriendData = List()
    for _ = 1, size do
        ---@type FriendRequestData
        local friendRequestData = FriendRequestData.CreateByBuffer(buffer)
        if inbound == nil or inbound:IsContainFriend(friendRequestData.friendId) == false then
            self.listFriendData:Add(friendRequestData)
        end
    end
    ---@type boolean
    self.lastRequest = zg.timeMgr:GetServerTime()
    --XDebug.Log(self:ToString())
end

function PlayerFriendRecommendedInBound:IsAvailableToRequest()
    return self.lastRequest == nil
            or self.listFriendData == nil
            or (zg.timeMgr:GetServerTime() - self.lastRequest > 30)
end

--- @return void
function PlayerFriendRecommendedInBound:CheckInFriendList()
    --- @type PlayerFriendInBound
    local inbound = zg.playerData:GetMethod(PlayerDataMethod.FRIEND)
    local i = self.listFriendData:Count()
    while (i > 0) do
        ---@type FriendRequestData
        local friendRequestData = self.listFriendData:Get(i)
        if inbound:IsContainFriend(friendRequestData.friendId) == true then
            self.listFriendData:RemoveByIndex(i)
        end
        i = i - 1
    end
end

--- @return void
---@param friendId number
function PlayerFriendRecommendedInBound:RemoveFriendId(friendId)
    ---@param v FriendRequestData
    for _, v in pairs(self.listFriendData:GetItems()) do
        if v.friendId == friendId then
            self.listFriendData:RemoveByReference(v)
            break
        end
    end
end

--- @return void
function PlayerFriendRecommendedInBound:ToString()
    local str = "PlayerFriendRecommendedInBound \n"
    ---@param v FriendData
    for _, v in ipairs(self.listFriendData:GetItems()) do
        str = str .. "FriendRequestData \n" .. LogUtils.ToDetail(v)
    end
    return str
end

return PlayerFriendRecommendedInBound