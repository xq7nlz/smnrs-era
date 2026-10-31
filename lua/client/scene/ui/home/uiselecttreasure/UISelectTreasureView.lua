
--- @class UISelectTreasureView : UIBaseView
UISelectTreasureView = Class(UISelectTreasureView, UIBaseView)

--- @param model UISelectTreasureModel
function UISelectTreasureView:Ctor(model)
	--- @type UISelectTreasureConfig
	self.config = nil
	UIBaseView.Ctor(self, model)
	--- @type UISelectTreasureModel
	self.model = model
end

function UISelectTreasureView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)
	self.itemsTable = ItemsTableView(self.config.item)
	self:InitButtons()
end

function UISelectTreasureView:InitButtons()
	self.config.button2.onClick:AddListener(function ()
		self:OnClickMove()
	end)
	self.config.background.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
end

function UISelectTreasureView:InitLocalization()
	self.config.textButton2.text =  LanguageUtils.LocalizeCommon("move")
	self.config.textTitle.text =  LanguageUtils.LocalizeCommon("reward")
end

--- @param data {callbackClose : function}
function UISelectTreasureView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
	self.rewardList = data.rewardList
	self.callbackMove = data.callbackMove
	self.price = data.price

	---@type List
	local listIconData = List()
	---@param v RewardInBound
	for i, v in ipairs(self.rewardList:GetItems()) do
		local iconData = v:GetIconData()
		listIconData:Add(iconData)
	end
	self.itemsTable:SetData(listIconData, UIPoolType.RootIconView)
	self.config.textPrice.text = tostring(self.price)
end

function UISelectTreasureView:Hide()
	UIBaseView.Hide(self)
	if self.itemsTable ~= nil then
		self.itemsTable:Hide()
	end
end

function UISelectTreasureView:OnClickMove()
	if self.callbackMove ~= nil then
		self.callbackMove()
	end
end
