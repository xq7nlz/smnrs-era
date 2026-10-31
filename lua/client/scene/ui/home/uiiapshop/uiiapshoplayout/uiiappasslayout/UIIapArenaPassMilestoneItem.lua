--- @class UIIapArenaPassMilestone : IconView
UIIapArenaPassMilestone = Class(UIIapArenaPassMilestone, IconView)

function UIIapArenaPassMilestone:Ctor()
    --- @type UIIapArenaPassMilestoneItemConfig
    self.config = nil
    --- @type ItemsTableView
    self.basicItemsTableView = nil
    --- @type ItemsTableView
    self.premiumItemsTableView = nil

    --- @type RootIconView
    self.premiumRewardIcon = nil
    --- @type function
    self.onClickClaim = nil

    IconView.Ctor(self)
end

function UIIapArenaPassMilestone:SetPrefabName()
    self.prefabName = 'arena_pass_milestone'
    self.uiPoolType = UIPoolType.UIIapArenaPassMilestone
end

--- @param transform UnityEngine_Transform
function UIIapArenaPassMilestone:SetConfig(transform)
    self.config = UIBaseConfig(transform)
    self.basicItemsTableView = ItemsTableView(self.config.basicAnchor)
    self.premiumItemsTableView = ItemsTableView(self.config.premiumAnchor)
    self:InitButtonListener()
end

function UIIapArenaPassMilestone:InitButtonListener()
    self.config.buttonClaimBasic.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickClaim(true)
    end)
    self.config.buttonClaimPremium.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickClaim(false)
    end)
end

--- @param data GrowthMilestoneConfig
--- @param notEnoughLevel boolean
function UIIapArenaPassMilestone:SetIconData(data, notEnoughLevel)
    self.config.dotOn:SetActive(notEnoughLevel == false)
    self.config.textMilestone.text = tostring(data.number)

    self.basicItemsTableView:SetData(RewardInBound.GetItemIconDataList(data.listBasicReward))
    self.premiumItemsTableView:SetData(RewardInBound.GetItemIconDataList(data.listPremiumReward))

    self.config.coverBasic:SetActive(notEnoughLevel)
    self.config.coverPremium:SetActive(notEnoughLevel)
end

function UIIapArenaPassMilestone:SetBasicRewardState(notEnoughLevel, isClaimed)
    self.config.coverBasic:SetActive(notEnoughLevel)
    self:ActiveEffectSelect(self.basicItemsTableView, false)
    if isClaimed then
        self:SetTextContent(self.config.textBasicState, LanguageUtils.LocalizeCommon("received"))
    elseif notEnoughLevel then
        self:SetTextContent(self.config.textBasicState, "")
    else
        self:SetTextContent(self.config.textBasicState, LanguageUtils.LocalizeCommon("tap_to_claim"))
        self:ActiveEffectSelect(self.basicItemsTableView, true)
    end
    self.basicItemsTableView:ActiveMaskSelect(isClaimed, UIUtils.sizeItem)
end

--- @param itemsTableView ItemsTableView
function UIIapArenaPassMilestone:ActiveEffectSelect(itemsTableView, isEnable)
    local listItems = itemsTableView:GetItems()
    --- @param iconView IconView
    for _, iconView in pairs(listItems:GetItems()) do
        iconView:ActiveEffectSelect(isEnable)
    end
end

--- @param itemsTableView ItemsTableView
function UIIapArenaPassMilestone:ActiveMaskLock(itemsTableView, isEnable)
    local listItems = itemsTableView:GetItems()
    --- @param iconView IconView
    for _, iconView in pairs(listItems:GetItems()) do
        iconView:ActiveMaskLockMini(isEnable, UIUtils.sizeItem)
    end
end

function UIIapArenaPassMilestone:SetPremiumRewardState(notEnoughLevel, isUnlockPremium, isClaimed)
    self.config.coverPremium:SetActive(notEnoughLevel)
    self:ActiveMaskLock(self.premiumItemsTableView, not isUnlockPremium)
    self:ActiveEffectSelect(self.premiumItemsTableView, false)
    if isClaimed then
        self:SetTextContent(self.config.textPremiumState, LanguageUtils.LocalizeCommon("received"))
    elseif notEnoughLevel then
        self:SetTextContent(self.config.textPremiumState, "")
    else
        self:SetTextContent(self.config.textPremiumState, LanguageUtils.LocalizeCommon("tap_to_claim"))
        self:ActiveEffectSelect(self.premiumItemsTableView, isUnlockPremium)
    end
    self.premiumItemsTableView:ActiveMaskSelect(isClaimed, UIUtils.sizeItem)
end

--- @param onClickClaim function
function UIIapArenaPassMilestone:SetButtonCallback(onClickClaim)
    self.onClickClaim = onClickClaim
end

function UIIapArenaPassMilestone:ReturnPool()
    IconView.ReturnPool(self)
    self:ReturnPoolRewardIcon()
end

function UIIapArenaPassMilestone:ReturnPoolRewardIcon()
    self.basicItemsTableView:Hide()
    self.premiumItemsTableView:Hide()
end

--- @param text UnityEngine_UI_Text
--- @param content string
function UIIapArenaPassMilestone:SetTextContent(text, content)
    text.gameObject.transform.parent.gameObject:SetActive(content ~= "")
    text.text = content
end

function UIIapArenaPassMilestone:EnableBgProgress(isLeft, isEnable)
    if isLeft then
        self.config.bgProgressLeft:SetActive(isEnable)
    else
        self.config.bgProgressRight:SetActive(isEnable)
    end
end

function UIIapArenaPassMilestone:EnableActiveProgress(isLeft, isEnable)
    if isLeft then
        self.config.activeProgressLeft:SetActive(isEnable)
    else
        self.config.activeProgressRight:SetActive(isEnable)
    end
end

--- @param isBasic boolean
function UIIapArenaPassMilestone:OnClickClaim(isBasic)
    if self.onClickClaim ~= nil then
        self.onClickClaim(isBasic)
    end
end

return UIIapArenaPassMilestone