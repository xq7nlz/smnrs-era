require "lua.client.core.network.iap.GrowthPack.ClaimPassOutBound"

--- @class UIIapPassLayout : UIIapShopLayout
UIIapPassLayout = Class(UIIapPassLayout, UIIapShopLayout)

--- @param view UIIapShopView
--- @param parent UnityEngine_RectTransform
--- @param eventTimeType EventTimeType
function UIIapPassLayout:Ctor(view, parent, eventTimeType)
    self.eventTimeType = eventTimeType
    --- @type UIIapPassLayoutConfig
    self.layoutConfig = nil
    --- @type EventArenaPassModel
    self.eventPassModel = nil
    --- @type GrowthPackLineConfig
    self.growthPackLineConfig = nil
    self.updateTime = nil
    --- @type ProductConfig
    self.productConfig = nil
    self.prefabName = "arena_pass_view"
    self.titleKey = "arena_pass"
    self.unlockContentKey = "arena_pass_unlock_content"
    --- @type OpCode
    self.opCodeClaim = OpCode.EVENT_ARENA_PASS_MILESTONE_CLAIM
    --- @type Dictionary
    self.milestoneItemDict = Dictionary()
    UIIapShopLayout.Ctor(self, view, parent)
end

--- @param parent UnityEngine_RectTransform
function UIIapPassLayout:InitLayoutConfig(parent)
    local inst = PrefabLoadUtils.Instantiate(self.prefabName, parent)
    self.layoutConfig = UIBaseConfig(inst.transform)
    UIUtils.SetParent(inst.transform, parent)
    inst:SetActive(true)

    self:InitUpdateTime()
    self:InitPack()

    self:InitLocalization()
    self:InitButtonListener()
end

function UIIapPassLayout:InitLocalization()
    self.layoutConfig.textFreeReward.text = LanguageUtils.LocalizeCommon("free_reward")
    self.layoutConfig.textPremiumReward.text = LanguageUtils.LocalizeCommon("premium_reward")
    self.layoutConfig.textActive.text = LanguageUtils.LocalizeCommon("activated")
    self.layoutConfig.textUnlock.text = LanguageUtils.LocalizeCommon("purchase_items")
    self.layoutConfig.textDesc.text = LanguageUtils.LocalizeCommon("arena_pass_desc")
    self.layoutConfig.tittle.text = LanguageUtils.LocalizeCommon(self.titleKey)

    self.layoutConfig.textClaimAllFree.text = LanguageUtils.LocalizeCommon("claim_all")
    self.layoutConfig.textClaimAllPremium.text = LanguageUtils.LocalizeCommon("claim_all")
end

function UIIapPassLayout:InitButtonListener()
    self.layoutConfig.buttonUnlock.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickPurchase()
    end)
    self.layoutConfig.buttonClaimFree.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickClaimAll(true)
    end)
    self.layoutConfig.buttonClaimPremium.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickClaimAll(false)
    end)
end

function UIIapPassLayout:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
            if self.timeRefresh <= 0 then
                self:OnTimeEnd()
                return
            end
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        if self.timeRefresh > 0 then
            self.layoutConfig.textTimer.text = TimeUtils.GetDeltaTime(self.timeRefresh)
        else
            self:OnTimeEnd()
        end
    end
end

function UIIapPassLayout:InitPack()
    --- @param obj UIIapArenaPassMilestone
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type GrowthMilestoneConfig
        local growthMilestoneConfig = self.growthPackLineConfig:GetMilestoneConfigByIndex(dataIndex)
        local notEnoughMilestone = self.eventPassModel:
        IsValidMilestone(growthMilestoneConfig.number, false) == false
        local isClaimedBasic, isClaimedPremium = self:GetMilestoneStateByNumber(growthMilestoneConfig.number)
        obj:SetIconData(growthMilestoneConfig, notEnoughMilestone)
        obj:SetButtonCallback(function(isBasic)
            self:OnClickClaimMilestone(isBasic, growthMilestoneConfig.number)
        end)
        obj:SetBasicRewardState(notEnoughMilestone, isClaimedBasic)
        obj:SetPremiumRewardState(notEnoughMilestone, self.isUnlocked, isClaimedPremium)
        obj:EnableBgProgress(true, dataIndex > 1)
        obj:EnableBgProgress(false, dataIndex < self.growthPackLineConfig.milestoneDict:Count())
        obj:EnableActiveProgress(true, notEnoughMilestone == false)
        obj:EnableActiveProgress(false, notEnoughMilestone == false)

        self.milestoneItemDict:Add(growthMilestoneConfig.number, obj)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.growthPatchLine, UIPoolType.UIIapArenaPassMilestone, onCreateItem)
