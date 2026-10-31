require("lua.client.core.network.login.AuthMethod")
require("lua.client.core.network.login.AuthProvider")
require("lua.client.core.network.login.register.RegisterByTokenOutBound")
require("lua.client.core.network.login.register.RegisterByUPOutBound")
require("lua.client.core.network.login.register.RegisterByMethodOutBound")
require("lua.client.core.network.login.login.LoginByTokenOutBound")
require("lua.client.core.network.login.login.LoginByUPOutBound")
require("lua.client.core.network.login.login.LoginByMethodOutBound")
require("lua.client.core.network.login.login.LoginInBound")
require "lua.client.core.network.serverList.ServerListInBound"

--- @class LoginUtils
LoginUtils = {}

--- @return
--- @param buffer UnifiedNetwork_ByteBuf
function LoginUtils.GetCallbackLoginInBound(callbackSuccess, callbackFailed)
    local onReceived = function(result)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            LoginInBound(buffer)
        end

        local onSuccess = function()
            zg.networkMgr.isLogin = true
            if callbackSuccess ~= nil then
                callbackSuccess()
            end
        end

        --- @param logicCode LogicCode
        local onFailed = function(logicCode)
            if callbackFailed ~= nil then
                callbackFailed(logicCode)
            end
        end

        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    return onReceived
end

--- REGISTER
--- @return void
function LoginUtils.Register(outBound, callbackSuccess, callbackFailed)
    local touchObject = TouchUtils.Spawn("LoginUtils.Register")
    local register = function()
        local request = function(advertisingId)
            outBound.advertisingId = advertisingId
            local callback = LoginUtils.GetCallbackLoginInBound(function()
                if callbackSuccess ~= nil then
                    callbackSuccess()
                end
            end, callbackFailed)
            touchObject:Enable()
            NetworkUtils.Request(OpCode.REGISTER, outBound, callback)
            RxMgr.notificationLoading:Next(LanguageUtils.LocalizeCommon("register"))
        end
        if IS_MOBILE_PLATFORM then
            LoginUtils.RequestAdvertisingIdentifierAsync(function(advertisingId)
                request(advertisingId)
            end)
        else
            request("editor")
        end
    end
    NetworkUtils.WaitForHandShake(register)
end

--- @return void
function LoginUtils.RegisterByToken(callbackSuccess, callbackFailed)
    local success = function()
        PlayerSetting.SetLoginByToken()
        if callbackSuccess ~= nil then
            callbackSuccess()
        end
    end
    LoginUtils.Register(RegisterByTokenOutBound(), success, callbackFailed)
end

--- @return void
--- @param userName string
--- @param password string
--- @param serverId number
function LoginUtils.RegisterByUP(userName, password, serverId, callbackSuccess, callbackFailed)
    if callbackSuccess == nil then
        XDebug.Error("Missing callbackSuccess method")
    end
    local passwordHash = SHA2.shaHex256(password)
    local success = function()
        PlayerSetting.SetLoginByUserName(userName, passwordHash)
        if callbackSuccess ~= nil then
            callbackSuccess()
        end
    end
    LoginUtils.Register(RegisterByUPOutBound(userName, passwordHash, serverId), success, callbackFailed)
end

--- @return void
function LoginUtils.RegisterByMethod(authMethod, userId, callbackSuccess, callbackFailed)
    local success = function()
        PlayerSetting.SetLoginByMethod(authMethod, userId)
        if callbackSuccess ~= nil then
            callbackSuccess()
        end
    end
    LoginUtils.Register(RegisterByMethodOutBound(authMethod, userId), success, callbackFailed)
end

--- @return void
function LoginUtils.RegisterBySunGame(token, uuid, callbackSuccess, callbackFailed)
    local success = function()
        PlayerSetting.SetLoginByMethod(AuthMethod.LOGIN_BY_SUN_GAME, nil)
        if callbackSuccess ~= nil then
            callbackSuccess()
        end
    end
    LoginUtils.Register(RegisterBySunGameOutBound(token, uuid), success, callbackFailed)
end

