
--- @class UILanguageSettingView : UIBaseView
UILanguageSettingView = Class(UILanguageSettingView, UIBaseView)

--- @return void
--- @param model UILanguageSettingModel
function UILanguageSettingView:Ctor(model)
	---@type UILanguageSettingConfig
	self.config = nil
	--- @type UILoopScroll
	self.uiScroll = nil
	---@type List
	self.languageItemList = List()

	UIBaseView.Ctor(self, model)
	--- @type UILanguageSettingModel
	self.model = model
end

--- @return void
function UILanguageSettingView:OnReadyCreate()
	--- @type List
	self.languageList = LanguageUtils.GetLanguageList()

	---@type UILanguageSettingConfig
	self.config = UIBaseConfig(self.uiTransform)

	self:InitButtonListener()

	self:InitScroll()
end

function UILanguageSettingView:InitButtonListener()
	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.backGround.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
end

--- @return void
function UILanguageSettingView:InitLocalization()
	self.config.titleLanguage.text = LanguageUtils.LocalizeCommon("language")
	self.config.localizeSelectLanguage.text = LanguageUtils.LocalizeCommon("please_select_language")
end

function UILanguageSettingView:InitScroll()
	if self.config.loopScrollRect == nil then
		return
	end

	--- @param obj SelectLanguageItemView
	--- @param index number
	local onCreateItem = function(obj, index)
		local dataIndex = index + 1
		--- @type Language
		local language = self.languageList:Get(dataIndex)
		obj:SetData(language)
		obj:AddListener(function (language)
			self:OnSelectLanguage(language)
		end)
	end
	self.uiScroll = UILoopScroll(self.config.loopScrollRect, UIPoolType.SelectLanguageItemView, onCreateItem)
	self.uiScroll:SetUpMotion(MotionConfig())
	self.config.loopScrollRect.enabled = self.languageList:Count() > 6
end

--- @return void
function UILanguageSettingView:OnReadyShow(result)
	self.callbackChangeLanguage = nil
	if result ~= nil then
		self.callbackChangeLanguage = result.callbackChangeLanguage
	end
	if self.uiScroll then
		self.uiScroll:Resize(self.languageList:Count())
	else
		self:OldOnReadyShow()
	end
end

function UILanguageSettingView:OldOnReadyShow()
	if self.languageItemList:Count() > 0 then
		return
	end

	---@param v  Language
	for _, v in ipairs(LanguageUtils.GetLanguageList():GetItems()) do
		---@type SelectLanguageItemView
		local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.SelectLanguageItemView, self.config.content)
		item:SetData(v)
		item:AddListener(function (language)
			self:OnSelectLanguage(language)
		end)
		item:SetSelected(v.keyLanguage == PlayerSettingData.language)

		self.languageItemList:Add(item)
	end
end

--- @return void
---@param language Language
function UILanguageSettingView:OnSelectLanguage(language)
	if language.keyLanguage ~= PlayerSettingData.language then
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		PopupUtils.ShowPopupNotificationYesNo(string.format(LanguageUtils.LocalizeCommon("change_language"), language.name), nil, function ()
			PlayerSettingData.language = language.keyLanguage
			NetworkUtils.CheckRequestChangeLanguage()
			PlayerSetting.SaveData()
			zg.audioMgr:PlaySfxUi(SfxUiType.CONFIRM)
			zg.languageMgr:SwitchLanguage()

			if self.callbackChangeLanguage ~= nil then
				self.callbackChangeLanguage()
			end

			RxMgr.changeLanguage:Next(language)
		end)
	end
end