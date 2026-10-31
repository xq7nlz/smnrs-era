
--- @class UIDomainMemberVerifyView : UIBaseView
UIDomainMemberVerifyView = Class(UIDomainMemberVerifyView, UIBaseView)

local VerifyTab = {
	VERIFY = 1,
	RECRUIT = 2,
}

--- @param model UIDomainMemberVerifyModel
function UIDomainMemberVerifyView:Ctor(model)
	--- @type UIDomainMemberVerifyConfig
	self.config = nil
	---@type
	self.listSearch = List()
	--- @type number
	self.lastSend = os.time() - 1000

	--- @type Dictionary
	self.tabDic = Dictionary()
	UIBaseView.Ctor(self, model)
	--- @type UIDomainMemberVerifyModel
	self.model = model
end

function UIDomainMemberVerifyView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)
	--- @type UIDomainVerifyConfig
	self.verifyConfig = UIBaseConfig(self.config.content:GetChild(0))
	--- @type UIDomainRecruitConfig
	self.recruitConfig = UIBaseConfig(self.config.content:GetChild(1))

	self.config.backGround.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)

	self:InitButtons()

	--- @type table
	self.funSelectTab = { self.ShowVerify, self.ShowRecruit }
	--- @type table
	self.funHideTab = { self.HideVerify, self.HideRecruit }

	--- @param obj UIDomainMemberVerifyItemView
	--- @param index number
	local onCreateItem = function(obj, index)
		index = index + 1
		obj:SetData(self.listSearch:Get(index), function (id)
			self:DeleteMemberId(id)
		end, function(id)
			self:AcceptMemberId(id)
		end, function ()
			self.listSearch:RemoveByIndex(index)
			self.uiScroll:Resize(self.listSearch:Count())
		end)
	end
	self.uiScroll = UILoopScroll(self.verifyConfig.scroll, UIPoolType.UIDomainMemberVerifyItemView, onCreateItem, onCreateItem)

	self:InitTabs()
end

function UIDomainMemberVerifyView:InitButtons()
	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.backGround.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.verifyConfig.buttonDeleteAll.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickDeleteAll()
	end)
	self.recruitConfig.buttonApply.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickApply()
	end)
end

function UIDomainMemberVerifyView:OnClickBackOrClose()
	UIBaseView.OnClickBackOrClose(self)
	if self.needRequestListMember == true then
		if self.callbackRequestDomain ~= nil then
			self.callbackRequestDomain()
		end
	end
end

function UIDomainMemberVerifyView:InitTabs()
	self.currentTab = VerifyTab.VERIFY
	self.selectTab = function(currentTab)
		self.currentTab = currentTab
		self.config.empty:SetActive(false)
		local i = 0
		for k, v in pairs(self.tabDic:GetItems()) do
			local isSelect = k == currentTab
			if isSelect then
				self.config.titleFriend.text = v.config.textTabName.text
				self.config.titleIcon.sprite = v.config.iconDefault.sprite
				self.config.titleIcon:SetNativeSize()
				self.funSelectTab[currentTab](self)
			end
			v:SetTabState(isSelect)
			self.config.content:GetChild(i).gameObject:SetActive(isSelect)
			i = i + 1
		end
		--self.funSelectTab[self.currentTab](self)
	end
	local addTab = function(tabId, anchor, localizeFunction)
		self.tabDic:Add(tabId, UITabItem(anchor, self.selectTab, localizeFunction, tabId))
	end
	addTab(VerifyTab.VERIFY, self.config.requestTab, function()
		return LanguageUtils.LocalizeCommon("verify")
	end)
	addTab(VerifyTab.RECRUIT, self.config.searchTab, function()
		return LanguageUtils.LocalizeCommon("recruit")
	end)
end

