
--- @class UISelectHeroPoolView : UIBaseView
UISelectHeroPoolView = Class(UISelectHeroPoolView, UIBaseView)

--- @param model UISelectItemPoolModel
function UISelectHeroPoolView:Ctor(model)
	--- @type UISelectHeroPoolConfig
	self.config = nil
	--- @type UILoopScroll
	self.uiScroll = nil

	self.listItem = List()
	self.listItemSelect = List()
	self.listItemCurrentSelect = List()
	self.listItemLock = List()
	self.minSelect = 1
	self.maxSelect = 1
	self.callbackSelect = nil

	UIBaseView.Ctor(self, model)
	--- @type UISelectHeroPoolModel
	self.model = model
end

function UISelectHeroPoolView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)

	self:InitButtons()

	-- Scroll view
	--- @param obj RootIconView
	--- @param index number
	local onCreateItem = function(obj, _index)
		local data = self.listItem:Get(_index + 1)
		obj:SetIconData(data)
		if self.listItemSelect:IsContainValue(data) then
			obj:ActiveMaskSelect(true, UIUtils.sizeItem)
		else
			obj:ActiveMaskSelect(false)

			if self.listItemLock:IsContainValue(data) then
				obj:ActiveMaskLock(true, UIUtils.sizeItem)
			else
				obj:ActiveMaskLock(false)
			end
		end

		obj:RemoveAllListeners()
		obj:AddListener(function ()
			if self.listItemLock:IsContainValue(data) == false then
				if self.maxSelect == 1 then
					self.listItemSelect:Clear()
					self.listItemSelect:Add(data)
					self.uiScroll:RefreshCells()
				else
					if self.listItemSelect:Count() < self.maxSelect then
						self.listItemSelect:Add(data)
						obj:ActiveMaskSelect(true, UIUtils.sizeItem)
					else
						SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("max_item_select"))
					end
				end
			end
		end)

	end
	self.uiScroll = UILoopScroll(self.config.scrollView, UIPoolType.RootIconView, onCreateItem, onCreateItem)
end

function UISelectHeroPoolView:InitButtons()
	self.config.bgClose.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonClose.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonSelect.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickSelect()
	end)
end

function UISelectHeroPoolView:InitLocalization()
	self.config.textItemPool.text = LanguageUtils.LocalizeCommon("select_hero_pool")
	self.config.textSelect.text = LanguageUtils.LocalizeCommon("select")
end

--- @param data {callbackClose : function}
function UISelectHeroPoolView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
	if data ~= nil then
		self.listItem = data.listItem or List()
		self.listItemSelect = data.listItemSelect or List()
		self.listItemSelect = TableUtils.Clone(self.listItemSelect)
		self.listItemLock = data.listItemLock or List()
		self.maxSelect = data.maxSelect or 1
		self.minSelect = data.minSelect or 1
		self.callbackSelect = data.callbackSelect
	end
	self.uiScroll:Resize(self.listItem:Count())
end

function UISelectHeroPoolView:Hide()
	UIBaseView.Hide(self)
	self.uiScroll:Hide()
end

function UISelectHeroPoolView:OnClickSelect()
	if self.callbackSelect ~= nil then
		self.callbackSelect(self.listItemSelect)
	end
end