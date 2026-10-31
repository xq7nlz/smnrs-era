--- @class NetworkUtils
NetworkUtils = { }

NetworkUtils.requestDict = Dictionary()

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
--- @param onBufferReading function
--- @param onSuccess function
--- @param onFailed function
function NetworkUtils.ExecuteResult(buffer, onBufferReading, onSuccess, onFailed)
    local logicCode
    local readBuffer = function()
        logicCode = buffer:GetShort()
        if logicCode == LogicCode.SUCCESS then
            if onBufferReading ~= nil then
                onBufferReading(buffer)
            end
        elseif logicCode == LogicCode.AUTH_ACCOUNT_LOCATION_ABUSED then
            NetworkUtils.LocationAbuse(buffer)
        else
            XDebug.Log(string.format("Logic code failed: %d", logicCode))
        end
    end

    local status, message = pcall(function()
        readBuffer()

        if logicCode == LogicCode.SUCCESS then
            if onSuccess ~= nil then
                onSuccess()
            end
        else
            if onFailed ~= nil and logicCode ~= LogicCode.AUTH_ACCOUNT_LOCATION_ABUSED then
                onFailed(logicCode)
            end
        end

        RxMgr.receiveLogicCode:Next(logicCode)

    end)
    if status == false then
        XDebug.Error(tostring(message))
    end
end

function NetworkUtils.RequestPlayerData(onSuccess)
    local subject
    subject = TrackingUtils.RequestProperty():Subscribe(function()
        subject:Unsubscribe()
        local onSuccessCallback = function()
            if onSuccess then
                onSuccess()
            end
        end
        PlayerDataRequest.RequestAllData(onSuccessCallback, function()
            zg.networkMgr.connector:Disconnect()
        end)
    end)
end

--- @return void
--- @param opCode OpCode
--- @param outBound OutBound
function NetworkUtils.Request(opCode, outBound, callback, showWaiting)
    if zg.networkMgr.isConnected == false then
        XDebug.Log("No network")
        return
    end

    if callback ~= nil then
        --- @type TouchObject
        local touchObject
        if showWaiting ~= false then
            touchObject = TouchUtils.Spawn(opCode)
        end

        zg.netDispatcherMgr:AddListener(opCode, EventDispatcherListener(nil, function(result)
            if showWaiting ~= false then
                touchObject:Enable()
            end
            callback(result)
        end))
    else
        if showWaiting then
            XDebug.Log("Show or hide waiting is invalid")
        end
    end

    zg.networkMgr:Send(opCode, outBound)
end

--- @return void
--- @param opCode OpCode
function NetworkUtils.RequestAndCallback(opCode, outBound, onSuccess, onFailed, onBufferReading, showWaiting)
    local callback = function(result)
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    NetworkUtils.Request(opCode, outBound, callback, showWaiting)
end

--- @return List
--- @param buffer UnifiedNetwork_ByteBuf
function NetworkUtils.GetRewardInBoundList(buffer)
    return NetworkUtils.GetListDataInBound(buffer, RewardInBound.CreateByBuffer)
end

--- @return List
--- @param buffer UnifiedNetwork_ByteBuf
function NetworkUtils.GetInjectorRewardInBoundList(buffer)
    local listReward = List()
    local isRead = buffer:GetBool()
    if (isRead) then
        local numberOfEvent = buffer:GetShort()
        for i = 1, numberOfEvent do
            --- @type InjectorType
            local injectorType = buffer:GetShort()
            local size = buffer:GetByte()
            if size > 0 then
                for i = 1, size do
                    local data = RewardInBound.CreateByBuffer(buffer)
                    if data ~= nil then
                        listReward:Add(data)
                    end
                end
            end
        end
    end

    return listReward
end

