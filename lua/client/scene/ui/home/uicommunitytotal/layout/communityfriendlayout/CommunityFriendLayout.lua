require "lua.client.scene.ui.home.uiFriend.UIFriendListView"
require "lua.client.scene.ui.home.uiFriend.UIFriendSearchView"
require "lua.client.scene.ui.home.uiFriend.UIFriendAddView"

local tabCount = 3

local FriendTab = {
    FriendList = 1,
    FriendSearch = 2,
    FriendRequest = 3,
}

--- @class CommunityFriendLayout
CommunityFriendLayout = Class(CommunityFriendLayout)

--- @return void
--- @param transform UnityEngine_Transform
function CommunityFriendLayout:Ctor(view, transform)
    --- @type UICommunityTotalView
    self.view = view
    ---@type CommunityFriendConfig
    self.config = UIBaseConfig(transform)
    --- @type UISelect
    self.tab = nil
    self.selectTab = nil
    self:InitContent()
    self:InitTab()
end

--- @return void
function CommunityFriendLayout:InitContent()
    self.contentFriendList = UIFriendListView(self.config.content:GetChild(0), self)
    self.contentFriendSearch = UIFriendSearchView(self.config.content:GetChild(1), self)
    self.contentFriendRequest = UIFriendAddView(self.config.content:GetChild(2), self)
end

function CommunityFriendLayout:InitLocalize()
    self.config.localizeFriendList.text = LanguageUtils.LocalizeCommon("friend_list")
    self.config.localizeFriendSearch.text = LanguageUtils.LocalizeCommon("search")
    self.config.localizeFriendRequest.text = LanguageUtils.LocalizeCommon("friend_request")
    self.config.localizeMember.text = LanguageUtils.LocalizeCommon("member")
    self.config.textEmpty.text = LanguageUtils.LocalizeCommon("empty")
end

--- @return void
function CommunityFriendLayout:InitTab()
    --- @param obj UIHeroCollectionTabConfig
    --- @param isSelect boolean
    local onSelect = function(obj, isSelect, indexTab)
        if obj ~= nil then
            obj.button.interactable = not isSelect
            obj.bgOn.gameObject:SetActive(isSelect)
            if isSelect then
                self:SelectTab(indexTab)
            end
            self.config.content:GetChild(indexTab - 1).gameObject:SetActive(isSelect)
        end
    end

    local onChangeSelect = function(indexTab)
        if indexTab then
            self:SelectTab(indexTab)
        end
        self:CheckNotificationAll()
    end
    self.tab = UISelect(self.config.tab, UIBaseConfig, onSelect, onChangeSelect)
end

function CommunityFriendLayout:SelectTab(tabIndex)
    self.selectTab = tabIndex
    for i = 1, tabCount do
        if i ~= self.selectTab then
            if i == FriendTab.FriendList then
                if self.contentFriendList then
                    self.contentFriendList:Hide()
                end
            elseif i == FriendTab.FriendSearch then
                if self.contentFriendSearch then
                    self.contentFriendSearch:Hide()
                end
            elseif i == FriendTab.FriendRequest then
                if self.contentFriendRequest then
                    self.contentFriendRequest:Hide()
                end
            end
        else
            if i == FriendTab.FriendList then
                self:EnableEmpty(true)
                self.contentFriendList:Show(self.canPlayMotion)
            elseif i == FriendTab.FriendSearch then
                self:EnableEmpty(false)
                self.contentFriendSearch:Show(self.canPlayMotion)
            elseif i == FriendTab.FriendRequest then
                self:EnableEmpty(true)
                self.contentFriendRequest:Show(self.canPlayMotion)
            end
        end
    end
end

--- @param isEnable boolean
function CommunityFriendLayout:EnableEmpty(isEnable)
    self.config.empty:SetActive(isEnable)
end

--- @return void
function CommunityFriendLayout:UpdateFriendCount()
    if zg.playerData:GetMethod(PlayerDataMethod.FRIEND).listFriendData:Count() >= 30 then
        self.config.friendCount.text = UIUtils.SetColorString(UIUtils.red_dark, "30") .. UIUtils.SetColorString(UIUtils.brown, "/30")
    else
        self.config.friendCount.text = UIUtils.SetColorString(UIUtils.green_dark, zg.playerData:GetMethod(PlayerDataMethod.FRIEND).listFriendData:Count()) .. UIUtils.SetColorString(UIUtils.brown, "/30")
    end
end

--- @return void
function CommunityFriendLayout:CheckNotificationAll()
    local CommunityTabCount = 6
    ---@type PlayerFriendInBound
    local friendInBound = zg.playerData:GetMethod(PlayerDataMethod.FRIEND)
    friendInBound:CheckNotificationFriendList()
    self.config.notiFriendList:SetActive(friendInBound.isNotificationFriendList)
    self.config.notiFriendRequest:SetActive(friendInBound.isNotificationFriendRequest)
    if self.view.uiScroll then
        self.view:RefreshTabView(true)
    end
end

--- @return void
function CommunityFriendLayout:FakeDisableNoti()
    local CommunityTabCount = 6
    self.config.notiFriendList:SetActive(false)
    if self.view.uiScroll then
        self.view:RefreshTabView(true)
    end
end

--- @return void
function CommunityFriendLayout:InitListener()
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
function CommunityFriendLayout:RemoveListener()
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
function CommunityFriendLayout:OnShow()
    self.canPlayMotion = true
    self.server = zg.playerData:GetMethod(PlayerDataMethod.FRIEND)
    self.config.gameObject:SetActive(true)
    self:InitLocalize()
    self:UpdateFriendCount()
    self:CheckNotificationAll()
    self.tab:Select(FriendTab.FriendList)
    self.canPlayMotion = false
end

--- @return void
function CommunityFriendLayout:OnHide()
    self.config.gameObject:SetActive(false)
    self:RemoveListener()
end

return CommunityFriendLayout