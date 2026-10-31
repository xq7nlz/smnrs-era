--- @class UIChooseRewardChestArenaView : UIBaseView
UIChooseRewardChestArenaView = Class(UIChooseRewardChestArenaView, UIBaseView)

--- @param model UIChooseRewardChestArenaModel
function UIChooseRewardChestArenaView:Ctor(model)
	--- @type UIChooseRewardChestArenaConfig
	self.config = nil
	UIBaseView.Ctor(self, model)
	--- @type UIChooseRewardChestArenaModel
	self.model = model
	--- @type List
	self.ListChooseItem = List()
	self.totalValue = 0
end

function UIChooseRewardChestArenaView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)
	self:InitScroll()
	self:InitButtons()
end

function UIChooseRewardChestArenaView:InitButtons()
	self.config.backToClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.closeButton.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.claimButton.onClick:AddListener(function ()
		self:OnClickUse()
	end)
end

function UIChooseRewardChestArenaView:InitLocalization()
	self.config.claimText.text = LanguageUtils.LocalizeCommon("claim")
	self.config.decs.text = LanguageUtils.LocalizeCommon("choose_arena_chest_reward")
	self.config.tapToCloseText.text = LanguageUtils.LocalizeCommon("tap_to_close")
end

function UIChooseRewardChestArenaView:InitScroll()
	self.ListChooseItem = List()

	--- @param obj ArenaChestItemView
	local onCreateItem = function(obj, index)
		obj:SetData(self.listReward:Get(index + 1),self.chestNumber)
		obj:SetInputData(self.chestNumber)
		self.totalValue= 0
		obj.reward.coefficient = 0
		obj.reward.total = 0
		obj.input.onAdd = function(value)
			obj.reward.coefficient = tonumber(obj.input.config.inputNumber.text)
			obj.reward.total = obj.reward.quantity * obj.reward.coefficient
			obj.iconView:SetIconData(ItemIconData.CreateInstance(obj.reward.type, obj.reward.itemId,obj.reward.total))
			self.totalValue = self.totalValue + value
			self:UpdateLocalizeChooseNumber()
			for i = 1, self.ListChooseItem:Count() do
				self.ListChooseItem:Get(i):SetInputData(self.chestNumber - self.totalValue)
			end
		end
		obj.input.onSub = function(value)
			obj.reward.coefficient = tonumber(obj.input.config.inputNumber.text)
			obj.reward.total = obj.reward.quantity * obj.reward.coefficient
			obj.iconView:SetIconData(ItemIconData.CreateInstance(obj.reward.type, obj.reward.itemId,obj.reward.total))
			self.totalValue = self.totalValue - value
			self:UpdateLocalizeChooseNumber()
			for i = 1, self.ListChooseItem:Count() do
				self.ListChooseItem:Get(i):SetInputData(self.chestNumber - self.totalValue)
			end
		end
		obj.input.onChangeInput = function(value)
			obj.reward.coefficient = tonumber(obj.input.config.inputNumber.text)
			obj.reward.total = obj.reward.quantity * obj.reward.coefficient
			obj.iconView:SetIconData(ItemIconData.CreateInstance(obj.reward.type, obj.reward.itemId,obj.reward.total))
			if value > 0 then
				self.totalValue = self.totalValue + value
			else
				self.totalValue = self.totalValue - value
			end
			self:UpdateLocalizeChooseNumber()
			for i = 1, self.ListChooseItem:Count() do
				self.ListChooseItem:Get(i):SetInputData(self.chestNumber - self.totalValue)
			end
		end
		self.ListChooseItem:Add(obj)
	end
	--- @param obj ArenaChestItemView
	local onUpdateItem = function(obj, index)
		obj:SetData(self.listReward:Get(index + 1))
	end
	---@type UILoopScroll
	self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.ArenaChestItemView, onCreateItem,onUpdateItem)
end


function UIChooseRewardChestArenaView:UpdateLocalizeChooseNumber()
	self.config.numberChoose.text =
	LanguageUtils.LocalizeCommon("selected_item")
			.. " " ..  UIUtils.SetColorString(UIUtils.green_light, self.totalValue .."/".. self.chestNumber)
end
--- @param data {callbackClose : function}
function UIChooseRewardChestArenaView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
	self.chestNumber = data.chestNumber
	self:UpdateLocalizeChooseNumber()
	--- @type List
	self.listReward = data.listReward
	self.onClaimClick = data.onClaimClick
	self.uiScroll:Resize(self.listReward:Count())
end

function UIChooseRewardChestArenaView:Hide()
	UIBaseView.Hide(self)
	if self.uiScroll ~= nil then
		self.uiScroll:Hide()
	end
end


function UIChooseRewardChestArenaView:OnClickUse()
	zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
	--- @type Dictionary
	local rewardDict = Dictionary()
	for i = 1, self.ListChooseItem:Count() do
		--- @type ArenaChestItemView
		local chestItem = self.ListChooseItem:Get(i)
		if chestItem.reward.coefficient > 0 then
			rewardDict:Add(chestItem.reward.selectionId,chestItem.reward.coefficient)
		end
	end
	self.onClaimClick(rewardDict)
end