--- @return List
--- @param buffer UnifiedNetwork_ByteBuf
--- @param originListReward List
function NetworkUtils.AddInjectRewardInBoundList(buffer, originListReward)
    local isRead = buffer:GetBool()
    if (isRead) then
        local numberOfEvent = buffer:GetShort()
        for i = 1, numberOfEvent do
            --- @type InjectorType
            local injectorType = buffer:GetShort()
            local listInjectReward = NetworkUtils.GetListDataInBound(buffer, RewardInBound.CreateByBuffer)
            originListReward = ClientConfigUtils.CombineListRewardInBound(listInjectReward, originListReward)
        end
    end
    return originListReward
end

--- @return List
--- @param buffer UnifiedNetwork_ByteBuf
function NetworkUtils.GetListDataInBound(buffer, dataInBound, _size)
    ---@type number
    local size = _size
    if size == nil then
        size = buffer:GetByte()
    end
    --XDebug.Log("Size List: " .. size)
    ---@type List
    local list = List()
    if size > 0 then
        for i = 1, size do
            local data = dataInBound(buffer)
            if data ~= nil then
                list:Add(data)
            end
        end
    end
    return list
end

--- @return List
--- @param json string
function NetworkUtils.GetListDataJson(json, serializeJson)
    local list = List()
    for _, jsonInBound in pairs(json) do
        local data = serializeJson(jsonInBound)
        if data ~= nil then
            list:Add(data)
        end
    end
    return list
end

--- @return void
--- @param playerId number
--- @param gameMode GameMode
function NetworkUtils.SilentRequestOtherPlayerInfoInBoundByGameMode(playerId, gameMode, callbackSuccess, callbackFailed, timeCache)
    NetworkUtils.SilentRequest(OpCode.SERVER_OTHER_PLAYER_DETAIL_GET, UnknownOutBound.CreateInstance(PutMethod.Long, playerId, PutMethod.Byte, gameMode),
            OtherPlayerInfoInBound, callbackSuccess, nil, callbackFailed, timeCache or 10)
end

--- @return void
--- @param playerId number
--- @param gameMode GameMode
function NetworkUtils.GetOtherPlayerInfoInBoundByGameMode(playerId, gameMode, callbackSuccess, callbackFailed)
    local callback = function(result)
        ---@type OtherPlayerInfoInBound
        local otherPlayerInfoInBound
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            otherPlayerInfoInBound = OtherPlayerInfoInBound.CreateByBuffer(buffer)
        end
        local onSuccess = function()
            if callbackSuccess ~= nil then
                callbackSuccess(otherPlayerInfoInBound)
            end
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            if callbackFailed ~= nil then
                callbackFailed()
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.SERVER_OTHER_PLAYER_DETAIL_GET, UnknownOutBound.CreateInstance(PutMethod.Long, playerId, PutMethod.Byte, gameMode), callback)
end

--- @return void
function NetworkUtils.BlockPlayer(playerId, isBlock, callbackSuccess, callbackFailed)
    local onReceived = function(result)
        local onSuccess = function()
            if isBlock == true then
                -- REQUEST HERO_LINKING
                ---@type HeroLinkingInBound
                local heroLinkingInBound = zg.playerData:GetMethod(PlayerDataMethod.HERO_LINKING)
                if heroLinkingInBound ~= nil then
                    heroLinkingInBound.needUpdateLinking = true
                end
            end
            if callbackSuccess ~= nil then
                callbackSuccess(playerId, isBlock)
            end
        end
        local onFailed = function(logicCode)
            if callbackFailed ~= nil then
                callbackFailed()
            end
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.PLAYER_BLOCK, UnknownOutBound.CreateInstance(PutMethod.Long, playerId, PutMethod.Bool, isBlock), onReceived)
end

--- @return List
--- @param buffer UnifiedNetwork_ByteBuf
function NetworkUtils.GetDictMastery(buffer)
    ---@type number
    local size = buffer:GetByte()
    ---@type Dictionary  --<classType, List<mastery>>
    local classDict = Dictionary()
    for i = 1, size do
        ---@type List
        local listLevel = List()
        classDict:Add(buffer:GetByte(), listLevel)
        ---@type number
        local sizeLevel = buffer:GetByte()
        for _ = 1, sizeLevel do
            listLevel:Add(buffer:GetShort())
        end
    end
    return classDict
