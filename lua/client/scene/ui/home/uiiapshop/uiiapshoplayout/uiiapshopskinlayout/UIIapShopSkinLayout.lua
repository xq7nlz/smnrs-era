--- @class UIIapShopSkinLayout : UIIapShopLayout
UIIapShopSkinLayout = Class(UIIapShopSkinLayout, UIIapShopLayout)

--- @param view UIIapShopView
--- @param parent UnityEngine_RectTransform
function UIIapShopSkinLayout:Ctor(view, parent)
    --- @type UIIapShopView
    self.view = view
    --- @type UIIapShopConfig
    self.config = view.config
    --- @type UIIapShopSkinLayoutConfig
    self.layoutConfig = nil
    --- @type SkinRawProducts
    self.skinRawProducts = nil
    --- @type UISelectFactionFilter
    self.factionFilter = nil
    --- @type number
    self.lastFactionTab = nil
    --- @type List --- ProductConfig
    self.skinBundleSortList = List()
    --- @type List --- skinId
    self.skinIdSortList = List()
    --- @type SortTypeSkin
    self.skinSortType = nil
    --- @type
    self.currentTabInst = nil

    self.isTabHotActive = false

    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SKIN_HOT_DEAL)
    self:InitLayoutConfig(parent)
    self:GetSkinBundleConfig()
    self:InitButtonListener()
    self:InitFactionFilter()
    self:InitScroll()
    self:InitScrollHot()
end

--- @param parent UnityEngine_RectTransform
function UIIapShopSkinLayout:InitLayoutConfig(parent)
    local inst = PrefabLoadUtils.Instantiate("skin_shop_view")
    self.layoutConfig = UIBaseConfig(inst.transform)
    UIUtils.SetParent(inst.transform, parent)
    inst:SetActive(true)
end

function UIIapShopSkinLayout:InitLocalization()
    self.layoutConfig.textPopular.text = LanguageUtils.LocalizeCommon("popular")
    self.layoutConfig.textPrice.text = LanguageUtils.LocalizeCommon("price")
    self.layoutConfig.textRecently.text = LanguageUtils.LocalizeCommon("recent")
    self.layoutConfig.textTitleSkinShop.text = LanguageUtils.LocalizeCommon("skin_shop")
    self.layoutConfig.textSort.text = LanguageUtils.LocalizeCommon("price")
end

function UIIapShopSkinLayout:InitButtonListener()
    self.layoutConfig.buttonHot.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonHot()
    end)
    self.layoutConfig.buttonSort.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonSort()
    end)
    self.layoutConfig.sortPannel.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonCloseSort()
    end)
    self.layoutConfig.buttonSortPopular.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonSortPopular()
    end)
    self.layoutConfig.buttonSortPrice.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonSortPrice()
    end)
    self.layoutConfig.buttonSortRecently.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonSortRecent()
    end)
end

function UIIapShopSkinLayout:SetUpLayout()
    self.layoutConfig.skinGridLayout.gameObject:SetActive(true)
    self.config.skinShopView.gameObject:SetActive(true)
    self:OnClickButtonSortPrice()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SKIN_HOT_DEAL)
    self:InitUpdateTime()
    if self.eventModel and self.eventModel:IsOpening() then
        self:SetEndEventTime(self:_GetEventEndTime(), function()
            self:_OnEventTimeEnded()
        end)
    end
    self:SortSkinBundleScroll()
end

function UIIapShopSkinLayout:OnHide()
    UIIapShopLayout.OnHide(self)
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end
    if self.uiScrollHot ~= nil then
        self.uiScrollHot:Hide()
    end
    self.isTabHotActive = false
    self.factionFilter:Select(1)
    self:UpdateButtonHot()
    self.config.skinShopView.gameObject:SetActive(false)
    if self.eventModel and self.eventModel:IsOpening() then
        self:RemoveUpdateTime()
    end
end

function UIIapShopSkinLayout:OnDestroy()

