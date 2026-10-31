--- @class UISpecialOfferNewYear2023ItemView
UISpecialOfferNewYear2023ItemView = Class(UISpecialOfferNewYear2023ItemView)

local BUY_SUCCESS = 1
local LIMIT_BUY = 0
local BUY_FAIL = 2

--- @param transform UnityEngine_Transform
function UISpecialOfferNewYear2023ItemView:Ctor(view, transform)
    --- @type UIEventNewYear2023View
    self.view = view
    --- @type UISpecialOfferMidAutumnItemConfig
    self.config = UIBaseConfig(transform)
    --- @type number
    self.packId = nil
    --- @type number
    self.dataId = nil
    --- @type string
    self.packKey = nil
    --- @type OpCode
    self.opCode = nil
    --- @type ItemsTableView
    self.itemsTable = nil
    --- @type IapDataInBound
    self.iapDataInBound = nil
    --- @type EventThankGivingModel
    self.eventModel = nil

    self:InitButtonListener()
    self:InitItemTableView()
end

function UISpecialOfferNewYear2023ItemView:InitButtonListener()
    self.config.buttonBuy.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBuy()
    end)
end

function UISpecialOfferNewYear2023ItemView:InitItemTableView()
    self.itemsTable = ItemsTableView(self.config.resAnchor)
end

function UISpecialOfferNewYear2023ItemView:OnShow(packId, dataId)
    self.dataId = dataId
    self.packId = packId
    self.data = ResourceMgr.GetPurchaseConfig():GetEventNewYear2023BundleStore():GetPack(self.dataId):GetPackBase(self.packId)
    self.opCode = self.data.opCode
    self.packKey = ClientConfigUtils.GetPurchaseKey(self.opCode, self.packId, dataId)
    --- @type IapDataInBound
    self.iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_YEAR_2023)
    self.config.tittle.text = LanguageUtils.LocalizeCommon(string.format("new_year_2023_purchase_%d", self.packId))

    self:ShowPack()
    self:SetPrice()
end

function UISpecialOfferNewYear2023ItemView:ShowPack()
    LanguageUtils.CheckInitLocalize(self, UISpecialOfferNewYear2023ItemView.InitLocalization)
    ---- @type EventNewYear2023Product
    local vipText, rewardList = self.data:GetReward()
    self:SetInstantReward(rewardList)
    self:SetVipText(vipText)

    local numberBought = self.eventModel:GetNumberBuy(EventActionType.NEW_YEAR_2023_BUNDLE_PURCHASE, self.packId)
    local left = self.data.stock
    left = self.data.stock - numberBought
    self:ShowTextBuy(left, self.data.stock)
end

function UISpecialOfferNewYear2023ItemView:SetPrice()
    self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(self.packKey)
  --  XDebug.Log("pack key: "..tostring(self.packKey))
end

function UISpecialOfferNewYear2023ItemView:SetInstantReward(rewardList)
    self.itemsTable:SetData(RewardInBound.GetItemIconDataList(rewardList), UIPoolType.ItemInfoView)
end

function UISpecialOfferNewYear2023ItemView:SetVipText(vipText)
    self.config.vipText.text = "+" .. tostring(vipText)
end

function UISpecialOfferNewYear2023ItemView:Hide()
    self.itemsTable:Hide()
end

function UISpecialOfferNewYear2023ItemView:OnClickBuy()
    if self:CanBuy() then
        local data = ResourceMgr.GetPurchaseConfig():GetEventNewYear2023BundleStore():GetPack(self.dataId):GetPackBase(self.packId)
        local packKey = self.packKey
        if data ~= nil then
            packKey = ClientConfigUtils.GetPurchaseKey(data.opCode, data.id, data.dataId)
        end
        BuyUtils.InitListener(function()
            PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.IAP }, function()
                self.eventModel:AddNumberBuy(EventActionType.NEW_YEAR_2023_BUNDLE_PURCHASE, self.packId, 1)
                self:ShowPack()
            end)
            self.view:CheckAllNotificationTab()
            TrackingUtils.AddFireBasePurchaseClickEvent(FBEvents.EVENT_NEW_YEAR_2023, self.data.androidPackageName, BUY_SUCCESS)
        end, function()
            TrackingUtils.AddFireBasePurchaseClickEvent(FBEvents.EVENT_NEW_YEAR_2023, self.data.androidPackageName, BUY_FAIL)
        end)
        RxMgr.purchaseProduct:Next(packKey)
    else
        TrackingUtils.AddFireBasePurchaseClickEvent(FBEvents.EVENT_NEW_YEAR_2023, self.data.androidPackageName, LIMIT_BUY)
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

--- @param left number
--- @param max number
function UISpecialOfferNewYear2023ItemView:ShowTextBuy(left, max)
    if left == nil or max == nil then
        self.config.localizeBuy.text = LanguageUtils.LocalizeCommon("buy")
    else
        local color = UIUtils.color2
        if left == 0 then
            color = UIUtils.red_dark
        end
        self.config.localizeBuy.text = string.format("%s %s",
                LanguageUtils.LocalizeCommon("buy"),
                UIUtils.SetColorString(color, string.format("(%s/%s)", left, max)))
    end
end

function UISpecialOfferNewYear2023ItemView:CanBuy()
    local numberBought = self.eventModel:GetNumberBuy(EventActionType.NEW_YEAR_2023_BUNDLE_PURCHASE, self.packId)
    return (self.data.stock - numberBought) > 0
end
