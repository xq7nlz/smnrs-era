require "lua.client.core.network.coupon.CouponRequest"

local SettingTab = {
    Account = 1,
    Setting = 2,
    Community = 3,
    Coupon = 4,
    Block = 5,
}
local GRAPHIC_QUALITY = {
    LOW = 1,
    MEDIUM = 2,
    HIGH = 3,
}

--- @class UIGeneralSettingView : UIBaseView
UIGeneralSettingView = Class(UIGeneralSettingView, UIBaseView)

--- @return void
--- @param model UIGeneralSettingModel
function UIGeneralSettingView:Ctor(model)
    ---@type UIGeneralSettingConfig
    self.config = nil
    ---@type UIAccountConfig
    self.accountConfig = nil
    ---@type UISettingConfig
    self.settingConfig = nil
    ---@type UIBlockConfig
    self.blockConfig = nil
    ---@type UICommunityConfig
    self.communityConfig = nil

    self.tabDic = Dictionary()
    --- @type UISelect
    self.selectGraphicQuality = nil
    ---@type VipIconView
    self.iconVip = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type BlockPlayerDetailInBound
    self.blockPlayerDetailInBound = nil
    UIBaseView.Ctor(self, model)
    --- @type UIGeneralSettingModel
    self.model = model
end

--- @return void
function UIGeneralSettingView:OnReadyCreate()
    ---@type UIGeneralSettingConfig
    self.config = UIBaseConfig(self.uiTransform)
    --- @type UICouponConfig
    self.accountConfig = UIBaseConfig(self.config.content:GetChild(SettingTab.Account - 1))
    self.settingConfig = UIBaseConfig(self.config.content:GetChild(SettingTab.Setting - 1))
    self.communityConfig = UIBaseConfig(self.config.content:GetChild(SettingTab.Community - 1))
    self.couponConfig = UIBaseConfig(self.config.content:GetChild(SettingTab.Coupon - 1))
    self.blockConfig = UIBaseConfig(self.config.content:GetChild(SettingTab.Block - 1))

    --- @type UnityEngine_UI_Text
    self.couponConfig.textPlaceHolder = self.couponConfig.transform:Find("InputField/Placeholder"):GetComponent(ComponentName.UnityEngine_UI_Text)

    self.couponConfig.buttonConfirm.onClick:AddListener(function()
        local canUseGiftCode = ClientConfigUtils.CheckUnlockMinorFeatureAndNotification(MinorFeatureType.GIFT_CODE, true)
        if (canUseGiftCode) then
            zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
            CouponRequest.SendCode(self.couponConfig.textCoupon.text)
        end
    end)

    -- ACCOUNT
    self.accountConfig.buttonRegisterAccount.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickRegister()
    end)
    self.accountConfig.buttonChangePassword.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickChangePassword()
    end)
    self.accountConfig.buttonSwitchAccount.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSwitchAccount()
    end)
    self.accountConfig.buttonSwitchServer.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSwitchServer()
    end)
    self.accountConfig.buttonEmailVerify.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEmailVerify()
    end)
    self.accountConfig.buttonFacebook.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBindFacebook()
    end)
    self.accountConfig.buttonGoogle.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBindGoogle()
    end)
    self.accountConfig.buttonApple.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBindApple()
    end)
    self.accountConfig.buttonTermOfUse.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickTermOfUse()
    end)
    self.accountConfig.buttonPolicy.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickPolicy()
    end)

    self.accountConfig.buttonSunGame.gameObject:SetActive(false)

    self.accountConfig.buttonDeleteAccount.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        self:OnClickDeleteAccount()
    end)

    -- SETTING
    --- @param obj UnityEngine_UI_Button
    --- @param isSelect boolean
    local onSelectQuality = function(obj, isSelect, indexTab)
        if obj ~= nil then
            UIUtils.SetInteractableButton(obj, not isSelect)
        end
    end
    local onChangeSelectQuality = function(indexTab, lastIndex)
        if indexTab ~= nil then
            zg:SetClientGraphic(indexTab)

            self.settingConfig.graphicSelect.position = self.settingConfig.graphic:GetChild(indexTab - 1).position

            self:SetupTitleGraphic()

            self:OnClickHideGraphic()

            PlayerSetting.LoadData()

            print(">> Reload ", PlayerSettingData.graphicQuality)
        end
    end
    self.selectGraphicQuality = UISelect(self.settingConfig.graphic, nil, onSelectQuality, onChangeSelectQuality)

    self:SetDefaultValueSlide()

    self.settingConfig.sliderMusic.onValueChanged:AddListener(function(value)
        if not (PlayerSettingData.isMuteMusic == true and value == 0) then
            PlayerSettingData.musicValue = value
            PlayerSettingData.isMuteMusic = (value == 0)
            self:UpdateMusicSetting(true)
        end
    end)
    self.settingConfig.sliderSound.onValueChanged:AddListener(function(value)
        if not (PlayerSettingData.isMuteSound == true and value == 0) then
            PlayerSettingData.soundValue = value
            PlayerSettingData.isMuteSound = (value == 0)
            self:UpdateSoundSetting(true)
        end
    end)
    self.settingConfig.selectGraphicBtn.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickOpenGraphic()
    end)
    self.settingConfig.hideGraphicButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHideGraphic()
    end)
    self.settingConfig.buttonMusic.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickMusic()
    end)
    self.settingConfig.buttonSound.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSound()
    end)
    self.settingConfig.buttonLanguageSetting.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickLanguage()
    end)
    self.settingConfig.selectLanguageBtn.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickLanguage()
    end)
    self.config.backGround.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)

    -- BLOCK
    --- @param obj UIBlockPlayerItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        ---@type OtherPlayerInfoInBound
        local blockData = self.blockPlayerDetailInBound.listIdBlock:Get(index + 1)
        obj:SetData(blockData, function(data)
            self:OnClickUnblock(data)
        end)
    end

    -- COMMUNITY
    self.communityConfig.buttonFacebook.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickFacebook()
    end)
    self.communityConfig.buttonTwitter.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickTwitter()
    end)
    self.communityConfig.buttonInstagram.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickInstagram()
    end)
    self.communityConfig.buttonReddit.gameObject:SetActive(false)
    self.communityConfig.buttonReddit.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickReddit()
    end)
    self.communityConfig.buttonDiscord.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickDiscord()
    end)

    --- @type UILoopScroll
    self.uiScroll = UILoopScroll(self.blockConfig.scroll, UIPoolType.UIBlockPlayerItemView, onUpdateItem, onUpdateItem)
    self:InitTabs()
    self:InitCouponView()
