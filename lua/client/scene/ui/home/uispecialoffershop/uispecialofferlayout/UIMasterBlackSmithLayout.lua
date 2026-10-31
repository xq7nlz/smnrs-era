--- @class UIMasterBlackSmithLayout : UISpecialOfferLayout
UIMasterBlackSmithLayout = Class(UIMasterBlackSmithLayout, UISpecialOfferLayout)

--- @param view UISpecialOfferShopView
--- @param packViewType PackViewType
--- @param root UnityEngine_RectTransform
function UIMasterBlackSmithLayout:Ctor(view, packViewType, root)
    UISpecialOfferLayout.Ctor(self, view, packViewType)
    --- @type UIMasterBlackSmithLayoutConfig
    self.layoutConfig = UIBaseConfig(root)
    --- @type Dictionary
    self.tabDict = Dictionary()

    self:InitUpdateTime()
    --- @type ItemsTableView
    self.itemsTableView = ItemsTableView(self.layoutConfig.itemsTableView)
    --- @type number
    self.firstShowGroup = nil
end

function UIMasterBlackSmithLayout:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
            if self.timeRefresh < 0 then
                self:OnPackEndTime()
            end
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        self:SetTextTimeRefresh()
        if self.timeRefresh < 0 then
            self:OnPackEndTime()
        end
    end
end

function UIMasterBlackSmithLayout:InitLocalization()
    --- @param k number
    --- @param v IapShopTabItem
    for k, v in pairs(self.tabDict:GetItems()) do
        v:SetTabName(self:GetTabName(k))
    end
    self.layoutConfig.textName.text = LanguageUtils.LocalizeCommon("master_blacksmith")
    self.layoutConfig.textExtra.text = LanguageUtils.LocalizeCommon("extra")
end

function UIMasterBlackSmithLayout:OnShow()
    UISpecialOfferLayout.OnShow(self)
    self:ShowAllActiveGroup()
end

function UIMasterBlackSmithLayout:ShowAllActiveGroup()
    self:SetUpLayout()

    if self.tabDict:Count() == 0 then
        self.view:OnReadyShow()
        return
    end
    self:OnSelectTab(self.firstShowGroup)
end

function UIMasterBlackSmithLayout:SetUpLayout()
    self.tabDict = Dictionary()
    self:DisableAllTab()
    for i = 1, self.listGroupProductConfig:Count() do
        --- @type GroupProductConfig
        local groupProductConfig = self.listGroupProductConfig:Get(i)
        self:GetTabByIndex(i - 1, groupProductConfig.groupId)
    end
end

function UIMasterBlackSmithLayout:OnHide()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
    self.itemsTableView:Hide()

    zg.playerData.remoteConfig.showedMasterBlackSmithLoginTime = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).lastLoginTime
    zg.playerData:SaveRemoteConfig()
end

function UIMasterBlackSmithLayout:OnDestroy()

end

function UIMasterBlackSmithLayout:DisableAllTab()
    for i = 1, self.layoutConfig.topTab.childCount do
        self.layoutConfig.topTab:GetChild(i - 1).gameObject:SetActive(false)
    end
end

--- @return IapShopTabItem
function UIMasterBlackSmithLayout:GetTabByIndex(index, groupId)
    --- @type UnityEngine_RectTransform
    local tabAnchor
    if index >= self.layoutConfig.topTab.childCount then
        local prefab = self.layoutConfig.topTab:GetChild(0)
        if prefab == nil then
            XDebug.Error("Mission prefab")
            return
        end
        --- @type UnityEngine_GameObject
        local clone = U_GameObject.Instantiate(prefab)
        --- @type UnityEngine_RectTransform
        tabAnchor = clone:GetComponent(ComponentName.UnityEngine_RectTransform)
        tabAnchor:SetParent(self.layoutConfig.topTab)
        tabAnchor.anchoredPosition3D = U_Vector3.zero
        tabAnchor.localScale = U_Vector3.one
        tabAnchor:SetAsLastSibling()
    else
        tabAnchor = self.layoutConfig.topTab:GetChild(index)
    end
    tabAnchor.gameObject:SetActive(true)
    local iapShopTabItem = IapShopTabItem(tabAnchor)
    self.tabDict:Add(groupId, iapShopTabItem)
    self.firstShowGroup = groupId
    iapShopTabItem:SetTabName(self:GetTabName(groupId))
    iapShopTabItem:SetListener(function()
        self:OnSelectTab(groupId)
    end)