--- LOGIN
--- @return void
function LoginUtils.Login(outBound, callbackSuccess, callbackFailed)
    XDebug.Log("Run login")
    local touchObject = TouchUtils.Spawn("LoginUtils.Login")
    NetworkUtils.loginData = { ['outBound'] = outBound, ['success'] = callbackSuccess, ['failed'] = callbackFailed }
    assert(callbackSuccess and callbackFailed)
    local login = function()
        local request = function(advertisingId)
            outBound.advertisingId = advertisingId
            local callback = LoginUtils.GetCallbackLoginInBound(function()
                outBound:SaveData()
                if callbackSuccess ~= nil then
                    callbackSuccess()
                end
            end, callbackFailed)
            touchObject:Enable()
            NetworkUtils.Request(OpCode.LOGIN, outBound, callback)
            RxMgr.notificationLoading:Next(LanguageUtils.LocalizeCommon("login"))
        end
        if IS_EDITOR_PLATFORM then
            request("editor")
        else
            LoginUtils.RequestAdvertisingIdentifierAsync(function(advertisingId)
                request(advertisingId)
            end)
        end
    end
    NetworkUtils.WaitForHandShake(login)
end

--- @return void
function LoginUtils.LoginByToken(callbackSuccess, callbackFailed, token)
    local success = function()
        PlayerSetting.SetLoginByToken()
        if callbackSuccess ~= nil then
            callbackSuccess()
        end
    end
    LoginUtils.Login(LoginByTokenOutBound(token), success, callbackFailed)
end

--- @return void
function LoginUtils.LoginByMethod(authMethod, userId, callbackSuccess, callbackFailed)
    local success = function()
        PlayerSetting.SetLoginByMethod(authMethod, userId)
        if callbackSuccess ~= nil then
            callbackSuccess()
        end
    end
    LoginUtils.Login(LoginByMethodOutBound(authMethod, userId), success, callbackFailed)
end

--- @return void
function LoginUtils.LoginBySunGame(token, uuid, callbackSuccess, callbackFailed)
    local success = function()
        PlayerSetting.SetLoginByMethod(AuthMethod.LOGIN_BY_SUN_GAME, nil)
        if callbackSuccess ~= nil then
            callbackSuccess()
        end
    end
    LoginUtils.Login(LoginBySunGameOutBound(token, uuid), success, callbackFailed)
end

--- @return void
function LoginUtils.LoginBySunGameUserId(userId, callbackSuccess, callbackFailed)
    XDebug.Log("LoginUtils.LoginBySunGameUserId")
    print(userId)
    local success = function()
        PlayerSetting.SetLoginByMethod(AuthMethod.LOGIN_BY_SUN_GAME_USER_ID, userId)
        XDebug.Log("LoginUtils.LoginBySunGameUserId success")
        if callbackSuccess ~= nil then
            callbackSuccess()
        end
    end
    LoginUtils.Login(LoginBySunGameUserIdOutBound(userId), success, callbackFailed)
end

--- @return void
function LoginUtils.LoginOrRegisterByMethod(authMethodLogin, authMethodRegister, userId, callbackSuccess, callbackFailed)
    LoginUtils.LoginByMethod(authMethodLogin, userId, callbackSuccess, function(logicCode)
        if logicCode == LogicCode.PLAYER_NOT_FOUND then
            local noCallback = function()
                zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
            end
            local yesCallback = function()
                LoginUtils.RegisterByMethod(authMethodRegister, userId, callbackSuccess, callbackFailed)
                zg.audioMgr:PlaySfxUi(SfxUiType.CONFIRM)
            end
            PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("noti_register"), noCallback, yesCallback)
        else
            if callbackFailed ~= nil then
                callbackFailed(logicCode)
            end
        end
    end)
end

