--- @class UIPopupLinkingView : UIBaseView
UIPopupLinkingView = Class(UIPopupLinkingView, UIBaseView)

--- @return void
--- @param model UIPopupLinkingModel
function UIPopupLinkingView:Ctor(model, ctrl)
	--- @type UIPopupLinkingConfig
	self.config = nil

	-- init variables here
	UIBaseView.Ctor(self, model, ctrl)
	--- @type UIPopupLinkingModel
	self.model = model
end

--- @return void
function UIPopupLinkingView:OnReadyCreate()
	---@type UIPopupLinkingConfig
	self.config = UIBaseConfig(self.uiTransform)
	self.config.popup.localPosition = U_Vector3(10000, 10000, 0)
	self.config.bg.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
end

--- @return void
function UIPopupLinkingView:Init(result)
	if result ~= nil then
		self.config.icon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconLinking, result.id)
		self.config.textSkillType.text = LanguageUtils.LocalizeCommon("linking")
		self.config.name.text = LanguageUtils.LocalizeNameLinking(result.id)
		-----@param v BaseLinking
		--for i, v in pairs(ResourceMgr.GetServiceConfig():GetHeroes().heroLinkingEntries:GetItems()) do
		--	if v.id == result.id then
		--		self.config.textInfo.text = LanguageUtils.LocalizeListStatBonus(v.bonuses, ", ")
		--		break
		--	end
		--end

		if result.anchor == nil then
			self.config.popup.pivot = U_Vector2(0.5, 0.5)
		else
			self.config.popup.pivot = result.anchor
		end
		UIUtils.SetInteractableButton(self.config.bg, false)

		Coroutine.start(function ()
			self.config.contentSizeFitter.enabled = false
			coroutine.waitforendofframe()
			self.config.contentSizeFitter.enabled = true
			coroutine.waitforendofframe()
			self.config.contentSizeFitter.enabled = false
			coroutine.waitforendofframe()
			self.config.contentSizeFitter.enabled = true
			UIUtils.SetInteractableButton(self.config.bg, true)
			if result.position == nil then
				self.config.popup.localPosition = U_Vector3.zero
			else
				self.config.popup.position = result.position
			end
		end)
	end
end

--- @return void
function UIPopupLinkingView:OnReadyShow(result)
	self:Init(result)
end

--- @return void
function UIPopupLinkingView:Hide()
	UIBaseView.Hide(self)
	self.config.popup.localPosition = U_Vector3(10000, 10000, 0)
end