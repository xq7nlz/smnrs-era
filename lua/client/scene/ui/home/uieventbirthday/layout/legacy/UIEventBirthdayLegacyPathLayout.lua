require "lua.client.core.network.iap.GrowthPack.ClaimPassOutBound"
require "lua.client.core.network.iap.GrowthPack.ClaimTigerPathOutBound"
--- @class UIEventBirthdayLegacyPathLayout : UIEventBirthdayLayout
UIEventBirthdayLegacyPathLayout = Class(UIEventBirthdayLegacyPathLayout, UIEventBirthdayLayout)

--- @param view UIIapShopView
function UIEventBirthdayLegacyPathLayout:Ctor(view, newYearTab, anchor, packId)
    --- @type LunarNewYearTigerPathPlanLayoutConfig
    self.layoutConfig = nil
    --- @type GrowthPackLineConfig
    self.growthPackLineConfig = nil
    self.updateTime = nil
    --- @type ProductConfig
    self.productConfig = nil
    self.titleKey = "birthday_legacy_path"
    self.unlockContentKey = "birthday_legacy_unlock_content"
    self.prefabName = "birthday_legacy_plan"
    --- @type Dictionary
    self.milestoneItemDict = Dictionary()
    self.packId = packId
    --- @type List
    self.listItem = List()
    --- @type List
    self.listIconItem = List()
    --- @type List
    self.listItemSelect = List()
    --- @type List
    self.listItemSlot = List()
    UIEventBirthdayLayout.Ctor(self, view, newYearTab, anchor)
    --- @type OpCode
    self.opCodeClaim = OpCode.EVENT_BIRTHDAY_LEGACY_PATH_MILESTONE_CLAIM

    --- @List
    self.resultReward = List()
    self.totalRewardSend = 0
    self.totalRewardGet = 0
end

function UIEventBirthdayLegacyPathLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate(self.prefabName, self.anchor)
    self.layoutConfig = UIBaseConfig(inst.transform)
    UIUtils.SetParent(inst.transform, self.anchor)
    inst:SetActive(true)
    self:InitUpdateTime()
    self:InitPack()
    self:InitLocalization()
    self:InitButtonListener()

end

function UIEventBirthdayLegacyPathLayout:InitLocalization()
    self.layoutConfig.pointDescText.text = LanguageUtils.LocalizeCommon("legacy_point_desc")
    self.layoutConfig.textPremiumReward.text = LanguageUtils.LocalizeCommon("premium_reward")
    self.layoutConfig.textDesc.text = LanguageUtils.LocalizeCommon("birthday_legacy_path_decs")
    self.layoutConfig.tittle.text = LanguageUtils.LocalizeCommon(self.titleKey)
    self.layoutConfig.notiButton.gameObject:SetActive(true)
    self.layoutConfig.textClaimAllPremium.text = LanguageUtils.LocalizeCommon("claim_all")
    self.layoutConfig.textBuyLevel.text = LanguageUtils.LocalizeCommon("buy_point")
    self.layoutConfig.guideText.text = LanguageUtils.LocalizeCommon("birthday_legacy_path_guide")
    self.layoutConfig.growthText.text = LanguageUtils.LocalizeMoneyType(MoneyType.EVENT_BIRTHDAY_LEGACY_POINT)
end

function UIEventBirthdayLegacyPathLayout:InitButtonListener()
    self.layoutConfig.buttonUnlock.onClick:RemoveAllListeners()
    self.layoutConfig.buttonClaimPremium.onClick:RemoveAllListeners()
    self.layoutConfig.buttonUnlock.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickPurchase()
    end)
    self.layoutConfig.buttonClaimPremium.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickClaimAll(false)
    end)
    self.layoutConfig.buttonBuyLevel.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBuyLevel()
    end)
end