--- @return void
function LoginUtils.LoginOrRegisterBySunGame(callbackSuccess, callbackFailed, callbackPlayNow)
    local playNow = function(token, uuid)
        if callbackPlayNow ~= nil then
            callbackPlayNow()
        end
    end
    if IS_EDITOR_PLATFORM then
        playNow()
    else
        local loginSuccess = function(token, uuid)
            LoginUtils.LoginBySunGame(token, uuid, callbackSuccess, function(logicCode)
                if logicCode == LogicCode.PLAYER_NOT_FOUND then
                    local noCallback = function()
                        zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
                    end
                    local yesCallback = function()
                        LoginUtils.RegisterBySunGame(token, uuid, callbackSuccess, callbackFailed)
                        zg.audioMgr:PlaySfxUi(SfxUiType.CONFIRM)
                    end
                    PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("noti_register"), noCallback, yesCallback)
                else
                    if callbackFailed ~= nil then
                        callbackFailed(logicCode)
                    end
                end
            end)
        end
        zg.sungameMgr:Login(loginSuccess, playNow, nil)
    end
end

--- @return void
function LoginUtils.LoginOrRegisterByToken(callbackSuccess, callbackFailed)
    XDebug.Log("LoginUtils.LoginOrRegisterByToken")
    LoginUtils.LoginByToken(callbackSuccess, function()
        LoginUtils.RegisterByToken(callbackSuccess, callbackFailed)
    end)
end

--- @return void
function LoginUtils.LoginOrRegisterByFacebook(callbackSuccess, callbackFailed)
    if IS_EDITOR_PLATFORM then
        LoginUtils.LoginOrRegisterByMethod(AuthMethod.LOGIN_BY_FACEBOOK, AuthMethod.REGISTER_BY_FACEBOOK, "ff-" .. DEVICE_INFO, callbackSuccess, callbackFailed)
    else
        require("lua.client.core.login.FacebookUtils")
        FacebookUtils.Login(function(userId)
            ---@type AuthenticationInBound
            local authenticationInBound = zg.playerData:GetMethod(PlayerDataMethod.AUTHENTICATION)
            if zg.networkMgr.isLogin == true and authenticationInBound ~= nil and userId == authenticationInBound.facebookId then
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("login_current_account"))
            else
                LoginUtils.LoginOrRegisterByMethod(AuthMethod.LOGIN_BY_FACEBOOK, AuthMethod.REGISTER_BY_FACEBOOK, userId, callbackSuccess, callbackFailed)
            end
        end, callbackFailed)
    end
end

--- @return void
function LoginUtils.LoginOrRegisterByGoogle(callbackSuccess, callbackFailed)
    if IS_EDITOR_PLATFORM then
        LoginUtils.LoginOrRegisterByMethod(AuthMethod.LOGIN_BY_GOOGLE, AuthMethod.REGISTER_BY_GOOGLE, "gg-" .. DEVICE_INFO, callbackSuccess, callbackFailed)
    else
        require("lua.client.core.login.PlatformLoginUtils")
        PlatformLoginUtils.Login(function(userId)
            ---@type AuthenticationInBound
            local authenticationInBound = zg.playerData:GetMethod(PlayerDataMethod.AUTHENTICATION)
            if zg.networkMgr.isLogin == true and authenticationInBound ~= nil and userId == authenticationInBound.googleId then
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("login_current_account"))
            else
                LoginUtils.LoginOrRegisterByMethod(AuthMethod.LOGIN_BY_GOOGLE, AuthMethod.REGISTER_BY_GOOGLE, userId, callbackSuccess, callbackFailed)
            end
        end, callbackFailed)
    end
end

--- @return void
function LoginUtils.LoginOrRegisterByApple(callbackSuccess, callbackFailed)
    if IS_EDITOR_PLATFORM then
        LoginUtils.LoginOrRegisterByMethod(AuthMethod.LOGIN_BY_APPLE, AuthMethod.REGISTER_BY_APPLE, "aa-" .. DEVICE_INFO, callbackSuccess, callbackFailed)
    else
        require("lua.client.core.login.PlatformLoginUtils")
        PlatformLoginUtils.Login(function(userId)
            ---@type AuthenticationInBound
            local authenticationInBound = zg.playerData:GetMethod(PlayerDataMethod.AUTHENTICATION)
            if zg.networkMgr.isLogin == true and authenticationInBound ~= nil and userId == authenticationInBound.appleId then
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("login_current_account"))
            else
                LoginUtils.LoginOrRegisterByMethod(AuthMethod.LOGIN_BY_APPLE, AuthMethod.REGISTER_BY_APPLE, userId, callbackSuccess, callbackFailed)
            end
        end, callbackFailed)
    end
