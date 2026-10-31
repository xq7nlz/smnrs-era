--- @class UICustomPackView
UICustomPackView = Class(UICustomPackView, UIPrefabView)

--- @param transform UnityEngine_Transform
--- @param packId number
--- @param view UIIapShopView
function UICustomPackView:Ctor()
    --- @type OpCode
    self.opCode = OpCode.CUSTOMIZE_BUNDLE_ITEM_SELECT

    --- @type List<RootIconView>
    self.listSelectableBox = List()
    --- @type List<RootIconView>
    self.listSelectedBox = List()
    UIPrefabView.Ctor(self)
end

function UICustomPackView:SetPrefabName()
    self.prefabName = 'custom_package'
    self.uiPoolType = UIPoolType.UICustomPackView
end

--- @return void
--- @param transform UnityEngine_Transform
function UICustomPackView:SetConfig(transform)
    --- @type UICustomPackConfig
    self.config = UIBaseConfig(transform)
    self:InitButtonListener()
    self:InitUpdateTime()
end

function UICustomPackView:InitLocalization()
    self.config.textWish.text = string.format(LanguageUtils.LocalizeCommon("select_2_reward"))
    self.config.textWillGet.text = LanguageUtils.LocalizeCommon("will_get_item")
end

function UICustomPackView:InitButtonListener()
    self.config.buttonBuy.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBuy()
    end)

    self.config.buttonSoldOut.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.LogicCodeNotification(LogicCode.PURCHASE_PACK_SOLD_OUT)
    end)
end

function UICustomPackView:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimerReset()
        else
            self.timeReset = self.timeReset - 1
        end
        self:SetTextTimeReset()
    end
end

function UICustomPackView:InitSelectable()
    if self.listSelectableBox:Count() > 0 then
        return
    end

    --- @param obj RootIconView
    local onCreateItem = function(obj, index)
        index = index + 1
        --- @type RewardInBound
        local rewardInBound = self.listReward:Get(index)
        obj:SetIconData(rewardInBound:GetIconData())
        if self.reachLimit then
            obj:SetActiveColor2(false)
        else
            obj:AddListener(function()
                self:ClickItem(index)
            end)
        end

        if self.package.listOfSelectedItem:IsContainValue(index) then
            obj:ActiveUIPool(UIPoolType.MaskSelected, true)
        end
        self.listSelectableBox:Add(obj)
    end

    self.uiScroll = UILoopScroll(self.config.scrollItemSelectable, UIPoolType.RootIconView, onCreateItem)
    self.uiScroll.scroll.enabled = false
    self.uiScroll:Resize(self.listReward:Count())
end

function UICustomPackView:InitSelected()
    if self.listSelectedBox:Count() > 0 then
        return
    end

    for i = 1, self.data.numberSelection do
        --- @type RootIconView
        local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.itemSelectedView)
        self.listSelectedBox:Add(iconView)
    end

    for i = 1, self.data.listDefaultReward:Count() do
        local iconData = self.data.listDefaultReward:Get(i)
        iconData.itemId = iconData.id
        ---@type RootIconView
        local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.itemSelectedView)
        iconView:SetIconData(iconData)
        self.listSelectedBox:Add(iconView)
    end
end

---@param index number
function UICustomPackView:ClickItem(index)
    if self.package.listOfSelectedItem:IsContainValue(index) then
        -- Deselect
        self:SelectItem(index, false)
    elseif self.package.listOfSelectedItem:Count() < self.data.numberSelection then
        -- Select
        self:SelectItem(index, true)
    else
        -- Reach max
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("selected_2_rewards"))
    end
end

---@param index number
function UICustomPackView:SelectItem(index, isSelect)
    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)

    if isSelect then
        self.package.listOfSelectedItem:Add(index)
    else
        self.package.listOfSelectedItem:RemoveOneByReference(index)
    end

    ---@type RootIconView
    local obj = self.listSelectableBox:Get(index)
    obj:ActiveUIPool(UIPoolType.MaskSelected, isSelect)

    self:UpdateBoxesView()
end

function UICustomPackView:UpdateBoxesView()
    -- SelectedBox
    local selectedCount = self.package.listOfSelectedItem:Count()
    print(selectedCount)
    --- @param v RootIconView
    for i, v in ipairs(self.listSelectedBox:GetItems()) do
        if (i <= selectedCount) then
            ---@type number
            local objIndex = self.package.listOfSelectedItem:Get(i)
            ---@type RewardInBound
            local reward = self.listReward:Get(objIndex)
            v:SetIconData(reward:GetIconData())
            v:RegisterShowInfo()
        elseif i > self.data.numberSelection then
            ---@type number
            local reward = self.data.listDefaultReward:Get(i - self.data.numberSelection)
            v:SetIconData(reward:GetIconData())
            v:RegisterShowInfo()
        else
            local itemIconData = ItemIconData()
            itemIconData:SetData(ResourceType.Money, MoneyType.None)
            v:SetIconData(itemIconData)
            v:RemoveAllListeners()
        end

        if self.reachLimit then
            v:SetActiveColor2(false)
            v:RemoveAllListeners()
        end
    end

    self.config.highlight:SetActive(selectedCount == self.data.numberSelection)
