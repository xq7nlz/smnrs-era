require "lua.client.scene.ui.home.uiIapShop.UILoopPackView"
require "lua.client.core.network.iap.GrowthPack.ClaimPassOutBound"

--- @class UIGrowthPackView : UILoopPackView
UIGrowthPackView = Class(UIGrowthPackView, UILoopPackView)

--- @param view UIIapShopView
--- @param root UnityEngine_UI_LoopScrollRect
--- @param id number
--- @param layout UIIapShopLevelPassLayout
function UIGrowthPackView:Ctor(view, layout, root, id)
    UILoopPackView.Ctor(self, root)
    self.opCode = OpCode.PURCHASE_GROWTH_PACK
    self.scrollName = "growth_pack_" .. id
    self.uiPoolType = UIPoolType.UIGrowthMilestoneItem
    self.id = id
    --- @type UIIapShopView
    self.view = view
    --- @type UIIapShopConfig
    self.config = view.config
    --- @type PopupGrowthView
    self.popupGrowthView = nil
    --- @type GrowthPackCollection
    self.growthPackCollection = nil
    --- @type GrowthPackLineConfig
    self.growthPackLineConfig = ResourceMgr.GetLevelPassConfig():GetGrowthPackConfigByLine(self.id)
    --- @type BasicInfoInBound
    self.basicInfoInbound = nil
    --- @type boolean
    self.isUnlocked = false
    --- @type boolean
    self.allowToBuy = false
    --- @type number
    self.minAvailableClaimIndex = nil
    --- @type UIIapShopLevelPassLayout
    self.layout = layout
    --- @type Dictionary
    self.milestoneItemDict = Dictionary()
    self:InitPack()
end

function UIGrowthPackView:InitPack()
    --- @param obj UIGrowthMilestoneItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type GrowthMilestoneConfig
        local growthMilestoneConfig = self.growthPackLineConfig:GetMilestoneConfigByIndex(dataIndex)
        local milestone = growthMilestoneConfig.number
        local notEnoughLevel = self.basicInfoInbound.level < milestone
        local isClaimedBasic, isClaimedPremium = self:GetMilestoneStateByNumber(milestone)

        obj:SetIconData(growthMilestoneConfig, notEnoughLevel)
        obj:SetButtonCallback(function(isBasic)
            self:OnClickClaimMilestone(isBasic, milestone)
        end)
        obj:SetBasicRewardState(notEnoughLevel, isClaimedBasic)
        obj:SetPremiumRewardState(notEnoughLevel, self.isUnlocked, isClaimedPremium)
        self.milestoneItemDict:Add(milestone, obj)
    end
    self.uiScroll = UILoopScroll(self.root, self.uiPoolType, onCreateItem)
end

function UIGrowthPackView:Show()
    self.basicInfoInbound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    self.growthPackCollection = zg.playerData:GetIAP().growthPackData
    self:ValidatePopupView()

    self.isUnlocked = self.growthPackCollection:GetBoughtCount(self.id) > 0
    self.allowToBuy = self.growthPackCollection:GetBoughtCount(self.id) == 0
    self.layout:SetBuyState(self.allowToBuy, self.isUnlocked)
    self.layout:EnableLockPremium(not self.isUnlocked)
    UILoopPackView.Show(self)
    self:CheckShowButtonClaimAll()
end

function UIGrowthPackView:Resize()
    self.milestoneItemDict:Clear()
    local offset = self:FindNearestAvailableClaim()
    offset = math.min(offset, self.growthPackLineConfig.listMilestone:Count() - 3)
    self.uiScroll:Resize(self.growthPackLineConfig.listMilestone:Count(), offset - 1)
end

function UIGrowthPackView:ValidatePopupView()
    --- @type PackOfProducts
    local packOfProducts = ResourceMgr.GetPurchaseConfig():GetCashShop():GetPack(OpCode.PURCHASE_GROWTH_PACK)
    --- @type ProductConfig
    self.productConfig = packOfProducts:GetPackBase(self.id)
    if self.productConfig == nil then
        return
    end
    self.layout:SetPrice(zg.iapMgr:GetLocalPrizeString(self.productConfig.productID))
    self.layout:AddOnClickBuyListener(function()
        if self.productConfig ~= nil then
            BuyUtils.InitListener(function()
                self.growthPackCollection:IncreaseBoughtPack(self.id)
                self:Show()
                self.view:CheckShowNotificationGrowthPack()
            end)
            TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "monthly_pack", self.packId)
            RxMgr.purchaseProduct:Next(self.productConfig.productID)
        end
    end)
    self.layout:AddOnClickClaimAllFree(function()
        self:OnClickClaimAll(true)
    end)
    self.layout:AddOnClickClaimAllPremium(function()
        self:OnClickClaimAll(false)
    end)
end

