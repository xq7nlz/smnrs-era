require "lua.client.utils.InventoryUtils"
require "lua.client.data.Player.RemoteConfigData"
require "lua.client.data.Player.RemoteConfigAccountData"

--- @class PlayerData
PlayerData = Class(PlayerData)

--- @return void
function PlayerData:Ctor()
    --- @type Dictionary <key:PlayerDataMethod value:any>
    self.playerDataMethodDict = Dictionary()
    --- @type Dictionary
    self.dataDict = Dictionary()
    --- @type boolean
    self.waitingPauseAction = false
    --- @type List -- <ItemIconData>
    self.rewardList = nil
    --- @type number
    self.medalGuildWarChange = nil
    --- @type boolean
    self.alreadyShowMiniQuestTree = false
    --- @type {season, arenaPreviousSeason}
    self.arenaDataNoti = {}
    --- @type {season, arenaPreviousSeason}
    self.arenaTeamDataNoti = {}
    ---@type RemoteConfigData
    self.remoteConfig = RemoteConfigData()
    ---@type RemoteConfigAccountData
    self.remoteConfigAccount = RemoteConfigAccountData()
    --- @type Dictionary
    self.activeLinking = Dictionary()

    --- @type Dictionary
    self.battleResultLinking = Dictionary()

    --- @type {listRecommendation : List, listInvitation : List, listGuildSearch : List, listFriendSearchDomain, listVerifyDomain : List}
    self.domainData = {}
    --- @type Dictionary
    self.abTestingData = Dictionary()
    self:InitListener()

    self:InitRX()
end

function PlayerData:SetABTestValFromFireBase()
    --- @param key FirebaseRemoteConfigKey
    local getFirebaseRemoteConfigLongValue = function(key, defaultValue)
        local status, message = pcall(function()
            local abTestVal = zgUnity.firebase:GetFirebaseRemoteConfigLongValue(key, defaultValue)
            self.abTestingData:Add(key, abTestVal)
            --XDebug.Log("ADD KEY ab test " .. tostring(key) .. " value " .. tostring(abTestVal))
        end)
        if status == false then
            --XDebug.Error("getFirebaseRemoteConfigLongValue Error: " .. key)
            self.abTestingData:Add(key, defaultValue)
        end
    end
    getFirebaseRemoteConfigLongValue(FirebaseRemoteConfigKey.Campaign, -1)
    getFirebaseRemoteConfigLongValue(FirebaseRemoteConfigKey.CampaignReward, -1)
    getFirebaseRemoteConfigLongValue(FirebaseRemoteConfigKey.ProgressPack, -1)
    getFirebaseRemoteConfigLongValue(FirebaseRemoteConfigKey.Summon, -1)
    getFirebaseRemoteConfigLongValue(FirebaseRemoteConfigKey.WatchAd, -1)
    getFirebaseRemoteConfigLongValue(FirebaseRemoteConfigKey.FirstTopUp, -1)
end

function PlayerData:SetABTesting(key, val)
    self.abTestingData:Add(key, val)
end

--- @return number
function PlayerData:GetABTesting(key)
    local val = self.abTestingData:Get(key)
    if (val == nil) then
        return -1
    end
    return val
end

function PlayerData:SetABSummonTest(val)
    self.abTestingData.abSummonTest = val
end

function PlayerData:GetData(class)
    local data = self.dataDict:Get(class)
    if data == nil then
        XDebug.ErrorFunction(function()
            data = class()
        end)
        self.dataDict:Add(class, data)
    end
    return data
end

--- @return GuildData
function PlayerData:GetGuildData()
    return self:GetData(require("lua.client.core.network.playerData.guild.GuildData"))
end

--- @return ChatData
function PlayerData:GetChatData()
    return self:GetData(require("lua.client.core.network.playerData.chat.ChatData"))
end

--- @return ArenaData
function PlayerData:GetArenaData()
    return self:GetData(require("lua.client.core.network.playerData.arena.ArenaData"))
end

--- @return RaidData
function PlayerData:GetRaidData()
    return self:GetData(require("lua.client.core.network.playerData.raid.RaidData"))
end

--- @return EmailStatusInBound
function PlayerData:GetEmailStatusInBound()
    return self:GetData(require("lua.client.core.network.email.EmailStatusInBound"))
end