function UIEventBirthdayLegacyPathLayout:OnClickBuyLevel()
    --- @type {onBuySuccess, onClosePopup, listProduct : List, dictNumberBuy : Dictionary, textTitle, bundleLocalize, endTime, numberBuy, remainWatchAds}
    local data = {}
    data.onBuySuccess = nil
    data.listProduct = ResourceMgr.GetPurchaseConfig():GetBirthdayPurchaseLevelStore():GetCurrentPack():GetAllPackBase()
    data.dictNumberBuy = Dictionary()
    data.textTitle = "birthday_buy_level"
    data.bundleLocalize = "birthday_level_bundle_"
    data.endTime = self.eventModel.timeData.endTime
    data.remainWatchAds = self.eventModel:GetNumberWatchAdsRemain()
    data.onClosePopup = function()
        self:SetGrowthProgress()
        self:Resize()
    end
    PopupMgr.ShowPopup(UIPopupName.UIPopupPurchaseLevel, data)
end

function UIEventBirthdayLegacyPathLayout:InitUpdateTime()
end

function UIEventBirthdayLegacyPathLayout:InitPack()
    --- @param obj UIIapLegacyPathItem
    --- @param index number
    local onUpdateItem = function(obj, index)
        local dataIndex = index + 1
        local growthMilestoneConfig = self.growthPackLineConfig:GetMilestoneConfigByIndex(dataIndex)
        local isClaimedBasic, isClaimedPremium = self.eventModel:GetMilestoneStateByNumber(growthMilestoneConfig.number)
        local enoughMilestone = self.eventModel:IsValidMilestone(growthMilestoneConfig.number, false) == true
        obj:SetIconData(growthMilestoneConfig, not enoughMilestone)
        obj:SetBasicRewardState(not enoughMilestone, isClaimedBasic)
        obj:SetPremiumRewardState(not enoughMilestone, self.isUnlocked, isClaimedPremium)
        obj:EnableBgProgress(true, enoughMilestone)
        local nextGrowthMilestoneConfig = self.growthPackLineConfig:GetMilestoneConfigByIndex(dataIndex + 1)
        local enoughNextMilestone = false
        if nextGrowthMilestoneConfig ~= nil then
            enoughNextMilestone = self.eventModel:IsValidMilestone(nextGrowthMilestoneConfig.number, false) == true
            obj:EnableBgProgress(false, enoughNextMilestone)
        elseif nextGrowthMilestoneConfig == nil and enoughMilestone then
            obj:EnableBgProgress(false, true)
        else
            obj:EnableBgProgress(false, false)
        end
        obj:SetCurrent(not enoughNextMilestone and enoughMilestone)
    end
    --- @param obj UIIapLegacyPathItem
    --- @param index number
    local onCreateItem = function(obj, index)
        onUpdateItem(obj, index)
        --- @type  UIIapLegacyPathItem
        local dataIndex = index + 1
        --- @type GrowthMilestoneConfig
        local growthMilestoneConfig = self.growthPackLineConfig:GetMilestoneConfigByIndex(dataIndex)
        obj:SetButtonCallback(function(isBasic)
            if not isBasic and not self.isUnlocked then
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("buy_premium_to_get_this"))
            else
                self:OnClickClaimMilestone(isBasic, growthMilestoneConfig.number)
            end
        end)
        obj:RegisterRewardDescButton(function()
            self:ResetRewardDesc()
        end)
        obj.config.buttonClaimPremium.gameObject:SetActive(true)
        self.milestoneItemDict:Add(growthMilestoneConfig.number, obj)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.growthPatchLine, UIPoolType.UIIapLegacyPathItem, onCreateItem, onUpdateItem)
end

function UIEventBirthdayLegacyPathLayout:ResetRewardDesc()
    ---@param v UIIapLegacyPathItem
    for _, v in pairs(self.milestoneItemDict:GetItems()) do
        v:DisableRewardDesc()
    end
end

function UIEventBirthdayLegacyPathLayout:CreateItemDefault()
    self:ReturnPoolItemDefault()
    ---@param v RewardInBound
    for _, v in ipairs(self.productConfig.rewardList:GetItems()) do
        ---@type ItemIconView
        local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.layoutConfig.rewardAnchor)
        iconView:SetIconData(v:GetIconData())
        iconView:RegisterShowInfo()
        self.listIconItem:Add(iconView)
    end
end

