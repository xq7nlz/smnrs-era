--- @class GuildInfoInBound
GuildInfoInBound = Class(GuildInfoInBound)

--- @param buffer UnifiedNetwork_ByteBuf
function GuildInfoInBound:Ctor(buffer)
    --- @type number
    self.guildId = buffer:GetInt()
    --- @type string
    self.guildName = buffer:GetString()
    --- @type string
    self.guildDescription = buffer:GetString()
    --- @type number
    self.guildAvatar = buffer:GetInt()
    --- @type number
    self.guildLevel = buffer:GetByte()
    --- @type number
    self.guildExp = buffer:GetInt()
    --- @type number
    self.guildLeader = buffer:GetLong()

    --- @type number
    local sizeOfListGuildSubLeader = buffer:GetByte()
    --- @type List
    self.listGuildSubLeader = List()
    for _ = 1, sizeOfListGuildSubLeader do
        self.listGuildSubLeader:Add(buffer:GetLong())
    end

    --- @type number
    local sizeOfGuildMember = buffer:GetByte()
    self.listGuildMember = List()
    for _ = 1, sizeOfGuildMember do
        self.listGuildMember:Add(GuildMemberInBound(buffer))
    end

    self:SortGuildMemberListByRole()

    --- @type GuildRole
    self.selfRole = nil
    self:GetSelfRole()
end

function GuildInfoInBound:SortGuildMemberListByRole()
    self.listGuildMember:SortWithMethod(GuildInfoInBound.SortGuildMemberByActiveTime)

    local listGuildMember = self.listGuildMember
    for i = 1, listGuildMember:Count() do
        --- @type GuildMemberInBound
        local member = listGuildMember:Get(i)
        if member.playerId == self.guildLeader then
            listGuildMember:RemoveByIndex(i)
            listGuildMember:Insert(member, 1)
            break
        end
    end
    local listSubLeaderIndex = List()
    for i = 1, listGuildMember:Count() do
        --- @type GuildMemberInBound
        local member = listGuildMember:Get(i)
        if self.listGuildSubLeader:IsContainValue(member.playerId) == true then
            listSubLeaderIndex:Add(i)
        end
    end
    for i = listSubLeaderIndex:Count(), 1, -1 do
        local index = listSubLeaderIndex:Get(i)
        local member = self.listGuildMember:Get(index)
        self.listGuildMember:RemoveByIndex(index)
        self.listGuildMember:Insert(member, 2)
    end
end

function GuildInfoInBound:GetSelfRole()
    if PlayerSettingData.playerId == self.guildLeader then
        self.selfRole = GuildRole.LEADER
    elseif self.listGuildSubLeader:IsContainValue(PlayerSettingData.playerId) == true then
        self.selfRole = GuildRole.SUB_LEADER
    else
        self.selfRole = GuildRole.MEMBER
    end
end

--- @param key string
function GuildInfoInBound:UpdateInfoByKey(key, newValue)
    for i = 1, self.listGuildMember:Count() do
        --- @type GuildMemberInBound
        local memberInBound = self.listGuildMember:Get(i)
        if memberInBound.playerId == PlayerSettingData.playerId then
            memberInBound:UpdateInfoByKey(key, newValue)
            break
        end
    end
end

--- @param x GuildMemberInBound
--- @param y GuildMemberInBound
function GuildInfoInBound.SortGuildMemberByActiveTime(x, y)
    if x.lastLoginTimeInSec < y.lastLoginTimeInSec then
        return -1
    end
    return 1
end