require "lua.client.core.network.guild.GuildLogActionType"
require "lua.client.config.const.GuildRole"
require "lua.client.core.network.guild.GuildInfoInBound"
require "lua.client.core.network.guild.GuildMemberInBound"
require "lua.client.core.network.guild.GuildSearchInfo"
require "lua.client.core.network.guild.GuildDungeonDefenderTeamInBound"
require "lua.client.core.network.guild.GuildDungeonStatisticsInBound"
require "lua.client.core.network.guild.GuildDungeonStatisticsGetInBound"
require "lua.client.core.network.guild.GuildRequest"

--- @class GuildBasicInfoInBound
GuildBasicInfoInBound = Class(GuildBasicInfoInBound)
GuildBasicInfoInBound.KEY_CHECK_IN_GUILD_DUNGEON = "guild_check_in_dungeon_season"

function GuildBasicInfoInBound:Ctor()
    --- @type boolean
    self.isAvailableToCheckIn = nil
    --- @type number
    self.lastTimeRequest = nil
    self.serverKickListener = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function GuildBasicInfoInBound:ReadBuffer(buffer)
    --- @type boolean
    self.isHaveGuild = buffer:GetBool()
    --- @type GuildInfoInBound
    self.guildInfo = nil
    if self.isHaveGuild == true then
        self.guildInfo = GuildInfoInBound(buffer)
    end
    self.lastLeaveGuildInSec = buffer:GetLong()
    self.lastCheckIn = buffer:GetLong()
    self.lastChallengeBoss = buffer:GetLong()
    self.lastChallengeDungeon = buffer:GetLong()

    self.lastTimeRequest = zg.timeMgr:GetServerTime()

    if self.isHaveGuild == true then
        self:CheckCheckInStatus()
        self:CheckGuildDungeonStamina()
        self:CheckGuildBossStamina()
    end
    self:ListenToServerKick()
end

function GuildBasicInfoInBound.IsAvailableToRequest()
    --- @type GuildBasicInfoInBound
    local guildBasicInfoInBound = zg.playerData:GetMethod(GuildBasicInfoInBound.GetPlayerDataMethod())
    return guildBasicInfoInBound == nil
            or guildBasicInfoInBound.lastTimeRequest == nil
            or (zg.timeMgr:GetServerTime() - guildBasicInfoInBound.lastTimeRequest) > TimeUtils.SecondAMin
end

--- @return boolean
--- @param playerId number
--- @param bonusGuildExp number
function GuildBasicInfoInBound:SetCheckInMember(playerId, bonusGuildExp)
    local serverTime = zg.timeMgr:GetServerTime()
    if playerId == PlayerSettingData.playerId then
        self.lastCheckIn = serverTime
    end
    local selfGuildMemberInBound = self:FindMemberById(playerId)
    selfGuildMemberInBound.lastCheckInTimeInSec = serverTime

    self.guildInfo.guildExp = self.guildInfo.guildExp + bonusGuildExp
    return self.guildInfo.guildExp >= self:GetMaxExpToRaiseLevel()
end

--- @return number
function GuildBasicInfoInBound:GetMaxExpToRaiseLevel()
    local nextLevel = math.min(self.guildInfo.guildLevel + 1, ResourceMgr.GetGuildDataConfig().guildLevel:GetGuildMaxLevel())
    --- @type GuildLevelUnit
    local guildNextLevelUnit = ResourceMgr.GetGuildDataConfig().guildLevel:GetGuildLevelUnitConfig(nextLevel)
    return guildNextLevelUnit.exp
end

--- @return GuildMemberInBound
--- @param playerId number
function GuildBasicInfoInBound:FindMemberById(playerId)
    local listGuildMember = self.guildInfo.listGuildMember
    for i = 1, listGuildMember:Count() do
        --- @type GuildMemberInBound
        local guildMemberInBound = listGuildMember:Get(i)
        if guildMemberInBound.playerId == playerId then
            return guildMemberInBound
        end
    end
end

--- @return GuildRole
--- @param memId number
function GuildBasicInfoInBound:GetMemberRoleById(memId)
    if memId == self.guildInfo.guildLeader then
        return GuildRole.LEADER
    elseif self.guildInfo.listGuildSubLeader:IsContainValue(memId) then
        return GuildRole.SUB_LEADER
    else
        return GuildRole.MEMBER
    end