function UIEventBirthdayLegacyPathLayout:SlotSelected()
    if (self.eventModel.heroSelectedIndex > 0) then
        return true
    end
    return false
end

function UIEventBirthdayLegacyPathLayout:CreateItemSelect()
    -- index in list select id
    self:ReturnPoolItemSelect()
    ---@type SlotHeroIconView
    local slot = self.listItemSlot:Get(1)
    ---@type ItemIconView
    local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, slot.config.slot_hero)
    if (self.eventModel.heroSelectedIndex ~= -1) then
        iconView:SetIconData(self.eventConfig.rewardPool:Get(self.eventModel.heroSelectedIndex):GetIconData())
    end
    self.listIconItem:Add(iconView)
    iconView:ActiveUIPool(UIPoolType.Noti, self.eventModel.heroSelectedIndex == -1)
    self:UpdateIconViewChange(iconView)
end

function UIEventBirthdayLegacyPathLayout:CreateItemSlot()
    self:ReturnPoolItemSlot()
    if self.eventConfig.numberSelect > 0 then
        for _ = 1, self.eventConfig.numberSelect do
            ---@type SlotHeroIconView
            local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.SlotHeroIconView, self.layoutConfig.rewardAnchor)
            iconView:AddListener(function()
                self:SelectItem()
            end)
            self:UpdateIconViewChange(iconView)
            self.listItemSlot:Add(iconView)
        end
    end
end

function UIEventBirthdayLegacyPathLayout:UpdateIconViewChange(iconView)
    self.iconSelectView = iconView
    iconView:ActiveUIPool(UIPoolType.Change,
            not self.isUnlocked and self:SlotSelected(), U_Vector2(130, 130))
end

function UIEventBirthdayLegacyPathLayout:SelectItem()
    if (self.isUnlocked) then
        local iconData = self.eventConfig.rewardPool:Get(self.eventModel.heroSelectedIndex):GetIconData()
        PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = { ["type"] = iconData.type,
                                                                      ["id"] = iconData.itemId } })
    else
        local listItem = List()
        ---@param v RewardInBound
        for i, v in ipairs(self.eventConfig.rewardPool:GetItems()) do
            local item = v:GetIconData()
            item.index = i
            listItem:Add(item)
        end
        local data = {}
        data.packId = self.packId
        data.numberSelect = self.eventConfig.numberSelect
        data.selectItems = List()
        if (self.eventModel.heroSelectedIndex ~= nil and self.eventModel.heroSelectedIndex > 0) then
            data.selectItems:Add(self.eventModel.heroSelectedIndex)
        end
        data.onSelectHeroSuccess = function(listIndex)
            data.selectItems = List()
            local indexSelected = listIndex:Get(1)
            data.selectItems:Add(indexSelected)
            self.eventModel:AddSelectItem(indexSelected)
            self:CreateItemSelect()
            local heroId = data.rewardSelectionList:Get(listIndex:Get(1)).id
            --self:SetRewardByHeroIndex(heroId)
            self:SetRewardByHeroIndex(ClientConfigUtils.GetHeroIdByFragmentHeroId(heroId))
        end
        data.rewardSelectionList = self.eventConfig.rewardPool
        data.selectedIndex = -1
        if (data.selectItems:Count() > 0) then
            data.selectedIndex = data.selectItems:Get(1)
        end
        data.opCode = OpCode.EVENT_BIRTHDAY_LEGACY_PATH_SELECT_HERO
        PopupMgr.ShowPopup(UIPopupName.UIPreviewTigerHeroFragment, data)
    end

end

function UIEventBirthdayLegacyPathLayout:SetRewardByHeroIndex(heroId)
    self:GetGrowthPackLineConfig(heroId)
    self:SetAvatarHero()
    self:Resize()
    self:ShowClaimAllState()
end

function UIEventBirthdayLegacyPathLayout:OnShow(iapShopTab)
    UIEventBirthdayLayout.OnShow(self, iapShopTab)
    self:InitLocalization()
    self:CheckResourceOnSeason()
    self:GetGrowthPackLineConfig()
    self:GetProductConfig()
    self:ShowUnlockState()
    self:ShowClaimAllState()
    self:ShowCurrentNumber()
    self:CreateItemSlot()
    self:CreateItemDefault()
    self:CreateItemSelect()
    self:Resize()
    self:StartTime()
    self:SetRewardByHeroIndex(self.eventModel:GetHeroIdBySelectIndex())
    self:SetGrowthProgress()
