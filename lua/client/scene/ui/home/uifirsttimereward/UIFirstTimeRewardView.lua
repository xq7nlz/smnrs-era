--[[
--- @class UIFirstTimeRewardView : UIBaseView
UIFirstTimeRewardView = Class(UIFirstTimeRewardView, UIBaseView)

--- @return void
--- @param model UIFirstTimeRewardModel
function UIFirstTimeRewardView:Ctor(model)
	--- @type UIFirstTimeRewardConfig
	self.config = nil
	--- @type ItemsTableView
	self.itemsTable = nil

	UIBaseView.Ctor(self, model)
	--- @type UIFirstTimeRewardModel
	self.model = model
end

function UIFirstTimeRewardView:OnReadyCreate()
	---@type UIFirstTimeRewardConfig
	self.config = UIBaseConfig(self.uiTransform)
	self.itemsTable = ItemsTableView(self.config.rewardAnchor)
	self:InitButtonListener()
end

function UIFirstTimeRewardView:InitButtonListener()
	self.config.bgClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonGo.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickGoShop()
	end)
end

function UIFirstTimeRewardView:InitLocalization()
	self.config.textTapToClose.gameObject:SetActive(false)
	self.config.rewardDesc.text = LanguageUtils.LocalizeCommon("first_time_reward_desc")
	self.config.textGo.text = LanguageUtils.LocalizeCommon("go_to_shop")
end

function UIFirstTimeRewardView:OnClickGoShop()
	PopupMgr.ShowPopup(UIPopupName.UIIapShop, nil, UIPopupHideType.HIDE_ALL)
end

function UIFirstTimeRewardView:OnReadyShow()
	local listReward = ResourceMgr.GetPurchaseConfig():GetListFirstTimeReward()
	--- @type RewardInBound
	local fragmentHeroId = listReward:Get(1)
	local heroId = ClientConfigUtils.GetHeroIdByFragmentHeroId(fragmentHeroId.id)
	local faction = ClientConfigUtils.GetFactionIdByHeroId(heroId)
	self.config.textName.text = LanguageUtils.LocalizeNameHero(heroId)
	self.config.textDesc.text = LanguageUtils.LocalizeCommon("defronowe_nick_name")
	self.config.iconFaction.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconFactions, faction)

	local iconDataList = List()
	for i = 1, listReward:Count() do
		--- @type RewardInBound
		local resData = listReward:Get(i)
		iconDataList:Add(resData:GetIconData())
	end
	self.itemsTable:SetData(iconDataList, UIPoolType.RootIconView)
end

function UIFirstTimeRewardView:Hide()
	UIBaseView.Hide(self)
	self.itemsTable:Hide()
end
]]