end

function UIIapShopSkinLayout:GetSkinBundleConfig()
    --- @type SkinRawProducts
    self.skinRawProducts = ResourceMgr.GetPurchaseConfig():GetCashShop().packConfigDict:Get(OpCode.ITEM_SKIN_BUNDLE_PURCHASE)
    self.rawSkinExchangeConfig = ResourceMgr.GetRawSkinExchangeConfig()
    self.skinBundleSortList = self.skinRawProducts:GetAllPackBase()
end

function UIIapShopSkinLayout:InitScroll()
    --- @param obj IapSkinBundlePackItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        local skinId = self.skinIdSortList:Get(dataIndex)
        obj:SetIconDataBySkin(skinId)

        local productConfig = self.skinRawProducts:FindSkinProductBySkinId(skinId)
        if productConfig ~= nil then
            local packKey = ClientConfigUtils.GetPurchaseKey(productConfig.opCode, productConfig.id)
            local price = zg.iapMgr:GetLocalPrizeString(packKey)
            obj:SetPrice(price)
            obj:AddBuyListener(function()
                RxMgr.purchaseProduct:Next(packKey)
            end)
        else
            --- @type {id, moneyType, moneyValue, rewardList, limit}
            local skinItemExchangeConfig = self.rawSkinExchangeConfig:GetSkinItemConfigBySkinId(skinId)
            if skinItemExchangeConfig ~= nil then
                obj:SetPrice(skinItemExchangeConfig.moneyValue, skinItemExchangeConfig.moneyType)
                obj:AddBuyListener(function()
                    if skinItemExchangeConfig ~= nil then
                        PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("want_to_buy"), nil,
                                function()
                                    self:RequestSkinExchange(skinItemExchangeConfig)
                                end)
                    end
                end)
            end
        end
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.skinScroll, UIPoolType.IapSkinBundlePackItem, onCreateItem)
end

function UIIapShopSkinLayout:OnBuySuccess(skinId)
    InventoryUtils.Add(ResourceType.Skin, skinId, 1)
end

--- @type {id, moneyType, moneyValue, rewardList, limit}
function UIIapShopSkinLayout:RequestSkinExchange(skinItemExchangeConfig)
    local price = RewardInBound.CreateBySingleParam(ResourceType.Money, skinItemExchangeConfig.moneyType, skinItemExchangeConfig.moneyValue)
    if InventoryUtils.IsEnoughSingleResourceRequirement(price) == false then
        return
    end
    --- @type List
    local listReward
    --- @param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        listReward = NetworkUtils.GetListDataInBound(buffer, RewardInBound.CreateByBuffer)
    end
    local onSuccess = function()
        if listReward ~= nil then
            PopupUtils.ClaimAndShowRewardList(listReward)
            InventoryUtils.Sub(price.type, price.id, price.number)
        end
    end
    NetworkUtils.RequestAndCallback(OpCode.ITEM_SKIN_EXCHANGE,
            UnknownOutBound.CreateInstance(PutMethod.Int, skinItemExchangeConfig.id),
            onSuccess, nil, onBufferReading)
end

function UIIapShopSkinLayout:InitScrollHot()
    --- @param obj IapSkinBundlePackItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type ProductConfig
        local productConfig = self.skinBundleSortList:Get(dataIndex)
        if self.eventModel ~= nil and self.eventModel:IsOpening() and self.isTabHotActive then
            local packKey = ClientConfigUtils.GetPurchaseKey(productConfig.opCode, productConfig.id, self.eventModel.timeData.dataId)
            local price = zg.iapMgr:GetLocalPrizeString(packKey)
            obj:SetIconDataByProductConfig(productConfig)
            obj:SetPrice(price)
            obj:AddBuyListener(function()
                RxMgr.purchaseProduct:Next(packKey)
            end)
        end
    end
    self.uiScrollHot = UILoopScroll(self.layoutConfig.hotSkinScroll, UIPoolType.IapSkinBundleHotPackItem, onCreateItem)
