--- @class ItemPurchaseBattlePassLayout
ItemPurchaseBattlePassLayout = Class(ItemPurchaseBattlePassLayout)

--- @param anchor UnityEngine_RectTransform
function ItemPurchaseBattlePassLayout:Ctor(anchor, onClickPurchase)
    --- @type ItemPurchaseBattlePassLayoutConfig
    self.config = UIBaseConfig(anchor)

    --- @type List
    self.listIconView = List()
    self.onClickPurchase = onClickPurchase

    self.config.buttonPurchase.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if self.onClickPurchase then
            self.onClickPurchase()
        end
    end)
    self.itemsTableView = ItemsTableView(self.config.rewardHolder)
end

function ItemPurchaseBattlePassLayout:InitLocalization(productId)
    self.config.textTittle.text = LanguageUtils.LocalizeCommon("purchase_battle_pass_level_" .. productId)
end

function ItemPurchaseBattlePassLayout:InitConfig(productId)
    self.eventBattlePassModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BATTLE_PASS)
    --- @type ProductConfig
    self.purchaseLevelProduct = ResourceMgr.GetPurchaseConfig()
            :GetBattlePassBundleLevelStore():GetPackById(self.eventBattlePassModel:GetTime().dataId,productId)
    local listIconData = RewardInBound.GetItemIconDataList(self.purchaseLevelProduct:GetRewardList())
    for i = 1, self.listIconView:Count() do
        self.listIconView:Get(i):ReturnPool()
    end
    self.listIconView:Clear()
    for i = 1,listIconData:Count() do
        local iconData = listIconData:Get(i)
        --- @type RootIconView
        local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.rewardHolder)
        iconView:SetIconData(iconData)
        iconView:RegisterShowInfo()
        self.listIconView:Add(iconView)
    end
end

--- @param productConfig ProductConfig
function ItemPurchaseBattlePassLayout:SetReward(productConfig, boughtCount)
    self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(productConfig.productID)


    --if boughtCount >= productConfig.stock then
    --    self.config.textPrice.text = LanguageUtils.LocalizeCommon("sold_out")
    --else
    --    self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(productConfig.productID)
    --end
    --
    --local left = productConfig.stock - boughtCount
    --local color = UIUtils.green_dark
    --if left == 0 then
    --    color = UIUtils.red_dark
    --end
    --self.config.textLimit.text = string.format(LanguageUtils.LocalizeCommon("limit_x"),
    --        UIUtils.SetColorString(color, string.format("(%s/%s)", left, productConfig.stock)))
end