end

function UIGeneralSettingView:EnableGiftCode()
    local url = string.format(NetConfig.REMOTE_URL, NetConfig.loadBalancerIP, NetConfig.loadBalancerPort, "a_enable_gift_code")

    XDebug.Log("Enable Coupon: " .. url)
    local onSuccess = function(content)
        local data = json.decode(content)
        for i = 1, #data do
            ---@type {platform : string, value : string, version : string, isEnable :boolean}
            local config = data[i]
            XDebug.Log(LogUtils.ToDetail(config))
            if config.platform then
                config.platform = string.lower(config.platform)
            end
            if ((IS_ANDROID_PLATFORM and config.platform == Platform.Android)
                    or (IS_IOS_PLATFORM and config.platform == Platform.IOS)
                    or (IS_EDITOR_PLATFORM and config.platform == Platform.Unity)
                    or (config.platform == Platform.All))
                    and config.version == VERSION_CLIENT_BUILD
            then
                if config.isEnable == nil then
                    config.isEnable = true
                end
                self.config.tab:GetChild(SettingTab.Coupon - 1).gameObject:SetActive(config.isEnable)
                self.accountConfig.buttonDeleteAccount.gameObject:SetActive(config.isEnable == false)
            end
        end
    end
    local onFailed = function()
    end
    NetworkUtils.TryRequestData(3, url, onSuccess, onFailed)
end

