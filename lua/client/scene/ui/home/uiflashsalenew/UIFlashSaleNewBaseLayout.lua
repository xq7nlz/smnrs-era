--- @class UIFlashSaleNewBaseLayout
UIFlashSaleNewBaseLayout = Class(UIFlashSaleNewBaseLayout)

--- @param view UIFlashSaleNewView
--- @param groupID number
--- @param anchor UnityEngine_RectTransform
function UIFlashSaleNewBaseLayout:Ctor(view, groupID, anchor)
    ---@type ItemsTableView
    self.rewardTableView = nil
    ---@type number
    self.groupID = groupID
    --- @type GroupProductConfig
    self.myGroup = nil
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIFlashSaleNewView
    self.view = view
    --- @type UIFlashSaleNewModel
    self.model = view.model
    --- @type UIFlashSaleNewLayoutConfig
    self.layoutConfig = nil
    --- @type string
    self.defaultPrefabName = "flash_sale_1"
    self:InitLayoutConfig()
    self:InitLocalization()
    self:InitButtons()
end

function UIFlashSaleNewBaseLayout:InitLocalization()
    --- @type ProductConfig
    local productConfig = self.myGroup.listProductConfig:Get(1)
    self.layoutConfig.textProfit.text = "+" .. tostring(productConfig.profit) .. "%"
    self.layoutConfig.packageTitle.text = UIFlashSaleNewView._GetPackageNameLocalizeByID(self.groupID)
    self:SetTextLimit()
end

function UIFlashSaleNewBaseLayout:SetReward()
    self.rewardTableView = ItemsTableView(self.layoutConfig.rewardLayout)
    --- @type ProductConfig
    local productConfig = self.myGroup.listProductConfig:Get(1)
    ---@type List<ItemIconData>
    local listRewards = List()
    productConfig = ResourceMgr.GetPurchaseConfig():GetCashShop():GetProgressPackWithId(productConfig.id)
    self.rewardTableView:SetData(RewardInBound.GetItemIconDataList(productConfig.rewardList))
    local hasBought = self:GetBoughtCount() > 0
    self:SetRewardTableView(hasBought)
end

function UIFlashSaleNewBaseLayout:SetTextLimit()
    local color = UIUtils.green_light

    local boughtCount = self:GetBoughtCount()
    --- @type ProductConfig
    local productConfig = self.myGroup.listProductConfig:Get(1)
    if (productConfig.isLimited) then
        if (boughtCount >= productConfig.stock) then
            color = UIUtils.red_dark
        end
        self.layoutConfig.textLimit.text = string.format(LanguageUtils.LocalizeCommon("limit_x"),
                string.format("<color=#%s>%s/%s</color>", color, productConfig.stock - boughtCount, productConfig.stock))
    end
end

function UIFlashSaleNewBaseLayout:SetOnBuyState()
    local boughtCount = self:GetBoughtCount()
    --- @type ProductConfig
    local productConfig = self.myGroup.listProductConfig:Get(1)
    if productConfig.productID == nil then
        productConfig.productID = self:SetProductId(productConfig.opCode, productConfig.id, productConfig.dataId)
    end
    local bought = boughtCount == productConfig.stock

    self.layoutConfig.buttonBuy.enabled = not bought
    self.layoutConfig.maskBtn.gameObject:SetActive(bought)

    self:SetTextLimit()

    if (bought) then
        self.layoutConfig.textPrice.text = LanguageUtils.LocalizeCommon("sold_out")
    else
        self.layoutConfig.textPrice.text = zg.iapMgr:GetLocalPrizeString(productConfig.productID)
    end
    self:SetRewardTableView(bought)
end

function UIFlashSaleNewBaseLayout:SetProductId(opCode, id, dataId)
    return ClientConfigUtils.GetPurchaseKey(opCode, id, dataId)
end

function UIFlashSaleNewBaseLayout:SetRewardTableView(bought)
    if (self.rewardTableView) then
        self.rewardTableView:ActiveMaskSelect(bought)
    end
end

