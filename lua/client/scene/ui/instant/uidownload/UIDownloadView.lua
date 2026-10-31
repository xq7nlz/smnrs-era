local NOTIFICATION_STATUS = 1
local NORMAL_STATUS = 2
local ORIGIN_SIZE = U_Vector2(2048, 1260)
local LAST_UPDATED_VERSION = "last_updated_version"

--- @class UIDownloadView : UIBaseView
UIDownloadView = Class(UIDownloadView, UIBaseView)
---@type boolean
--- @return void
--- @param model UIDownloadModel
function UIDownloadView:Ctor(model, ctrl)
    UIBaseView.Ctor(self, model, ctrl)
    --- @type UIDownloadModel
    self.model = model
end

--- @return void
function UIDownloadView:OnReadyCreate()
    uiCanvas.canTouch = true
    ---@type DownloadConfig
    self.config = UIBaseConfig(self.uiTransform)

    self:InitButtonListener()

    self:SetButtonChangeLanguage()

    uiCanvas:SetBackgroundSize(self.config.loadingScreen)

    self:SetSizeAnim()
end

function UIDownloadView:SetSizeAnim()
    if self.config.anim == nil then
        return
    end
    local newSize = self.config.loadingScreen.rectTransform.sizeDelta
    self.config.anim.transform.localScale = U_Vector3(newSize.x / ORIGIN_SIZE.x, newSize.y / ORIGIN_SIZE.y, 1)

    --- @type UnityEngine_RectTransform
    local rectTransform = self.config.anim:GetComponent(ComponentName.UnityEngine_RectTransform)
    local pos = rectTransform.anchoredPosition3D
    pos.y = pos.y * rectTransform.localScale.y
    rectTransform.anchoredPosition3D = pos
end

--- @return void
function UIDownloadView:InitLocalization()
    self.config.textTapToPlay.text = LanguageUtils.LocalizeCommon("tap_to_play")
    self.config.textVersion.text = Main.GetVersionInfo()
end

--- @return void
function UIDownloadView:SetButtonChangeLanguage()
    if self.config.buttonChangeLanguage then
        self.config.buttonChangeLanguage.gameObject:SetActive(true)
    end
end

function UIDownloadView:CheckSwitchServer()
    if PlayerSetting.IsLogin() == false then
        ServerListInBound.Request(function()
            self:SetActiveSwitchServer()
            self:UpdateCurrentServer()
        end)
    end
end

--- @return void
function UIDownloadView:OnReadyShow()
    self:InitListener()
    self:CheckSwitchServer()
    self:SwitchStatus(NORMAL_STATUS)
    self:SetMusic()
    self:ShowLanguage()
    self:SetTouchBackgroundStatus(true)
    self:CheckAutoClickBackground()
    TrackingUtils.AddFirebaseAssetDownloaded(AssetDownloadedStep.ShowPopupDownload)

    self.config.buttonLogin.gameObject:SetActive(true)

    --self:ShowTermOfUse()

    self:CheckShowChangeLog()

    self.config.buttonCheatConnection.gameObject:SetActive(zgUnity.IsTest)
end

--- @return void
function UIDownloadView:ShowTermOfUse()
    local key = "term_of_use"
    if U_PlayerPrefs.HasKey(key) == false then
        local data = {}
        data.notification = LanguageUtils.LocalizeCommon("noti_term_of_use")
        data.alignment = U_TextAnchor.MiddleCenter
        data.closeCallback = nil
        data.canCloseByBackButton = false
        local buttonNo = {}
        buttonNo.text = LanguageUtils.LocalizeCommon("term_of_use")
        buttonNo.callback = function()
            U_Application.OpenURL("https://fansipan.hk/")
        end
        data.button1 = buttonNo
        local buttonYes = {}
        buttonYes.text = LanguageUtils.LocalizeCommon("accept")
        buttonYes.callback = function()
            PopupMgr.HidePopup(UIPopupName.UIPopupNotification)
            U_PlayerPrefs.SetInt(key, 1)
        end
        data.button2 = buttonYes
        PopupMgr.ShowPopup(UIPopupName.UIPopupNotification, data)
    end
end

function UIDownloadView:CheckAutoClickBackground()
    if zgUnity.IsResetGame then
        zgUnity.IsResetGame = false
        self:OnClickBackground()
    end
end

function UIDownloadView:SetTouchBackgroundStatus(isEnable)
    self.config.buttonBackground.enabled = isEnable
end

--- @return void
function UIDownloadView:InitListener()
    self.loadingListener = RxMgr.notificationLoading:Subscribe(RxMgr.CreateFunction(self, self.UpdateNotification))
end

--- @return void
function UIDownloadView:ShowLanguage()
    ---@type  Language
    local currentLanguage = LanguageUtils.GetLanguageByType(PlayerSettingData.language)
    if currentLanguage ~= nil then
        self.config.textLanguage.text = currentLanguage.name
    end
end

--- @return void
function UIDownloadView:RemoveListener()
    if self.loadingListener ~= nil then
        self.loadingListener:Unsubscribe()
        self.loadingListener = nil
    end
end

--- @return void
function UIDownloadView:UpdateNotification(result)
    self:SetGuideText(result)
end

--- @return void
function UIDownloadView:UpdateCurrentServer()
    self.config.textServer.text = string.format("S%s", zg.playerData:GetServerListInBound():GetClusterRegister())
end

--- @return void
--- @param content string
function UIDownloadView:SetGuideText(content)
    self.config.textGuide.text = content
end