function UIGeneralSettingView:InitTabs()
    self.currentTab = SettingTab.Account
    self.selectTab = function(currentTab)
        self.currentTab = currentTab
        local i = 0
        for k, v in pairs(self.tabDic:GetItems()) do
            local isSelect = k == currentTab
            if isSelect then
                self.config.titleSetting.text = v.config.textTabName.text
                self.config.titleIcon.sprite = v.config.iconDefault.sprite
                self.config.titleIcon:SetNativeSize()
            end
            v:SetTabState(isSelect)
            self.config.content:GetChild(i).gameObject:SetActive(isSelect)
            i = i + 1
        end
        if self.currentTab == SettingTab.Block then
            self:ShowBlockPlayer()
        end
        --self.funSelectTab[self.currentTab](self)
    end
    local addTab = function(tabId, anchor, localizeFunction)
        self.tabDic:Add(tabId, UITabItem(anchor, self.selectTab, localizeFunction, tabId))
    end
    addTab(SettingTab.Account, self.config.accountTab, function()
        return LanguageUtils.LocalizeCommon("account")
    end)
    addTab(SettingTab.Community, self.config.communityTab, function()
        return LanguageUtils.LocalizeCommon("community")
    end)
    addTab(SettingTab.Setting, self.config.settingTab, function()
        return LanguageUtils.LocalizeCommon("setting")
    end)
    addTab(SettingTab.Coupon, self.config.couponTab, function()
        return LanguageUtils.LocalizeCommon("gift_code")
    end)
    addTab(SettingTab.Block, self.config.blockTab, function()
        return LanguageUtils.LocalizeCommon("block")
    end)
end

function UIGeneralSettingView:InitCouponView()
    local isEnable = true
    --- @type UITabItem
    local tabCoupon = self.tabDic:Get(SettingTab.Coupon)
    tabCoupon:SetActive(isEnable)
    self.communityConfig.gameObject:SetActive(isEnable)
end

function UIGeneralSettingView:InitLocalization()
    if self.tabDic ~= nil then
        --- @param v UITabItem
        for _, v in pairs(self.tabDic:GetItems()) do
            v:InitLocalization()
        end
    end
    --!1.2.19!
    self.couponConfig.textConfirm.text = LanguageUtils.LocalizeCommon("confirm")
    self.couponConfig.textConfirm.text = LanguageUtils.LocalizeCommon("confirm")
    self.couponConfig.textCoupon.text = LanguageUtils.LocalizeCommon("enter_redemption_code") .. "..."
    --!1.2.19!

    self.config.textTapToClose.gameObject:SetActive(false)

    -- ACCOUNT
    local localizeBinded = LanguageUtils.LocalizeCommon("binded")
    self.accountConfig.localizeId.text = LanguageUtils.LocalizeCommon("id")
    self.accountConfig.localizeSummoner.text = LanguageUtils.LocalizeCommon("summoner")
    self.accountConfig.localizeSwitchAccount.text = LanguageUtils.LocalizeCommon("switch_account")
    self.accountConfig.localizeSwitchServer.text = LanguageUtils.LocalizeCommon("switch_server")
    self.accountConfig.localizeLoginFacebook.text = LanguageUtils.LocalizeCommon("binding_facebook")
    self.accountConfig.localizeLoginApple.text = LanguageUtils.LocalizeCommon("sign_in_apple")
    self.accountConfig.localizeLoginGoogle.text = LanguageUtils.LocalizeCommon("binding_google")
    if self.accountConfig.localizeSunGame ~= nil then
        self.accountConfig.localizeSunGame.text = LanguageUtils.LocalizeCommon("binding_sungame")
    end
    self.accountConfig.localizeDisableFacebook.text = localizeBinded
    self.accountConfig.localizeDisableApple.text = LanguageUtils.LocalizeCommon("continue_with_apple")
    self.accountConfig.localizeDisableGoogle.text = localizeBinded
    if self.accountConfig.localizeDisableGoogle ~= nil then
        self.accountConfig.localizeDisableSunGame.text = localizeBinded
    end
    self.accountConfig.localizeEmailVerify.text = LanguageUtils.LocalizeCommon("email_verify")
    self.accountConfig.localizeRegisterAccount.text = LanguageUtils.LocalizeCommon("binding_summoner_era")
    self.accountConfig.textGameVersion.text = Main.GetVersionInfo()
    self.accountConfig.textNotiBinding.text = LanguageUtils.LocalizeCommon("noti_binding")
    self.accountConfig.textTermOfUse.text = LanguageUtils.LocalizeCommon("term_of_use")
    self.accountConfig.textPolicy.text = LanguageUtils.LocalizeCommon("policy")
    self.accountConfig.textDeleteAccount.text = LanguageUtils.LocalizeCommon("delete_account")

    --SETTING
    self.settingConfig.localizeMusic.text = LanguageUtils.LocalizeCommon("music")
    self.settingConfig.localizeSound.text = LanguageUtils.LocalizeCommon("sound")
    self.settingConfig.localizeGraphicQuality.text = LanguageUtils.LocalizeCommon("graphic_quality")
    self.settingConfig.localizeLow.text = LanguageUtils.LocalizeCommon("low")
    self.settingConfig.localizeMedium.text = LanguageUtils.LocalizeCommon("medium")
    self.settingConfig.localizeHigh.text = LanguageUtils.LocalizeCommon("high")
    self.settingConfig.localizeLanguageSetting.text = LanguageUtils.LocalizeCommon("language_setting")
    self.settingConfig.titleLanguage.text = LanguageUtils.LocalizeCommon("language")

    --COMMUNITY
    self.blockConfig.textEmpty.text = LanguageUtils.LocalizeCommon("empty")

    self.couponConfig.textPlaceHolder.text = LanguageUtils.LocalizeCommon("enter_redemption_code")