end

function UIIapPassLayout:OnShow(iapShopTab)
    UIIapShopLayout.OnShow(self, iapShopTab)
    self.eventPassModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    self:CheckResourceOnSeason()
    self:GetGrowthPackLineConfig()
    self:GetProductConfig()
    self:ShowUnlockState()
    self:ShowClaimAllState()
    self:ShowCurrentNumber()
    self:Resize()
    self:StartTime()
end

function UIIapPassLayout:CheckResourceOnSeason()
    local endTime = self.eventPassModel.timeData.endTime
    local savedEndSeason = zg.playerData.remoteConfig.eventArenaPassEnd or endTime
    if savedEndSeason ~= endTime then
        self:ClearMoneyType()
    end
    zg.playerData.remoteConfig.eventArenaPassEnd = endTime
    zg.playerData:SaveRemoteConfig()
end

function UIIapPassLayout:ClearMoneyType()
    local current = InventoryUtils.Get(ResourceType.Money, MoneyType.EVENT_ARENA_PASS_POINT)
    InventoryUtils.Sub(ResourceType.Money, MoneyType.EVENT_ARENA_PASS_POINT, current)
end

function UIIapPassLayout:GetGrowthPackLineConfig()
    self.growthPackLineConfig = ResourceMgr.GetEventArenaPassConfig():GetConfig(self.eventPassModel.timeData.dataId)
end

function UIIapPassLayout:GetProductConfig()
    local packOfProducts = self.eventPassModel:GetConfig()
    --- @type ProductConfig
    self.productConfig = packOfProducts:GetAllPackBase():Get(1)
    self.packId = self.productConfig.id
    self.packKey = ClientConfigUtils.GetPurchaseKey(self.productConfig.opCode, self.packId, self.productConfig.dataId)
end

function UIIapPassLayout:ShowUnlockState()
    local boughtCount = self.eventPassModel:GetBoughtCount(self.packId)
    self.isUnlocked = boughtCount > 0
    self:SetBuyState(boughtCount == 0, self.isUnlocked)
    self.layoutConfig.iconLockPremium:SetActive(boughtCount == 0)
    if self.isUnlocked == false then
        self.layoutConfig.textPrice.text = zg.iapMgr:GetLocalPrizeString(self.packKey)
    end
end

function UIIapPassLayout:ShowClaimAllState()
    local listClaimableFree = self:_GetAllClaimableMilestone(true)
    self.layoutConfig.buttonClaimFree.gameObject:SetActive(listClaimableFree:Count() > 0)

    local listClaimablePremium = self:_GetAllClaimableMilestone(false, true)
    self.layoutConfig.buttonClaimPremium.gameObject:SetActive(listClaimablePremium:Count() > 0)
end

function UIIapPassLayout:SetUpLayout()
    UIIapShopLayout.SetUpLayout(self)
    self.layoutConfig.gameObject:SetActive(true)
end

function UIIapPassLayout:Resize()
    self.milestoneItemDict:Clear()
    local offset = self:FindNearestAvailableClaim()
    offset = math.min(offset, self.growthPackLineConfig.listMilestone:Count() - 3)
    self.uiScroll:Resize(self.growthPackLineConfig.listMilestone:Count(), offset - 1)
end

function UIIapPassLayout:ShowCurrentNumber()
    self.layoutConfig.textCurrentNumber.text = tostring(self.eventPassModel:GetNumber())
end

function UIIapPassLayout:OnHide()
    self.layoutConfig.gameObject:SetActive(false)
    self.uiScroll:Hide()
    self:StopTime()
end

function UIIapPassLayout:SetTimeRefresh()
    self.timeRefresh = self.eventPassModel.timeData.endTime - zg.timeMgr:GetServerTime()
end

function UIIapPassLayout:StartTime()
    if self.updateTime ~= nil then
        zg.timeMgr:AddUpdateFunction(self.updateTime)
    end
end

function UIIapPassLayout:StopTime()
    if self.updateTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
    end
end

function UIIapPassLayout:OnTimeEnd()
    self:StopTime()
    self:ClearMoneyType()
    EventInBound.ValidateEventModel(function()
        self.view:OnReadyShow()
    end, true, true, true)
end