end

--- @return void
function LoginUtils.LoginByUPHash(userName, passwordHash, callbackSuccess, callbackFailed)
    local success = function()
        PlayerSetting.SetLoginByUserName(userName, passwordHash)
        if callbackSuccess ~= nil then
            callbackSuccess()
        end
    end
    LoginUtils.Login(LoginByUPOutBound(userName, passwordHash), success, callbackFailed)
end

--- @return void
--- @param oldPass string
--- @param newPass string
function LoginUtils.ChangePassword(oldPass, newPass, callbackSuccess, callbackFailed)
    local oldPass256 = SHA2.shaHex256(oldPass)
    local newPass256 = SHA2.shaHex256(newPass)

    local onReceived = function(result)
        local onSuccess = function()
            if callbackSuccess ~= nil then
                callbackSuccess()
            end
            PlayerSettingData.passwordHash = newPass256
            PlayerSetting.SaveData()
        end

        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            if callbackFailed ~= nil then
                callbackFailed(logicCode)
            end
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.PLAYER_PASSWORD_CHANGE, UnknownOutBound.CreateInstance(PutMethod.LongString, oldPass256, PutMethod.LongString, newPass256), onReceived)
end

--- @return void
--- @param serverId number
function LoginUtils.SwitchServer(serverId, callbackSuccess, callbackFailed)
    local onReceived = function(result)
        ---@type LoginInBound
        local loginInBound
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            loginInBound = LoginInBound(buffer)
        end

        local onSuccess = function()
            if callbackSuccess ~= nil then
                callbackSuccess()
            end
            loginInBound:SaveData()
        end

        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            if callbackFailed ~= nil then
                callbackFailed(logicCode)
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.PLAYER_ACCOUNT_SWITCH, UnknownOutBound.CreateInstance(PutMethod.Short, serverId), onReceived)
end

--- @return void
--- @param userName string
--- @param password string
function LoginUtils.BindAccountByUP(userName, password, callbackSuccess, callbackFailed)
    local passwordHash = SHA2.shaHex256(password)
    local onReceived = function(result)
        if callbackSuccess == nil then
            XDebug.Error("Missing callbackSuccess method")
        end
        local onSuccess = function()
            callbackSuccess()
            PlayerSetting.SetLoginByUserName(userName, passwordHash)
        end

        local onFailed = function(logicCode)
            if logicCode == LogicCode.AUTH_PASSWORD_MISMATCHED then
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("password_failed"))
            else
                SmartPoolUtils.LogicCodeNotification(logicCode)
            end
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            if callbackFailed ~= nil then
                callbackFailed(logicCode)
            end
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.PLAYER_ACCOUNT_BIND, UnknownOutBound.CreateInstance(PutMethod.Byte, AuthMethod.BIND_ACCOUNT_BY_USER_NAME, PutMethod.String, userName, PutMethod.LongString, passwordHash), onReceived)
end

--- @return void
--- @param authMethod AuthMethod
--- @param userId string
function LoginUtils.BindAccountByMethod(authMethod, userId, callbackSuccess, callbackFailed)
    local onSuccess = function()
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("binding_success"))
        if callbackSuccess ~= nil then
            callbackSuccess()
        end
    end
    local onFailed = function(logicCode)
        SmartPoolUtils.LogicCodeNotification(logicCode)
        if callbackFailed ~= nil then
            callbackFailed(logicCode)
        end
    end
    NetworkUtils.RequestAndCallback(
            OpCode.PLAYER_ACCOUNT_BIND,
            UnknownOutBound.CreateInstance(PutMethod.Byte, authMethod, PutMethod.String, userId),
            onSuccess,
            onFailed
    )
end