end

--- @return void
function UIGeneralSettingView:OnReadyShow(data)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    self:EnableGiftCode()
    self.blockPlayerDetailInBound = zg.playerData:GetBlockPlayerDetailInBound()
    self.selectTab(SettingTab.Account)
    self:UpdateAccount()
    self:UpdateSetting(false)
    self:InitListener()
    self:ShowDetectPlatform()
    self.accountConfig.buttonSwitchServer.gameObject:SetActive(true)

    ---@type Subscription
    self.subscriptionBindingAccount = RxUtils.WaitOfCode(OpCode.PLAYER_ACCOUNT_BIND):Merge(RxUtils.WaitOfCode(OpCode.PLAYER_EMAIL_VERIFY))
                                             :Subscribe(function()
        self:UpdateAccount()
    end)

    if data ~= nil and data.isAutoClickRegister then
        self:OnClickRegister()
    end
end

--- @return void
function UIGeneralSettingView:ShowDetectPlatform()
    if IS_IOS_PLATFORM or IS_EDITOR_PLATFORM then
        self.accountConfig.buttonFacebook.gameObject:SetActive(true)
        self.accountConfig.buttonApple.gameObject:SetActive(true)
        self.accountConfig.buttonGoogle.gameObject:SetActive(false)
    elseif IS_ANDROID_PLATFORM then
        self.accountConfig.buttonFacebook.gameObject:SetActive(true)
        self.accountConfig.buttonApple.gameObject:SetActive(false)
        self.accountConfig.buttonGoogle.gameObject:SetActive(true)
    else
        self.accountConfig.buttonFacebook.gameObject:SetActive(false)
        self.accountConfig.buttonApple.gameObject:SetActive(false)
        self.accountConfig.buttonGoogle.gameObject:SetActive(false)
    end
end

--- @return void
function UIGeneralSettingView:Hide()
    UIBaseView.Hide(self)
    if self.iconVip ~= nil then
        self.iconVip:ReturnPool()
        self.iconVip = nil
    end
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end
    self:RemoveListener()
    if self.subscriptionBindingAccount ~= nil then
        self.subscriptionBindingAccount:Unsubscribe()
        self.subscriptionBindingAccount = nil
    end
end

--- @return void
function UIGeneralSettingView:InitListener()
    self.listener = RxMgr.registerSuccess:Subscribe(RxMgr.CreateFunction(self, self.Init))
end

--- @return void
function UIGeneralSettingView:RemoveListener()
    self.listener:Unsubscribe()
end

--- @return void
function UIGeneralSettingView:Init(result)
    self:UpdateAccount()
end

function UIGeneralSettingView:SetupTitleGraphic()
    local graphicQualityType = PlayerSettingData.graphicQuality
    if graphicQualityType == GRAPHIC_QUALITY.LOW then
        self.settingConfig.titleGraphicText.text = LanguageUtils.LocalizeCommon("low")
    elseif graphicQualityType == GRAPHIC_QUALITY.MEDIUM then
        self.settingConfig.titleGraphicText.text = LanguageUtils.LocalizeCommon("medium")
    elseif graphicQualityType == GRAPHIC_QUALITY.HIGH then
        self.settingConfig.titleGraphicText.text = LanguageUtils.LocalizeCommon("high")
    else

    end
