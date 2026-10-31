require "lua.client.core.network.otherPlayer.DetailTeamFormation"
require "lua.client.core.network.otherPlayer.OtherPlayerData"

--- @class FriendData : OtherPlayerData
FriendData = Class(FriendData, OtherPlayerData)

--- @return void
function FriendData:Ctor()
    --- @type number
    self.friendId = nil
    --- @type string
    self.friendName = nil
    --- @type number
    self.friendAvatar = nil
    --- @type number
    self.friendLevel = nil
    --- @type number
    self.lastLoginTime = nil
    --- @type RewardState
    self.stateClaimFriendPoint = nil
end

--- @return FriendData
--- @param buffer UnifiedNetwork_ByteBuf
function FriendData.CreateByBuffer(buffer)
    local data = FriendData()
    data.friendId = buffer:GetLong()
    data.friendName = buffer:GetString()
    data.friendAvatar = buffer:GetInt()
    data.friendLevel = buffer:GetShort()
    data.lastLoginTime = buffer:GetLong()
    data.avatarData = AvatarData(buffer)
    data.stateClaimFriendPoint = buffer:GetByte()
    return data
end