end

function UIIapShopSkinLayout:InitFactionFilter()
    -- Select faction
    --- @param obj UnityEngine_UI_Button
    --- @param isSelect boolean
    local onSelectFaction = function(obj, isSelect)
        if obj ~= nil then
            UIUtils.SetInteractableButton(obj, not isSelect)
            self.currentTabInst = obj
            if isSelect then
                self.layoutConfig.imageSelect.gameObject:SetActive(true)
                self.layoutConfig.imageSelect.transform:SetParent(obj.transform)
                self.layoutConfig.imageSelect.transform.localPosition = U_Vector3.zero
            end
        end
    end
    local onChangeSelectFaction = function(indexTab, lastTab)

    end
    local onClickSelectFaction = function()
        self.isTabHotActive = false
        self:UpdateButtonHot()
        self:SortSkinBundleScroll()
    end

    self.factionFilter = UISelectFactionFilter(self.layoutConfig.faction,
            nil, onSelectFaction, onChangeSelectFaction,
            onClickSelectFaction)
    self.factionFilter:SetSprite()
end

function UIIapShopSkinLayout:SortSkinByFaction()
    local faction = self:GetFaction()

    self.skinBundleSortList:Clear()
    self.skinIdSortList:Clear()
    for i, skinId in ipairs(self.skinRawProducts:GetAllPackSkinList():GetItems()) do
        if faction == nil or ClientConfigUtils.GetFactionIdByHeroId(ClientConfigUtils.GetHeroIdBySkinId(skinId)) == faction then
            self.skinIdSortList:Add(skinId)
            ---@type ProductConfig
            local skinBundleProduct = self.skinRawProducts:GetAllPackSkinDict():Get(skinId)
            self.skinBundleSortList:Add(skinBundleProduct)
        end
    end
    --- @param skinConfig {id, moneyType, moneyValue, rewardList, limit}
    for i, skinConfig in ipairs(self.rawSkinExchangeConfig:GetListSkinItem():GetItems()) do
        local skinId = skinConfig.rewardList:Get(1).id
        if faction == nil or ClientConfigUtils.GetFactionIdByHeroId(ClientConfigUtils.GetHeroIdBySkinId(skinId)) == faction then
            self.skinIdSortList:Add(skinId)
            ---@type ProductConfig
            local skinBundleProduct = ProductConfig()
            skinBundleProduct.id = self.skinIdSortList:GetCurrentIndex() + i
            skinBundleProduct.dollarPrice = tostring(skinConfig.moneyValue)
            self.skinBundleSortList:Add(skinBundleProduct)
        end
    end
end

function UIIapShopSkinLayout:SortSkinBundleScroll()
    if self.isTabHotActive == false then
        self:SortSkinByFaction()
    end
    self:SortSkinByType()
    self:ResizeScroll()
end

function UIIapShopSkinLayout:SortSkinByType()
    if self.skinSortType == SortTypeSkin.POPULAR then
        if self.isTabHotActive then
            self:SortByPrice()
            return
        end
        self.skinIdSortList:SortWithMethod(SortUtils._SkinSortRarity)
        self:UpdateSortSkinProductList()
        return
    elseif self.skinSortType == SortTypeSkin.PRICE then
        self:SortByPrice()
    else
        self:SortById()
    end
end

function UIIapShopSkinLayout:SortByPrice()
    self.skinBundleSortList:SortWithMethod(function(x, y)
        if x.dollarPrice < y.dollarPrice then
            return -1
        end
        return 1
    end)
end

function UIIapShopSkinLayout:SortById()
    self.skinBundleSortList:SortWithMethod(function(x, y)
        if x.id > y.id then
            return -1
        end
        return 1
    end)
end