end
--- @return void
function UIGeneralSettingView:UpdateSetting(needSaveData)
    self.selectGraphicQuality:Select(PlayerSettingData.graphicQuality)

    self:SetupTitleGraphic()

    self:UpdateMusicSetting()

    self:UpdateSoundSetting()

    if PlayerSettingData.language ~= nil then
        ---@type  Language
        local currentLanguage = LanguageUtils.GetLanguageByType(PlayerSettingData.language)
        if currentLanguage ~= nil then
            self.settingConfig.titleLanguage.text = currentLanguage.name
        end
    end

    if needSaveData ~= false then
        PlayerSetting.SaveData()
    end
end

function UIGeneralSettingView:UpdateSoundSetting(needSaveData)
    self.settingConfig.iconTatSound:SetActive(PlayerSettingData.isMuteSound)
    self.settingConfig.iconSoundOn:SetActive(not PlayerSettingData.isMuteSound)
    self.settingConfig.sliderSound.value = PlayerSettingData.isMuteSound == true and 0 or PlayerSettingData.soundValue
    zg.audioMgr:SetSoundVolume(PlayerSettingData.soundValue, PlayerSettingData.isMuteSound)

    if needSaveData == true then
        PlayerSetting.SaveData()
    end
end

function UIGeneralSettingView:UpdateMusicSetting(needSaveData)
    self.settingConfig.iconTatMusic:SetActive(PlayerSettingData.isMuteMusic)
    self.settingConfig.iconMusicOn:SetActive(not PlayerSettingData.isMuteMusic)
    self.settingConfig.sliderMusic.value = PlayerSettingData.isMuteMusic == true and 0 or PlayerSettingData.musicValue
    zg.audioMgr:SetMusicVolume(PlayerSettingData.musicValue, PlayerSettingData.isMuteMusic)

    if needSaveData == true then
        PlayerSetting.SaveData()
    end
end

--SETTING
--- @return void
function UIGeneralSettingView:OnClickMusic()
    if PlayerSettingData.isMuteMusic == true then
        PlayerSettingData.isMuteMusic = false
        if PlayerSettingData.musicValue == 0 then
            PlayerSettingData.musicValue = 0.5
        end
    else
        PlayerSettingData.isMuteMusic = true
    end
    self:UpdateMusicSetting(true)
end

--- @return void
function UIGeneralSettingView:OnClickSound()
    if PlayerSettingData.isMuteSound == true then
        PlayerSettingData.isMuteSound = false
        if PlayerSettingData.soundValue == 0 then
            PlayerSettingData.soundValue = 0.5
        end
    else
        PlayerSettingData.isMuteSound = true
    end
    self:UpdateSoundSetting(true)
end

function UIGeneralSettingView:OnClickOpenGraphic()
    self.settingConfig.iconGraphicState.transform.localScale = U_Vector3(1, -1, 1)
    self.settingConfig.selectGraphicBtn.enabled = false
    self.settingConfig.graphicStateList:SetActive(true)
    self.settingConfig.hideGraphicButton.gameObject:SetActive(true)
end

function UIGeneralSettingView:OnClickHideGraphic()
    self.settingConfig.iconGraphicState.transform.localScale = U_Vector3(1, 1, 1)
    self.settingConfig.selectGraphicBtn.enabled = true
    self.settingConfig.graphicStateList:SetActive(false)
    self.settingConfig.hideGraphicButton.gameObject:SetActive(false)
end

function UIGeneralSettingView:OnClickLanguage()
    local data = {}
    data.callbackChangeLanguage = function()
        SceneMgr.ResetToMainArea()
    end
    PopupMgr.ShowPopup(UIPopupName.UILanguageSetting, data)
end