function UIIapPassLayout:OnClickClaimMilestone(isBasic, number)
    if isBasic == false and self.isUnlocked == false then
        self:OnClickPurchase()
        return
    elseif self.eventPassModel:IsValidMilestone(number) == false then
        return
    else
        local isClaimedBasic, isClaimedPremium = self:GetMilestoneStateByNumber(number)
        if (isBasic and isClaimedBasic) or (not isBasic and isClaimedPremium) then
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reward_claimed"))
            return
        end
        local listMilestone = List()
        listMilestone:Add(number)
        self:RequestClaimListMilestone(isBasic, listMilestone)
    end
end

function UIIapPassLayout:UpdateCheckNotification()
    self.view:CheckNotificationArenaPass()
end

--- @return number
function UIIapPassLayout:FindNearestAvailableClaim()
    local claimableLevel, claimableIndex = self.growthPackLineConfig:GetClaimableMilestone(self.eventPassModel:GetNumber(),
            self.isUnlocked,
            self.eventPassModel.growPatchLine)
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

function UIIapPassLayout:SetBuyState(isAllowToBuy, isUnlocked)
    self.layoutConfig.buttonUnlock.gameObject:SetActive(isAllowToBuy and not isUnlocked)
    self.layoutConfig.buttonActive.gameObject:SetActive(isUnlocked)
end

function UIIapPassLayout:OnClickPurchase()
    --- @type {title, content, listReward : List, textUnlock, price, onClickBuy}
    local data = {}
    data.title = LanguageUtils.LocalizeCommon(self.titleKey)
    data.content = LanguageUtils.LocalizeCommon(self.unlockContentKey)
    data.textUnlock = LanguageUtils.LocalizeCommon("purchase_items")
    data.price = zg.iapMgr:GetLocalPrizeString(self.productConfig.productID)

    local vipReward, _ = self.productConfig:GetReward()
    local vipInBound = RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.VIP_POINT, vipReward)
    data.listReward = self.growthPackLineConfig:GetTotalClaimAblePremiumReward(vipInBound)

    data.onClickBuy = function()
        BuyUtils.InitListener(function()
            PopupMgr.HidePopup(UIPopupName.UIUnlockPass)
            self:OnPurchaseSuccess()
        end)
        TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, self.titleKey, self.packId)
        RxMgr.purchaseProduct:Next(self.productConfig.productID)
    end
    PopupMgr.ShowPopup(UIPopupName.UIUnlockPass, data)
end

--- @return boolean, boolean
function UIIapPassLayout:GetMilestoneStateByNumber(number)
    if self.eventPassModel.growPatchLine == nil then
        return false, false
    end
    local basic, premium = self.eventPassModel.growPatchLine:GetMilestoneState(number)
    return basic ~= nil and basic > 0, premium ~= nil and premium > 0
end

function UIIapPassLayout:OnPurchaseSuccess()
    self.eventPassModel:IncreaseBoughtPack(self.packId)
    self:OnShow()
    self:UpdateCheckNotification()
end

function UIIapPassLayout:OnClickClaimAll(isBasic)
    local requestClaim = function()
        --- @type List
        local listClaimableMilestone = self:_GetAllClaimableMilestone(isBasic)
        self:RequestClaimListMilestone(isBasic, listClaimableMilestone)
    end
    if isBasic then
        requestClaim()
    else
        if self.isUnlocked == false then
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            self:OnClickPurchase()
        else
            requestClaim()
        end
    end
end

--- @return List
function UIIapPassLayout:_GetAllClaimableMilestone(isFree, countLocked)
    countLocked = countLocked or false
    local listClaimableMilestone = List()
    for i = 1, self.growthPackLineConfig.listMilestone:Count() do
        --- @type GrowthMilestoneConfig
        local growthMilestoneConfig = self.growthPackLineConfig.listMilestone:Get(i)
        local milestone = growthMilestoneConfig.number
        local isClaimedBasic, isClaimedPremium = self:GetMilestoneStateByNumber(milestone)
        if self.eventPassModel:IsValidMilestone(milestone, false)
                and ((isFree and not isClaimedBasic)
                or (not isFree and not isClaimedPremium and (self.isUnlocked or countLocked))) then
            listClaimableMilestone:Add(milestone)
        end
    end
    return listClaimableMilestone
end

--- @param listMilestone List
function UIIapPassLayout:RequestClaimListMilestone(isBasic, listMilestone)
    local onSuccess = function()
        self.eventPassModel:OnSuccessClaimListMilestone(isBasic, listMilestone)
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
    end
    ClaimPassOutBound.RequestClaimPass(self.opCodeClaim, nil, isBasic, listMilestone, onSuccess)
end