end

--- @param playerId number
function GuildBasicInfoInBound:OnKickMember(playerId)
    local listGuildMember = self.guildInfo.listGuildMember
    for i = 1, listGuildMember:Count() do
        --- @type GuildMemberInBound
        local guildMember = listGuildMember:Get(i)
        if guildMember.playerId == playerId then
            listGuildMember:RemoveByIndex(i)
            break
        end
    end
end

--- @param playerId number
--- @param newRole GuildRole
function GuildBasicInfoInBound:OnChangeMemberRole(playerId, newRole)
    local listGuildMember = self.guildInfo.listGuildMember
    --- @type GuildMemberInBound
    local memberInListMember
    for i = 1, listGuildMember:Count() do
        --- @type GuildMemberInBound
        local guildMember = listGuildMember:Get(i)
        if guildMember.playerId == playerId then
            memberInListMember = guildMember
            break
        end
    end
    if memberInListMember == nil then
        XDebug.Error(string.format("Member not found!!: %s", playerId))
        return
    end
    if newRole == GuildRole.SUB_LEADER then
        self.guildInfo.listGuildSubLeader:Add(memberInListMember.playerId)
    elseif newRole == GuildRole.MEMBER then
        self.guildInfo.listGuildSubLeader:RemoveByReference(memberInListMember.playerId)
    end
    self.guildInfo:SortGuildMemberListByRole()
end

--- @param playerId number
function GuildBasicInfoInBound:GetMemberIndexById(playerId)
    local listGuildMember = self.guildInfo.listGuildMember
    for i = 1, listGuildMember:Count() do
        --- @type GuildMemberInBound
        local guildMember = listGuildMember:Get(i)
        if guildMember.playerId == playerId then
            return i
        end
    end
end

--- @return GuildMemberInBound
--- @param index number
function GuildBasicInfoInBound:GetMemberByIndex(index)
    return self.guildInfo.listGuildMember:Get(index)
end

--- @return GuildMemberInBound
--- @param memberId number
function GuildBasicInfoInBound:GetMemberInfoById(memberId)
    for i = 1, self.guildInfo.listGuildMember:Count() do
        --- @type GuildMemberInBound
        local guildMemberInBound = self.guildInfo.listGuildMember:Get(i)
        if guildMemberInBound.playerId == memberId then
            return guildMemberInBound
        end
    end
    return nil
end

--- @param key string
function GuildBasicInfoInBound:UpdateInfoByKey(key, newValue)
    if self.guildInfo ~= nil then
        self.guildInfo:UpdateInfoByKey(key, newValue)
    end
end

--- @param memberId number
--- @param newRole GuildRole
--- @param onSuccess function
--- @param onFailed function
function GuildBasicInfoInBound.RequestChangeMemberRole(memberId, newRole, onSuccess, onFailed)
    onFailed = onFailed or SmartPoolUtils.LogicCodeNotification
    local onReceived = function(result)
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.GUILD_MEMBER_ROLE_CHANGE, UnknownOutBound.CreateInstance(PutMethod.Long, memberId, PutMethod.Byte, newRole), onReceived)
end

function GuildBasicInfoInBound:CheckCheckInStatus()
    local secFromStartDay = TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime())
    self.isAvailableToCheckIn = self.lastCheckIn < secFromStartDay
end

function GuildBasicInfoInBound:CheckGuildDungeonStamina()
    local maxStamina = ResourceMgr.GetGuildDungeonConfig():GetGeneralGuildDungeonConfig().max_guild_dungeon_stamina
    local currentStamina = InventoryUtils.GetMoney( MoneyType.GUILD_DUNGEON_STAMINA)
    if currentStamina < maxStamina then
        local timeStartDay = TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime())
        local lastTimeCheckIn = self.lastChallengeDungeon
        if timeStartDay > lastTimeCheckIn then
            local addedStamina = maxStamina - currentStamina
            InventoryUtils.Add(ResourceType.Money, MoneyType.GUILD_DUNGEON_STAMINA, addedStamina)
        end
    end
end

