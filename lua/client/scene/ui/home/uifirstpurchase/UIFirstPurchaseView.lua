--- @class UIFirstPurchaseView : UIBaseView
UIFirstPurchaseView = Class(UIFirstPurchaseView, UIBaseView)

--- @return void
--- @param model UIFirstPurchaseModel
function UIFirstPurchaseView:Ctor(model, ctrl)
    --- @type UIFirstPurchaseConfig
    self.config = nil

    --- @type ItemsTableView
    self.itemsTableView = nil

    --- @type number
    self.timeRefresh = nil
    --- @type IapDataInBound
    self.iapDataInBound = nil

    UIBaseView.Ctor(self, model, ctrl)
    --- @type UIFirstPurchaseModel
    self.model = model
end

function UIFirstPurchaseView:OnReadyCreate()
    ---@type UIFirstPurchaseConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.itemsTableView = ItemsTableView(self.config.listItemAnchor)
    self:InitButtonListener()
    self:InitUpdateTime()
end

--- @return void
function UIFirstPurchaseView:InitLocalization()
    self.config.textTittle.text = LanguageUtils.LocalizeCommon("first_purchase")
    self.config.textTapToClose.gameObject:SetActive(false)
end

function UIFirstPurchaseView:InitButtonListener()
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonBuy.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBuy()
    end)
end

function UIFirstPurchaseView:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        self:SetTextTimeRefresh()
        if self.timeRefresh < 0 then
            self.progressPackCollection.activeProgressPackDict:RemoveByKey(self.groupId)
            self:OnReadyHide()
        end
    end
end

function UIFirstPurchaseView:OnReadyShow()
    --- @type IapDataInBound
    self.iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    --- @type ProgressPackCollection
    self.progressPackCollection = self.iapDataInBound.progressPackData

    self:GetPack()
    self:ShowPackData()
    self:SetTimeClose()
end

function UIFirstPurchaseView:SetTimeRefresh()
    local createdTime = self.iapDataInBound.progressPackData.activeProgressPackDict:Get(self.groupId)
    self.timeRefresh = createdTime + self.groupProductConfig.duration - zg.timeMgr:GetServerTime()
end

function UIFirstPurchaseView:SetTimeClose()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIFirstPurchaseView:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIFirstPurchaseView:SetTextTimeRefresh()
    self.config.duration.text = string.format("%s %s", LanguageUtils.LocalizeCommon("will_end_in"),
            UIUtils.SetColorString(UIUtils.green_light, TimeUtils.SecondsToClock(self.timeRefresh)))
end

function UIFirstPurchaseView:Hide()
    UIBaseView.Hide(self)
    self.itemsTableView:Hide()
    self:RemoveUpdateTime()
end

function UIFirstPurchaseView:OnClickBuy()
    BuyUtils.InitListener(function()
        self:CheckGroupStillActive()
        RxMgr.notificationPurchasePacks:Next()
    end, function(logicCode)
        print("Error logic code ", logicCode)
    end)
    RxMgr.purchaseProduct:Next(ClientConfigUtils.GetPurchaseKey(OpCode.PURCHASE_PROGRESS_PACK, self.packId))
end

function UIFirstPurchaseView:OnClickBackOrClose()
    zg.playerData.remoteConfig.showedFirstPurchaseLoginTime = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).lastLoginTime
    zg.playerData:SaveRemoteConfig()
    UIBaseView.OnClickBackOrClose(self)
end

function UIFirstPurchaseView:GetPack()
    local listActiveGroupProductConfig = self.progressPackCollection:GetListActiveGroupByViewType(PackViewType.FIRST_TIME_PACK)
    --- @type GroupProductConfig
    self.groupProductConfig = listActiveGroupProductConfig:Get(1)
    self.groupId = self.groupProductConfig.groupId

    --- Just Show the 1st pack in group
    --- @type List
    local listProductInGroup = self.groupProductConfig:GetListProductConfig()
    --- @type ProductConfig
    local firstPack = listProductInGroup:Get(1)
    self.packId = firstPack.id
    self.csv = ResourceMgr.GetPurchaseConfig():GetCashShop():GetPackById(OpCode.PURCHASE_PROGRESS_PACK, self.packId)
end

function UIFirstPurchaseView:ShowPackData()
    self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(ClientConfigUtils.GetPurchaseKey(OpCode.PURCHASE_PROGRESS_PACK, self.packId))
    local vipReward, listRewardInBound = self.csv:GetReward()
    local vipRewardInBound = RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.VIP_POINT, vipReward)
    listRewardInBound:Add(vipRewardInBound)
    local iconDataList = RewardInBound.GetItemIconDataList(listRewardInBound)
    self.itemsTableView:SetData(iconDataList, UIPoolType.ItemIconView)
end

function UIFirstPurchaseView:CheckGroupStillActive()
    local listProductConfig = self.groupProductConfig.listProductConfig
    local availablePack = listProductConfig:Count()
    for i = availablePack, 1, -1 do
        --- @type ProductConfig
        local productConfig = listProductConfig:Get(i)
        local boughtCount = self.progressPackCollection:GetBoughtCount(productConfig.id)
        if boughtCount >= productConfig.stock then
            availablePack = availablePack - 1
        end
    end
    if availablePack == 0 then
        self.progressPackCollection.activeProgressPackDict:RemoveByKey(self.groupId)
        self:OnReadyHide()
    end
end