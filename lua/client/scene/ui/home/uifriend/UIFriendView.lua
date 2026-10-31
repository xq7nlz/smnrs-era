---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiFriend.UIFriendConfig"
require "lua.client.scene.ui.home.uiFriend.UIFriendListView"
require "lua.client.scene.ui.home.uiFriend.UIFriendSearchView"
require "lua.client.scene.ui.home.uiFriend.UIFriendAddView"

local FriendTab = {
    FRIEND_LIST = 1,
    SEARCH = 2,
    REQUEST = 3,
    HELP_FIGHT = 4,
}
--- @class UIFriendView : UIBaseView
UIFriendView = Class(UIFriendView, UIBaseView)


--- @return void
--- @param model UIFriendModel
function UIFriendView:Ctor(model)
    --- @type UIFriendConfig
    self.config = nil

    --- @type Dictionary
    self.tabDic = Dictionary()

    --- @type PlayerFriendInBound
    self.server = nil
    ---@type UIFriendListView
    self.friendListView = nil
    ---@type UIFriendSearchView
    self.friendSearchView = nil
    ---@type UIFriendAddView
    self.friendAddView = nil
    UIBaseView.Ctor(self, model)
    --- @type UIFriendModel
    self.model = model
end

--- @return void
function UIFriendView:OnReadyCreate()
    ---@type UIFriendConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.friendListView = UIFriendListView(self.config.content:GetChild(0), self)
    self.friendSearchView = UIFriendSearchView(self.config.content:GetChild(1), self)
    self.friendAddView = UIFriendAddView(self.config.content:GetChild(2), self)
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.backGround.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)

    -- Tab
    --- @type table
    self.funSelectTab = { self.ShowFriendList, self.ShowSearch, self.ShowFriendAdd }
    --- @type table
    self.funHideTab = { self.HideFriendList, self.HideSearch, self.HideFriendAdd }
    --- @type table
    self.funRefreshTab = { self.RefreshFriendList, self.RefreshSearch, self.RefreshFriendAdd }
    --- @param obj UITabConfig
    --- @param isSelect boolean
    self:InitTabs()
    --local onSelect = function (obj, isSelect, indexTab)
    --	if obj ~= nil then
    --		obj.button.interactable = not isSelect
    --    obj.imageOn.gameObject:SetActive(isSelect)
    --	end
    --	self.config.content:GetChild(indexTab - 1).gameObject:SetActive(isSelect)
    --end
    --local onChangeSelect = function (indexTab, lastTab)
    --	if lastTab ~= nil then
    --		self.funHideTab[lastTab](self)
    --	end
    --	if indexTab ~= nil then
    --		self.funSelectTab[indexTab](self)
    --	end
    --end
    --self.tab = UISelect(self.config.tabChon, UIBaseConfig, onSelect, onChangeSelect)
end

function UIFriendView:InitTabs()
    self.currentTab = FriendTab.FRIEND_LIST
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
    addTab(FriendTab.FRIEND_LIST, self.config.friendListTab, function()
        return LanguageUtils.LocalizeCommon("friend_list")
    end)
    addTab(FriendTab.SEARCH, self.config.searchTab, function()
        return LanguageUtils.LocalizeCommon("search")
    end)
    addTab(FriendTab.REQUEST, self.config.requestTab, function()
        return LanguageUtils.LocalizeCommon("friend_request")
    end)
end

function UIFriendView:InitLocalization()
    self.config.textEmpty.text = LanguageUtils.LocalizeCommon("empty")
    self.config.titleMember.text = LanguageUtils.LocalizeCommon("member")
    self.config.textTapToClose.gameObject:SetActive(false)

    self.friendListView:InitLocalization()
    self.friendSearchView:InitLocalization()
    self.friendAddView:InitLocalization()

    if self.tabDic ~= nil then
        --- @param v UITabItem
        for _, v in pairs(self.tabDic:GetItems()) do
            v:InitLocalization()
        end
    end
end

