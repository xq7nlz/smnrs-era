---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiUserProfile.UIUserProfileConfig"

--- @class UIUserProfileView : UIBaseView
UIUserProfileView = Class(UIUserProfileView, UIBaseView)

--- @return void
--- @param model UIUserProfileModel
function UIUserProfileView:Ctor(model, ctrl)
	---@type UIUserProfileConfig
	self.config = nil
	---@type VipIconView
	self.iconVip = nil

	-- init variables here
	UIBaseView.Ctor(self, model)
	--- @type UIUserProfileModel
	self.model = model
end

--- @return void
function UIUserProfileView:OnReadyCreate()
	---@type UIUserProfileConfig
	self.config = UIBaseConfig(self.uiTransform)

	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.bgClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonChangeFrameAvatar.onClick:AddListener(function ()
		self:OnClickChangeAvatar()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
	end)
	self.config.nameEditButton.onClick:AddListener(function ()
		self:OnClickRename()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
	end)
	self.config.buttonCoppy.onClick:AddListener(function ()
		UIUtils.CopyToClipboard(PlayerSettingData.playerId)
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
	end)
end

--- @return void
function UIUserProfileView:InitLocalization()
--[[	self.config.localizeExp.text = LanguageUtils.LocalizeCommon("exp")]]
	self.config.localizeChangeAvatar.text = LanguageUtils.LocalizeCommon("change_avatar")
	self.config.localizeVip.text = LanguageUtils.LocalizeCommon("vip")
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("user_profile")
end

--- @return void
function UIUserProfileView:OnReadyShow()
	self:ShowAvatar()
	self.config.textUserName.text = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).name
	self.config.textUserLevel.text = string.format("Lv.%s", zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).level)
	self.config.textId.text = UIUtils.SetColorString(UIUtils.brown, LanguageUtils.LocalizeCommon("id") .. ": ") .. PlayerSettingData.playerId

	-- EXP
--[[	if zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).level < ResourceMgr.GetMainCharacterConfig().mainCharacterExpDictionary:Count() then
		---@type MainCharacterExpConfig
		local mainCharacterExp = ResourceMgr.GetMainCharacterConfig().mainCharacterExpDictionary:Get(zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).level + 1)
		local exp = InventoryUtils.Get(ResourceType.SummonerExp, 0)
		self.config.textExpValue.text = string.format("%d/%d", exp, mainCharacterExp.exp)
		self.config.bgQuestProgressBar1.fillAmount = math.min(exp / mainCharacterExp.exp, 1)
	else
		self.config.textExpValue.text = LanguageUtils.LocalizeCommon("max")
		self.config.bgQuestProgressBar1.fillAmount = 1
	end]]

	self:InitListener()
end

--- @return void
function UIUserProfileView:InitListener()
	self.listenerRename = RxMgr.finishName:Subscribe(RxMgr.CreateFunction(self, self.CheckRename))

	self.listenerChangeAvatar = RxMgr.changeAvatar:Subscribe(RxMgr.CreateFunction(self, self.ShowAvatar))
end

--- @return void
function UIUserProfileView:RemoveListener()
	if self.listenerRename then
		self.listenerRename:Unsubscribe()
		self.listenerRename = nil
	end
	if self.listenerChangeAvatar then
		self.listenerChangeAvatar:Unsubscribe()
		self.listenerChangeAvatar = nil
	end
end

function UIUserProfileView:ShowAvatar()
	if self.iconVip == nil then
		self.iconVip = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipIconView, self.config.iconUser)
	end
	--- @type BasicInfoInBound
	basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
	self.iconVip:SetData(basicInfoInBound.avatarData:GetAvatar(), basicInfoInBound.level, basicInfoInBound.avatarData:GetFrame())
end

--- @return void
function UIUserProfileView:CheckRename()
	self.config.textUserName.text = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).name
end

--- @return void
function UIUserProfileView:OnClickRename()
	PopupMgr.ShowPopup(UIPopupName.UIRename)
end

--- @return void
function UIUserProfileView:OnClickChangeAvatar()
	--- @type ItemCollectionInBound
	local itemCollectionInBound = zg.playerData:GetMethod(PlayerDataMethod.ITEM_COLLECTION)
	if itemCollectionInBound.needRequestItemCollection ~= true then
		PopupMgr.ShowPopup(UIPopupName.UIChangeAvatar)
	else
		PlayerDataRequest.RequestAndCallback({PlayerDataMethod.ITEM_COLLECTION}, function ()
			PopupMgr.ShowPopup(UIPopupName.UIChangeAvatar)
		end, SmartPoolUtils.LogicCodeNotification)
	end
end

--- @return void
function UIUserProfileView:OnClickChangeVip()
	PopupMgr.ShowPopup(UIPopupName.UIVipNew)
end

--- @return void
function UIUserProfileView:Hide()
	UIBaseView.Hide(self)
	if self.iconVip ~= nil then
		self.iconVip:ReturnPool()
		self.iconVip = nil
	end
	self:RemoveListener()
end

--- @return void
function UIUserProfileView:OnClickBackOrClose()
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
	PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end