end

function UIEventBirthdayLegacyPathLayout:SetGrowthProgress()
    local number = self.eventModel:GetLegacyPoints()
    local maxPoint = self.eventModel.config:GetMaxPointLegacyPath()
    self.layoutConfig.point.text = tostring(number) .. "/" .. maxPoint
    self.layoutConfig.pointSlider.value = number / maxPoint
end

function UIEventBirthdayLegacyPathLayout:SetAvatarHero()
    if self.eventModel.heroSelectedIndex ~= -1 then
        self.layoutConfig.avatarHolder.enabled = false
        self.layoutConfig.heroAvatar.enabled = true
        self.layoutConfig.heroAvatar.sprite = ResourceLoadUtils.LoadBirthdayLegacyPathHeroAvatar(self.eventModel.heroSelectedIndex)
    else
        self.layoutConfig.heroAvatar.enabled = false
        self.layoutConfig.avatarHolder.enabled = true
    end
end

function UIEventBirthdayLegacyPathLayout:CheckResourceOnSeason()
    if not self.eventModel.timeData:IsOpening() then
        self:ClearMoneyType()
    end
    zg.playerData:SaveRemoteConfig()
end

function UIEventBirthdayLegacyPathLayout:ClearMoneyType()
    local current = InventoryUtils.Get(ResourceType.Money, MoneyType.EVENT_BIRTHDAY_LEGACY_POINT)
    InventoryUtils.Sub(ResourceType.Money, MoneyType.EVENT_BIRTHDAY_LEGACY_POINT, current)
end

function UIEventBirthdayLegacyPathLayout:GetGrowthPackLineConfig(heroid)
    self.growthPackLineConfig = self.eventConfig:GetLegacyPathConfig(self.eventModel.timeData.dataId, heroid)
end

function UIEventBirthdayLegacyPathLayout:GetProductConfig()
    --- @type TigerPathStore
    local bundleConfig = ResourceMgr.GetPurchaseConfig():GetLegacyPathStore()
    --- @type ProductConfig


    self.productConfig = bundleConfig:GetPack(self.eventModel.timeData.dataId).packList:Get(1)
    self.packKey = ClientConfigUtils.GetPurchaseKey(self.productConfig.opCode, 1, self.eventModel.timeData.dataId)
end

function UIEventBirthdayLegacyPathLayout:ShowUnlockState()
    local boughtCount = self.eventModel:GetNumberBuy(EventActionType.BIRTHDAY_LEGACY_PATH_PURCHASE, self.packId)
    self.isUnlocked = boughtCount > 0
    --self:SetBuyState(boughtCount == 0, self.isUnlocked)
    if self.isUnlocked == false then
        self.layoutConfig.textPrice.text = zg.iapMgr:GetLocalPrizeString(self.packKey)
    else
        self.layoutConfig.textPrice.text = LanguageUtils.LocalizeCommon("sold_out")
    end
end

function UIEventBirthdayLegacyPathLayout:ShowClaimAllState()
    local listClaimableFree = self.eventModel:_GetAllClaimableMilestone(true)
    local listClaimablePremium = self.eventModel:_GetAllClaimableMilestone(false)
    if listClaimablePremium:Count() < 1 and listClaimableFree:Count() < 1 then
        self.layoutConfig.notiButton.gameObject:SetActive(false)
        self.layoutConfig.textClaimAllPremium.text = LanguageUtils.LocalizeCommon("all_received")
    end
end

function UIEventBirthdayLegacyPathLayout:SetUpLayout()
    UIEventBirthdayLayout.SetUpLayout(self)
    self.layoutConfig.gameObject:SetActive(true)
end

