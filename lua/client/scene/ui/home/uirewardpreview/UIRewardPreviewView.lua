--- @class UIRewardPreviewView : UIBaseView
UIRewardPreviewView = Class(UIRewardPreviewView, UIBaseView)

--- @return void
--- @param model UIRewardPreviewModel
function UIRewardPreviewView:Ctor(model)
	---@type UIRewardPreviewConfig
	self.config = nil

	UIBaseView.Ctor(self, model, ctrl)
	--- @type UIRewardPreviewModel
	self.model = self.model

	--- @type List
	self.lstReward = List()
end

--- @return void
function UIRewardPreviewView:OnReadyCreate()
	---@type UIRewardPreviewConfig
	self.config = UIBaseConfig(self.uiTransform)

	self.config.closeBtn.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
end

function UIRewardPreviewView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("preview_reward")
	self.config.textReward.text = LanguageUtils.LocalizeCommon("reward")
end

--- @return void
function UIRewardPreviewView:Init(data)
	local current = data.current
	local max = data.max
	self.config.textInfo.text = string.format(LanguageUtils.LocalizeCommon("reward_info"), current, max)

	local rewards = data.rewardList
	for i = 1, rewards:Count() do
		---@type RootIconView
		local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.Layout)

		--- @type RewardInBound
		local res = rewards:Get(1)
		if res ~= nil then
			item:SetIconData(ItemIconData.CreateInstance(res.type, res.id, res.number))
			item:RegisterShowInfo()
		end

		self.lstReward:Add(item)
	end
end

--- @return void
--- @param data {callbackClose : function}
function UIRewardPreviewView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
	if data ~= nil then
		self:Init(data)
	end
end

--- @return void
function UIRewardPreviewView:Hide()
	UIBaseView.Hide(self)

	for i = 1, self.lstReward:Count() do
		self.lstReward:Get(i):ReturnPool()
	end
	self.lstReward = List()
end