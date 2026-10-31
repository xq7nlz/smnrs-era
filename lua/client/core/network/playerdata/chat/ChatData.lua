--- @class ChatData
ChatData = Class(ChatData)
---@type number
ChatData.DELAY_SEND_MESSAGE = 10
local DELAY_CHECK_SYSTEM_MESSAGE = 300

function ChatData:Ctor()
    --- @type boolean
    self.isHasNotifyMainMenu = nil
    --- @type boolean
    self.isNotifyWorld = nil
    --- @type boolean
    self.isNotifyGuild = nil
    --- @type boolean
    self.isNotifyRecruit = nil
    --- @type boolean
    self.isNotifyDomainRecruit = nil

    --- @type boolean
    self.isNotifyDomainTeam = nil

    --- @type function
    self.sendMessageCallback = nil
    --- @type Dictionary
    self.lastMessageChannelReceivedDict = Dictionary()
    --- @type Dictionary
    self.chatMessageDict = Dictionary()
    --- @type function
    self.receiveMessageCallback = nil

    --- @type Dictionary
    self.previewPlayerInfoDict = Dictionary()

    --- @type number
    self.lastTimeCheckSystemMessage = nil
end

--- @return List
--- @param chatChanel ChatChanel
function ChatData:GetChatMessageByChannel(chatChanel)
    return self.chatMessageDict:Get(chatChanel)
end

--- @param chatChanel ChatChanel
--- @param chatMessage ChatMessageInBound
function ChatData:AddMessageToChannel(chatChanel, chatMessage)
    if zg.playerData:GetMethod(PlayerDataMethod.BLOCKED_PLAYER_LIST):IsBlock(chatMessage.playerId) == true
            or ChatData.IsBlockChatChannel(chatChanel) == true then
        return
    end
    local listChatMessageInBound = self:GetChatMessageByChannel(chatChanel) or List()
    listChatMessageInBound:Add(chatMessage)
end

--- @return ChatMessageInBound
--- @param chatChanel ChatChanel
function ChatData:GetLastChatMessageByChannel(chatChanel)
    local chatMessageData = self:GetChatMessageByChannel(chatChanel)
    if chatMessageData ~= nil then
        return chatMessageData:Get(chatMessageData:Count())
    end
    return nil
end

--- @param chatChanel ChatChanel
--- @param receivedTime number
function ChatData:SetLastTimeReceivedMessageByChannel(chatChanel, receivedTime)
    self.lastMessageChannelReceivedDict:Add(chatChanel, receivedTime)
end

--- @return number
--- @param chatChanel ChatChanel
function ChatData:GetLastTimeReceivedMessageByChannel(chatChanel)
    if self.lastMessageChannelReceivedDict:IsContainKey(chatChanel) == true then
        return self.lastMessageChannelReceivedDict:Get(chatChanel)
    end
    return UIChatModel.GetLastTimeReadChannel(chatChanel)
end

--- @param key string
function ChatData:UpdateInfoByKey(key, newValue)
    --- @param v List
    for _, v in pairs(self.chatMessageDict:GetItems()) do
        for i = 1, v:Count() do
            --- @type ChatMessageInBound
            local chatMessageInBound = v:Get(i)
            if chatMessageInBound.playerId == PlayerSettingData.playerId then
                chatMessageInBound:UpdateInfoByKey(key, newValue)
            end
        end
    end
end

--- @param chatChanel ChatChanel
--- @param buffer UnifiedNetwork_ByteBuf
function ChatData.ReadChatMessageData(chatChanel, buffer)
    local listChatMessageInBound = ChatMessageInBound.GetChatMessageInBoundList(buffer)
    if ChatData.IsBlockChatChannel(chatChanel) == true then
        listChatMessageInBound = List()
    end
    zg.playerData:GetChatData().chatMessageDict:Add(chatChanel, listChatMessageInBound)
end

--- @param chatChanel ChatChanel
function ChatData.IsBlockChatChannel(chatChanel)
    if chatChanel == ChatChanel.WORLD then
        return PlayerSettingData.isBlockWorldChat
    elseif chatChanel == ChatChanel.GUILD then
        return PlayerSettingData.isBlockGuildChat
                or not ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.GUILD, false)
    elseif chatChanel == ChatChanel.RECRUIT then
        return PlayerSettingData.isBlockRecruitChat
                or not ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.GUILD, false)
    elseif chatChanel == ChatChanel.DOMAINS_TEAM then
        return PlayerSettingData.isBlockDomainsTeamChat
                or not ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.DOMAINS, false)
    elseif chatChanel == ChatChanel.DOMAINS_RECRUIT then
        return PlayerSettingData.isBlockDomainsRecruitChat
                or not ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.DOMAINS, false)
    end
end

--- @param chatChanel ChatChanel
function ChatData:IsHasNewUnReadMessageByChannel(chatChanel)
    return self:GetLastTimeReceivedMessageByChannel(chatChanel) > UIChatModel.GetLastTimeReadChannel(chatChanel)