--- @return void
function LoginUtils.BindAccountByFacebook(callbackSuccess, callbackFailed)
    local bind = function(userId)
        LoginUtils.BindAccountByMethod(AuthMethod.BIND_ACCOUNT_BY_FACEBOOK, userId, function()
            ---@type AuthenticationInBound
            local authenticationInBound = zg.playerData:GetMethod(PlayerDataMethod.AUTHENTICATION)
            authenticationInBound.facebookId = userId
            if callbackSuccess ~= nil then
                callbackSuccess()
            end
        end, callbackFailed)
    end
    if IS_EDITOR_PLATFORM then
        bind("ff-" .. DEVICE_INFO)
    else
        require("lua.client.core.login.FacebookUtils")
        FacebookUtils.Login(function(userId)
            bind(userId)
        end, callbackFailed)
    end
end

--- @return void
function LoginUtils.BindAccountByGoogle(callbackSuccess, callbackFailed)
    local bind = function(userId)
        LoginUtils.BindAccountByMethod(AuthMethod.BIND_ACCOUNT_BY_GOOGLE, userId, function()
            ---@type AuthenticationInBound
            local authenticationInBound = zg.playerData:GetMethod(PlayerDataMethod.AUTHENTICATION)
            authenticationInBound.googleId = userId
            if callbackSuccess ~= nil then
                callbackSuccess()
            end
        end, callbackFailed)
    end
    if IS_EDITOR_PLATFORM then
        bind("gg-" .. DEVICE_INFO)
    else
        require("lua.client.core.login.PlatformLoginUtils")
        PlatformLoginUtils.Login(function(userId)
            bind(userId)
        end, callbackFailed)
    end
end

--- @return void
function LoginUtils.BindAccountByApple(callbackSuccess, callbackFailed)
    local bind = function(userId)
        LoginUtils.BindAccountByMethod(AuthMethod.BIND_ACCOUNT_BY_APPLE, userId, function()
            ---@type AuthenticationInBound
            local authenticationInBound = zg.playerData:GetMethod(PlayerDataMethod.AUTHENTICATION)
            authenticationInBound.appleId = userId
            if callbackSuccess ~= nil then
                callbackSuccess()
            end
        end, callbackFailed)
    end
    if IS_EDITOR_PLATFORM then
        bind("aa-" .. DEVICE_INFO)
    else
        require("lua.client.core.login.PlatformLoginUtils")
        PlatformLoginUtils.Login(function(userId)
            bind(userId)
        end, callbackFailed)
    end
end

--- @return void
function LoginUtils.BindAccountBySunGame(callbackSuccess, callbackFailed, onAuthenticateUpdated)
    local bind = function(token, uuid)
        local onSuccess = function()
            ---@type AuthenticationInBound
            local authenticationInBound = zg.playerData:GetMethod(PlayerDataMethod.AUTHENTICATION)
            authenticationInBound.sunGameId = 1
            PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.AUTHENTICATION }, onAuthenticateUpdated, nil, false)
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("binding_success"))
            if callbackSuccess ~= nil then
                callbackSuccess()
            end
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            if callbackFailed ~= nil then
                callbackFailed(logicCode)
            end
        end
        NetworkUtils.RequestAndCallback(
                OpCode.PLAYER_ACCOUNT_BIND,
                UnknownOutBound.CreateInstance(PutMethod.Byte, AuthMethod.BIND_ACCOUNT_BY_SUN_GAME,
                        PutMethod.LongString, token, PutMethod.LongString, uuid),
                onSuccess,
                onFailed
        )
    end

    local needLogin = function(token, uuid)
        PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("need_login_by_sungame"), nil, function()
            LoginUtils.BindAccountBySunGame(callbackSuccess, callbackFailed)
        end)
    end
    if IS_EDITOR_PLATFORM then
        bind("sunId", "uuid")
    else
        zg.sungameMgr:Login(bind, needLogin, needLogin)
    end
end

--- @param mail string
--- @param code number
--- @param password string
--- @param callbackSuccess function
--- @param callbackFailed function
function LoginUtils.ResetPassword(mail, code, password, callbackSuccess, callbackFailed)
    local outBound = UnknownOutBound.CreateInstance(PutMethod.String, mail, PutMethod.Int, code, PutMethod.LongString, SHA2.shaHex256(password))
    NetworkUtils.RequestAndCallback(OpCode.PLAYER_PASSWORD_RESET, outBound, callbackSuccess, callbackFailed)