function UIFlashSaleNewBaseLayout:OnClickBuyButton()
    BuyUtils.InitListener(function()
        self:SetOnBuyState()
    end, function(logicCode)
        XDebug.Error("Error logic code " .. logicCode)
    end)
    --- @type ProductConfig
    local productConfig = self.myGroup.listProductConfig:Get(1)
    RxMgr.purchaseProduct:Next(productConfig.productID)
end

function UIFlashSaleNewBaseLayout:InitButtons()
    self.layoutConfig.buttonBuy.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBuyButton()
    end)
end

function UIFlashSaleNewBaseLayout:GetPrefabNameByGroupID()
    return "flash_sale_" .. tostring(self.groupID)
end

--- @return GroupProductConfig
function UIFlashSaleNewBaseLayout:GetMyFlashSaleGroup()
    if (self.myGroup ~= nil) then
        return self.myGroup
    end
    for _, v in pairs(self.model.listNewFlashSaleGroup:GetItems()) do
        if (v.groupId == self.groupID) then
            self.myGroup = v
            return v
        end
    end
    return nil
end

function UIFlashSaleNewBaseLayout:GetBoughtCount()
    --- @type IapDataInBound
    local iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    ---@type GroupProductConfig
    local groupProductConfig = self:GetMyFlashSaleGroup()
    local packID = groupProductConfig.listProductConfig:Get(1).id
    local boughtCount = iapDataInBound.progressPackData:GetBoughtCount(packID)
    return boughtCount
end

function UIFlashSaleNewBaseLayout:InitLayoutConfig()
    local prefabName = self:GetPrefabNameByGroupID()
    local inst = PrefabLoadUtils.Instantiate(prefabName, self.anchor)
    if inst == nil then
        inst = PrefabLoadUtils.Instantiate(self.defaultPrefabName, self.anchor)
    end
    self.layoutConfig = UIBaseConfig(inst.transform)
    UIUtils.SetParent(inst.transform, self.anchor)
    inst:SetActive(true)
    self:GetMyFlashSaleGroup()
end

function UIFlashSaleNewBaseLayout:OnHide()
    self.anchor.gameObject:SetActive(false)
    self:RemoveUpdateTime()
    if (self.rewardTableView) then
        self.rewardTableView:Hide()
    end
end

function UIFlashSaleNewBaseLayout:OnShow()
    self:StartUpdateTime()
    self:SetUpLayout()
    self:SetReward()
    local hasBought = self:GetBoughtCount() > 0
    self:SetOnBuyState(hasBought)
end

function UIFlashSaleNewBaseLayout:SetUpLayout()
    self.anchor.gameObject:SetActive(true)
    self:SetTabSeen()
end

function UIFlashSaleNewBaseLayout:SetTabSeen()
    local remoteConfigData = zg.playerData.remoteConfig
    if remoteConfigData.isFlashSaleNewTabSeen == nil then
        remoteConfigData.isFlashSaleNewTabSeen = {}
    end
    remoteConfigData.isFlashSaleNewTabSeen["new_group_" .. self.groupID] = true
    self.view:UpdateNotificationByTab(self.groupID)
    zg.playerData:SaveRemoteConfig()
end

function UIFlashSaleNewBaseLayout:StartUpdateTime()
    if self.updateTime == nil then
        --- @param isSetTime boolean
        self.updateTime = function(isSetTime)
            if isSetTime == true then
                self:SetTimeRefresh()
            else
                self.timeRefresh = self.timeRefresh - 1
            end
            self.layoutConfig.textEventTime.text = string.format("%s %s", LanguageUtils.LocalizeCommon("will_end_in"),
                    UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRefresh)))
        end
    end
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIFlashSaleNewBaseLayout:SetTimeRefresh()
    --- @type ProgressPackCollection
    local progressPackCollection = zg.playerData:GetMethod(PlayerDataMethod.IAP).progressPackData
    local createdTime = progressPackCollection.activeProgressPackDict:Get(self.groupID)
    ---@type GroupProductConfig
    local groupProductConfig = self.view:GetGroupProductConfigByID(self.groupID)
    local endTime = createdTime + groupProductConfig.duration
    self.timeRefresh = endTime - zg.timeMgr:GetServerTime()
end

function UIFlashSaleNewBaseLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

