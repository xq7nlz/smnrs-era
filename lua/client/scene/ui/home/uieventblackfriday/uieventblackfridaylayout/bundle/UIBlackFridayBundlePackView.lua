--- @class UIBlackFridayBundlePackView
UIBlackFridayBundlePackView = Class(UIBlackFridayBundlePackView)

--- @param transform UnityEngine_Transform
function UIBlackFridayBundlePackView:Ctor(transform)
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
    --- @type EventBlackFridayModel
    self.eventBlackFridayModel = nil

    self:InitButtonListener()
    self:InitItemTableView()
end

function UIBlackFridayBundlePackView:InitButtonListener()
    self.config.buttonBuy.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBuy()
    end)
end

function UIBlackFridayBundlePackView:InitItemTableView()
    self.itemsTable = ItemsTableView(self.config.resAnchor)
end

function UIBlackFridayBundlePackView:OnShow(packId, dataId)
    self.dataId = dataId
    self.packId = packId
    self.data = ResourceMgr.GetPurchaseConfig():GetBlackFridayBundleStore():GetPack(self.dataId):GetPackBase(self.packId)

    self.opCode = self.data.opCode
    self.packKey = ClientConfigUtils.GetPurchaseKey(self.opCode, self.packId, dataId)
    --- @type IapDataInBound
    self.iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    ---@type  EventBlackFridayModel
    self.eventBlackFridayModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BLACK_FRIDAY)
    self.config.tittle.text = LanguageUtils.LocalizeCommon(string.format("black_friday_purchase_%d", self.packId))

    self:ShowPack()
    self:SetPrice()
end

function UIBlackFridayBundlePackView:ShowPack()
    LanguageUtils.CheckInitLocalize(self, UIBlackFridayBundlePackView.InitLocalization)
    local vipText, rewardList = self.data:GetReward()
    self:SetInstantReward(rewardList)
    self:SetVipText(vipText)

    local numberBought = self.eventBlackFridayModel:GetNumberBuy(EventActionType.BLACK_FRIDAY_BUNDLE_PACK_BUY, self.packId)
    local left = self.data.stock
    if (self.data.stock == nil) then
        XDebug.Log("stock nil " .. tostring(self.packId))
    end
    left = self.data.stock - numberBought
    self:ShowTextBuy(left, self.data.stock)
end

function UIBlackFridayBundlePackView:SetPrice()
    self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(self.packKey)
    --  XDebug.Log("pack key: "..tostring(self.packKey))
end

function UIBlackFridayBundlePackView:SetInstantReward(rewardList)
    self.itemsTable:SetData(RewardInBound.GetItemIconDataList(rewardList), UIPoolType.ItemInfoView)
end

function UIBlackFridayBundlePackView:SetVipText(vipText)
    self.config.vipText.text = "+" .. tostring(vipText)
end

function UIBlackFridayBundlePackView:Hide()
    self.itemsTable:Hide()
end

function UIBlackFridayBundlePackView:OnClickBuy()
    if self:CanBuy() then
        local data = ResourceMgr.GetPurchaseConfig():GetBlackFridayBundleStore():GetPack(self.dataId):GetPackBase(self.packId)
        local packKey = self.packKey
        if data ~= nil then
            packKey = ClientConfigUtils.GetPurchaseKey(data.opCode, data.id, data.dataId)
        end
        BuyUtils.InitListener(function()
            PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.IAP }, function()
                --self.eventBlackFridayModel:AddNumberBuy(EventActionType.BLACK_FRIDAY_BUNDLE_PACK_BUY, self.packId, 1)
                self:ShowPack()
            end)
        end)
        RxMgr.purchaseProduct:Next(packKey)
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

--- @param left number
--- @param max number
function UIBlackFridayBundlePackView:ShowTextBuy(left, max)
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

function UIBlackFridayBundlePackView:CanBuy()

    local numberBought = self.eventBlackFridayModel:GetNumberBuy(EventActionType.BLACK_FRIDAY_BUNDLE_PACK_BUY, self.packId)
    return (self.data.stock - numberBought) > 0
end
