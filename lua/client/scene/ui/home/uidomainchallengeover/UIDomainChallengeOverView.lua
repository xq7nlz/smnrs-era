
--- @class UIDomainChallengeOverView : UIBaseView
UIDomainChallengeOverView = Class(UIDomainChallengeOverView, UIBaseView)

--- @param model UIDomainChallengeOverModel
function UIDomainChallengeOverView:Ctor(model)
	--- @type UIDomainChallengeOverConfig
	self.config = nil
	--- @type ItemsTableView
	self.itemsTableView = nil
	UIBaseView.Ctor(self, model)
	--- @type UIDomainChallengeOverModel
	self.model = model
end

function UIDomainChallengeOverView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)

	self.itemsTableView = ItemsTableView(self.config.rewardAnchor)

	self:InitButtons()
end

function UIDomainChallengeOverView:InitButtons()
	self.config.bgClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonGotoMail.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickGotoMail()
	end)
end

function UIDomainChallengeOverView:InitLocalization()
	self.config.textChallengeOver.text = LanguageUtils.LocalizeCommon("domain_challenge_over")
	self.config.textCongrat.text = LanguageUtils.LocalizeCommon("domain_challenge_congrat")
	self.config.textReward.text = LanguageUtils.LocalizeCommon("reward_claimed")
	self.config.textGotoMail.text = LanguageUtils.LocalizeCommon("go_to_mail")
	self.config.textSent.text = LanguageUtils.LocalizeCommon("has_sent_to_mail")
end

--- @param data {callbackClose : function}
function UIDomainChallengeOverView:OnReadyShow(data)
	local domainInBound = zg.playerData:GetDomainInBound()

	--- @type DomainRewardDayConfig
	local domainRewardDayConfig = ResourceMgr.GetDomainConfig():GetDomainRewardConfig():GetDomainRewardDayConfig(domainInBound.challengeDay)
	self.itemsTableView:SetData(RewardInBound.GetItemIconDataList(domainRewardDayConfig:GetTotalRewardAllStage()))
end

function UIDomainChallengeOverView:OnClickGotoMail()
	FeatureMapping.GoToFeature(FeatureType.MAIL, false, function ()
		PopupMgr.HidePopup(self.model.uiName)
		PopupMgr.HidePopup(UIPopupName.UIDomainsStageMap)
	end)
end

function UIDomainChallengeOverView:Hide()
	UIBaseView.Hide(self)
	self.itemsTableView:Hide()
end