end

function UIMasterBlackSmithLayout:GetTabName(groupId)
    return string.format("%s %d", LanguageUtils.LocalizeCommon("master_blacksmith"), groupId)
end

function UIMasterBlackSmithLayout:OnSelectTab(groupId)
    self:OnHide()

    --- @param v IapShopTabItem
    for k, v in pairs(self.tabDict:GetItems()) do
        v:SetTabState(k == groupId)
    end
    for i = 1, self.listGroupProductConfig:Count() do
        --- @type GroupProductConfig
        local groupProductConfig = self.listGroupProductConfig:Get(i)
        if groupProductConfig.groupId == groupId then
            self:SetGroupData(groupProductConfig)
            break
        end
    end
end

--- @param groupProductConfig GroupProductConfig
function UIMasterBlackSmithLayout:SetGroupData(groupProductConfig)
    self.groupProductConfig = groupProductConfig
    self.groupId = groupProductConfig.groupId
    local listPack = groupProductConfig:GetListProductConfig()
    --- @type ProductConfig
    local firstPack = listPack:Get(1)
    self.packId = firstPack.id
    --- @return ProductConfig
    self.csv = ResourceMgr.GetPurchaseConfig():GetCashShop():GetPackById(OpCode.PURCHASE_PROGRESS_PACK, self.packId)
    self.layoutConfig.textPrice.text = zg.iapMgr:GetLocalPrizeString(ClientConfigUtils.GetPurchaseKey(OpCode.PURCHASE_PROGRESS_PACK, self.packId))
    self.layoutConfig.textProfitValue.text = string.format("+%s%%", self.csv.profit)

    self:ShowReward()
    zg.timeMgr:AddUpdateFunction(self.updateTime)

    self:SetOnClickBuy(function()
        BuyUtils.InitListener(function()
            local progressPackCollection = self.iapDataInBound.progressPackData
            progressPackCollection.activeProgressPackDict:RemoveByKey(self.groupId)
            self.listGroupProductConfig:RemoveByReference(self.groupProductConfig)
            self:ShowAllActiveGroup()
            RxMgr.notificationPurchasePacks:Next()
        end, function(logicCode)
            XDebug.Error("Error logic code " .. logicCode)
        end)
        RxMgr.purchaseProduct:Next(ClientConfigUtils.GetPurchaseKey(OpCode.PURCHASE_PROGRESS_PACK, self.packId))
    end)
end

function UIMasterBlackSmithLayout:SetTimeRefresh()
    local progressPackCollection = self.iapDataInBound.progressPackData
    self.timeRefresh = progressPackCollection.activeProgressPackDict:Get(self.groupId) + self.groupProductConfig.duration - zg.timeMgr:GetServerTime()
end

function UIMasterBlackSmithLayout:SetTextTimeRefresh()
    self.layoutConfig.textTimer.text = string.format("%s", TimeUtils.SecondsToClock(self.timeRefresh))
end

function UIMasterBlackSmithLayout:OnPackEndTime()
    self:OnShow()
end

function UIMasterBlackSmithLayout:SetOnClickBuy(listener)
    self.layoutConfig.buttonBuy.onClick:RemoveAllListeners()
    self.layoutConfig.buttonBuy.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if listener then
            listener()
        end
    end)
end

function UIMasterBlackSmithLayout:ShowReward()
    local rewardList = List()
    for i = 1, self.csv.rewardList:Count() - 1 do
        rewardList:Add(self.csv.rewardList:Get(i))
    end
    self.itemsTableView:SetData(RewardInBound.GetItemIconDataList(rewardList), UIPoolType.RootIconView)
    self:ShowVipPointReward(self.csv.rewardList:Get(self.csv.rewardList:Count()))
end

--- @param rewardInBound RewardInBound
function UIMasterBlackSmithLayout:ShowVipPointReward(rewardInBound)
    self.layoutConfig.iconVipPoint.sprite = ResourceLoadUtils.LoadMoneyIcon(rewardInBound.id)
    self.layoutConfig.iconVipPoint:SetNativeSize()
    self.layoutConfig.textVipPointValue.text = string.format("+%s", tostring(rewardInBound.number))
end