function UIEventBirthdayLegacyPathLayout:Resize()
    self.milestoneItemDict:Clear()
    local offset = self:FindNearestAvailableClaim()
    offset = math.min(offset, self.growthPackLineConfig.listMilestone:Count() - 3)
    self.uiScroll:Resize(self.growthPackLineConfig.listMilestone:Count(), offset - 1)
end

function UIEventBirthdayLegacyPathLayout:ShowCurrentNumber()
    self.layoutConfig.textCurrentNumber.text = tostring(self.eventModel:GetLegacyPoints())
    local limitText
    local nunberBought = self.eventModel:GetNumberBuy(EventActionType.BIRTHDAY_LEGACY_PATH_PURCHASE, 1)
    local currentBuyLeft = self.productConfig.stock - nunberBought
    if currentBuyLeft > 0 then
        limitText = UIUtils.SetColorString(UIUtils.green_light, tostring(currentBuyLeft) .. "/" .. tostring(self.productConfig.stock))
    else
        limitText = UIUtils.SetColorString(UIUtils.red_light, tostring(currentBuyLeft) .. "/" .. tostring(self.productConfig.stock))

    end
    self.layoutConfig.limitText.text = string.format("%s %s",
            LanguageUtils.LocalizeCommon("limit"),
            limitText)
end

function UIEventBirthdayLegacyPathLayout:OnHide()
    self.layoutConfig.gameObject:SetActive(false)
    self.uiScroll:Hide()
    self:ReturnPoolItemDefault()
    self:ReturnPoolItemSelect()
    self:ReturnPoolItemSlot()
    self:StopTime()
end

function UIEventBirthdayLegacyPathLayout:SetTimeRefresh()
    self.timeRefresh = self.eventModel.timeData.endTime - zg.timeMgr:GetServerTime()
end

function UIEventBirthdayLegacyPathLayout:StartTime()
    if self.updateTime ~= nil then
        zg.timeMgr:AddUpdateFunction(self.updateTime)
    end
end

function UIEventBirthdayLegacyPathLayout:StopTime()
    if self.updateTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
    end
end

function UIEventBirthdayLegacyPathLayout:OnTimeEnd()
    self:StopTime()
    self:ClearMoneyType()
    EventInBound.ValidateEventModel(function()
        self.view:OnReadyShow()
    end, true, true, true)
end

function UIEventBirthdayLegacyPathLayout:OnClickClaimMilestone(isBasic, number)
    if isBasic == false and self.isUnlocked == false then
        self:OnClickPurchase()
        return
    elseif self.eventModel:IsValidMilestone(number) == false then
        return
    else
        local isClaimedBasic, isClaimedPremium = self.eventModel:GetMilestoneStateByNumber(number)
        if (isBasic and isClaimedBasic) or (not isBasic and isClaimedPremium) then
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reward_claimed"))
            return
        end
        local listMilestone = List()
        listMilestone:Add(number)
        self.totalRewardSend = self.totalRewardSend + 1
        self:RequestClaimListMilestone(isBasic, listMilestone)
    end
end

function UIEventBirthdayLegacyPathLayout:UpdateCheckNotification()
    self.view:CheckAllNotificationTab()
end

--- @return number
function UIEventBirthdayLegacyPathLayout:FindNearestAvailableClaim()
    local _, claimableIndex = self.growthPackLineConfig:GetClaimableMilestone(self.eventModel:GetLegacyPoints(),
            self.isUnlocked,
            self.eventModel. eventPassLine)
    if claimableIndex ~= nil then
        return claimableIndex
    else
        local totalClaim = self.growthPackLineConfig:GetTotalClaimedReward()
        if totalClaim > 0 then
            return self.growthPackLineConfig.listMilestone:Count()
        end
    end
    return 1
end

function UIEventBirthdayLegacyPathLayout:OnClickPurchase()
    if self.isUnlocked then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("sold_out"))
        return
    end
    if self.eventModel.heroSelectedIndex == -1 then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("select_hero"))
        return
    end
    BuyUtils.InitListener(function()
        --PopupMgr.HidePopup(UIPopupName.UIUnlockPass)
        self:OnPurchaseSuccess()
    end)
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, self.titleKey, self.packId)
    RxMgr.purchaseProduct:Next(self.productConfig.productID)
