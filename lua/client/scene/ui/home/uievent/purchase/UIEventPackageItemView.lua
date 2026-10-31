---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiEvent.purchase.UIEventPackageItemConfig"

--- @class UIEventPackageItemView : MotionIconView
UIEventPackageItemView = Class(UIEventPackageItemView, MotionIconView)

function UIEventPackageItemView:Ctor()
    MotionIconView.Ctor(self)
    --- @type ItemsTableView
    self.itemsTable = nil
    --- @type ProductConfig
    self.productConfig = nil
end

function UIEventPackageItemView:SetPrefabName()
    self.prefabName = 'event_package_item_view'
    self.uiPoolType = UIPoolType.EventPackageItem
end

--- @param transform UnityEngine_Transform
function UIEventPackageItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type UIEventPackageItemConfig
    self.config = UIBaseConfig(transform)
end

function UIEventPackageItemView:InitLocalization()
    self.config.localizeVipPoint.text = LanguageUtils.LocalizeMoneyType(MoneyType.VIP_POINT)
end

function UIEventPackageItemView:AddListener(listener)
    self.config.buttonBuy.onClick:RemoveAllListeners()
    self.config.buttonBuy.onClick:AddListener(function()
        if listener ~= nil and self.iconData.numberOfBought < self.productConfig.stock then
            BuyUtils.InitListener(function()
                self:UpdateTextBuy()
            end)
            listener()
            zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        else
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        end
    end)
end

--- @param iconData PurchasedPackInBound
function UIEventPackageItemView:SetIconData(iconData)
    --- @type PurchasedPackInBound
    self.iconData = iconData
    self.productConfig = self.iconData.config
    local vipReward, rewardList = self.productConfig:GetReward()
    self.config.iconVipPoint.sprite = ResourceLoadUtils.LoadMoneyIcon(MoneyType.VIP_POINT)
    self.config.textVipPoint.text = tostring(vipReward)
    self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(
            ClientConfigUtils.GetPurchaseKey(self.productConfig.opCode, self.productConfig.id, self.productConfig.dataId)
    )

    self.itemsTable = ItemsTableView(self.config.resAnchor)
    self.itemsTable:SetData(RewardInBound.GetItemIconDataList(rewardList))

    self:UpdateTextBuy()

    LanguageUtils.CheckInitLocalize(self, UIEventPackageItemView.InitLocalization)
end

--- @return void
function UIEventPackageItemView:UpdateTextBuy()
    self.config.textLimited.text = string.format("%s: %d", LanguageUtils.LocalizeCommon("limited_packs"), self.productConfig.stock - self.iconData.numberOfBought)
end

function UIEventPackageItemView:ReturnPool()
    MotionIconView.ReturnPool(self)
    if self.itemsTable then
        self.itemsTable:Hide()
    end
end
return UIEventPackageItemView