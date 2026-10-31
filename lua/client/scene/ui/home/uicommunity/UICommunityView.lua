
--- @class UICommunityView : UIBaseView
UICommunityView = Class(UICommunityView, UIBaseView)

--- @return void
--- @param model UICommunityModel
function UICommunityView:Ctor(model)
	-- init variables here
	UIBaseView.Ctor(self, model)
	--- @type UICommunityModel
	self.model = model
end

--- @return void
function UICommunityView:OnReadyCreate()
	---@type UICommunityConfig
	self.config = UIBaseConfig(self.uiTransform)

	self.config.backGround.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonFacebook.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickFacebook()
	end)
	self.config.buttonTwitter.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickTwitter()
	end)
	self.config.buttonInstagram.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickInstagram()
	end)
	self.config.buttonReddit.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickReddit()
	end)
	self.config.buttonDiscord.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickDiscord()
	end)
end

function UICommunityView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("community")
end

--- @return void
function UICommunityView:OnReadyShow(result)
	
end

--- @return void
function UICommunityView:OnClickFacebook()
	PopupUtils.OpenFanpage()
	NetworkUtils.Request(OpCode.FACEBOOK_FAN_PAGE_JOIN, nil, nil, false)
end

--- @return void
function UICommunityView:OnClickTwitter()
	U_Application.OpenURL("https://twitter.com/SummonersEra")
end

--- @return void
function UICommunityView:OnClickInstagram()
	U_Application.OpenURL("https://www.instagram.com/summoners.era/")
end

--- @return void
function UICommunityView:OnClickReddit()
	U_Application.OpenURL("https://www.reddit.com/r/SummonersEra/")
end

--- @return void
function UICommunityView:OnClickDiscord()
	U_Application.OpenURL("https://discord.gg/jUPHrrP")
end

--- @return void
function UICommunityView:OnClickBackOrClose()
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
	PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end