--- @return ServerListInBound
function PlayerData:GetServerListInBound()
    return self:GetData(require("lua.client.core.network.serverList.ServerListInBound"))
end

--- @return FormationInBound
function PlayerData:GetFormationInBound()
    return self:GetData(require("lua.client.core.network.playerData.formation.FormationInBound"))
end

--- @return PlayerFriendRecommendedInBound
function PlayerData:GetPlayerFriendRecommendedInBound()
    return self:GetData(require("lua.client.core.network.playerData.friend.PlayerFriendRecommendedInBound"))
end

--- @return Inventory
function PlayerData:GetInventoryData()
    return self:GetData(require("lua.client.core.inventory.Inventory"))
end

--- @return BlockPlayerDetailInBound
function PlayerData:GetBlockPlayerDetailInBound()
    return self:GetData(require("lua.client.core.network.playerData.BlockPlayerDetailInBound"))
end

--- @return CampaignData
function PlayerData:GetCampaignData()
    return self:GetData(require("lua.client.data.CampaignData.CampaignData"))
end

--- @return PlayerRaiseLevelInbound
function PlayerData:GetRaiseLevelHero()
    return self:GetMethod(PlayerDataMethod.RAISE_HERO)
end

--- @return DomainInBound
function PlayerData:GetDomainInBound()
    return self:GetMethod(PlayerDataMethod.DOMAIN)
end
--- @param method PlayerDataMethod
function PlayerData:GetMethod(method)
    local inbound = self.playerDataMethodDict:Get(method)
    return inbound
end

--- @param method PlayerDataMethod
function PlayerData:AddMethod(method)
    if self.playerDataMethodDict:IsContainKey(method) then
        XDebug.Warning(string.format("Method is exist: %s", tostring(method)))
        return self.playerDataMethodDict:Get(method)
    end
    local inbound = PlayerDataRequest.GetMethod(method)
    assert(inbound ~= nil)
    self.playerDataMethodDict:Add(method, inbound)
    return inbound
end

--- @return QuestDataInBound
function PlayerData:GetQuest()
    return self:GetMethod(PlayerDataMethod.QUEST)
end

--- @return EventInBound
function PlayerData:GetEvents()
    return self:GetMethod(PlayerDataMethod.EVENT_TIME)
end

--- @return IapDataInBound
function PlayerData:GetIAP()
    return self:GetMethod(PlayerDataMethod.IAP)
end

--- @param key string
function PlayerData:UpdatePlayerInfoOnOthersUI(key, newValue, oldValue)
    local rankingMethod = { PlayerDataMethod.CAMPAIGN_RANKING, PlayerDataMethod.TOWER_RANKING,
                            PlayerDataMethod.DUNGEON_RANKING, PlayerDataMethod.FRIEND_RANKING,
                            PlayerDataMethod.ARENA_GROUP_RANKING, PlayerDataMethod.ARENA_SERVER_RANKING,
                            PlayerDataMethod.GUILD_BASIC_INFO }
    for _, method in pairs(rankingMethod) do
        local inbound = self:GetMethod(method)
        if inbound ~= nil then
            inbound:UpdateInfoByKey(key, newValue)
        end
    end
    local guildData = self:GetGuildData()
    if guildData.guildDungeonStatisticsGetInBound ~= nil then
        guildData.guildDungeonStatisticsGetInBound:UpdateInfoByKey(key, newValue)
    end
    if self.chatData ~= nil then
        self.chatData:UpdateInfoByKey(key, newValue)
    end
end

--- @return void
function PlayerData:InitListener()
    zg.netDispatcherMgr:AddListener(OpCode.SERVER_NOTICE, EventDispatcherListener(self, self.OnServerNotification))
end

--- @return void
function PlayerData:InitRX()
    ---@type List
    self.listRx = List()
    self.listRx:Add(
            RxMgr.guildMemberAdded
                 :Merge(RxMgr.guildMemberKicked)
                 :Subscribe(function()
                PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.IAP }, nil, nil, false)
                --- @type EventInBound
                local eventData = self:GetEvents()
                if eventData ~= nil then
                    eventData.lastTimeGetEventPopupModel = nil
                end
            end)
    )
end