function UIDomainMemberVerifyView:InitLocalization()
	self.config.textTabName1.text = LanguageUtils.LocalizeCommon("verify")
	self.config.textTabName2.text = LanguageUtils.LocalizeCommon("recruit")
	self.config.textEmpty.text = LanguageUtils.LocalizeCommon("empty")
	self.verifyConfig.localizeDeleteAll.text = LanguageUtils.LocalizeCommon("delete_all")
	self.recruitConfig.localizeApply.text = LanguageUtils.LocalizeCommon("send")

	self.recruitConfig.recruitPlaceHolder.text = LanguageUtils.LocalizeCommon("enter_domain_recruit")
end

--- @param data {callbackClose : function}
function UIDomainMemberVerifyView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)

	if data ~= nil then
		self.callbackRequestDomain = data.callbackRequestDomain
	else
		self.callbackRequestDomain = nil
	end

	---@type DomainInBound
	self.domainInBound = zg.playerData:GetDomainInBound()
	self.selectTab(VerifyTab.VERIFY)

	self.needRequestListMember = false
end

function UIDomainMemberVerifyView:Hide()
	UIBaseView.Hide(self)
	self.uiScroll:Hide()
end

function UIDomainMemberVerifyView:DeleteMemberId(id)
	self.domainInBound:RemoveVerifyById(id)
	self:RefreshListMember()
end

function UIDomainMemberVerifyView:AcceptMemberId(id)
	self.domainInBound:RemoveVerifyById(id)
	self:RefreshListMember()
	self.needRequestListMember = true
end

function UIDomainMemberVerifyView:UpdateListMember()
	if self.listSearch:Count() > 0 then
		self.uiScroll:Resize(self.listSearch:Count())
		self.config.empty:SetActive(false)
	else
		self.uiScroll:Hide()
		self.config.empty:SetActive(true)
	end
	self.verifyConfig.textReceivedApplications.text = string.format(LanguageUtils.LocalizeCommon("request_x") , self.listSearch:Count())
end

function UIDomainMemberVerifyView:RefreshListMember()
	if self.listSearch:Count() > 0 then
		self.uiScroll:RefreshCells(self.listSearch:Count())
		self.config.empty:SetActive(false)
	else
		self.uiScroll:Hide()
		self.config.empty:SetActive(true)
	end
	self.verifyConfig.textReceivedApplications.text = string.format(LanguageUtils.LocalizeCommon("request_x") , self.listSearch:Count())
end

function UIDomainMemberVerifyView:ShowVerify()
	self.listSearch = zg.playerData.domainData.listVerifyDomain

	self:UpdateListMember()
end

function UIDomainMemberVerifyView:ShowRecruit()
	self.uiScroll:Hide()
	self.recruitConfig.inputField.text = self.domainInBound.domainCrewInBound.description
end

function UIDomainMemberVerifyView:HideVerify()

end

function UIDomainMemberVerifyView:HideRecruit()

end

function UIDomainMemberVerifyView:OnClickDeleteAll()
	NetworkUtils.RequestAndCallback(OpCode.DOMAINS_CREW_APPLICATION_DELETE_ALL, nil, function ()
		zg.playerData.domainData.listVerifyDomain:Clear()

		self:ShowVerify()
	end)
end

function UIDomainMemberVerifyView:OnClickApply()
	if self.recruitConfig.inputField.text == "" then
		zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("enter_recruit_info_please"))
		return
	end
	---@type number
	local delay = self.lastSend + ChatData.DELAY_SEND_MESSAGE - os.time()
	if delay > 0 then
		SmartPoolUtils.ShowShortNotification(string.format(LanguageUtils.LocalizeCommon("chat_delay"), delay))
		zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
	else
		local onSuccess = function()
			self.lastSend = os.time()
			SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("send_recruit_successful"))
			self:OnReadyHide()
		end
		local message = self.recruitConfig.inputField.text
		NetworkUtils.RequestAndCallback(OpCode.DOMAINS_MEMBER_RECRUIT, UnknownOutBound.CreateInstance(PutMethod.LongString, message), onSuccess)
	end
end