--- @class UIFlashSaleBaseLayout
UIFlashSaleBaseLayout = Class(UIFlashSaleBaseLayout)

--- @param view UIFlashSaleView
--- @param groupID number
--- @param anchor UnityEngine_RectTransform
function UIFlashSaleBaseLayout:Ctor(view, groupID, anchor)
    ---@type ItemsTableView
    self.rewardTableView = nil
    ---@type number
    self.groupID = groupID
    -- XDebug.Log("SET GROUP ID hoangpl " .. tostring(groupID))
    -- --- @type ProductConfig
    -- self.myProduct = nil
    --- @type GroupProductConfig
    self.myGroup = nil
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIFlashSaleView
    self.view = view
    --- @type UIFlashSaleModel
    self.model = view.model
    --- @type UIFlashSaleLayoutConfig
    self.layoutConfig = nil
    self:InitLayoutConfig()
    self:OnHide()
    self:InitLocalization()
    self:InitButtons()
end

function UIFlashSaleBaseLayout:InitLocalization()
    --- @type ProductConfig
    local productConfig = self.myGroup.listProductConfig:Get(1)
    self.layoutConfig.textProfit.text = tostring(productConfig.profit) .. "%"
    self.layoutConfig.textProfitTitle.text = LanguageUtils.LocalizeCommon("extra")
    self.layoutConfig.packageTitle.text = UIFlashSaleView._GetPackageNameLocalizeByID(self.groupID)
    self:SetTextLimit()
end

function UIFlashSaleBaseLayout:SetReward()
    self.rewardTableView = ItemsTableView(self.layoutConfig.rewardLayout)
    --- @type ProductConfig
    local productConfig = self.myGroup.listProductConfig:Get(1)
    ---@type List<ItemIconData>
    local listRewards = List()
    self.rewardTableView:SetData(RewardInBound.GetItemIconDataList(productConfig.rewardList))
    local hasBought = self:GetBoughtCount() > 0
    self:SetRewardTableView(hasBought)
end

function UIFlashSaleBaseLayout:SetTextLimit()
    --local color = UIUtils.green_light

    --local boughtCount = self:GetBoughtCount()
    ----- @type ProductConfig
    --local productConfig = self.myGroup.listProductConfig:Get(1)
    --if (productConfig.isLimited) then
    --    if (boughtCount >= productConfig.stock) then
    --        color = UIUtils.red_dark
    --    end
    --    self.layoutConfig.textLimit.text = string.format(LanguageUtils.LocalizeCommon("limit_x"),
    --            string.format("<color=#%s>%s/%s</color>", color, productConfig.stock - boughtCount, productConfig.stock))
    --end

    self:SetOldPrice()
end

function UIFlashSaleBaseLayout:SetOnBuyState()
    local boughtCount = self:GetBoughtCount()
    --- @type ProductConfig
    local productConfig = self.myGroup.listProductConfig:Get(1)
    local bought = boughtCount == productConfig.stock
    if productConfig.productID == nil then
        productConfig.productID = self:SetProductId(productConfig.opCode, productConfig.id, productConfig.dataId)
    end
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

function UIFlashSaleBaseLayout:SetProductId(opCode, id, dataId)
    return ClientConfigUtils.GetPurchaseKey(opCode, id, dataId)
end

function UIFlashSaleBaseLayout:SetRewardTableView(bought)
    if (self.rewardTableView) then
        self.rewardTableView:ActiveMaskSelect(bought)
    end
end

function UIFlashSaleBaseLayout:OnClickBuyButton()
    BuyUtils.InitListener(function()
        self:SetOnBuyState()
    end, function(logicCode)
        XDebug.Error("Error logic code " .. logicCode)
    end)
    --- @type ProductConfig
    local productConfig = self.myGroup.listProductConfig:Get(1)
    RxMgr.purchaseProduct:Next(productConfig.productID)
end

function UIFlashSaleBaseLayout:InitButtons()
    self.layoutConfig.buttonBuy.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBuyButton()
    end)
end

function UIFlashSaleBaseLayout:GetPrefabNameByGroupID()
    return "flash_sale_" .. tostring(self.groupID)
end

--- @return GroupProductConfig
function UIFlashSaleBaseLayout:GetMyFlashSaleGroup()
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

function UIFlashSaleBaseLayout:GetBoughtCount()
    --- @type IapDataInBound
    local iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    ---@type GroupProductConfig
    local groupProductConfig = self:GetMyFlashSaleGroup()
    local packID = groupProductConfig.listProductConfig:Get(1).id
    local boughtCount = iapDataInBound.progressPackData:GetBoughtCount(packID)
    return boughtCount
end

function UIFlashSaleBaseLayout:InitLayoutConfig()
    local prefabName = self:GetPrefabNameByGroupID()
    local inst = PrefabLoadUtils.Instantiate(prefabName, self.anchor)
    self.layoutConfig = UIBaseConfig(inst.transform)
    UIUtils.SetParent(inst.transform, self.anchor)
    inst:SetActive(true)
    self:GetMyFlashSaleGroup()
end

function UIFlashSaleBaseLayout:OnHide()
    self.anchor.gameObject:SetActive(false)
    if (self.rewardTableView) then
        self.rewardTableView:Hide()
    end
end

function UIFlashSaleBaseLayout:OnShow()
    self:SetUpLayout()
    self:SetReward()
    local hasBought = self:GetBoughtCount() > 0
    self:SetOnBuyState(hasBought)

    self:SetOldPrice()
end

function UIFlashSaleBaseLayout:SetUpLayout()
    self.anchor.gameObject:SetActive(true)
    self:SetTabSeen()
end

function UIFlashSaleBaseLayout:SetTabSeen()
    local remoteConfigData = zg.playerData.remoteConfig
    if remoteConfigData.isFlashSaleTabSeen == nil then
        remoteConfigData.isFlashSaleTabSeen = {}
    end
    remoteConfigData.isFlashSaleTabSeen["group_" .. self.groupID] = true
    self.view:UpdateNotificationByTab(self.groupID)
    zg.playerData:SaveRemoteConfig()
end

function UIFlashSaleBaseLayout:SetOldPrice()
    --- @type ProductConfig
    local productConfig = self.myGroup.listProductConfig:Get(1)
    if productConfig.originPricePackId ~= nil and productConfig.originPricePackId ~= "" then
        self.layoutConfig.textLimit.gameObject:SetActive(true)
        self.layoutConfig.textLimit.text = zg.iapMgr:GetLocalPrizeString(productConfig.originPricePackId)
    else
        self.layoutConfig.textLimit.gameObject:SetActive(false)
    end
end