function UIGrowthPackView:OnClickPremiumLockMilestone()
    --- @type {title, content, listReward : List, textUnlock, price, onClickBuy}
    local data = {}
    data.title = string.format("%s %d", LanguageUtils.LocalizeCommon("level_pass"), self.id)
    data.content = LanguageUtils.LocalizeCommon("growth_pack_lock")
    data.textUnlock = LanguageUtils.LocalizeCommon("unlock_level_pass")
    data.listReward = List()
    data.listReward:Add(self.growthPackLineConfig:GetAllPremiumMilestone())
    local vipReward, _ = self.productConfig:GetReward()
    local vipInBound = RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.VIP_POINT, vipReward)
    data.listReward:Add(vipInBound)
    data.price = zg.iapMgr:GetLocalPrizeString(self.productConfig.productID)
    data.onClickBuy = function()
        BuyUtils.InitListener(function()
            self.growthPackCollection:IncreaseBoughtPack(self.id)
            PopupMgr.HidePopup(UIPopupName.UIUnlockPass)
            self:Show()
        end)
        RxMgr.purchaseProduct:Next(self.productConfig.productID)
    end
    PopupMgr.ShowPopup(UIPopupName.UIUnlockPass, data)
end

function UIGrowthPackView:OnClickClaimMilestone(isBasic, level)
    if self.basicInfoInbound.level < level then
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(string.format(LanguageUtils.LocalizeCommon("unlock_level"), level))
        return
    elseif isBasic == false and self.isUnlocked == false then
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        self:OnClickPremiumLockMilestone()
        return
    else
        local isClaimedBasic, isClaimedPremium = self:GetMilestoneStateByNumber(level)
        if (isBasic and isClaimedBasic) or (not isBasic and isClaimedPremium) then
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reward_claimed"))
            return
        end
        local listMilestone = List()
        listMilestone:Add(level)
        self:RequestClaimListMilestone(self.id, isBasic, listMilestone)
    end
end

--- @param passId number
--- @param isBasic boolean
--- @param listMilestone List
function UIGrowthPackView:RequestClaimListMilestone(passId, isBasic, listMilestone)
    if listMilestone:Count() == 0 then
        return
    end
    local onSuccess = function()
        self.growthPackCollection:OnSuccessClaimListMilestone(passId, isBasic, listMilestone)
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
        self:CheckShowButtonClaimAll()
        self.view:CheckShowNotificationGrowthPack()

        local checkCompleted = self.growthPackLineConfig:IsClaimCompleted()
        if checkCompleted then
            local touch = TouchUtils.Spawn("UIGrowthPackView:RequestClaimListMilestone")
            Coroutine.start(function()
                coroutine.waitforseconds(1.5)
                SmartPoolUtils.ShowShortNotification(string.format(LanguageUtils.LocalizeCommon("completed_level_x"), passId))
                touch:Enable()
            end)
        end
    end
    ClaimPassOutBound.RequestClaimPass(OpCode.PURCHASE_GROWTH_PACK_MILESTONE_CLAIM,
            passId, isBasic, listMilestone, onSuccess)
end

--- @return boolean, boolean
function UIGrowthPackView:GetMilestoneStateByNumber(number)
    local growPatchLine = self.growthPackCollection:GetGrowPatchLine(self.id)
    if growPatchLine == nil then
        return false, false
    end
    local basic, premium = growPatchLine:GetMilestoneState(number)
    return basic ~= nil and basic > 0, premium ~= nil and premium > 0
end

--- @return number
function UIGrowthPackView:FindNearestAvailableClaim()
    local claimableLevel, claimableIndex = self.growthPackLineConfig:GetClaimableMilestone(self.basicInfoInbound.level,
            self.isUnlocked,
            self.growthPackCollection:GetGrowPatchLine(self.id))
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

function UIGrowthPackView:CheckShowButtonClaimAll()
    local listClaimableFree = self:_GetAllClaimableMilestone(true)
    self.layout:SetActiveButtonClaimAll(true, listClaimableFree:Count() > 0)

    local listClaimablePremium = self:_GetAllClaimableMilestone(false, true)
    self.layout:SetActiveButtonClaimAll(false, listClaimablePremium:Count() > 0)
end

--- @param isBasic boolean
function UIGrowthPackView:OnClickClaimAll(isBasic)
    local requestClaim = function()
        local listClaimableMilestone = self:_GetAllClaimableMilestone(isBasic)
        self:RequestClaimListMilestone(self.id, isBasic, listClaimableMilestone)
    end
    if isBasic then
        requestClaim()
    else
        if self.isUnlocked == false then
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            self:OnClickPremiumLockMilestone()
        else
            requestClaim()
        end
    end
end

--- @return List
function UIGrowthPackView:_GetAllClaimableMilestone(isBasic, countLocked)
    countLocked = countLocked or false
    local listClaimableMilestone = List()
    local currentNumber = self.basicInfoInbound.level
    for i = 1, self.growthPackLineConfig.listMilestone:Count() do
        --- @type GrowthMilestoneConfig
        local growthMilestoneConfig = self.growthPackLineConfig.listMilestone:Get(i)
        local milestone = growthMilestoneConfig.number
        local isClaimedBasic, isClaimedPremium = self:GetMilestoneStateByNumber(milestone)
        if currentNumber >= milestone
                and ((isBasic and not isClaimedBasic)
                or (not isBasic and not isClaimedPremium and (self.isUnlocked or countLocked))) then
            listClaimableMilestone:Add(milestone)
        end
    end
    return listClaimableMilestone
end