--- @return void
--- @param status number
function UIDownloadView:SwitchStatus(status)
    if status == NOTIFICATION_STATUS then
        self:SetNotificationStatus(true)
        self:SetNormalStatus(false)
    else
        self:SetNotificationStatus(false)
        self:SetNormalStatus(true)
    end
end

function UIDownloadView:SetNotificationStatus(isEnable)
    self.config.textGuide.gameObject:SetActive(isEnable)
end

function UIDownloadView:SetNormalStatus(isEnable)
    self.config.safeArea.gameObject:SetActive(isEnable)
end

function UIDownloadView:OnClickBackground()
    TrackingUtils.AddFirebaseAssetDownloaded(AssetDownloadedStep.TapToPlay)
    self:SetTouchBackgroundStatus(false)
    self:SwitchStatus(NOTIFICATION_STATUS)
    LoginUtils.AutoLogin()
    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
end

--- @return void
function UIDownloadView:InitButtonListener()
    self.config.buttonBackground.onClick:AddListener(function()
        self:OnClickBackground()
    end)

    self.config.buttonLogin.onClick:AddListener(function()
        PopupMgr.ShowPopup(UIPopupName.UISwitchAccount, { ["callbackLoginSuccess"] = function()
            self:SetTouchBackgroundStatus(false)
            LoginUtils.LoginComplete()
        end, ["callbackClose"] = function()
            PopupMgr.HidePopup(UIPopupName.UISwitchAccount)
        end })
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)

    self.config.buttonNotice.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        local data = {}
        data.callbackClose = function()
            PopupMgr.HidePopup(UIPopupName.UINewUpdate)
        end
        PopupMgr.ShowPopup(UIPopupName.UINewUpdate, data)
    end)

    self.config.buttonRecover.gameObject:SetActive(false)

    self.config.buttonPrivacyPolicy.onClick:AddListener(function()
        self:OnClickPrivacyPolicy()
    end)

    self.config.buttonChangeLanguage.onClick:AddListener(function()
        self:OnClickChangeLanguage()
    end)
    self.config.buttonCheatConnection.onClick:AddListener(function()
        UIDownloadView.FakeRandomDisconnect()
    end)
    self.config.buttonVersion.onClick:AddListener(function()
        UIUtils.CopyToClipboard(DEVICE_INFO)
    end)
end

function UIDownloadView.FakeRandomDisconnect()
    local errorCodeNumber = math.random(DisconnectReason.NO_NETWORK_CONNECTION, DisconnectReason.CANT_DOWNLOAD_BALANCER)
    zg.networkMgr:ShowNotificationDisconnect(errorCodeNumber)
end

function UIDownloadView.DeleteAllDataAndReset()
    zg:OnDestroy()
    Main.ResetGame()
end

function UIDownloadView:OnClickPrivacyPolicy()
    local url = "https://zitga.com.vn/en/fansipan-privacy-policy/"
    local openOnBrowzer = function()
        U_Application.OpenURL(url)
    end

    local delayOpenOnBrowzer = function()
        ---@type Subscription
        local listenerApplicationPause = nil
        local coroutine = Coroutine.start(function()
            coroutine.waitforseconds(0.5)
            openOnBrowzer()
            if listenerApplicationPause ~= nil then
                listenerApplicationPause:Unsubscribe()
            end
        end)
        listenerApplicationPause = RxMgr.applicationPause:Subscribe(function()
            Coroutine.stop(coroutine)
            listenerApplicationPause:Unsubscribe()
        end)
    end

    if IS_MOBILE_PLATFORM then
        delayOpenOnBrowzer()
        if IS_ANDROID_PLATFORM then
            U_Application.OpenURL(url)
        elseif IS_IOS_PLATFORM then
            U_Application.OpenURL(url)
        end
    else
        openOnBrowzer()
    end
end

function UIDownloadView:OnClickChangeLanguage()
    local data = {}
    data.callbackChangeLanguage = function()
        PopupMgr.HidePopup(UIPopupName.UILanguageSetting)
        self:ShowLanguage()
        self:InitLocalization()
    end
    PopupMgr.ShowPopup(UIPopupName.UILanguageSetting, data)
    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
end

function UIDownloadView:OnClickSwitchServer()
    local serverListInBound = zg.playerData:GetServerListInBound()
    local data = {}
    data.callbackSwitchServer = function(clusterId)
        serverListInBound.clusterRegister = clusterId
        self:UpdateCurrentServer()
    end
    data.currentClusterId = serverListInBound.clusterRegister
    PopupMgr.ShowPopup(UIPopupName.UISwitchServer, data)
    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
end

function UIDownloadView:SetMusic()
    zg.audioMgr:PlayMusic(MusicCtrl.splashMusic, true)
end

--- @return void
function UIDownloadView:OnReadyHide()
    -- do nothing
end

--- @return void
function UIDownloadView:Hide()
    UIBaseView.Hide(self)
    self:RemoveListener()

    if self.videoPlayerView then
        self.videoPlayerView:Stop()
        self.videoPlayerView = nil
    end
end

function UIDownloadView:CheckShowChangeLog()
    local lastVersion = U_PlayerPrefs.GetString(LAST_UPDATED_VERSION)
    if lastVersion == nil or lastVersion == "" then
        U_PlayerPrefs.SetString(LAST_UPDATED_VERSION, PRODUCT_VERSION)
        return
    end
    if lastVersion ~= PRODUCT_VERSION then
        U_PlayerPrefs.SetString(LAST_UPDATED_VERSION, PRODUCT_VERSION)
        PopupMgr.ShowPopup(UIPopupName.UINewUpdate)
    end
end