end

--- @return void
function NetworkUtils.CheckMaskRequest(buffer, functionCheck)
    if functionCheck ~= nil then
        local beforeRead = buffer.readPos
        local size = buffer:GetInt()
        functionCheck(buffer)
        local afterRead = buffer.readPos
        if beforeRead + size ~= afterRead then
            XDebug.Error("bitmask is invalid: " .. string.format("before: %d, size: %d, after: %d", beforeRead, size, afterRead))
            buffer:OffsetRead(beforeRead + size - afterRead)
            return false
        end
    else
        XDebug.Warning("function is nil")
        return true
    end
end

--- @return void
--- @param func function
function NetworkUtils.WaitForHandShake(func)
    zg.networkMgr:CheckConnect(function()
        if zg.networkMgr.handShake:IsComplete() then
            func()
        else
            local listener
            listener = RxMgr.handShakeComplete:Subscribe(function()
                listener:Unsubscribe()
                func()
            end)
        end
    end)
end

--- After connect, login => return the last server login => not valid => reconnect new server
--- @type {outBound, success, failed}
NetworkUtils.loginData = nil
--- @param buffer UnifiedNetwork_ByteBuf
function NetworkUtils.LocationAbuse(buffer)
    PlayerSetting.SaveBestAddress(buffer:GetString())
    zg.networkMgr.isLocationAbuse = true
    zg.networkMgr.connector:Disconnect()
    Coroutine.start(function()
        XDebug.Log(">>>>>>>>>>> run location abuse")
        while zg.networkMgr.isConnected do
            coroutine.waitforendofframe()
        end
        LoginUtils.Login(NetworkUtils.loginData.outBound,
                NetworkUtils.loginData.success,
                NetworkUtils.loginData.failed)
        zg.networkMgr.isLocationAbuse = false
    end)
end

function NetworkUtils.CheckRequestChangeLanguage()
    ---@type BasicInfoInBound
    local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    if basicInfoInBound ~= nil and PlayerSettingData.language ~= nil then
        ---@param v Language
        for i, v in pairs(LanguageUtils.GetLanguageList():GetItems()) do
            if v.keyLanguage == PlayerSettingData.language and basicInfoInBound.language ~= v.code then
                NetworkUtils.RequestAndCallback(OpCode.PLAYER_LANGUAGE_CHANGE, UnknownOutBound.CreateInstance(PutMethod.String, v.code), function()
                    basicInfoInBound.language = PlayerSettingData.language
                end, SmartPoolUtils.LogicCodeNotification, nil, false)
                break
            end
        end
    end
end

--- @return void
function NetworkUtils.ResetAllSetUp()
    local hidePopupList = function()
        local popupList = { UIPopupName.UITutorial, UIPopupName.UIPopupWaiting, UIPopupName.UIPopupNotification }
        for _, v in ipairs(popupList) do
            if PopupUtils.IsPopupShowing(v) then
                PopupMgr.HidePopup(v)
            end
        end
    end
    hidePopupList()
    zg.netDispatcherMgr:Reset()
    RxMgr.Reset()
    TouchUtils.Reset()
    NetworkUtils.Reset()
end

--- @return void
--- @param requestPath string
--- @param onSuccess function
--- @param onFailed function
function NetworkUtils.TryRequestData(maxRetry, requestPath, onSuccess, onFailed)
    assert(maxRetry and requestPath and onSuccess and onFailed)
    print("Request: " .. requestPath)
    local countRetry = 1
    local doRetry
    doRetry = function(error)
        print("Download Error: " .. tostring(error))
        if countRetry == maxRetry then
            print(string.format("Cant get file: %s %s", error, requestPath))
            onFailed()
        else
            U_GameUtils.DownloadScript(requestPath, onSuccess, doRetry)
            countRetry = countRetry + 1
        end
    end
    U_GameUtils.DownloadScript(requestPath, onSuccess, doRetry)
end