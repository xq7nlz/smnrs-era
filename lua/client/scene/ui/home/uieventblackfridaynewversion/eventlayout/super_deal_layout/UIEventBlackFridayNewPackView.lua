--- @class UIEventBlackFridayNewPackView
UIEventBlackFridayNewPackView = Class(UIEventBlackFridayNewPackView, UIPrefabView)

local MAX_ITEM = 5

--- @param transform UnityEngine_Transform
--- @param packId number
--- @param view UIIapShopView
function UIEventBlackFridayNewPackView:Ctor(view, transform)
    --- @type EventBlackFridayNewCustomizeProduct
    self.data = nil
    --- @type UIEventBlackFridayNewVersionView
    self.view = view
    --- @type OpCode
    self.opCode = OpCode.CUSTOMIZE_BUNDLE_ITEM_SELECT
    --- @type List<RootIconView>
    self.listSelectedBox = List()
    UIPrefabView.Ctor(self)
end

function UIEventBlackFridayNewPackView:SetPrefabName()
    self.prefabName = 'black_friday_new_package'
    self.uiPoolType = UIPoolType.UIEventBlackFridayNewPackView
end

--- @return void
--- @param transform UnityEngine_Transform
function UIEventBlackFridayNewPackView:SetConfig(transform)
    --- @type UIEventBlackFridayNewPackageConfig
    self.config = UIBaseConfig(transform)
    self:InitButtonListener()
end

--- @return void
--- @param customizeProduct EventBlackFridayNewCustomizeProduct
--- @param customizePack CustomizePackStatisticsInBound
function UIEventBlackFridayNewPackView:SetData(customizeProduct)
    --- @type EventBlackFridayNewCustomizeProduct
    self.data = customizeProduct
    self:ShowPack()
end

function UIEventBlackFridayNewPackView:InitLocalization()
end

function UIEventBlackFridayNewPackView:InitButtonListener()
    self.config.buttonBuy.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBuy()
    end)

    self.config.buttonSoldOut.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end)
end

function UIEventBlackFridayNewPackView:ShowPack()
    self.config.tittle.text = LanguageUtils.LocalizeCommon(string.format("black_friday_sale_%d", self.data.id))
    --- @type EventBlackFridayNewVersionModel
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BLACK_FRIDAY_SALE)
    if self.eventModel:GetCustomizePack(self.data.id) == nil then
        return
    end
    --- @type CustomizePackStatisticsInBound
    self.package = self.eventModel:GetCustomizePack(self.data.id)
    --- @type number
    self.stock = self.data.stock
    --- @type number
    self.left = self.stock - self.package.numberOfBought
    --- @type boolean
    self.reachLimit = self.package.numberOfBought == self.stock
    --local vipText = self.data:GetReward(self.data.listDefaultReward)
    --self:SetVipText(vipText)
    self:SetBanner()
    self:GetListDailyReward()
    self:InitReward()

    self:SetLimit()
    self:SetPrice()
end

function UIEventBlackFridayNewPackView:GetListDailyReward()
    self.listReward = List()
    self.listReward = self.data:GetRewardList()
end

function UIEventBlackFridayNewPackView:SetBanner()
    self.config.bg.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconBlackFridaySale, self.data.id)
end

function UIEventBlackFridayNewPackView:SetVipText(vipText)
    self.config.vipText.text = "+" .. tostring(vipText)
end

function UIEventBlackFridayNewPackView:SetLimit()
    local color = UIUtils.white
    if self.reachLimit then
        color = UIUtils.red_dark
    end

    self.config.localizeBuy.text = string.format(LanguageUtils.LocalizeCommon("buy_stock_remain_x"), string.format("<color=#%s>%s/%s</color>", color, self.left, self.data.stock))
end

function UIEventBlackFridayNewPackView:SetPrice()
    if self.reachLimit then
        self.config.buttonBuy.gameObject:SetActive(false)
        self.config.buttonSoldOut.gameObject:SetActive(true)
        self.config.textSoldOut.text = LanguageUtils.LocalizeCommon("sold_out")
        return
    end
    self.config.buttonBuy.gameObject:SetActive(true)
    self.config.buttonSoldOut.gameObject:SetActive(false)
    self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(self.data.productID)
end

function UIEventBlackFridayNewPackView:InitReward()
    for i = 1, MAX_ITEM do
        --- @type RootIconView
        local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.resAnchor)
        if i <= MAX_ITEM - self.data.listDefaultReward:Count() then
            ---@type number
            local objIndex = self.package.listOfSelectedItem:Get(i)
            ---@type RewardInBound
            local reward = self.listReward:Get(objIndex)
            iconView:SetIconData(reward:GetIconData())
            iconView:RegisterShowInfo()
        else
            ---@type number
            local reward = self.data.listDefaultReward:Get(i - self.data.numberSelection)
            iconView:SetIconData(reward:GetIconData())
            iconView:RegisterShowInfo()
        end
        self.listSelectedBox:Add(iconView)
    end
end

function UIEventBlackFridayNewPackView:ReturnItemsToPool()
    ---@param v RootIconView
    for _, v in pairs(self.listSelectedBox:GetItems()) do
        v:ReturnPool()
    end

    self.listSelectedBox:Clear()
end

function UIEventBlackFridayNewPackView:OnClickBuy()
    if self.eventModel:GetCustomizePack(self.data.id) == nil then
        return
    end
    if self:CanBuy() then
        BuyUtils.InitListener(function()
            PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.IAP }, function()
                self.eventModel:IncreaseNumberOfBoughtCustomizePack(self.data.id)
                self:ReturnItemsToPool()
                self:ShowPack()
            end)
        end)

        ---@type List <RewardInBound>
        local rewardList = List()

        --- @param v number
        if self.package.listOfSelectedItem ~= nil then
            for i, v in pairs(self.package.listOfSelectedItem:GetItems()) do
                rewardList:Add(self.listReward:Get(v))
            end
        end

        self.data.listSelectReward = rewardList
        RxMgr.purchaseProduct:Next(self.data.productID)
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

function UIEventBlackFridayNewPackView:CanBuy()
    return not self.reachLimit
end

--- @return void
function UIEventBlackFridayNewPackView:ReturnPool()
    UIPrefabView.ReturnPool(self)
    self:ReturnItemsToPool()
end

return UIEventBlackFridayNewPackView