end

--- @return void
--- @param customizeProduct CustomizeProduct
--- @param customizePack CustomizePackStatisticsInBound
function UICustomPackView:SetData(customizeProduct)
    --- @type CustomizeProduct
    self.data = customizeProduct
    self:ShowPack()
end

function UICustomPackView:ShowPack()
    --- @type IapDataInBound
    self.iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    --- @type CustomizePackStatisticsInBound
    self.package = self.iapDataInBound:GetCustomizePack(self.data.id)

    --- @type number
    self.stock = self.data.stock
    --- @type number
    self.left = self.stock - self.package.numberOfBought
    --- @type boolean
    self.reachLimit = self.package.numberOfBought == self.stock

    self:GetListDailyReward()

    self:InitSelectable()
    self:InitSelected()
    self:UpdateBoxesView()

    self:AddTimer()
    self:SetBanner()
    self:SetTagDeal()
    self:SetTittle()
    self:SetLimit()
    self:SetPrice()
end

function UICustomPackView:ReturnItemsToPool()
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end

    ---@param v RootIconView
    for _, v in pairs(self.listSelectedBox:GetItems()) do
        v:ReturnPool()
    end

    self.listSelectableBox = List()
    self.listSelectedBox = List()
end

function UICustomPackView:AddTimer()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UICustomPackView:RemoveTimer()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UICustomPackView:SetTimerReset()
    local serverTime = zg.timeMgr:GetServerTime()
    local date = TimeUtils.GetOsDateFromSecWithFormatT(serverTime)

    if self.data.resetType == LimitedPackResetType.RESET_BY_WEEK then
        --- Weekly Reset Time
        self.timeReset = ((7 - date.wday + 1) * TimeUtils.SecondADay)
                - (serverTime - TimeUtils.GetTimeStartDayFromSec(serverTime))
    elseif self.data.resetType == LimitedPackResetType.RESET_BY_MONTH then
        --- Monthly Reset Time
        local startTimeOfMonth = TimeUtils.GetTimeStartDayFromSec(serverTime) - (date.day - 1) * TimeUtils.SecondADay
        local dayOfMonth = TimeUtils.GetDayOfMonth(date.month, date.year)
        local endTime = startTimeOfMonth + dayOfMonth * TimeUtils.SecondADay
        self.timeReset = endTime - serverTime
    else
        --- Daily Reset Time
        self.timeReset = zg.timeMgr:GetRemainingTime()
    end

end

function UICustomPackView:SetTextTimeReset()
    self.config.textTimer.text = string.format(LanguageUtils.LocalizeCommon("refresh_in"), UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeReset)))
end

function UICustomPackView:SetBanner()
    self.config.banner.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconCustomizeBundlePack, self.data.id)
end

function UICustomPackView:SetTagDeal()
    self.config.tagHotDeal:SetActive(self.data.isHot)
end

function UICustomPackView:SetLimit()
    local color = UIUtils.green_dark
    if self.reachLimit then
        color = UIUtils.red_dark
    end

    self.config.textLimit.text = string.format(LanguageUtils.LocalizeCommon("buy_stock_remain_x"), string.format("<color=#%s>%s/%s</color>", color, self.left, self.data.stock))
end

function UICustomPackView:SetPrice()
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

function UICustomPackView:SetTittle()
    self.config.textBanner.text = LanguageUtils.LocalizeCommon("customizeble_bundle_" .. self.data.id)
end

function UICustomPackView:OnClickBuy()
    if not self:CanBuy() then
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.LogicCodeNotification(LogicCode.PURCHASE_PACK_SOLD_OUT)
        return
    end

    if self.package.listOfSelectedItem:Count() < self.data.numberSelection then
        SmartPoolUtils.ShowShortNotification(
                LanguageUtils.LocalizeCommon("select_2_rewards_before_purchase"))

        self.config.fxHighlight:Play()
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        return
    end

    BuyUtils.InitListener(function()
        self:ReturnItemsToPool()
        self:ShowPack()
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

    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "customize_pack", self.data.id)

    local outBound = CustomizeBundleItemSelectOutBound(self.data.id)
    outBound.selectItems = self.package.listOfSelectedItem
    NetworkUtils.RequestAndCallback(self.opCode, outBound)

    RxMgr.purchaseProduct:Next(self.data.productID)
end

function UICustomPackView:CanBuy()
    return not self.reachLimit
end

function UICustomPackView:GetListDailyReward()
    self.listReward = List()

    self.listReward = self.data:GetRewardList()
end

--- @return void
function UICustomPackView:ReturnPool()
    UIPrefabView.ReturnPool(self)
    self:RemoveTimer()
    self:ReturnItemsToPool()
end

return UICustomPackView