end

--- @return void
function LoginUtils.LogInCacheMethod(loginSuccess, loginFailed)
    --XDebug.Log("LoginUtils.LogInCacheMethod")
    if PlayerSettingData.authMethod == AuthMethod.LOGIN_BY_TOKEN then
        LoginUtils.LoginByToken(loginSuccess, loginFailed, PlayerSettingData.guestToken)
        --LoginUtils.LoginByToken(loginSuccess, loginFailed)
    elseif PlayerSettingData.authMethod == AuthMethod.LOGIN_BY_USER_NAME then
        LoginUtils.LoginByUPHash(PlayerSettingData.userName, PlayerSettingData.passwordHash, loginSuccess, loginFailed)
    elseif PlayerSettingData.authMethod == AuthMethod.LOGIN_BY_SUN_GAME
            or PlayerSettingData.authMethod == AuthMethod.REGISTER_BY_SUN_GAME
            or PlayerSettingData.authMethod == AuthMethod.LOGIN_BY_SUN_GAME_USER_ID then
        if PlayerSettingData.loginId ~= nil then
            LoginUtils.LoginBySunGameUserId(PlayerSettingData.loginId, loginSuccess, loginFailed)
        elseif loginFailed ~= nil then
            loginFailed()
        else
            XDebug.Log("PlayerSettingData.authMethod == AuthMethod.LOGIN_BY_SUN_GAME")
        end
    else
        LoginUtils.LoginByMethod(PlayerSettingData.authMethod, PlayerSettingData.loginId, loginSuccess, loginFailed)
    end
end

--- @return void
function LoginUtils.AutoLogin()
    local touchObject = TouchUtils.Spawn("LoginUtils.AutoLogin")
    local autoLogin = function()
        touchObject:Enable()
        local openLogin = function()
            local data = {
                callbackLoginSuccess = LoginUtils.LoginComplete,
                canCloseByBackButton = false
            }
            PopupMgr.ShowPopup(UIPopupName.UISwitchAccount, data)
        end
        if PlayerSetting.IsLogin() == true then
            local loginFailed = function()
                --RxMgr.notificationLoading:Next()
                zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
                SceneMgr.ResetToDownloadView()
                openLogin()
            end
            if PlayerSettingData.guestToken == DEVICE_INFO and PlayerSettingData.emailState ~= EmailState.VERIFIED then
                LoginUtils.LoginOrRegisterByToken(LoginUtils.LoginComplete, loginFailed)
            else
                LoginUtils.LogInCacheMethod(LoginUtils.LoginComplete, loginFailed)
            end
        else
            local registerFailed = function(logicCode)
                LoginUtils.LoginByToken(LoginUtils.LoginComplete, openLogin)
            end
            LoginUtils.RegisterByToken(LoginUtils.LoginComplete, registerFailed)
        end
    end
    NetworkUtils.WaitForHandShake(autoLogin)
end

--- @return void
function LoginUtils.LoginComplete()
    Coroutine.start(function()
        RxMgr.notificationLoading:Next(LanguageUtils.LocalizeCommon("preload_resources"))
        ResourceMgr.GetPurchaseConfig():GetAllPackBase()
        coroutine.waitforseconds(0.1)
        RxMgr.notificationLoading:Next(LanguageUtils.LocalizeCommon("load_user_data"))
        coroutine.waitforseconds(0.1)
        NetworkUtils.RequestPlayerData(function()
            local status, message = pcall(function()
                PlayerSetting.SaveData()
                zg.iapMgr:InitProduct()
                PopupMgr.ShowAndHidePopup(UIPopupName.UILoading, nil, UIPopupName.UIDownload)
                ResourceLoadUtils.InitLoadResource()
            end)
            if status == false then
                XDebug.Error(message)
            end
        end)
        ServerListInBound.Request()
    end)
end

function LoginUtils.RequestAdvertisingIdentifierAsync(callback)
    local  advertisingId = tostring(zgUnity.ironSrc:GetAdID())
    if advertisingId then
        print("RequestAdvertisingIdentifierAsync: playerId: " .. advertisingId)
        callback(advertisingId)
    end
end