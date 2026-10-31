require "lua.client.core.network.guild.guildWar.GuildWarPlayerInBound"

--- @class GuildWarInBound
GuildWarInBound = Class(GuildWarInBound)

function GuildWarInBound:Ctor()
    --- @type number
    self.lastTimeRequest = nil
    --- @type boolean
    self.registered = nil
    --- @type boolean
    self.selectedForGuildWar = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function GuildWarInBound:ReadBuffer(buffer)
    self.hasData = buffer:GetBool()
    if self.hasData == true then
        self:ReadInnerBuffer(buffer)
    end
    self:ListenToServerKick()
end

function GuildWarInBound:ReadInnerBuffer(buffer)
    self.guildId = buffer:GetInt()
    self.guildName = buffer:GetString()
    self.guildAvatar = buffer:GetInt()
    self.season = buffer:GetLong()
    self.battleIdOfGuildWar = buffer:GetLong()
    self.listParticipants = NetworkUtils.GetListDataInBound(buffer, GuildWarPlayerInBound.CreateByBuffer)
    self.numberAttack = buffer:GetInt()
    self.elo = buffer:GetInt()
    self.opponentGuildInWar = buffer:GetInt()
    self:SeparateSelectedMember(self.listParticipants)
    self.lastTimeRequest = zg.timeMgr:GetServerTime()
end

function GuildWarInBound:SeparateSelectedMember(listParticipants)
    self.registered = false
    self.selectedForGuildWar = false
    self.listSelectedForGuildWar = List()
    self.listParticipants = List()
    for i = listParticipants:Count(), 1, -1 do
        --- @type GuildWarPlayerInBound
        local member = listParticipants:Get(i)
        if member.isSelectedForGuildWar == true then
            self.listSelectedForGuildWar:Add(member)
        else
            self.listParticipants:Add(member)
        end
        if member.compactPlayerInfo.playerId == PlayerSettingData.playerId then
            self.registered = true
            self.selectedForGuildWar = member.isSelectedForGuildWar
        end
    end
    self.listSelectedForGuildWar:SortWithMethod(GuildWarInBound.SortMemberByPositionIndex)
end

function GuildWarInBound.IsAvailableToRequest()
    --- @type GuildWarInBound
    local guildWarInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_WAR)
    return guildWarInBound == nil or guildWarInBound.lastTimeRequest == nil
            or zg.timeMgr:GetServerTime() - guildWarInBound.lastTimeRequest > 20
end

--- @return PlayerDataMethod
function GuildWarInBound.GetPlayerDataMethod()
    return PlayerDataMethod.GUILD_WAR
end

--- @param callback function
--- @param forceUpdate boolean
function GuildWarInBound.ValidateData(callback, forceUpdate, showLoading)
    if GuildWarInBound.IsAvailableToRequest() or forceUpdate == true then
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.GUILD_WAR }, callback, nil, showLoading)
    else
        callback()
    end
end

--- @return number
function GuildWarInBound:CountSelectedForGuildWar()
    return self.listSelectedForGuildWar:Count()
end

--- @return number
function GuildWarInBound:CountParticipants()
    return self.listParticipants:Count()
end

--- @return number
function GuildWarInBound:CountTotalParticipants()
    return self:CountSelectedForGuildWar() + self:CountParticipants()
end

--- @return number
--- @param fromSelected GuildWarPlayerInBound
--- @param toNewOne GuildWarPlayerInBound
function GuildWarInBound:SwapMemberSlot(fromSelected, toNewOne)
    if toNewOne.isSelectedForGuildWar == false then
        self.listParticipants:RemoveByReference(toNewOne)
        self.listSelectedForGuildWar:Add(toNewOne)

        self.listSelectedForGuildWar:RemoveByReference(fromSelected)
        self.listParticipants:Add(fromSelected)
    end

    local position = toNewOne.positionInGuildWarBattle
    local isSelected = toNewOne.isSelectedForGuildWar
    toNewOne.positionInGuildWarBattle = fromSelected.positionInGuildWarBattle
    toNewOne.isSelectedForGuildWar = true
    fromSelected.positionInGuildWarBattle = position
    fromSelected.isSelectedForGuildWar = isSelected

    self.listSelectedForGuildWar:SortWithMethod(GuildWarInBound.SortMemberByPositionIndex)
    self.listParticipants:SortWithMethod(GuildWarInBound.SortMemberByPower)
end

--- @param uiFormationTeamData UIFormationTeamData
function GuildWarInBound:RegisterMemberForGuildWar(uiFormationTeamData, onSuccess, onFailed)
    NetworkUtils.RequestAndCallback(OpCode.GUILD_WAR_MEMBER_REGISTER, BattleFormationOutBound(uiFormationTeamData),
            function()
                zg.playerData:GetFormationInBound().teamDict:Add(GameMode.GUILD_WAR, TeamFormationInBound.CreateByFormationTeamData(uiFormationTeamData))
                self.lastTimeRequest = nil
                GuildWarInBound.ValidateData(onSuccess)
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("save_successful"))
            end, function(logicCode)
                SmartPoolUtils.LogicCodeNotification(logicCode)
                if onFailed ~= nil then
                    onFailed()
                end
            end)
end

