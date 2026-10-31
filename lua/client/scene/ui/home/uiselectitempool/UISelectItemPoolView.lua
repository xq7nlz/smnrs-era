
--- @class UISelectItemPoolView : UIBaseView
UISelectItemPoolView = Class(UISelectItemPoolView, UIBaseView)

--- @param model UISelectItemPoolModel
function UISelectItemPoolView:Ctor(model)
	--- @type UISelectItemPoolConfig
	self.config = nil
	--- @type UILoopScroll
	self.uiScroll = nil

	self.listItem = List()
	self.listItemSelect = List()
	self.listItemLock = List()
	self.minSelect = 1
	self.maxSelect = 1
	self.callbackSelect = nil

	UIBaseView.Ctor(self, model)
	--- @type UISelectItemPoolModel
	self.model = model
end

function UISelectItemPoolView:OnReadyCreate()
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
				if self.listItemSelect:IsContainValue(data) then
					self.listItemSelect:RemoveByReference(data)
					obj:ActiveMaskSelect(false)
				else
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
			end
		end)

	end
	self.uiScroll = UILoopScroll(self.config.scrollView, UIPoolType.RootIconView, onCreateItem, onCreateItem)
end

function UISelectItemPoolView:InitButtons()
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

function UISelectItemPoolView:InitLocalization()
	self.config.textItemPool.text = LanguageUtils.LocalizeCommon("select_item_pool")
	self.config.textSelect.text = LanguageUtils.LocalizeCommon("select")
end

--- @param data {callbackClose : function}
function UISelectItemPoolView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)

	if data ~= nil then
		self.listItem = data.listItem or List()
		self.listItemSelect = data.listItemSelect or List()
		self.listItemLock = data.listItemLock or List()
		self.maxSelect = data.maxSelect or 1
		self.minSelect = data.minSelect or 1
		self.callbackSelect = data.callbackSelect
		if data.textItemPool ~= nil then
			self.config.textItemPool.text = data.textItemPool
			else
			self.config.textItemPool.text =  LanguageUtils.LocalizeCommon("select_item_pool")
		end
	end
	self.uiScroll:Resize(self.listItem:Count())
end

function UISelectItemPoolView:Hide()
	UIBaseView.Hide(self)
	self.uiScroll:Hide()
end

function UISelectItemPoolView:OnClickSelect()
	if self.callbackSelect ~= nil then
		self.callbackSelect(self.listItemSelect)
	end
end