--- @return void
function PlayerData:UnsubscribeRX()
    ---@param v Subscription
    for _, v in pairs(self.listRx:GetItems()) do
        v:Unsubscribe()
    end
    self.listRx:Clear()
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function PlayerData:OnServerNotification(buffer)
    if buffer ~= nil then
        --- @type ServerNotificationType
        local serverNotificationType = buffer:GetLong()
        RxMgr.serverNotification:Next(serverNotificationType)
        self:CheckMail(serverNotificationType)
        self:CheckFriend(serverNotificationType)
        self:CheckQuest(serverNotificationType)
        self:CheckIAP(serverNotificationType)
        self:CheckGuild(serverNotificationType)
        self:CheckEvent(serverNotificationType)
        self:CheckAvatar(serverNotificationType)
        self:CheckArenaBeAttack(serverNotificationType)
        self:CheckRaiseLevel(serverNotificationType)
        self:CheckHeroLinking(serverNotificationType)
        self:CheckFeatureNotification(serverNotificationType)
        self:CheckNotificationWelcomeBack(serverNotificationType)
        self:CheckNotificationDomainCrewUpdated(serverNotificationType)
        self:CheckNotificationEventServerOpenUpdated(serverNotificationType)
        self:CheckNotificationFirstPurchase(serverNotificationType)
    end
end

function PlayerData:CheckMail(notificationType)
    --- @type MailDataInBound
    local mailData = self:GetMethod(PlayerDataMethod.MAIL)
    if BitUtils.IsOn(notificationType, ServerNotificationType.MAIL) and mailData ~= nil then
        mailData.needRequest = true
        mailData.isContainNewOrUnclaimedMail = true
        RxMgr.notificationRequestMail:Next()
    end
end

function PlayerData:CheckHeroLinking(notificationType)
    --- @type HeroLinkingInBound
    local heroLinkingInBound = self:GetMethod(PlayerDataMethod.HERO_LINKING)
    if heroLinkingInBound ~= nil then
        local isChangeLinking = BitUtils.IsOn(notificationType, ServerNotificationType.LINKING_SUPPORT_HERO_CHANGE)
        local isFriendDelete = BitUtils.IsOn(notificationType, ServerNotificationType.FRIEND_DELETE)
        local isFriendAdd = BitUtils.IsOn(notificationType, ServerNotificationType.FRIEND_ADD)
        if isChangeLinking or isFriendDelete then
            heroLinkingInBound.needUpdateLinking = true
            RxMgr.notificationRequestLinking:Next()
        elseif isFriendAdd then
            heroLinkingInBound.needUpdateListSupport = true
            RxMgr.notificationRequestListSupportHero:Next()
        end
    end
end

function PlayerData:CheckFeatureNotification(notificationType)
    if BitUtils.IsOn(notificationType, ServerNotificationType.FEATURE_UPDATED) then
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.FEATURE_CONFIG },
                function()
                    FeatureConfigInBound.VISUAL_UPDATED = false
                    RxMgr.featureConfigUpdated:Next()
                end, nil, false)
    end
end

function PlayerData:CheckNotificationWelcomeBack(notificationType)
    if BitUtils.IsOn(notificationType, ServerNotificationType.COMEBACK_DATA_UPDATED) then
        --- @type WelcomeBackInBound
        local welcomeBackInBound = zg.playerData:GetMethod(PlayerDataMethod.COMEBACK)
        if welcomeBackInBound ~= nil then
            welcomeBackInBound.lastTimeRequest = nil
        end
    end
end

