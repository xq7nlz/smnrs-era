--- @class UIPopupPackOfItemsView : UIBaseView
UIPopupPackOfItemsView = Class(UIPopupPackOfItemsView, UIBaseView)

--- @return void
--- @param model UIPopupPackOfItemsModel
function UIPopupPackOfItemsView:Ctor(model, ctrl)
	--- @type UIPopupPackOfItemsConfig
	self.config = nil
	--- @type UILoopScroll
	self.uiScroll = nil
	--- @type function
	self.onActionCallback = nil

	--- @type List
	self.listItemData = nil

	UIBaseView.Ctor(self, model, ctrl)
	--- @type UIPopupPackOfItemsModel
	self.model = model
end

function UIPopupPackOfItemsView:OnReadyCreate()
	---@type UIPopupPackOfItemsConfig
	self.config = UIBaseConfig(self.uiTransform)

	self:_InitButtonListener()
    self:_InitScroll()
end

function UIPopupPackOfItemsView:InitLocalization()
	self.config.textTapToClose.gameObject:SetActive(false)
end

function UIPopupPackOfItemsView:_InitScroll()
	--- @param obj RootIconView
	--- @param index number
	local onCreateItem = function(obj, index)
		local dataIndex = index + 1
		--- @type ItemIconData
		local itemIconData = self.listItemData:Get(dataIndex)
		obj:SetIconData(itemIconData)
		obj:RegisterShowInfo()
	end

	--- @param obj ItemInfoView
	--- @param index number
	local onUpdateItem = function(obj, index)
		onCreateItem(obj, index)
	end

	self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.RootIconView, onCreateItem, onUpdateItem)
end

function UIPopupPackOfItemsView:_InitButtonListener()
	self.config.bgClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonAction.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		if self.onActionCallback ~= nil then
			self.onActionCallback()
		end
	end)
end

--- @param data --- @type {listItemData, iconChest, chestName, chestInfo, onActionCallback}
function UIPopupPackOfItemsView:OnReadyShow(data)
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)

	self.listItemData = data.listItemData

    self.onActionCallback = data.onActionCallback

	self.config.iconPack.sprite = data.iconChest
	self.config.iconPack:SetNativeSize()

	self.uiScroll:Resize(self.listItemData:Count())

	self.config.packName.text = data.chestName
	self.config.packDesc.text = data.chestInfo
end

function UIPopupPackOfItemsView:Hide()
    UIBaseView.Hide(self)
    self.uiScroll:Hide()
end
