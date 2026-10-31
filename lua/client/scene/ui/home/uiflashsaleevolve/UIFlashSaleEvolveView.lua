require "lua.client.scene.ui.home.uiFlashSaleEvolve.FlashSaleEvolvePackageItem"
--- @class UIFlashSaleEvolveView : UIBaseView
UIFlashSaleEvolveView = Class(UIFlashSaleEvolveView, UIBaseView)

--- @param model UIFlashSaleEvolveModel
function UIFlashSaleEvolveView:Ctor(model)
    --- @type UIFlashSaleEvolveConfig
    self.config = nil
    UIBaseView.Ctor(self, model)
    --- @type UIFlashSaleEvolveModel
    self.model = model
    self.numberOfAvailablePackage = nil
    ---@type List
    self.listPackageItemView = nil
    ---@type number
    self.buyTime = nil
end

function UIFlashSaleEvolveView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    local rect = self.config.transform:GetComponent(ComponentName.UnityEngine_RectTransform)
    rect.anchorMin = Vector2(0, 0)
    rect.anchorMax = Vector2(1, 1)
    rect.pivot = Vector2(0.5, 0.5)

    self:InitItemView()
    self:InitLocalization()
    self:InitButtons()
end

function UIFlashSaleEvolveView:InitItemView()
    if (self.listPackageItemView == nil) then
        self.listPackageItemView = List()
        self.listPackageItemView:Add(FlashSaleEvolvePackageItem(self.config.package1, self, 1))
        self.listPackageItemView:Add(FlashSaleEvolvePackageItem(self.config.package2, self, 2))
    end
end

function UIFlashSaleEvolveView:Hide()
    UIBaseView.Hide(self)
    ---@param v FlashSaleEvolvePackageItem
    for _, v in pairs(self.listPackageItemView:GetItems()) do
        v:ReturnPool()
    end
end

function UIFlashSaleEvolveView:InitButtons()
    self.config.bgNone.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

function UIFlashSaleEvolveView:OnClickBackOrClose()
    if self.buyTime < self.listPackageItemView:Count() then
        PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("popup_not_appear_anymore"), nil, function()
            self:ClosePopup()
        end)
    else
        self:ClosePopup()
    end
end

function UIFlashSaleEvolveView:ClosePopup()
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
    zg.playerData.remoteConfig.showedFirstTopUpLoginTime = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).lastLoginTime
    zg.playerData:SaveRemoteConfig()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
    --- @type IapDataInBound
    local iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    iapDataInBound:ResetFlashSaleEvolveActiveGroup()
    self:CallOpCodeDeactivateFlashSaleEvolve()
end

function UIFlashSaleEvolveView:CallOpCodeDeactivateFlashSaleEvolve()
    NetworkUtils.Request(OpCode.FLASH_SALE_EVOLVE_DEACTIVATE)
end

function UIFlashSaleEvolveView:InitLocalization()
    self.config.textMain.text = LanguageUtils.LocalizeCommon("flash_sale_evolve_title")
end

--- @param data {callbackClose : function, listIdHero : List}
function UIFlashSaleEvolveView:OnReadyShow(data)
    UIBaseView.OnReadyShow(self, data)
    self.buyTime = 0
    local listIdHero = data.listIdHero
    if not listIdHero or listIdHero:Count() == 0 then
        --- @type IapDataInBound
        local iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
        listIdHero = iapDataInBound.GetFlashSaleEvolveActiveGroup():GetListIdHeroActive()
    end
    if listIdHero and listIdHero:Count() > 0 then
        self:InitData(listIdHero)
    else
        self:OnClickBackOrClose()
    end
end

---@return boolean
function UIFlashSaleEvolveView.ShouldShow()
    ---@type IapDataInBound
    local iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    return not iapDataInBound:HasClaimedAllFirstTopUPReward()
end

---@param listIdHero List
function UIFlashSaleEvolveView:InitData(listIdHero)
    ---@param v FlashSaleEvolvePackageItem
    for k, v in pairs(self.listPackageItemView:GetItems()) do
        ---@type RewardState
        v:SetData(listIdHero:Get(k))
    end
end