function PlayerData:CheckNotificationDomainCrewUpdated(serverNotificationType)
    local updateData = function(type)
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.DOMAIN },
                function()
                    RxMgr.domainUpdated:Next({ ['serverNotificationType'] = type })
                end, nil, true)
    end
    if BitUtils.IsOn(serverNotificationType, ServerNotificationType.DOMAINS_CREW_UPDATED) then
        updateData(ServerNotificationType.DOMAINS_CREW_UPDATED)
    end
    if BitUtils.IsOn(serverNotificationType, ServerNotificationType.DOMAINS_CREW_DISBANDED) then
        updateData(ServerNotificationType.DOMAINS_CREW_DISBANDED)
    end
    if BitUtils.IsOn(serverNotificationType, ServerNotificationType.DOMAINS_CREW_MEMBER_ADDED) then
        updateData(ServerNotificationType.DOMAINS_CREW_MEMBER_ADDED)
    end
    if BitUtils.IsOn(serverNotificationType, ServerNotificationType.DOMAINS_CREW_MEMBER_KICKED) then
        updateData(ServerNotificationType.DOMAINS_CREW_MEMBER_KICKED)
    end
    if BitUtils.IsOn(serverNotificationType, ServerNotificationType.DOMAINS_CREW_CHALLENGE_START) then
        updateData(ServerNotificationType.DOMAINS_CREW_CHALLENGE_START)
    end
    if BitUtils.IsOn(serverNotificationType, ServerNotificationType.DOMAINS_CREW_CHALLENGE_UPDATED) then
        updateData(ServerNotificationType.DOMAINS_CREW_CHALLENGE_UPDATED)
    end
    if BitUtils.IsOn(serverNotificationType, ServerNotificationType.DOMAINS_CREW_APPLICATION_UPDATED) then
        zg.playerData.domainData.listVerifyDomain = nil
        RxMgr.domainUpdated:Next({ ['serverNotificationType'] = ServerNotificationType.DOMAINS_CREW_APPLICATION_UPDATED })
    end
    if BitUtils.IsOn(serverNotificationType, ServerNotificationType.DOMAINS_CREW_INVITATION_UPDATED) then
        zg.playerData.domainData.listInvitation = nil
        RxMgr.domainUpdated:Next({ ['serverNotificationType'] = ServerNotificationType.DOMAINS_CREW_INVITATION_UPDATED })
    end
end


function PlayerData:CheckNotificationFirstPurchase(serverNotificationType)
    if BitUtils.IsOn(serverNotificationType, ServerNotificationType.FIRST_PURCHASE_UPDATED) then
        --- @type IapDataInBound
        local iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
        local hasToUpdateFirstPurchaseData = not iapDataInBound:AllFirstPurchasePackageAvailable()
        if (hasToUpdateFirstPurchaseData) then
            IapDataInBound.Validate(nil, nil, true)
        end
    end
end

function PlayerData:CheckNotificationEventServerOpenUpdated(serverNotificationType)
    if BitUtils.IsOn(serverNotificationType, ServerNotificationType.SERVER_OPEN_UPDATED) then
        --- @type ServerOpenInBound
        local serverOpenInBound = zg.playerData:GetMethod(PlayerDataMethod.SERVER_OPEN)
        serverOpenInBound.lastTimeUpdated = nil
    end
    if BitUtils.IsOn(serverNotificationType, ServerNotificationType.EVENT_SERVER_OPEN_COMPLETED) then
        --- @type ServerOpenInBound
        local serverOpenInBound = zg.playerData:GetMethod(PlayerDataMethod.SERVER_OPEN)
        serverOpenInBound.lastTimeUpdated = nil
        serverOpenInBound.hasQuestComplete = true
    end
end

function PlayerData:CheckFriend(notificationType)
    ---@type FriendConfig
    local friendConfig = ResourceMgr.GetFriendConfig()
    --- @type PlayerFriendInBound
    local friendData = self:GetMethod(PlayerDataMethod.FRIEND)
    if friendData ~= nil then
        local notiFriendSend = (BitUtils.IsOn(notificationType, ServerNotificationType.FRIEND_ADD)
                and friendData.sentFriendPoint < friendConfig.friendPointDailyLimit)
        local notiFriendRequest = BitUtils.IsOn(notificationType, ServerNotificationType.FRIEND_REQUEST)
        local notiFriendReceived = (BitUtils.IsOn(notificationType, ServerNotificationType.FRIEND_SEND_POINT)
                and friendData.receivedFriendPoint < friendConfig.friendPointDailyLimit)
        if notiFriendSend or notiFriendRequest or notiFriendReceived then
            friendData.needRequest = true
            RxMgr.notificationRequestUiFriend:Next()
            --XDebug.Log(string.format("ClientEventId.NOTIFICATION_REQUEST_FRIEND: notiFriendSend %s, notiFriendRequest %s, notiFriendReceived %s",
            --        notiFriendSend, notiFriendRequest, notiFriendReceived))
        end

        local notiFriendDelete = BitUtils.IsOn(notificationType, ServerNotificationType.FRIEND_DELETE)
        if notiFriendDelete then
            friendData.needRequest = true
            RxMgr.notificationRequestFriend:Next()
            XDebug.Log(string.format("ClientEventId.NOTIFICATION_REQUEST_FRIEND: notiFriendDelete %s, notiBossChanged %s", notiFriendDelete, notiBossChanged))
        end
    end