--- @return void
function UIFriendView:OnReadyShow()
    self.canPlayMotion = true
    self.server = zg.playerData:GetMethod(PlayerDataMethod.FRIEND)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    if self.cacheData == true then
        self.selectTab(self.currentTab)
    else
        self.selectTab(FriendTab.FRIEND_LIST)
    end
    self.cacheData = true
    self:InitListener()
    self:CheckNotificationAll()
    self:UpdateFriendCount()
    self.canPlayMotion = false
end

--- @return void
function UIFriendView:Hide()
    UIBaseView.Hide(self)
    self:RemoveListener()
    self.funHideTab[self.currentTab](self)
end

--- @return void
function UIFriendView:OnReadyHide()
    UIBaseView.OnReadyHide(self)
    self.cacheData = false
end

--- @return void
function UIFriendView:UpdateFriendCount()
    if zg.playerData:GetMethod(PlayerDataMethod.FRIEND).listFriendData:Count() >= 30 then
        self.config.friendCount.text = "30/30"
    else
        self.config.friendCount.text = zg.playerData:GetMethod(PlayerDataMethod.FRIEND).listFriendData:Count() .. UIUtils.SetColorString(UIUtils.brown, "/30")
    end
end

--- @return void
function UIFriendView:InitListener()
    self.listener = RxMgr.notificationRequestFriend
                         :Merge(RxMgr.notificationRequestUiFriend)
                         :Subscribe(RxMgr.CreateFunction(self, self.OnServerNotificationFriend))
    self.listenerNotiUI = RxMgr.notificationUiFriend:Subscribe(RxMgr.CreateFunction(self, self.CheckNotificationAll))

    self.listenerRequestFriend = RxMgr.friendAddSuccess
                                      :Filter(function(id)
        return self.server:IsContainFriendRequest(id)
    end)
                                      :Subscribe(function()
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.FRIEND })
    end)
end

--- @return void
function UIFriendView:RemoveListener()
    if self.listener then
        self.listener:Unsubscribe()
        self.listener = nil
    end
    if self.listenerNotiUI then
        self.listenerNotiUI:Unsubscribe()
        self.listenerNotiUI = nil
    end
    if self.listenerRequestFriend ~= nil then
        self.listenerRequestFriend:Unsubscribe()
        self.listenerRequestFriend = nil
    end
end

--- @return void
function UIFriendView:OnServerNotificationFriend()
    PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.FRIEND }, function()
        self:CheckNotificationAll()
    end)
end

--- @return void
function UIFriendView:CheckNotificationAll()
    ---@type PlayerFriendInBound
    local friendInBound = zg.playerData:GetMethod(PlayerDataMethod.FRIEND)
    self.funRefreshTab[self.currentTab](self)
    self.config.notiFriendList:SetActive(friendInBound.isNotificationFriendList)
    self.config.notiFriendRequest:SetActive(friendInBound.isNotificationFriendRequest)
end

--- @return void
function UIFriendView:ShowFriendList()
    self.friendListView:Show(self.canPlayMotion)
end

--- @return void
function UIFriendView:HideFriendList()
    if self.friendListView ~= nil then
        self.friendListView:Hide()
    end
end

--- @return void
function UIFriendView:RefreshFriendList()
    if self.friendListView ~= nil then
        self.friendListView:Refresh()
    end
end

--- @return void
function UIFriendView:ShowSearch()
    self.friendSearchView:Show(self.canPlayMotion)
end

--- @return void
function UIFriendView:HideSearch()
    if self.friendSearchView ~= nil then
        self.friendSearchView:Hide()
    end
end

--- @return void
function UIFriendView:RefreshSearch()
    if self.friendSearchView ~= nil then
        self.friendSearchView:Refresh()
    end
end

--- @return void
function UIFriendView:ShowFriendAdd()
    self.friendAddView:Show(self.canPlayMotion)
end

--- @return void
function UIFriendView:HideFriendAdd()
    if self.friendAddView ~= nil then
        self.friendAddView:Hide()
    end
end

--- @return void
function UIFriendView:RefreshFriendAdd()
    if self.friendAddView ~= nil then
        self.friendAddView:Refresh()
    end
end
