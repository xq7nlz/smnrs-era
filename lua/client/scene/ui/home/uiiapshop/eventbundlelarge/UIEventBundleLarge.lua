--- @class UIEventBundleLarge
UIEventBundleLarge = Class(UIEventBundleLarge)

local ITEM_INFO_SIZE = U_Vector2(165, 165)
local ITEM_SIZE = U_Vector2(105, 105)

--- @param transform UnityEngine_Transform
function UIEventBundleLarge:Ctor(transform)
    --- @type UIEventBundleLargeConfig
    self.config = UIBaseConfig(transform)
    --- @type IapDataInBound
    self.iapDataInBound = nil
    --- @type UILoopScroll
    self.uiLoopScroll = nil

    self:InitScroll()

    self:InitButtonListener()
end

--- @param productConfig ProductConfig
--- @param eventPopupModel EventPopupModel
function UIEventBundleLarge:SetProduct(productConfig, eventPopupModel,callbackOnPurchase)
    --- @type ProductConfig
    self.productConfig = productConfig
    ----- @type List
    --self.rewardList = productConfig:GetRewardList()

    self.vipValue, self.rewardList = productConfig:GetReward()

    --- @type EventPopupModel
    self.eventPopupModel = eventPopupModel

    --- @type function
    self.callbackOnPurchase = callbackOnPurchase
end

function UIEventBundleLarge:InitButtonListener()
    self.config.buttonBuy.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBuy()
    end)
end

function UIEventBundleLarge:InitScroll()
    --- @param obj ItemInfoView
    --- @param index number
    local onCreateItem = function(obj, index)
        local index = index + 1
        --- @type RewardInBound
        local reward = self.rewardList:Get(index)
        obj:SetIconData(reward:GetIconData(), ITEM_SIZE)
        obj:ActiveMaskSelect(not self:IsStockValid(), ITEM_SIZE)
        obj:SetSize(ITEM_INFO_SIZE.x, ITEM_INFO_SIZE.y)
    end
    self.uiLoopScroll = UILoopScroll(self.config.scroll, UIPoolType.ItemInfoView, onCreateItem)
end

function UIEventBundleLarge:OnShow()
    self:SetPrice()

    self:ShowReward()

    self:ShowTextLimit()
end

function UIEventBundleLarge:SetPrice()
    self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(self.productConfig.productID)
end

function UIEventBundleLarge:SetTittle(tittle)
    self.config.textTitle.text = tittle
end

function UIEventBundleLarge:ShowReward()
    self.uiLoopScroll:Resize(self.rewardList:Count())

    self.config.vip:SetActive(self.vipValue ~= nil and self.vipValue > 0)
    if self.vipValue ~= nil and self.vipValue > 0 then
        self.config.vipValue.text = "+" .. tostring(self.vipValue)
    end
end

function UIEventBundleLarge:OnHide()
    self.uiLoopScroll:Hide()
end

function UIEventBundleLarge:OnClickBuy()
    if self:IsStockValid() then
        BuyUtils.InitListener(function()
            self:OnShow()
            if self.callbackOnPurchase ~= nil then
                self.callbackOnPurchase()
            end
        end)
        RxMgr.purchaseProduct:Next(self.productConfig.productID)
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end
end

function UIEventBundleLarge:ShowTextLimit()
    local max = self.productConfig.stock
    local left = 0
    if self.eventPopupModel ~= nil then
        left = max - self.eventPopupModel:GetNumberBuyOpCode(self.productConfig.opCode, self.productConfig.id)
    end

    local color = UIUtils.green_dark
    if left == 0 then
        color = UIUtils.red_dark
    end
    self.config.localizeBuy.text = string.format(LanguageUtils.LocalizeCommon("limit_x"),
            UIUtils.SetColorString(color, string.format("(%s/%s)", left, max)))
end

function UIEventBundleLarge:IsStockValid()
    local max = self.productConfig.stock
    local left = 0
    if self.eventPopupModel ~= nil then
        left = max - self.eventPopupModel:GetNumberBuyOpCode(self.productConfig.opCode, self.productConfig.id)
    end
    return left > 0
end