end

--- @return boolean, boolean
function UIEventBirthdayLegacyPathLayout:GetMilestoneStateByNumber(number)
    if self.eventModel.eventPassLine == nil then
        return false, false
    end
    local basic, premium = self.eventModel.eventPassLine:GetMilestoneState(number)
    return basic ~= nil and basic > 0, premium ~= nil and premium > 0
end

function UIEventBirthdayLegacyPathLayout:UpdateUI()
    self:OnShow()
    self:UpdateCheckNotification()
end
function UIEventBirthdayLegacyPathLayout:OnPurchaseSuccess()
    self.eventModel:AddNumberBuy(EventActionType.BIRTHDAY_LEGACY_PATH_PURCHASE, self.packId, 1)
    self:UpdateUI()
end

function UIEventBirthdayLegacyPathLayout:OnClickClaimAll(isBasic)
    --- @type List
    local listClaimableMilestone1 = self.eventModel:_GetAllClaimableMilestone(isBasic)
    local listClaimableMilestone2 = self.eventModel:_GetAllClaimableMilestone(not isBasic)
    if listClaimableMilestone1:Count() > 0 then
        self:RequestClaimListMilestone(isBasic, listClaimableMilestone1)
        self.totalRewardSend = self.totalRewardSend + 1
    end
    if listClaimableMilestone2:Count() > 0 then
        self:RequestClaimListMilestone(not isBasic, listClaimableMilestone2)
        self.totalRewardSend = self.totalRewardSend + 1
    end
    if listClaimableMilestone2:Count() < 1 and listClaimableMilestone1:Count() < 1 then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("all_received"))
    end
    self:UpdateUI()
end

--- @param listMilestone List
function UIEventBirthdayLegacyPathLayout:RequestClaimListMilestone(isBasic, listMilestone)
    local onSuccess = function(rewardList)
        self.resultReward:AddAll(rewardList)
        self.totalRewardGet = self.totalRewardGet + 1
        self:ShowReward()
        self.eventModel:OnSuccessClaimListMilestone(isBasic, listMilestone)
        for i = 1, listMilestone:Count() do
            local milestone = listMilestone:Get(i)
            local milestoneItem = self.milestoneItemDict:Get(milestone)
            if milestoneItem ~= nil then
                if isBasic then
                    milestoneItem:SetBasicRewardState(false, true)
                else
                    milestoneItem:SetPremiumRewardState(false, true, true)
                end
            end
        end
        self:UpdateCheckNotification()
        self:ShowClaimAllState()
        self.uiScroll:ScrollToCell(0, 9000)
    end
    ClaimTigerPathOutBound.RequestClaimPass(self.opCodeClaim, nil, isBasic, listMilestone, onSuccess)
end

function UIEventBirthdayLegacyPathLayout:ShowReward()
    if self.totalRewardSend == self.totalRewardGet and self.resultReward:Count() > 0 then
        PopupUtils.ClaimAndShowRewardList(self.resultReward)
        self.resultReward:Clear()
        self.totalRewardSend = 0
        self.totalRewardGet = 0
    end
end

function UIEventBirthdayLegacyPathLayout:ReturnPoolItemDefault()
    ---@param v ItemIconView
    for _, v in ipairs(self.listItem:GetItems()) do
        v:ReturnPool()
    end
    ---@param v ItemIconView
    for _, v in ipairs(self.listIconItem:GetItems()) do
        v:ReturnPool()
    end
    self.listIconItem:Clear()
    self.listItem:Clear()
end

function UIEventBirthdayLegacyPathLayout:ReturnPoolItemSlot()
    for i = 1, self.listItemSlot:Count() do
        self.listItemSlot:Get(i):ReturnPool()
    end
    self.listItemSlot:Clear()
    self.iconSelectView = nil
end

function UIEventBirthdayLegacyPathLayout:ReturnPoolItemSelect()
    ---@param v ItemIconView
    for _, v in ipairs(self.listItemSelect:GetItems()) do
        v:ReturnPool()
    end
    self.listItemSelect:Clear()
end