function UIIapShopSkinLayout:UpdateSortSkinProductList()
    self.skinBundleSortList:Clear()
    for i, skinId in ipairs(self.skinIdSortList:GetItems()) do
        ---@type ProductConfig
        local skinBundleProduct = self.skinRawProducts:GetAllPackSkinDict():Get(skinId)
        self.skinBundleSortList:Add(skinBundleProduct)
    end
    return self.skinBundleSortList
end

function UIIapShopSkinLayout:ResizeScroll()
    self.uiScroll:Resize(self.skinBundleSortList:Count())
    self.uiScrollHot:Resize(self.skinBundleSortList:Count())

    if self.canPlayMotion == true then
        self.canPlayMotion = false
        self.uiScroll:PlayMotion()
    end
end

--- @return void
function UIIapShopSkinLayout:GetFaction()
    local faction
    if self.lastFactionTab ~= nil then
        faction = self.lastFactionTab
    else
        faction = self.factionFilter.indexTab
    end
    if faction ~= nil and faction > 1 then
        faction = faction - 1
    else
        faction = nil
    end
    return faction
end

--- @return void
function UIIapShopSkinLayout:OnClickButtonSort()
    self.layoutConfig.sortPannel.gameObject:SetActive(true)
    self:ViewSortPanel()
end

--- @return void
function UIIapShopSkinLayout:ViewSortPanel()
    if self.skinSortType == SortTypeSkin.POPULAR then
        self:EnableSortButton(self.layoutConfig.buttonSortRecently, true)
        self:EnableSortButton(self.layoutConfig.buttonSortPrice, true)
        self.layoutConfig.chooseButton.transform.position = self.layoutConfig.buttonSortPopular.transform.position
        self:EnableSortButton(self.layoutConfig.buttonSortPopular, false)
        self.layoutConfig.textSort.text = LanguageUtils.LocalizeCommon("popular")
    elseif self.skinSortType == SortTypeSkin.PRICE then
        self:EnableSortButton(self.layoutConfig.buttonSortRecently, true)
        self:EnableSortButton(self.layoutConfig.buttonSortPopular, true)
        self.layoutConfig.chooseButton.transform.position = self.layoutConfig.buttonSortPrice.transform.position
        self:EnableSortButton(self.layoutConfig.buttonSortPrice, false)
        self.layoutConfig.textSort.text = LanguageUtils.LocalizeCommon("price")
    else
        self:EnableSortButton(self.layoutConfig.buttonSortPrice, true)
        self:EnableSortButton(self.layoutConfig.buttonSortPopular, true)
        self.layoutConfig.chooseButton.transform.position = self.layoutConfig.buttonSortRecently.transform.position
        self:EnableSortButton(self.layoutConfig.buttonSortRecently, false)
        self.layoutConfig.textSort.text = LanguageUtils.LocalizeCommon("recent")
    end
end

--- @return void
---@param button UnityEngine_UI_Button
---@param enable boolean
function UIIapShopSkinLayout:EnableSortButton(button, enable)
    UIUtils.SetInteractableButton(button, enable)
    ---@type UnityEngine_UI_Image
    local image = button:GetComponent(ComponentName.UnityEngine_UI_Image)
    if image ~= nil then
        image.raycastTarget = enable
    end
end

function UIIapShopSkinLayout:OnClickButtonSortPopular()
    self.skinSortType = SortTypeSkin.POPULAR
    self:ViewSortPanel()
    self:SortSkinBundleScroll()
    self.layoutConfig.sortPannel.gameObject:SetActive(false)
end

function UIIapShopSkinLayout:OnClickButtonSortPrice()
    self.skinSortType = SortTypeSkin.PRICE
    self:ViewSortPanel()
    self:SortSkinBundleScroll()
    self.layoutConfig.sortPannel.gameObject:SetActive(false)
end

function UIIapShopSkinLayout:OnClickButtonSortRecent()
    self.skinSortType = SortTypeSkin.RECENT
    self:ViewSortPanel()
    self:SortSkinBundleScroll()
    self.layoutConfig.sortPannel.gameObject:SetActive(false)
