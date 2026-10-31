
--- @class UITreasureInfoView : UIBaseView
UITreasureInfoView = Class(UITreasureInfoView, UIBaseView)

--- @param model UITreasureInfoModel
function UITreasureInfoView:Ctor(model)
	--- @type UITreasureInfoConfig
	self.config = nil
	UIBaseView.Ctor(self, model)
	--- @type UITreasureInfoModel
	self.model = model
end

function UITreasureInfoView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)

	self:InitButtons()
end

function UITreasureInfoView:InitButtons()
	self.config.bgNone.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
end

function UITreasureInfoView:InitLocalization()
	self.config.textQuestName.text = LanguageUtils.LocalizeCommon("final_journey_reward")
end

--- @param data {callbackClose : function}
function UITreasureInfoView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
	---@type EventNewHeroTreasureModel
	self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_HERO_TREASURE)
	---@type EventNewHeroTreasureConfig
	self.eventConfig = self.eventModel:GetConfig()
	self.listItem = List()
	---@param v FinalTreasureRewardConfig
	for i, v in ipairs(self.eventConfig:GetDictRewardLineComplete():GetItems()) do
		---@type UITreasureItemInfoView
		local itemOwn = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.UITreasureItemInfoView, self.config.item)
		itemOwn:SetData(i, v.listReward, i <= self.eventModel.numberCompletedLine)
		self.listItem:Add(itemOwn)
	end
end

--- @return void
function UITreasureInfoView:Hide()
	UIBaseView.Hide(self)
	if self.listItem ~= nil then
		---@param v IconView
		for i, v in ipairs(self.listItem:GetItems()) do
			v:ReturnPool()
		end
		self.listItem = nil
	end
end