function GuildBasicInfoInBound:CheckGuildBossStamina()
    local maxStamina = ResourceMgr.GetGuildBossConfig():GetCommonGuildBossConfig().maxGuildBossStamina
    local currentStamina = InventoryUtils.GetMoney(MoneyType.GUILD_BOSS_STAMINA)
    if currentStamina < maxStamina then
        local timeStartDay = TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime())
        local lastTimeCheckIn = self.lastChallengeBoss
        if timeStartDay > lastTimeCheckIn then
            local addedStamina = maxStamina - currentStamina
            InventoryUtils.Add(ResourceType.Money, MoneyType.GUILD_BOSS_STAMINA, addedStamina)
        end
    end
end

--- @return boolean
function GuildBasicInfoInBound:CheckNotifyGuild()
    --- @type EventInBound
    local eventInBound = zg.playerData:GetEvents()
    --- @type EventPopupModel
    local eventDungeon = eventInBound:GetEvent(EventTimeType.GUILD_DUNGEON)
    local isGuildDungeonOpen = eventDungeon:IsOpening()
    return self.isAvailableToCheckIn
            or (InventoryUtils.GetMoney(MoneyType.GUILD_DUNGEON_STAMINA) > 0 and isGuildDungeonOpen)
            or InventoryUtils.GetMoney(MoneyType.GUILD_BOSS_STAMINA) > 0
end

--- @param callback function
--- @param forceUpdate boolean
function GuildBasicInfoInBound.Validate(callback, forceUpdate)
    if GuildBasicInfoInBound.IsAvailableToRequest() or forceUpdate then
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.GUILD_BASIC_INFO }, callback)
    else
        callback()
    end
end

function GuildBasicInfoInBound:CheckLeaderNotification(callbackNotification)
    if callbackNotification == nil then
        XDebug.Error("Callback notification nil")
        return
    end
    if self.guildInfo ~= nil and self.guildInfo.selfRole == GuildRole.MEMBER then
        callbackNotification(false)
        return
    end

    local onRequestSuccess = function()
        local isNotifyGuild
        local onNotifiedGuildApplication = function(isNotified)
            isNotifyGuild = isNotifyGuild or isNotified
            if isNotifyGuild == false then
                self:_CheckGuildLogChange(callbackNotification)
            else
                callbackNotification(true)
            end
        end
        --- @type GuildApplicationInBound
        local guildApplicationInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_APPLICATION)
        guildApplicationInBound:CheckNotify(onNotifiedGuildApplication)
    end

    local listDataNeedLoad = {}
    --- @param dataType PlayerDataMethod
    local checkDataNeedToLoad = function(dataType)
        local data = zg.playerData:GetMethod(dataType)
        if data == nil or data:IsAvailableToRequest() == true then
            listDataNeedLoad[#listDataNeedLoad + 1] = dataType
        end
    end
    checkDataNeedToLoad(PlayerDataMethod.GUILD_APPLICATION)
    checkDataNeedToLoad(PlayerDataMethod.GUILD_LOG)
    if #listDataNeedLoad > 0 then
        PlayerDataRequest.RequestAndCallback(listDataNeedLoad, onRequestSuccess, nil, false)
    else
        onRequestSuccess()
    end
end

function GuildBasicInfoInBound:_CheckGuildLogChange(callbackNotification)
    if callbackNotification == nil then
        XDebug.Error("Callback notification nil")
        return
    end
    local onSuccess = function(lastUpdatedTime)
        --- @type GuildLogDataInBound
        local guildLogDataInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_LOG)
        local lastNotifiableLog = guildLogDataInBound:GetTheLastNotifiableLog()
        if lastNotifiableLog ~= nil
                and lastNotifiableLog.createdTimeInSec ~= guildLogDataInBound.lastTimeUpdatedLog then
            callbackNotification(true)
        else
            callbackNotification(false)
        end
    end
    GuildLogDataInBound.GetLastTimeGuildMemberChange(onSuccess)
end

function GuildBasicInfoInBound:OnServerKickFromGuild()
    self.lastTimeRequest = nil
    self.isHaveGuild = false
end

function GuildBasicInfoInBound:ListenToServerKick()
    if self.serverKickListener ~= nil then
        self.serverKickListener:Unsubscribe()
        self.serverKickListener = nil
    end
    self.serverKickListener = RxMgr.guildMemberKicked:Subscribe(RxMgr.CreateFunction(self, self.OnServerKickFromGuild))
end

--- @return PlayerDataMethod
function GuildBasicInfoInBound.GetPlayerDataMethod()
    return PlayerDataMethod.GUILD_BASIC_INFO
end