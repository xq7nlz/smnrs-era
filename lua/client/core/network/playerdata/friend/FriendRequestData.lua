require "lua.client.core.network.otherPlayer.DetailTeamFormation"

--- @class FriendRequestData : OtherPlayerData
FriendRequestData = Class(FriendRequestData, OtherPlayerData)

--- @return void
function FriendRequestData:Ctor()
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
end

--- @return FriendRequestData
--- @param buffer UnifiedNetwork_ByteBuf
function FriendRequestData.CreateByBuffer(buffer)
    local data = FriendRequestData()
    data.friendId = buffer:GetLong()
    data.friendName = buffer:GetString()
    data.friendAvatar = buffer:GetInt()
    data.friendLevel = buffer:GetShort()
    data.lastLoginTime = buffer:GetLong()
    data.avatarData = AvatarData(buffer)
    return data
end