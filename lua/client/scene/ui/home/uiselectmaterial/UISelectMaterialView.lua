---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiSelectMaterial.UISelectMaterialConfig"

--- @class UISelectMaterialView : UIBaseView
UISelectMaterialView = Class(UISelectMaterialView, UIBaseView)

--- @return void
--- @param model UISelectMaterialModel
function UISelectMaterialView:Ctor(model)
	---@type UISelectMaterialConfig
	self.config = nil
	--- @type UILoopScroll
	self.uiScroll = nil
	--- @type function
	self.callbackSelect = nil

	-- init variables here
	UIBaseView.Ctor(self, model)
	--- @type UISelectMaterialModel
	self.model = model
end

--- @return void
function UISelectMaterialView:OnReadyCreate()
	---@type UISelectMaterialConfig
	self.config = UIBaseConfig(self.uiTransform)
	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.background.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonSelect.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickSelect()
	end)
end

--- @return void
function UISelectMaterialView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("material")
	self.config.localizeSelect.text = LanguageUtils.LocalizeCommon("select")
end


function UISelectMaterialView:OnReadyShow(result)
	self:Init(result)
end

--- @return void
function UISelectMaterialView:Init(result)
	self.callbackSelect = result.callbackSelect
	if result.createUIScroll ~= nil then
		self.uiScroll = result.createUIScroll(self.config.scroll)
	end
end

--- @return void
function UISelectMaterialView:Hide()
	UIBaseView.Hide(self)
	self.uiScroll:Hide()
end

--- @return void
function UISelectMaterialView:OnClickSelect()
	PopupMgr.HidePopup(UIPopupName.UISelectMaterial)
	if self.callbackSelect ~= nil then
		self.callbackSelect(self.listSelect)
	end
end