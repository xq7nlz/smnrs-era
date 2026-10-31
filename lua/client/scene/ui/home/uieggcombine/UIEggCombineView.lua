
--- @class UIEggCombineView : UIBaseView
UIEggCombineView = Class(UIEggCombineView, UIBaseView)

--- @param model UIEggCombineModel
function UIEggCombineView:Ctor(model)
	--- @type UIEggCombineConfig
	self.config = nil

	--- @type UIEggCombineItemConfig
	self.combine1 = nil
	--- @type UIEggCombineItemConfig
	self.combine2 = nil
	UIBaseView.Ctor(self, model)
	--- @type UIEggCombineModel
	self.model = model
end

function UIEggCombineView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)

	self:InitButtons()
end

function UIEggCombineView:InitButtons()
	self.config.bgNone.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
end

function UIEggCombineView:InitLocalization()
	self.config.textQuestName.text = LanguageUtils.LocalizeCommon("egg_combine")
end

--- @param data {callbackClose : function}
function UIEggCombineView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
	self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_EASTER_EGG)
	---@type EventEasterEggConfig
	self.eventConfig = self.eventModel:GetConfig()
	self.listItem = List()
	for i, v in ipairs(self.eventConfig:GetListExchangeConfig():GetItems()) do
		---@type UIEggCombineItemView
		local itemOwn = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.UIEggCombineItemView, self.config.item)
		itemOwn:SetData(v)
		self.listItem:Add(itemOwn)
	end
end

--- @return void
function UIEggCombineView:Hide()
	UIBaseView.Hide(self)
	if self.listItem ~= nil then
		---@param v IconView
		for i, v in ipairs(self.listItem:GetItems()) do
			v:ReturnPool()
		end
		self.listItem = nil
	end
end