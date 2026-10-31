---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiSelectGuildLogo.UISelectGuildLogoConfig"

--- @class UISelectGuildLogoView : UIBaseView
UISelectGuildLogoView = Class(UISelectGuildLogoView, UIBaseView)

--- @return void
--- @param model UISelectGuildLogoModel
function UISelectGuildLogoView:Ctor(model)
	--- @type UISelectGuildLogoConfig
	self.config = nil
	--- @type function
	self.onSelectGuildLogo = nil
	--- @type UnityEngine_UI_LoopScrollRect
	self.scrollView = nil
	UIBaseView.Ctor(self, model)
	--- @type UISelectGuildLogoModel
	self.model = model
end

function UISelectGuildLogoView:OnReadyCreate()
	---@type UISelectGuildLogoConfig
	self.config = UIBaseConfig(self.uiTransform)
	self:InitButtonListener()
	self:InitScroll()
end

--- @return void
function UISelectGuildLogoView:InitLocalization()
	self.config.localizeTittle.text = LanguageUtils.LocalizeCommon("select_guild_logo")
	self.config.localizeSelect.text = LanguageUtils.LocalizeCommon("select")
	self.config.textTapToClose.gameObject:SetActive(false)
end

function UISelectGuildLogoView:InitButtonListener()
	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.bgClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.selectButton.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickSelect()
	end)
end

function UISelectGuildLogoView:InitScroll()
	--- @param obj GuildLogoSelectItem
	--- @param index number
	local onCreateItem = function(obj, index)
		local dataIndex = index + 1
		local sprite = ResourceLoadUtils.LoadGuildIcon(dataIndex)
		if sprite ~= nil then
			 obj:SetIcon(sprite)
		end
		obj:SetSelect(self.model.selectedLogoId == dataIndex)
		obj:AddOnSelectListener(function ()
			if dataIndex ~= self.model.selectedLogoId then
				self.model.selectedLogoId = dataIndex
				self.scrollView:Resize(self.model.numberOfGuildLogo)
			end
		end)
	end
	self.scrollView = UILoopScroll(self.config.scrollView, UIPoolType.GuildLogoSelectItem, onCreateItem)
end

--- @param data	{defaultGuildLogo : number, onSelectGuildLogo}
function UISelectGuildLogoView:OnReadyShow(data)
	self.model.selectedLogoId = data.defaultGuildLogo
	self.onSelectGuildLogo = data.onSelectGuildLogo

	self.scrollView:Resize(self.model.numberOfGuildLogo)
end

function UISelectGuildLogoView:OnClickSelect()
	if self.onSelectGuildLogo ~= nil then
		self.onSelectGuildLogo(self.model.selectedLogoId)
	end
	self:OnReadyHide()
end

function UISelectGuildLogoView:OnReadyHide()
	UIBaseView.OnReadyHide(self)
	self.scrollView:Hide()
end