--ACCOUNT
--- @return void
function UIGeneralSettingView:UpdateAccount()
    ---@type AuthenticationInBound
    local authenticationInBound = zg.playerData:GetMethod(PlayerDataMethod.AUTHENTICATION)
    if self.iconVip == nil then
        self.iconVip = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipIconView, self.accountConfig.avatarTuong)
    end
    ---@type BasicInfoInBound
    local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)

    self.iconVip:SetData(basicInfoInBound.avatarData:GetAvatar(), basicInfoInBound.level, basicInfoInBound.avatarData:GetFrame())
    self.accountConfig.textId.text = tostring(PlayerSettingData.playerId)
    self.accountConfig.textSummon.text = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).name
    if authenticationInBound.userName == "" then
        self.accountConfig.buttonRegisterAccount.gameObject:SetActive(true)
        --self.accountConfig.buttonChangePassword.gameObject:SetActive(false)
        self.accountConfig.buttonEmailVerify.gameObject:SetActive(false)
    else
        self.accountConfig.buttonRegisterAccount.gameObject:SetActive(false)
        --self.accountConfig.buttonChangePassword.gameObject:SetActive(true)
        self.accountConfig.buttonEmailVerify.gameObject:SetActive(true)
        if authenticationInBound.emailState == EmailState.VERIFIED then
            self.accountConfig.buttonEmailVerify.enabled = false
            local str = authenticationInBound.email:Split("@")
            self.accountConfig.localizeEmailVerify.text = string.format(LanguageUtils.LocalizeCommon("mail_verified"),
                    string.format("%s***@%s", string.sub(str[1], 1, string.len(str[1]) - 3), str[2]))
        else
            self.accountConfig.buttonEmailVerify.enabled = true
            self.accountConfig.localizeEmailVerify.text = LanguageUtils.LocalizeCommon("email_verify")
        end
    end

    if authenticationInBound.facebookId == "" then
        self.accountConfig.localizeDisableFacebook.transform.parent.gameObject:SetActive(false)
        self.accountConfig.localizeLoginFacebook.transform.parent.gameObject:SetActive(true)
    else
        self.accountConfig.localizeDisableFacebook.transform.parent.gameObject:SetActive(true)
        self.accountConfig.localizeLoginFacebook.transform.parent.gameObject:SetActive(false)
    end

    if authenticationInBound.googleId == "" then
        self.accountConfig.localizeDisableGoogle.transform.parent.gameObject:SetActive(false)
        self.accountConfig.localizeLoginGoogle.transform.parent.gameObject:SetActive(true)
    else
        self.accountConfig.localizeDisableGoogle.transform.parent.gameObject:SetActive(true)
        self.accountConfig.localizeLoginGoogle.transform.parent.gameObject:SetActive(false)
    end

    if authenticationInBound.appleId == "" then
        self.accountConfig.localizeDisableApple.transform.parent.gameObject:SetActive(false)
        self.accountConfig.localizeLoginApple.transform.parent.gameObject:SetActive(true)
    else
        self.accountConfig.localizeDisableApple.transform.parent.gameObject:SetActive(true)
        self.accountConfig.localizeLoginApple.transform.parent.gameObject:SetActive(false)
    end

    self.accountConfig.localizeDisableSunGame.transform.parent.gameObject:SetActive(false)
    self.accountConfig.localizeSunGame.transform.parent.gameObject:SetActive(true)

    if authenticationInBound:IsAccountBinding() then
        self.accountConfig.textNotiBinding.gameObject:SetActive(false)
    else
        self.accountConfig.textNotiBinding.gameObject:SetActive(true)
    end
end

--- @return void
function UIGeneralSettingView:OnClickRegister()
    PopupMgr.ShowPopup(UIPopupName.UIRegisterAccount, { ["isBindingAccount"] = true })
end

--- @return void
function UIGeneralSettingView:OnClickChangePassword()
    PopupMgr.ShowPopup(UIPopupName.UIChangePassword)
end

--- @return void
function UIGeneralSettingView:OnClickSwitchAccount()
    PopupMgr.ShowPopup(UIPopupName.UISwitchAccount, { ["callbackLoginSuccess"] = SceneMgr.RequestAndResetToMainArea, ["canRegister"] = false })
end

--- @return void
function UIGeneralSettingView:OnClickSwitchServer()
    local openSwitchServer = function()
        PopupMgr.ShowPopup(UIPopupName.UISwitchServer)
    end
    if zg.playerData:GetServerListInBound():IsAvailableToRequest() == false then
        openSwitchServer()
    else
        ServerListInBound.Request(openSwitchServer)
    end
end

