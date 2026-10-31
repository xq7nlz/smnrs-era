--- @class GuildWarPlayerInBound
GuildWarPlayerInBound = Class(GuildWarPlayerInBound)

function GuildWarPlayerInBound:Ctor()
    --- @type number
    self.power = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function GuildWarPlayerInBound:ReadBuffer(buffer)
    self.compactPlayerInfo = OtherPlayerInfoInBound.CreateByBuffer(buffer)
    self.isSelectedForGuildWar = buffer:GetBool()
    self.positionInGuildWarBattle = buffer:GetByte()
    self.medalClaimByPosDict = Dictionary()
    local sizeOfAttackMedal = buffer:GetByte()
    for _ = 1, sizeOfAttackMedal do
        local position = buffer:GetByte()
        local medalClaimed = buffer:GetByte()
        self.medalClaimByPosDict:Add(position, medalClaimed)
    end
    self.medalHoldDefense = buffer:GetByte()
    self.power = nil
end

function GuildWarPlayerInBound:GetPower()
    if self.power == nil then
        --- @type BattleTeamInfo
        local battleTeamInfo = self.compactPlayerInfo:CreateBattleTeamInfo(self.compactPlayerInfo.playerLevel)
        self.power = ClientConfigUtils.GetPowerByBattleTeamInfo(battleTeamInfo, false)
    end
    return self.power
end

--- @param buffer UnifiedNetwork_ByteBuf
function GuildWarPlayerInBound.CreateByBuffer(buffer)
    local guildWarPlayerInBound = GuildWarPlayerInBound()
    guildWarPlayerInBound:ReadBuffer(buffer)
    return guildWarPlayerInBound
end

--- @param x GuildWarPlayerInBound
--- @param y GuildWarPlayerInBound
function GuildWarPlayerInBound.SortMemberByLevel(x, y)
    if x.compactPlayerInfo.playerLevel > y.compactPlayerInfo.playerLevel then
        return -1
    end
    return 1
end

--- @param x GuildWarPlayerInBound
--- @param y GuildWarPlayerInBound
function GuildWarPlayerInBound.SortMemberByPower(x, y)
    if x:GetPower() > y:GetPower() then
         return -1
    end
    return 1
end