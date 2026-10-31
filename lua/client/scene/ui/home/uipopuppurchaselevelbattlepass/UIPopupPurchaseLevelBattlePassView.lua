require "lua.client.scene.ui.home.uiPopupPurchaseLevelBattlePass.ItemPurchaseBattlePassLayout"
require "lua.client.scene.ui.home.uiPopupPurchaseLevelBattlePass.PurchaseLevelBattlePassByGemLayout"

--- @class UIPopupPurchaseLevelBattlePassView : UIBaseView
UIPopupPurchaseLevelBattlePassView = Class(UIPopupPurchaseLevelBattlePassView, UIBaseView)

--- @param model UIPopupPurchaseLevelBattlePassModel
function UIPopupPurchaseLevelBattlePassView:Ctor(model)
    --- @type UIPopupPurchaseLevelBattlePassConfig
    self.config = nil
    --- @type Dictionary
    self.bundleLayoutDict = Dictionary()
    self.updateTime = nil
    UIBaseView.Ctor(self, model)
    --- @type UIPopupPurchaseLevelBattlePassModel
    self.model = model
end

function UIPopupPurchaseLevelBattlePassView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)

    self:InitButtons()

    self:InitBundleLayout()

    self:InitUpdateTime()
end

function UIPopupPurchaseLevelBattlePassView:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        self:SetTextTimeRefresh()
        if self.timeRefresh < 0 then
            self:OnReadyHide()
        end
    end
end

function UIPopupPurchaseLevelBattlePassView:InitBundleLayout()
    local childCount = self.config.bundleAnchor.childCount
    --- @type List
    local ids = List()
    for i = 1, self.config.bundleAnchor.childCount do
        local layout = ItemPurchaseBattlePassLayout(self.config.bundleAnchor:GetChild(i - 1), function ()
            self:OnClickBuyBundleLevel(i)
        end)
        ids:Add(i)
        layout:InitLocalization(i)
        layout:InitConfig(i)
        self.bundleLayoutDict:Add(i, layout)
    end
    local buyByGemLayout = PurchaseLevelBattlePassByGemLayout(self.config.bundleGem,function ()
        self:OnClickBuyLevelByGem()
    end)
    buyByGemLayout:InitLocalization()
    self.bundleLayoutDict:Add(self.bundleLayoutDict:Count()+1, buyByGemLayout)
end

function UIPopupPurchaseLevelBattlePassView:InitButtons()
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

function UIPopupPurchaseLevelBattlePassView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("bundle_battle_pass_level")

    --- @param v ItemPurchaseBattlePassLayout
    for k, v in pairs(self.bundleLayoutDict:GetItems()) do
        v:InitLocalization(k)
    end
end

function UIPopupPurchaseLevelBattlePassView:InitLayoutConfig()
    --- @param v ItemPurchaseBattlePassLayout
    for k, v in pairs(self.bundleLayoutDict:GetItems()) do
        v:InitConfig(k)
    end
end

--- @param data {onBuySuccess : function}
function UIPopupPurchaseLevelBattlePassView:OnReadyShow(data)
    UIBaseView.OnReadyShow(self, data)

    self.onBuySuccess = data.onBuySuccess

    --- @type EventBattlePassModel
    self.eventBattlePassModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BATTLE_PASS)
    self.listProduct = ResourceMgr.GetPurchaseConfig():GetBattlePassBundleLevelStore():GetCurrentPack():GetAllPackBase()
    self:ShowReward()
    self:StartRefreshTime()
    self:InitLocalization()
end

function UIPopupPurchaseLevelBattlePassView:ShowReward()
    --- @param v ItemPurchaseBattlePassLayout
    for k, v in pairs(self.bundleLayoutDict:GetItems()) do
        local productConfig = self.listProduct:Get(k)
        if productConfig then
            v:SetReward(productConfig, self.eventBattlePassModel:GetNumberBuyOpCode(productConfig.opCode, productConfig.id))
        end
    end
end

function UIPopupPurchaseLevelBattlePassView:OnClickBuyBundleLevel(packId)
    --- @type ProductConfig
    local productConfig = self.listProduct:Get(packId)
    --local numberOfBuy = self.eventBattlePassModel:GetNumberBuyOpCode(productConfig.opCode, productConfig.id)
    --if numberOfBuy >= productConfig.stock then
    --    SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("sold_out"))
    --    zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    --    return
    --end

    BuyUtils.InitListener(function()
        if self.onBuySuccess then
            self.onBuySuccess()
        end
    end)
    RxMgr.purchaseProduct:Next(productConfig.productID)
end

function UIPopupPurchaseLevelBattlePassView:OnClickBuyLevelByGem()
    local data = {}
    data.onBuySuccess = function()
        self.onBuySuccess()
        self:InitLocalization()
    end
    PopupMgr.ShowPopup(UIPopupName.UIPopupBuyLevelBattlePass,data)
end

function UIPopupPurchaseLevelBattlePassView:SetTimeRefresh()
    self.timeRefresh = self.eventBattlePassModel.timeData.endTime - zg.timeMgr:GetServerTime()
end

function UIPopupPurchaseLevelBattlePassView:StartRefreshTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIPopupPurchaseLevelBattlePassView:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIPopupPurchaseLevelBattlePassView:Hide()
    UIBaseView.Hide(self)

    self:RemoveUpdateTime()
end

function UIPopupPurchaseLevelBattlePassView:SetTextTimeRefresh()
    self.config.textTimer.text = string.format("%s %s", LanguageUtils.LocalizeCommon("will_end_in"),
            UIUtils.SetColorString(UIUtils.green_dark, TimeUtils.GetDeltaTime(self.timeRefresh)))
end