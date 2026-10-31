--- @class UIDeletePublisherView : UIBaseView
UIDeletePublisherView = Class(UIDeletePublisherView, UIBaseView)

--- @param model UIDeletePublisherModel
function UIDeletePublisherView:Ctor(model)
    ---@type UIDeletePublisherConfig
    self.config = nil

    UIBaseView.Ctor(self, model)
    --- @type UIDeletePublisherModel
    self.model = model
end

--- @return void
function UIDeletePublisherView:OnReadyCreate()
    ---@type UIDeletePublisherConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

--- @return void
function UIDeletePublisherView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("sungame_die_title")
    self.config.textDetail.text = LanguageUtils.LocalizeCommon("sungame_die_detail")
    self.config.textToBinding.text = LanguageUtils.LocalizeCommon("go_to_binding")
end

--- @return void
function UIDeletePublisherView:OnReadyShow()
    self.config.buttonToBinding.onClick:RemoveAllListeners()
    if not zg.playerData:GetMethod(PlayerDataMethod.AUTHENTICATION):IsAccountBindingNotFansipan() then
        self.config.textToBinding.text = LanguageUtils.LocalizeCommon("go_to_binding")
        self.config.buttonToBinding.onClick:AddListener(function()
            self:OnClickGoToBinding()
        end)
    else
        self.config.textToBinding.text = LanguageUtils.LocalizeCommon("ok")
        self.config.buttonToBinding.onClick:AddListener(function()
            PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
        end)
    end
end

function UIDeletePublisherView:OnClickGoToBinding()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil , self.model.uiName)
    ---@type AuthenticationInBound
    local authenticationInBound = zg.playerData:GetMethod(PlayerDataMethod.AUTHENTICATION)
    if authenticationInBound ~= nil and authenticationInBound.emailState ~= nil then
        UIBaseView.CheckBlurMain(true, true, function()
            PopupMgr.ShowAndHidePopup(UIPopupName.UIGeneralSetting, { isAutoClickRegister = true }, UIPopupName.UIMainArea)
        end)
    else
        AuthenticationInBound.Request(function()
            UIBaseView.CheckBlurMain(true, true, function()
                PopupMgr.ShowAndHidePopup(UIPopupName.UIGeneralSetting, { isAutoClickRegister = true } , UIPopupName.UIMainArea)
            end)
        end)
    end
end


--- @return void
function UIDeletePublisherView:Hide()
    UIBaseView.Hide(self)
    zg.playerData.remoteConfig.lastTimeShowPopupDeletePublisher = zg.timeMgr:GetServerTime()
    zg.playerData:SaveRemoteConfig()
end