end

function PlayerData:CheckQuest(notificationType)
    --- @type QuestDataInBound
    local questData = self:GetQuest()
    if questData == nil then
        return
    end
    if BitUtils.IsOn(notificationType, ServerNotificationType.QUEST_UPDATED) then
        questData.needRequest = true
    end
    if BitUtils.IsOn(notificationType, ServerNotificationType.QUEST_COMPLETED) then
        if questData:IsQuestNotifyTimeStepAvailable(zg.timeMgr:GetServerTime()) then
            questData.needRequest = true
            questData.hasNotification = true
            RxMgr.notificationRequestQuest:Next()
        end
    end
    if BitUtils.IsOn(notificationType, ServerNotificationType.ACHIEVEMENT_UPDATED) then
        questData.needRequest = true
    end
    if BitUtils.IsOn(notificationType, ServerNotificationType.ACHIEVEMENT_COMPLETED) then
        if questData:IsQuestNotifyTimeStepAvailable(zg.timeMgr:GetServerTime()) then
            questData.needRequest = true
            questData.achievementQuestInBound.hasNotification = true
            RxMgr.notificationRequestQuest:Next()
        end
    end
end

function PlayerData:CheckIAP(notificationType)
    if BitUtils.IsOn(notificationType, ServerNotificationType.IAP_UPDATED) then
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.IAP }, nil, SmartPoolUtils.LogicCodeNotification, false)
    end
end

function PlayerData:CheckGuild(notificationType)
    if BitUtils.IsOn(notificationType, ServerNotificationType.GUILD_MEMBER_KICKED) then
        RxMgr.guildMemberKicked:Next()
    end
    if BitUtils.IsOn(notificationType, ServerNotificationType.GUILD_MEMBER_ADDED) then
        RxMgr.guildMemberAdded:Next()
    end
    if BitUtils.IsOn(notificationType, ServerNotificationType.GUILD_WAR_REGISTERED) then
        RxMgr.guildWarRegistered:Next()
    end
end

function PlayerData:CheckEvent(notificationType)
    --- @type EventInBound
    local eventData = self:GetEvents()
    if BitUtils.IsOn(notificationType, ServerNotificationType.EVENT_UPDATED)
            or BitUtils.IsOn(notificationType, ServerNotificationType.EVENT_GUILD_QUEST_DONATE) then
        --PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.IAP }, nil, nil, false)
        if eventData ~= nil then
            eventData.lastTimeGetEventPopupModel = nil
        end
    end
    if BitUtils.IsOn(notificationType, ServerNotificationType.EVENT_ADDED) then
        EventInBound.ValidateEventModel(function()
            RxMgr.eventStateChange:Next()
        end, true, false, false)
    end
end

function PlayerData:CheckAvatar(notificationType)
    if BitUtils.IsOn(notificationType, ServerNotificationType.AVATAR_UPDATED) then
        --- @type ItemCollectionInBound
        local itemCollectionInBound = self:GetMethod(PlayerDataMethod.ITEM_COLLECTION)
        itemCollectionInBound.needRequestItemCollection = true
    end
end

function PlayerData:CheckArenaBeAttack(notificationType)
    if BitUtils.IsOn(notificationType, ServerNotificationType.ARENA_BE_ATTACKED) then
        --- @type BattleRecordDataInBound
        local battleRecordDataInBound = self:GetArenaData().arenaRecordDataInBound
        if battleRecordDataInBound ~= nil then
            battleRecordDataInBound.needRequest = true
        end
    end
end

function PlayerData:CheckRaiseLevel(notificationType)
    if BitUtils.IsOn(notificationType, ServerNotificationType.RAISED_HERO_PENTAGRAM_UPDATE) then
        --- @type PlayerRaiseLevelInbound
        local playerRaiseLevelInbound = self:GetRaiseLevelHero()
        if playerRaiseLevelInbound ~= nil then
            playerRaiseLevelInbound.needRequest = true
        end
    end
end

--- @return PlayerData
function PlayerData:AddListRewardToInventory()
    ---@param v ItemIconData
    for _, v in pairs(self.rewardList:GetItems()) do
        v:AddToInventory()
    end