--- @param guildWarPlayerInBound GuildWarPlayerInBound
function GuildWarInBound:SelectMemberIntoBattle(guildWarPlayerInBound, posIndex)
    for i = 1, self.listParticipants:Count() do
        --- @type GuildWarPlayerInBound
        local participant = self.listParticipants:Get(i)
        if participant.compactPlayerInfo.playerId == guildWarPlayerInBound.compactPlayerInfo.playerId then
            participant.isSelectedForGuildWar = true
            participant.positionInGuildWarBattle = posIndex

            self.listSelectedForGuildWar:Add(participant)
            self.listSelectedForGuildWar:SortWithMethod(GuildWarInBound.SortMemberByPositionIndex)

            self.listParticipants:RemoveByReference(participant)
            break
        end
    end
end

--- @return List
function GuildWarInBound:GetListSelectedMemberInGuildWar()
    return self.listSelectedForGuildWar
end

--- @return List
function GuildWarInBound:GetListParticipants()
    return self.listParticipants
end

--- @return number
function GuildWarInBound:GetTotalElo()
    local total = 0
    local eloPositionConfig = ResourceMgr.GetGuildDataConfig():GetGuildWarDataConfig():GetGuildWarEloPositionConfig()
    for i = 1, self.listSelectedForGuildWar:Count() do
        --- @type GuildWarPlayerInBound
        local guildWarPlayerInBound = self.listSelectedForGuildWar:Get(i)
        local medal = guildWarPlayerInBound.medalHoldDefense
        total = total + medal * eloPositionConfig:GetEloByPosition(guildWarPlayerInBound.positionInGuildWarBattle)
    end
    return total
end

--- @return number
---@param x GuildWarPlayerInBound
---@param y GuildWarPlayerInBound
function GuildWarInBound.SortMemberByPositionIndex(x, y)
    if (x.positionInGuildWarBattle < y.positionInGuildWarBattle) then
        return -1
    else
        return 1
    end
end

--- @return number
---@param x GuildWarPlayerInBound
---@param y GuildWarPlayerInBound
function GuildWarInBound.SortMemberByPower(x, y)
    if (x.positionInGuildWarBattle < y.positionInGuildWarBattle) then
        return -1
    else
        return 1
    end
end

--- @param listMember List
function GuildWarInBound:OnSuccessRegisterMemberForGuildWar(listMember)
    for i = listMember:Count(), 1, -1 do
        --- @type GuildWarPlayerInBound
        local registeredMember = listMember:Get(i)
        local id = registeredMember.compactPlayerInfo.playerId
        for k = self.listParticipants:Count(), 1, -1 do
            --- @type GuildWarPlayerInBound
            local member = self.listParticipants:Get(k)
            local memberId = member.compactPlayerInfo.playerId
            if memberId == id then
                self.listSelectedForGuildWar:Add(member)
                member.isSelectedForGuildWar = true
                member.positionInGuildWarBattle = i

                self.listParticipants:RemoveByIndex(k)
                listMember:RemoveByIndex(i)
            end
        end
    end
    self.listSelectedForGuildWar:SortWithMethod(GuildWarInBound.SortMemberByPositionIndex)
end

--- @return GuildWarPlayerInBound
---@param position GuildWarPlayerInBound
function GuildWarInBound:FindSelectedMemberByPosition(position)
    for i = 1, self.listSelectedForGuildWar:Count() do
        ---@type GuildWarPlayerInBound
        local member = self.listSelectedForGuildWar:Get(i)
        if member.positionInGuildWarBattle == position then
            return member
        end
    end
    return nil
end

--- @return GuildWarPlayerInBound
---@param playerId number
function GuildWarInBound:FindSelectedMemberById(playerId)
    for i = 1, self.listSelectedForGuildWar:Count() do
        ---@type GuildWarPlayerInBound
        local member = self.listSelectedForGuildWar:Get(i)
        if member.compactPlayerInfo.playerId == playerId then
            return member
        end
    end
    return nil
end

--- @param listSelectedMember List
function GuildWarInBound.RequestGuildWarRegister(listSelectedMember, onSuccess, onFailedCallback)
    local callbackRequest = function(result)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            --- @type GuildWarInBound
            local guildWarInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_WAR)
            guildWarInBound:OnSuccessRegisterMemberForGuildWar(listSelectedMember)
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            if onFailedCallback then
                onFailedCallback(logicCode)
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    local guildWarRegisterOutBound = GuildWarRegisterOutBound(listSelectedMember)
    NetworkUtils.Request(OpCode.GUILD_WAR_REGISTER, guildWarRegisterOutBound, callbackRequest)
end

function GuildWarInBound:ListenToServerKick()
    if self.serverKickListener ~= nil then
        self.serverKickListener:Unsubscribe()
        self.serverKickListener = nil
    end
    self.serverKickListener = RxMgr.guildMemberKicked:Subscribe(RxMgr.CreateFunction(self, self.OnLeftGuild))
end

function GuildWarInBound:OnLeftGuild()
    self.lastTimeRequest = nil
    self.registered = nil
    self.selectedForGuildWar = nil
    self.guildId = nil
end

--- @class GuildWarRegisterOutBound : OutBound
GuildWarRegisterOutBound = Class(GuildWarRegisterOutBound, OutBound)

--- @param listMember List
function GuildWarRegisterOutBound:Ctor(listMember)
    self.listMemberId = List()
    for i = 1, listMember:Count() do
        --- @type GuildWarPlayerInBound
        local member = listMember:Get(i)
        self.listMemberId:Add(member.compactPlayerInfo.playerId)
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function GuildWarRegisterOutBound:Serialize(buffer)
    buffer:PutByte(self.listMemberId:Count())
    for i = 1, self.listMemberId:Count() do
        buffer:PutLong(self.listMemberId:Get(i))
    end
end