--- @return void
---@param data OtherPlayerInfoInBound
function UIGeneralSettingView:OnClickUnblock(data)
    NetworkUtils.BlockPlayer(data.playerId, false, function()
        zg.playerData:GetMethod(PlayerDataMethod.BLOCKED_PLAYER_LIST):Remove(data.playerId)
        if self.blockPlayerDetailInBound:IsAvailableToRequest() == false then
            self.uiScroll:RefreshCells(self.blockPlayerDetailInBound.listIdBlock:Count())
        else
            self.uiScroll:Resize(0)
        end
    end)
end

--- @return void
function UIGeneralSettingView:OnClickEmailVerify()
    PopupMgr.ShowPopup(UIPopupName.UIEmailVerify, { ["verifySuccess"] = function()
        self:UpdateAccount()
    end, ["isVerifyEmail"] = true })
end

--- @return void
function UIGeneralSettingView:OnClickBindFacebook()
    LoginUtils.BindAccountByFacebook()
end

--- @return void
function UIGeneralSettingView:OnClickBindGoogle()
    LoginUtils.BindAccountByGoogle()
end

--- @return void
function UIGeneralSettingView:OnClickBindApple()
    LoginUtils.BindAccountByApple()
end

--- @return void
function UIGeneralSettingView:OnClickBindSunGame()
    LoginUtils.BindAccountBySunGame(nil, nil, function()
        self:UpdateAccount()
    end)
end

--- @return void
function UIGeneralSettingView:OnClickDeleteAccount()
    PopupMgr.ShowPopup(UIPopupName.UIDeleteAccount, { stepPage = 1 })
end

--- @return void
function UIGeneralSettingView:ShowBlockPlayer()
    local showBlock = function()
        if self.blockPlayerDetailInBound:IsAvailableToRequest() == false then
            self.uiScroll:Resize(self.blockPlayerDetailInBound.listIdBlock:Count())
            if self.blockPlayerDetailInBound.listIdBlock:Count() > 0 then
                self.blockConfig.empty:SetActive(false)
            else
                self.blockConfig.empty:SetActive(true)
            end
        else
            self.uiScroll:Resize(0)
            self.blockConfig.empty:SetActive(true)
        end
    end
    if self.blockPlayerDetailInBound:IsAvailableToRequest() == true and
            zg.playerData:GetMethod(PlayerDataMethod.BLOCKED_PLAYER_LIST).listBlock:Count() > 0 then
        local onReceived = function(result)
            local onBufferReading = function(buffer)
                self.blockPlayerDetailInBound:ReadBuffer(buffer)
            end
            local onSuccess = function()
                showBlock()
            end
            NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess)
        end
        NetworkUtils.Request(OpCode.SERVER_OTHER_PLAYER_DETAIL_LIST_GET, zg.playerData:GetMethod(PlayerDataMethod.BLOCKED_PLAYER_LIST), onReceived)
    else
        showBlock()
    end
end

--- @return void
function UIGeneralSettingView:OnClickFacebook()
    PopupUtils.OpenFanpage()
    NetworkUtils.Request(OpCode.FACEBOOK_FAN_PAGE_JOIN, nil, nil, false)
end

--- @return void
function UIGeneralSettingView:SetDefaultValueSlide()
    self.settingConfig.sliderMusic.value = PlayerSettingData.isMuteMusic == true and 0 or PlayerSettingData.musicValue
    self.settingConfig.sliderSound.value = PlayerSettingData.isMuteSound == true and 0 or PlayerSettingData.soundValue
end

--- @return void
function UIGeneralSettingView:OnClickTwitter()
    U_Application.OpenURL("https://twitter.com/SummonersEra")
end

--- @return void
function UIGeneralSettingView:OnClickInstagram()
    U_Application.OpenURL("https://www.instagram.com/summoners.era/")
end

--- @return void
function UIGeneralSettingView:OnClickReddit()
    U_Application.OpenURL("https://www.reddit.com/r/SummonersEra/")
end

--- @return void
function UIGeneralSettingView:OnClickDiscord()
    U_Application.OpenURL("https://discord.gg/jUPHrrP")
end

--- @return void
function UIGeneralSettingView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIGeneralSettingView:OnClickTermOfUse()
    U_Application.OpenURL("https://fansipan.hk/")
end

function UIGeneralSettingView:OnClickPolicy()
    U_Application.OpenURL("https://fansipan.hk/")
end