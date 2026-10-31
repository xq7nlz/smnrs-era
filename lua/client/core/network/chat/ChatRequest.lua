require "lua.client.core.network.playerData.chat.ChatData"
require "lua.client.core.network.playerData.chat.ChatMessageInBound"
require "lua.client.core.network.playerData.chat.ChatInBound"

--- @class ChatRequest
ChatRequest = Class(ChatRequest)

---@type string
ChatRequest.message = nil
--- @type function
ChatRequest.subscribeFunc = nil

--- @return void
--- @param message string
--- @param channel number
--- @param callback function
function ChatRequest.Send(message, channel, callback)
    local chatData = zg.playerData:GetChatData()
    chatData.sendMessageCallback = callback
    ChatRequest.message = message

    local onReceived = function(result)
        local onSuccess = function()
            if chatData.sendMessageCallback ~= nil then
                chatData.sendMessageCallback(ChatRequest.message)
            else
                print("NULL sendMessageCallback")
            end
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(OpCode.CHAT_SEND,
            UnknownOutBound.CreateInstance(PutMethod.LongString, message, PutMethod.Byte, channel), onReceived)
end

function ChatRequest.SubscribeChat()
    if zg.netDispatcherMgr:ExistEvent(OpCode.CHAT_SERVER_SEND) == false then
        if ChatRequest.subscribeFunc == nil then
            ChatRequest.subscribeFunc = function(result)
                --- @type ChatMessageInBound
                local message
                --- @param buffer UnifiedNetwork_ByteBuf
                local onBufferReading = function(buffer)
                    message = ChatMessageInBound.CreateByBuffer(buffer)
                end

                local onSuccess = function()
                    ChatRequest.OnReceiveChatMessageFromServerCallback(message)
                end

                NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, nil)
            end
        end
        zg.netDispatcherMgr:AddListener(OpCode.CHAT_SERVER_SEND, EventDispatcherListener(self, ChatRequest.subscribeFunc))
        NetworkUtils.Request(OpCode.CHAT_SUBSCRIBE, nil, nil, false)
    end
end

--- @return void
function ChatRequest.UnsubscribeChat()
    if zg.netDispatcherMgr:ExistEvent(OpCode.CHAT_SERVER_SEND) == false then
        return
    end
    zg.netDispatcherMgr:RemoveListener(OpCode.CHAT_SERVER_SEND)
    NetworkUtils.Request(OpCode.CHAT_UNSUBSCRIBE, nil, nil, false)
end

---@param message ChatMessageInBound
---@return void
function ChatRequest.OnReceiveChatMessageFromServerCallback(message)
    local playerId = message.playerId
    if zg.playerData:GetMethod(PlayerDataMethod.BLOCKED_PLAYER_LIST):IsBlock(playerId) == true
            or ChatData.IsBlockChatChannel(message.chatChannel) == true then
        return
    end
    local channel = message.chatChannel
    local chatData = zg.playerData:GetChatData()
    chatData:AddMessageToChannel(message.chatChannel, message)
    chatData:SetLastTimeReceivedMessageByChannel(message.chatChannel, message.createdTimeInSeconds)

    if chatData.receiveMessageCallback ~= nil then
        chatData.receiveMessageCallback(message)
    end

    if PopupUtils.IsPopupShowing(UIPopupName.UIChat) == false then
        ChatRequest.UnsubscribeChat()
        if ChatData.IsMainMenuChat(channel) then
            chatData.isHasNotifyMainMenu = true
        else
            chatData.isNotifyDomainTeam = true
        end
    end

    RxMgr.notificationUnreadChatMessage:Next()
end

--- @param chatChanel ChatChanel
--- @param onComplete function
function ChatRequest.RequestChatDataByChannel(chatChanel, onComplete)
    PlayerDataRequest.RequestAndCallback({ ChatRequest.GetDataMethodByChanel(chatChanel) },
            function()
                if onComplete ~= nil then
                    onComplete()
                end
            end)
end

--- @return PlayerDataMethod
--- @param chatChanel ChatChanel
function ChatRequest.GetDataMethodByChanel(chatChanel)
    if chatChanel == ChatChanel.WORLD then
        return PlayerDataMethod.CHAT_WORLD
    elseif chatChanel == ChatChanel.GUILD then
        return PlayerDataMethod.CHAT_GUILD
    elseif chatChanel == ChatChanel.RECRUIT then
        return PlayerDataMethod.CHAT_RECRUIT
    elseif chatChanel == ChatChanel.SYSTEM then
        return PlayerDataMethod.CHAT_SYSTEM
    elseif chatChanel == ChatChanel.DOMAINS_TEAM then
        return PlayerDataMethod.DOMAINS_CHAT_CREW
    elseif chatChanel == ChatChanel.DOMAINS_RECRUIT then
        return PlayerDataMethod.DOMAINS_CHAT_RECRUIT
    end
end

--- @param chatChanel ChatChanel
--- @param callback function
function ChatRequest.ValidateChatChannel(chatChanel, callback)
    if ChatRequest.IsAvailableToRequestChatChannel(chatChanel) then
        ChatRequest.RequestChatDataByChannel(chatChanel, function()
            callback()
        end)
    else
        callback()
    end
end

--- @param chatChanel ChatChanel
function ChatRequest.IsAvailableToRequestChatChannel(chatChanel)
    return zg.playerData:GetChatData().chatMessageDict:IsContainKey(chatChanel) == false
end

--- @param chatChanel ChatChanel
--- @param callback function
function ChatRequest.ValidateChatData(chatChanel, callback)
    local chatData = zg.playerData:GetChatData()
    local worldChatData = chatData:GetChatMessageByChannel(chatChanel)
    if worldChatData == nil then
        ChatRequest.RequestChatDataByChannel(chatChanel, function()
            callback()
        end)
    else
        callback()
    end
end