end

--- @return void
function UIIapShopSkinLayout:OnClickButtonCloseSort()
    self.layoutConfig.sortPannel.gameObject:SetActive(false)
end

--- @return void
function UIIapShopSkinLayout:OnClickButtonHot()
    self.isTabHotActive = true
    UIUtils.SetInteractableButton(self.currentTabInst, true)

    self:UpdateButtonHot()
    self.factionFilter.indexTab = -1
    self.skinBundleSortList:Clear()
    self:UpdateUIByEvent()
    self:SortSkinByType()
    self:ResizeScroll()
end

function UIIapShopSkinLayout:UpdateUIByEvent()
    local isEventOpen = self.eventModel ~= nil and self.eventModel:IsOpening()
    self.layoutConfig.skinHotGridLayout.gameObject:SetActive(isEventOpen)
    self.layoutConfig.emptyLayout.gameObject:SetActive(not isEventOpen)
    self.layoutConfig.bgTimer.gameObject:SetActive(isEventOpen)

    if isEventOpen then
        for i, v in ipairs(self.eventModel:GetConfig():GetSkinProductConfigs():GetAllPackBase():GetItems()) do
            self.skinBundleSortList:Add(v)
        end
    else
        self.layoutConfig.textEmptySale.text = LanguageUtils.LocalizeCommon("there_is_no_current_sale")
    end
end
--- @return void
function UIIapShopSkinLayout:UpdateButtonHot()
    self.layoutConfig.skinGridLayout.gameObject:SetActive(not self.isTabHotActive)
    self.layoutConfig.skinHotGridLayout.gameObject:SetActive(self.isTabHotActive)
    self.layoutConfig.tabHotOn.gameObject:SetActive(self.isTabHotActive)
    self.layoutConfig.tabHotOff.gameObject:SetActive(not self.isTabHotActive)
    self.layoutConfig.imageSelect.gameObject:SetActive(not self.isTabHotActive)
    self.layoutConfig.emptyLayout.gameObject:SetActive(self.isTabHotActive)
    self.layoutConfig.bgTimer.gameObject:SetActive(self.isTabHotActive)
end

function UIIapShopSkinLayout:_GetEventEndTime()
    return self.eventModel.timeData.endTime
end

--- @param endTime number
--- @param onEventTimeEnded function
function UIIapShopSkinLayout:SetEndEventTime(endTime, onEventTimeEnded)
    self.endTime = endTime
    self.onEventTimeEnded = onEventTimeEnded
    self:StartUpdateTime()
end

function UIIapShopSkinLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIIapShopSkinLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIIapShopSkinLayout:SetTimeRefresh()
    self.timeRefresh = self.endTime - zg.timeMgr:GetServerTime()
end

function UIIapShopSkinLayout:InitUpdateTime()
    if self.eventModel and self.eventModel:IsOpening() then
        --- @param isSetTime boolean
        self.updateTime = function(isSetTime)
            if isSetTime == true then
                self:SetTimeRefresh()
            else
                self.timeRefresh = self.timeRefresh - 1
            end
            self.layoutConfig.textEventTime.text = string.format("%s %s", LanguageUtils.LocalizeCommon("will_end_in"),
                    UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRefresh)))
            if self.timeRefresh <= 0 then
                self:RemoveUpdateTime()
                if self.onEventTimeEnded then
                    self.onEventTimeEnded()
                end
            end
        end
    end
end

function UIIapShopSkinLayout:_GetEventEndTime()
    return self.eventModel and self.eventModel.timeData.endTime
end

--- @param eventTimeType EventTimeType
function UIIapShopSkinLayout:_OnEventTimeEnded()
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = self.eventModel:GetType(), ["isAdded"] = false })
end

--- @class SortTypeSkin
SortTypeSkin = {
    POPULAR = 1,
    PRICE = 2,
    RECENT = 3
}