end

function ChatData:CheckNotificationMainMenu()
    self.isNotifyWorld = self:IsHasNewUnReadMessageByChannel(ChatChanel.WORLD)
    self.isNotifyGuild = self:IsHasNewUnReadMessageByChannel(ChatChanel.GUILD)
    self.isNotifyRecruit = self:IsHasNewUnReadMessageByChannel(ChatChanel.RECRUIT)
    self.isNotifyDomainRecruit = self:IsHasNewUnReadMessageByChannel(ChatChanel.DOMAINS_RECRUIT)

    self.isHasNotifyMainMenu = self.isNotifyWorld or self.isNotifyGuild or self.isNotifyRecruit or self.isNotifyDomainRecruit
end

function ChatData:CheckNotificationDomains()
    self.isNotifyDomainTeam = self:IsHasNewUnReadMessageByChannel(ChatChanel.DOMAINS_TEAM)
end

function ChatData.CheckSystemMessage()
    local chatData = zg.playerData:GetChatData()
    if chatData == nil then
        return
    end
    local svTime = zg.timeMgr:GetServerTime()
    if chatData.lastTimeCheckSystemMessage == nil
            or svTime - chatData.lastTimeCheckSystemMessage > DELAY_CHECK_SYSTEM_MESSAGE then
        local listChatMessage = chatData:GetChatMessageByChannel(ChatChanel.SYSTEM)
        if listChatMessage ~= nil then
            for i = listChatMessage:Count(), 1, -1 do
                --- @type ChatMessageInBound
                local chatMessageInBound = listChatMessage:Get(i)
                local maintenanceMessageInBound = chatMessageInBound.messageInBound
                if chatMessageInBound.startActiveTime <= svTime
                        and chatMessageInBound.endActiveTime >= svTime then
                    uiCanvas:ShowMaintenanceMessage(maintenanceMessageInBound)
                    chatData.lastTimeCheckSystemMessage = zg.timeMgr:GetServerTime()
                    return
                end
            end
        end
    end
end

function ChatData.OnValidateMainMenuChat(onCompleteAll)
    local onLoadedServerList = function()
        local listDataNeedLoad = {}
        local addDataNeedToLoad = function(playerDataMethod)
            listDataNeedLoad[#listDataNeedLoad + 1] = playerDataMethod
        end
        if GuildBasicInfoInBound.IsAvailableToRequest() then
            addDataNeedToLoad(PlayerDataMethod.GUILD_BASIC_INFO)
        end
        if ChatRequest.IsAvailableToRequestChatChannel(ChatChanel.WORLD) then
            addDataNeedToLoad(ChatRequest.GetDataMethodByChanel(ChatChanel.WORLD))
        end
        if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.GUILD, false) == true then
            if ChatRequest.IsAvailableToRequestChatChannel(ChatChanel.RECRUIT) then
                addDataNeedToLoad(ChatRequest.GetDataMethodByChanel(ChatChanel.RECRUIT))
            end
            --- @type GuildBasicInfoInBound
            local guildBasicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_BASIC_INFO)
            if guildBasicInfoInBound ~= nil and guildBasicInfoInBound.isHaveGuild == true then
                if ChatRequest.IsAvailableToRequestChatChannel(ChatChanel.GUILD) then
                    addDataNeedToLoad(ChatRequest.GetDataMethodByChanel(ChatChanel.GUILD))
                end
            end
        end
        if #listDataNeedLoad > 0 then
            PlayerDataRequest.RequestAndCallback(listDataNeedLoad, onCompleteAll)
        else
            onCompleteAll()
        end
    end
    ServerListInBound.Validate(onLoadedServerList)
end

function ChatData.OnValidateDomainChat(onCompleteAll)
    local onLoadedServerList = function()
        local listDataNeedLoad = {}
        local addDataNeedToLoad = function(playerDataMethod)
            listDataNeedLoad[#listDataNeedLoad + 1] = playerDataMethod
        end
        if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.DOMAINS, false) == true then
            addDataNeedToLoad(ChatRequest.GetDataMethodByChanel(ChatChanel.DOMAINS_TEAM))
            addDataNeedToLoad(ChatRequest.GetDataMethodByChanel(ChatChanel.DOMAINS_RECRUIT))
        end
        if #listDataNeedLoad > 0 then
            PlayerDataRequest.RequestAndCallback(listDataNeedLoad, onCompleteAll)
        else
            onCompleteAll()
        end
    end
    ServerListInBound.Validate(onLoadedServerList)
end

--- @return ChatChanel
function ChatData.IsMainMenuChat(chatChanel)
    return chatChanel == ChatChanel.WORLD
            or chatChanel == ChatChanel.GUILD
            or chatChanel == ChatChanel.RECRUIT
            or chatChanel == ChatChanel.DOMAINS_RECRUIT
end

--- @class ChatLayoutType
ChatLayoutType = {
    MAIN_MENU = 1,
    DOMAINS = 2,
}

return ChatData
