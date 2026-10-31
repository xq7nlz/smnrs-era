--- @class UIIapTigerPathMilestoneItem : IconView
UIIapTigerPathMilestoneItem = Class(UIIapTigerPathMilestoneItem, IconView)

function UIIapTigerPathMilestoneItem:Ctor()
	--- @type UIIapTigerPathMilestoneItemConfig
	self.config = nil
	--- @type ItemsTableView
	self.basicItemsTableView = nil
	--- @type ItemsTableView
	self.premiumItemsTableView = nil

	--- @type RootIconView
	self.premiumRewardIcon = nil
	--- @type function
	self.OnClickRewardDesc = nil

	--- @type function
	self.onClickClaim = nil
	self.number = nil
	IconView.Ctor(self)
end

function UIIapTigerPathMilestoneItem:SetPrefabName()
	self.prefabName = 'tiger_path_milestone'
	self.uiPoolType = UIPoolType.UIIapTigerPathMilestoneItem
end

--- @param transform UnityEngine_Transform
function UIIapTigerPathMilestoneItem:SetConfig(transform)
	self.config = UIBaseConfig(transform)
	self.basicItemsTableView = ItemsTableView(self.config.basicAnchor)
	self.premiumItemsTableView = ItemsTableView(self.config.premiumAnchor)
	self:InitButtonListener()
end

function UIIapTigerPathMilestoneItem:InitButtonListener()
	self.config.buttonClaimBasic.onClick:RemoveAllListeners()
	self.config.buttonClaimPremium.onClick:RemoveAllListeners()
	self.config.buttonDot.onClick:RemoveAllListeners()
	self.config.buttonClaimBasic.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickClaim(true)
	end)
	self.config.buttonClaimPremium.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickClaim(false)
	end)
	self.config.buttonDot.onClick:AddListener(function()
		local lastActive = self.config.tigerPathDecsReward.gameObject.activeSelf
		self.OnClickRewardDesc()
		self:EnableRewardDesc(lastActive)
	end)
end

function UIIapTigerPathMilestoneItem:DescriptionReward()

end

--- @param data GrowthMilestoneConfig
--- @param notEnoughLevel boolean
function UIIapTigerPathMilestoneItem:SetIconData(data, notEnoughLevel)
	self.number = data.number
	self.config.dotOn:SetActive(notEnoughLevel == false)
	self.config.textMilestone.text = tostring(self.number)
	self.config.textBasicState.text = LanguageUtils.LocalizeCommon("basic")
	self.config.textPremiumState.text = LanguageUtils.LocalizeCommon("premium")
	self.basicItemsTableView:SetData(RewardInBound.GetItemIconDataList(data.listBasicReward))
	self.premiumItemsTableView:SetData(RewardInBound.GetItemIconDataList(data.listPremiumReward))
	self.config.point.text = tostring(self.number) .. " " .. LanguageUtils.LocalizeMoneyType(MoneyType.EVENT_LUNAR_2022_GROWTH_POINT)
	self.config.decs.text = LanguageUtils.LocalizeMoneyDescription(MoneyType.EVENT_LUNAR_2022_GROWTH_POINT)
	self.config.coverBasic:SetActive(notEnoughLevel)
	self.config.coverPremium:SetActive(notEnoughLevel)
end

function UIIapTigerPathMilestoneItem:SetBasicRewardState(notEnoughLevel, isClaimed)
	self.config.highLightCurrent.gameObject:SetActive(not isClaimed and not notEnoughLevel)
	self.config.coverBasic:SetActive(notEnoughLevel)
	self:ActiveEffectSelect(self.basicItemsTableView, false)
	if isClaimed then

	elseif not isClaimed and not notEnoughLevel then

		self:ActiveEffectSelect(self.basicItemsTableView, true)
	end
	self.basicItemsTableView:ActiveMaskSelect(isClaimed, UIUtils.sizeItem)
end

--- @param itemsTableView ItemsTableView
function UIIapTigerPathMilestoneItem:ActiveEffectSelect(itemsTableView, isEnable)
	local listItems = itemsTableView:GetItems()
	--- @param iconView IconView
	for _, iconView in pairs(listItems:GetItems()) do
		iconView:ActiveEffectSelect(isEnable)
	end
end

function UIIapTigerPathMilestoneItem:SetCurrent(isCurrent)
	self.config.highlightProgress.gameObject:SetActive(isCurrent)
end

--- @param itemsTableView ItemsTableView
function UIIapTigerPathMilestoneItem:ActiveMaskLock(itemsTableView, isEnable)
	local listItems = itemsTableView:GetItems()
	--- @param iconView IconView
	for _, iconView in pairs(listItems:GetItems()) do
		iconView:ActiveMaskLockMini(isEnable, UIUtils.sizeItem)
	end
end

function UIIapTigerPathMilestoneItem:SetPremiumRewardState(notEnoughLevel, isUnlockPremium, isClaimed)
	self.config.coverPremium:SetActive(notEnoughLevel)
	self:ActiveMaskLock(self.premiumItemsTableView, not isUnlockPremium)
	self:ActiveEffectSelect(self.premiumItemsTableView, false)
	if isClaimed then
	elseif notEnoughLevel then
	else
		self:ActiveEffectSelect(self.premiumItemsTableView, isUnlockPremium)
	end
	self.premiumItemsTableView:ActiveMaskSelect(isClaimed, UIUtils.sizeItem)
end

--- @param onClickClaim function
function UIIapTigerPathMilestoneItem:SetButtonCallback(onClickClaim)
	self.onClickClaim = onClickClaim
end

function UIIapTigerPathMilestoneItem:ReturnPool()
	IconView.ReturnPool(self)
	self:SetCurrent(false)
	self:DisableRewardDesc()
	self:ReturnPoolRewardIcon()
end

function UIIapTigerPathMilestoneItem:ReturnPoolRewardIcon()
	self.basicItemsTableView:Hide()
	self.premiumItemsTableView:Hide()
end

--- @param text UnityEngine_UI_Text
--- @param content string
function UIIapTigerPathMilestoneItem:SetTextContent(text, content)
	text.gameObject.transform.parent.gameObject:SetActive(content ~= "")
	text.text = content
end

function UIIapTigerPathMilestoneItem:EnableBgProgress(isLeft, isEnable)
	if isLeft then
		self.config.bgProgressLeft:SetActive(isEnable)
	else
		self.config.bgProgressRight:SetActive(isEnable)
	end
end

function UIIapTigerPathMilestoneItem:EnableActiveProgress(isLeft, isEnable)
	if isLeft then
		self.config.activeProgressLeft:SetActive(isEnable)
	else
		print(self.number .. " : " .. tostring(isEnable))
		self.config.activeProgressRight:SetActive(isEnable)
	end
end

--- @param isBasic boolean
function UIIapTigerPathMilestoneItem:OnClickClaim(isBasic)
	if self.onClickClaim ~= nil then
		self.onClickClaim(isBasic)
	end
end

function UIIapTigerPathMilestoneItem:EnableRewardDesc(lastActive)
	if lastActive ~= nil then
		self.config.tigerPathDecsReward.gameObject:SetActive(not lastActive)
	end
end

function UIIapTigerPathMilestoneItem:RegisterRewardDescButton(OnClickRewardDesc)
	self.OnClickRewardDesc = OnClickRewardDesc
end

function UIIapTigerPathMilestoneItem:DisableRewardDesc()
	self.config.tigerPathDecsReward.gameObject:SetActive(false)
end

return UIIapTigerPathMilestoneItem