end

--- @return PlayerData
function PlayerData:SaveRemoteConfig()
    if self.coroutineSaveRemote == nil then
        self.coroutineSaveRemote = Coroutine.start(function()
            coroutine.waitforseconds(0.5)
            if self.remoteConfig ~= nil then
                require "lua.client.core.network.remoteConfig.RemoteConfigSetOutbound"
                require "lua.client.core.network.remoteConfig.RemoteConfigValueType"
                local remoteConfigSetOutBound = RemoteConfigSetOutBound()
                remoteConfigSetOutBound:AddItem(RemoteConfigItemOutBound(REMOTE_CONFIG_KEY,
                        RemoteConfigValueType.STRING, json.encode(self.remoteConfig)))
                RemoteConfigSetOutBound.SetValue(remoteConfigSetOutBound)
            end
            self.coroutineSaveRemote = nil
        end)
    end
end

--- @return PlayerData
function PlayerData:SaveRemoteConfigAccount()
    if self.coroutineSaveRemoteAccount == nil then
        self.coroutineSaveRemoteAccount = Coroutine.start(function()
            coroutine.waitforseconds(0.5)
            if self.remoteConfigAccount ~= nil then
                local onReceived = function(result)
                    NetworkUtils.ExecuteResult(result, nil, nil, nil)
                end
                NetworkUtils.Request(OpCode.ACCOUNT_REMOTE_CONFIG_SET,
                        UnknownOutBound.CreateInstance(PutMethod.Byte, 1, PutMethod.LongString, REMOTE_CONFIG_ACCOUNT_KEY, PutMethod.LongString, json.encode(self.remoteConfigAccount)),
                        onReceived, false)
            end
            self.coroutineSaveRemoteAccount = nil
        end)
    end
end

--- @return void
function PlayerData.ClearAllData()
    local playerData = zg.playerData
    if playerData ~= nil then
        zg.netDispatcherMgr:RemoveListener(OpCode.SERVER_NOTICE)
        ---@type BasicInfoInBound
        local basicInfoInBound = playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
        if basicInfoInBound ~= nil then
            basicInfoInBound:RemoveListener()
        end
        playerData:UnsubscribeRX()
    end
    zg.playerData = PlayerData()
    zg.sceneMgr.gameMode = nil
end

function PlayerData:HasReward()
    return self.rewardList ~= nil and self.rewardList:Count() > 0
end

function PlayerData:CheckDataLinking(callbackSuccess, showWaiting)
    local success = function()
        if callbackSuccess ~= nil then
            callbackSuccess()
        end
    end
    -----@type HeroLinkingInBound
    --local heroLinkingInBound = self:GetMethod(PlayerDataMethod.HERO_LINKING)
    --if heroLinkingInBound == nil or heroLinkingInBound.needUpdateLinking == true then
    --    PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.HERO_LINKING }, function()
    --        success()
    --    end, nil, showWaiting)
    --else
    success()
    --end
end

function PlayerData:CheckDataLinkingOrSupportList(callbackSuccess, showWaiting)
    local success = function()
        if callbackSuccess ~= nil then
            callbackSuccess()
        end
    end
    ---@type HeroLinkingInBound
    local heroLinkingInBound = self:GetMethod(PlayerDataMethod.HERO_LINKING)
    if heroLinkingInBound == nil or heroLinkingInBound.needUpdateLinking == true or heroLinkingInBound.needUpdateListSupport == true then
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.HERO_LINKING }, function()
            success()
        end, nil, showWaiting)
    else
        success()
    end
end

--- @param linkingDict Dictionary
function PlayerData:SetActiveLinking(linkingDict)
    for k, v in pairs(linkingDict:GetItems()) do
        self.activeLinking:Add(k, v)
    end

    self.battleResultLinking:Clear()
    for k, v in pairs(linkingDict:GetItems()) do
        self.battleResultLinking:Add(k, v)
    end
end

function PlayerData.UpdateABTestValue()
--[[    local campaignABTestID = zg.playerData:GetABTesting(FirebaseRemoteConfigKey.Campaign)
    if (campaignABTestID < 0) then
        zg.playerData:SetABTestValFromFireBase()
    end]]
    zg.playerData:SetABTestValFromFireBase()
    RemoteConfigSetOutBound.UpdateABTest()
end