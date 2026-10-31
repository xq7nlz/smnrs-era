
--- @class UIDomainMemberSearchView : UIBaseView
UIDomainMemberSearchView = Class(UIDomainMemberSearchView, UIBaseView)

local SearchTab = {
	FRIEND = 1,
	GUILD = 2,
}

--- @param model UIDomainMemberSearchModel
function UIDomainMemberSearchView:Ctor(model)
	--- @type UIDomainMemberSearchConfig
	self.config = nil
	---@type
	self.listSearch = List()

	--- @type Dictionary
	self.tabDic = Dictionary()

	UIBaseView.Ctor(self, model)
	--- @type UIDomainMemberSearchModel
	self.model = model
end

function UIDomainMemberSearchView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)

	--- @type table
	self.funSelectTab = { self.ShowFriend, self.ShowGuild }
	--- @type table
	self.funHideTab = { self.HideFriend, self.HideGuild }

	self:InitButtons()

	--- @param obj UIDomainMemberSearchItemView
	--- @param index number
	local onCreateItem = function(obj, index)
		obj:SetData(self.listSearch:Get(index + 1))
	end
	self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.UIDomainMemberSearchItemView, onCreateItem, onCreateItem)

	self:InitTabs()
end

function UIDomainMemberSearchView:InitButtons()
	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.backGround.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonAplly.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickApply()
	end)
end

function UIDomainMemberSearchView:InitLocalization()
	self.config.textTabFriend.text = LanguageUtils.LocalizeCommon("friend")
	self.config.textTabGuild.text = LanguageUtils.LocalizeFeature(FeatureType.GUILD)
	self.config.textEmpty.text = LanguageUtils.LocalizeCommon("empty")
	self.config.textSend.text = LanguageUtils.LocalizeCommon("send")
	self.config.textEnterSearch.text = LanguageUtils.LocalizeCommon("enter_text")
end

function UIDomainMemberSearchView:InitTabs()
	self.currentTab = SearchTab.FRIEND
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
			--self.config.content:GetChild(i).gameObject:SetActive(isSelect)
			i = i + 1
		end
		--self.funSelectTab[self.currentTab](self)
	end
	local addTab = function(tabId, anchor, localizeFunction)
		self.tabDic:Add(tabId, UITabItem(anchor, self.selectTab, localizeFunction, tabId))
	end
	addTab(SearchTab.FRIEND, self.config.friendListTab, function()
		return LanguageUtils.LocalizeCommon("friend")
	end)
	addTab(SearchTab.GUILD, self.config.searchTab, function()
		return LanguageUtils.LocalizeFeature(FeatureType.GUILD)
	end)
end

--- @param data {callbackClose : function}
function UIDomainMemberSearchView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
	self.config.inputId.text = ""
	---@type DomainInBound
	self.domainInBound = zg.playerData:GetDomainInBound()

	self.selectTab(SearchTab.FRIEND)
end

function UIDomainMemberSearchView:UpdateListMember()
	self.uiScroll.scroll.gameObject:SetActive(true)
	if self.listSearch:Count() > 0 then
		self.uiScroll:Resize(self.listSearch:Count())
		self.config.empty:SetActive(false)
	else
		self.uiScroll:Hide()
		self.config.empty:SetActive(true)
	end
end

function UIDomainMemberSearchView:OnClickApply()
	self.domainInBound:GetListIdSearch(tonumber(self.config.inputId.text), function (list)
		self.listSearch = list
		self:UpdateListMember()
	end)
end

function UIDomainMemberSearchView:Hide()
	UIBaseView.Hide(self)
	self.uiScroll:Hide()
end

function UIDomainMemberSearchView:ShowFriend()
	self.listSearch = zg.playerData.domainData.listFriendSearchDomain

	self:UpdateListMember()
end

function UIDomainMemberSearchView:ShowGuild()
	self.uiScroll.scroll.gameObject:SetActive(false)
	self.domainInBound:GetListGuildSearch(function ()
		self.listSearch = zg.playerData.domainData.listGuildSearch
		self:UpdateListMember()
	end, function ()
		self.selectTab(SearchTab.FRIEND)
	end)

end

function UIDomainMemberSearchView:HideFriend()

end

function UIDomainMemberSearchView:HideGuild()

end