require "lua.client.scene.ui.home.uiFirstTopUp.FirstTopUpPackageItemView"
--- @class UIFirstTopUpView : UIBaseView
UIFirstTopUpView = Class(UIFirstTopUpView, UIBaseView)

--- @param model UIFirstTopUpModel
function UIFirstTopUpView:Ctor(model)
    --- @type UIFirstTopUpConfig
    self.config = nil
    --[[    --- @type Dictionary
        self.layoutDict = Dictionary()]]
    --[[    --- @type UIFirstTopUpLayout
        self.currentLayout = nil]]
    UIBaseView.Ctor(self, model)
    --- @type UIFirstTopUpModel
    self.model = model
    self.numberOfAvailablePackage = nil

end

function UIFirstTopUpView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    local rect = self.config.transform:GetComponent(ComponentName.UnityEngine_RectTransform)
    rect.anchorMin = Vector2(0, 0)
    rect.anchorMax = Vector2(1, 1)
    rect.pivot = Vector2(0.5, 0.5)
    if (self.listFirstTopUpPackageItemView == nil) then
        ---@type List
        self.listFirstTopUpPackageItemView = List()
        self.listFirstTopUpPackageItemView:Add(FirstTopUpPackageItemView(self.config.package1, self, 1))
        self.listFirstTopUpPackageItemView:Add(FirstTopUpPackageItemView(self.config.package2, self, 2))
    end

    -- self.config.packageLayout.gameObject:SetActive(false)
    --self.config.chooseRewardLayout.gameObject:SetActive(false)

    self:InitLocalization()
    self:InitButtons()
end

function UIFirstTopUpView:Hide()
    UIBaseView.Hide(self)
    if (self.listFirstTopUpPackageItemView ~= nil) then
        for i = 1, self.listFirstTopUpPackageItemView:Count() do
            ---@type FirstTopUpPackageItemView
            local firstTopUpPackageItemView = self.listFirstTopUpPackageItemView:Get(i)
            self.listFirstTopUpPackageItemView:Get(i):OnReadyHide()
        end
    end
end

function UIFirstTopUpView:OnClickGoShop()
    PopupMgr.ShowPopup(UIPopupName.UIIapShop, nil, UIPopupHideType.HIDE_ALL)
end

function UIFirstTopUpView:InitButtons()
    self.config.btnGoShop.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickGoShop()
    end)
    self.config.btnClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)

    self.config.bgNone.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)

end

function UIFirstTopUpView:InitLocalization()
    -- self.config.textDes.text = LanguageUtils.LocalizeCommon("first_top_up_desc")
    self.config.textShop.text = LanguageUtils.LocalizeCommon("shop")
    self.config.textMain.text = LanguageUtils.LocalizeCommon("first_top_up_main")
    self:InitData(true)
end

function UIFirstTopUpView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
    zg.playerData.remoteConfig.showedFirstTopUpLoginTime = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).lastLoginTime
    zg.playerData:SaveRemoteConfig()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end
function UIFirstTopUpView:OnReload()
    ---@type IapDataInBound
    local iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    if (iapDataInBound:HasClaimedAllFirstTopUPReward()) then
        self:OnClickBackOrClose()
    else
        self:InitData(true)
    end
end

--- @param data {callbackClose : function}
function UIFirstTopUpView:OnReadyShow(data)
    self.data = data
    UIBaseView.OnReadyShow(self, data)
    self:InitData()
end

---@return boolean
function UIFirstTopUpView.ShouldShow()
    ---@type IapDataInBound
    local iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    return not iapDataInBound:HasClaimedAllFirstTopUPReward()
end

function UIFirstTopUpView:InitData(onlyLocalize)
    ---@type IapDataInBound
    local iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    for i = 1, self.listFirstTopUpPackageItemView:Count() do
        ---@type FirstTopUpPackageItemView
        local firstTopUpPackageItemView = self.listFirstTopUpPackageItemView:Get(i)
        ---@type RewardState
        local rewardState = iapDataInBound.dicFirstPurchasePack:Get(i)
        firstTopUpPackageItemView:SetData(rewardState, onlyLocalize)
    end
end

--- @class UIFirstTopTab
UIFirstTopTab = {
    ChooseReward = 1,
    PackageContent = 2
}