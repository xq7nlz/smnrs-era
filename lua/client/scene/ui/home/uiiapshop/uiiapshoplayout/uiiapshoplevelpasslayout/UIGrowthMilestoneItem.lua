--- @class UIGrowthMilestoneItem : IconView
UIGrowthMilestoneItem = Class(UIGrowthMilestoneItem, IconView)

function UIGrowthMilestoneItem:Ctor()
    --- @type UIGrowthMilestoneItemConfig
    self.config = nil

    --- @type ItemsTableView
    self.basicItemsTableView = nil
    --- @type ItemsTableView
    self.premiumItemsTableView = nil

    --- @type function
    self.onClickBasic = nil
    --- @type function
    self.onClickPremium = nil
    --- @type function
    self.onClickClaim = nil

    IconView.Ctor(self)
end

function UIGrowthMilestoneItem:SetPrefabName()
    self.prefabName = 'growth_milestone'
    self.uiPoolType = UIPoolType.UIGrowthMilestoneItem
end

--- @param transform UnityEngine_Transform
function UIGrowthMilestoneItem:SetConfig(transform)
    ---@type UIGrowthMilestoneItemConfig
    self.config = UIBaseConfig(transform)
    self.basicItemsTableView = ItemsTableView(self.config.basicAnchor)
    self.premiumItemsTableView = ItemsTableView(self.config.premiumAnchor)
    self:InitButtonListener()
end

function UIGrowthMilestoneItem:InitButtonListener()
    self.config.buttonClaimBasic.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if self.onClickClaim ~= nil then
            self.onClickClaim(true)
        end
    end)
    self.config.buttonClaimPremium.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if self.onClickClaim ~= nil then
            self.onClickClaim(false)
        end
    end)
end

--- @param data GrowthMilestoneConfig
--- @param notEnoughLevel boolean
function UIGrowthMilestoneItem:SetIconData(data, notEnoughLevel)
    self.config.textLevel.text = tostring(data.number)

    self.basicItemsTableView:SetData(RewardInBound.GetItemIconDataList(data.listBasicReward))
    self.premiumItemsTableView:SetData(RewardInBound.GetItemIconDataList(data.listPremiumReward))

    self.config.coverBasic:SetActive(notEnoughLevel)
    self.config.coverPremium:SetActive(notEnoughLevel)
end

function UIGrowthMilestoneItem:SetBasicRewardState(notEnoughLevel, isClaimed)
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
function UIGrowthMilestoneItem:ActiveEffectSelect(itemsTableView, isEnable)
    local listItems = itemsTableView:GetItems()
    --- @param iconView IconView
    for _, iconView in pairs(listItems:GetItems()) do
        iconView:ActiveEffectSelect(isEnable)
    end
end

function UIGrowthMilestoneItem:SetPremiumRewardState(notEnoughLevel, isUnlockPremium, isClaimed)
    self.config.coverPremium:SetActive(notEnoughLevel)
    self.config.lockPremium:SetActive(not isUnlockPremium)
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
function UIGrowthMilestoneItem:SetButtonCallback(onClickClaim)
    self.onClickClaim = onClickClaim
end

function UIGrowthMilestoneItem:ReturnPool()
    IconView.ReturnPool(self)
    self:ReturnPoolRewardIcon()
end

function UIGrowthMilestoneItem:ReturnPoolRewardIcon()
    self.basicItemsTableView:Hide()
    self.premiumItemsTableView:Hide()
end

--- @param text UnityEngine_UI_Text
--- @param content string
function UIGrowthMilestoneItem:SetTextContent(text, content)
    text.gameObject.transform.parent.gameObject:SetActive(content ~= "")
    text.text = content
end

return UIGrowthMilestoneItem