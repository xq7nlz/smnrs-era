require "lua.client.scene.ui.home.uiCommunityTotal.layout.CommunityGuideBookLayout.CommunityGuideBookLayout"
require "lua.client.scene.ui.home.uiCommunityTotal.layout.CommunityFriendLayout.CommunityFriendLayout"
require "lua.client.scene.ui.home.uiCommunityTotal.layout.CommunityNoticeLayout.CommunityNoticeLayout"
require "lua.client.scene.ui.home.uiCommunityTotal.layout.CommunityEventLayout.CommunityEventLayout"
require "lua.client.scene.ui.home.uiCommunityTotal.layout.CommunityCustomerServiceLayout.CommunityCustomerServiceLayout"
require "lua.client.scene.ui.home.uiEvent.community.EventCommunityPopup"

--- @class UICommunityTotalView : UIBaseView
UICommunityTotalView = Class(UICommunityTotalView, UIBaseView)

local tabCount = 6

CommunityTotalTab = {
    Guide_Book = 1,
    Event = 2,
    Notice = 3,
    Social = 4,
    Friend = 5,
    Customer_Service = 6,
}

--- @return void
--- @param model UICommunityTotalModel
function UICommunityTotalView:Ctor(model)
    ---@type CommunityTotalConfig
    self.config = nil
    ---@type Dictionary
    self.dictLeftTab = Dictionary()
    ---@type UILoopScroll
    self.uiScroll = nil
    ---@type number
    self.selectTab = nil
    self.content = nil
    --- @type UICommunityTotalModel
    self.model = model
    UIBaseView.Ctor(self, model)
end

--- @return void
function UICommunityTotalView:OnReadyCreate()
    ---@type CommunityTotalConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.selectTab = CommunityTotalTab.Guide_Book
    self:InitRemoteConfig()
    self:InitButton()
    self:InitContent()
    self:InitDictTabData()
    self:InitLeftTabScrolls()
end

function UICommunityTotalView:InitButton()
    self.config.backButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBackOrClose()
    end)
    self.config.helpButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("community_info"))
    end)
end

function UICommunityTotalView:InitRemoteConfig()
    ---@type CommunityEventData
    self.communityEventData = zg.playerData:GetEvents().communityEventData
end

function UICommunityTotalView:InitDictTabData()
    self.dictLeftTab:Clear()
    self.dictLeftTab:Add(CommunityTotalTab.Guide_Book, { localizeKey = "guide_book" })
    self.dictLeftTab:Add(CommunityTotalTab.Event, { localizeKey = "event" })
    self.dictLeftTab:Add(CommunityTotalTab.Notice, { localizeKey = "notice" })
    self.dictLeftTab:Add(CommunityTotalTab.Social, { localizeKey = "social" })
    self.dictLeftTab:Add(CommunityTotalTab.Friend, { localizeKey = "friends" })
    self.dictLeftTab:Add(CommunityTotalTab.Customer_Service, { localizeKey = "customer_service" })
end

function UICommunityTotalView:InitLeftTabScrolls()
    --- @param obj UIEventPackageTabItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local tabIndex = index + 1
        if tabIndex == CommunityTotalTab.Notice then
            obj:SetActive(false)
            return
        end
        ---@type {localizeKey,prefab}
        local data = self.dictLeftTab:Get(tabIndex)
        obj:EnableTimer(false)
        obj:EnableNoti(false)
        obj:SetTextPositionY()
        obj:SetText(LanguageUtils.LocalizeCommon(data.localizeKey))
        obj:AddOnSelectListener(function()
            self:SelectTab(obj, tabIndex)
        end)
        obj.config.icon:SetNativeSize()
        obj:SetSelectState(self.selectTab == tabIndex)
        self:CheckNotiAll(obj, tabIndex)
        self:SetSprite(tabIndex, self.selectTab == tabIndex, obj.config.icon)
    end
    --- @param obj UIEventPackageTabItem
    --- @param index number
    local onUpdateItem = function(obj, index)
        local tabIndex = index + 1
        if tabIndex == CommunityTotalTab.Notice then
            obj:SetActive(false)
            return
        end
        obj:SetSelectState(self.selectTab == tabIndex)
        self:CheckNotiAll(obj, tabIndex)
        self:SetSprite(tabIndex, self.selectTab == tabIndex, obj.config.icon)
    end
    self.uiScroll = UILoopScroll(self.config.leftTab, UIPoolType.EventPackageTabItem, onCreateItem, onUpdateItem)
    self.uiScroll:SetUpMotion(MotionConfig(nil, nil, nil, 0.02))
end

--- @param obj UIEventPackageTabItem
function UICommunityTotalView:SelectTab(obj, index)
    ---@type {localizeKey,prefab}
    local data = self.dictLeftTab:Get(index)
    obj:SetSelectState(true)
    self:ShowContent(index)
    self.uiScroll:RefreshCells()
end

function UICommunityTotalView:ShowContent(tabIndex)
    self.selectTab = tabIndex
    for i = 1, tabCount do
        if i == self.selectTab then
            if i == CommunityTotalTab.Guide_Book then
                self.contentGuideBook:OnShow()
            elseif i == CommunityTotalTab.Event then
                self.contentEvent:OnShow()
            elseif i == CommunityTotalTab.Notice then
                --self.contentNotice:OnShow()
            elseif i == CommunityTotalTab.Social then
                self:OnClickTabSocial()
            elseif i == CommunityTotalTab.Friend then
                self.contentFriend:OnShow()
            elseif i == CommunityTotalTab.Customer_Service then
                self.contentCustomerService:OnShow()
            end
        else
            if i == CommunityTotalTab.Guide_Book then
                self:OnHideTabGuideBook()
            elseif i == CommunityTotalTab.Event then
                self:OnHideTabEvent()
            elseif i == CommunityTotalTab.Notice then
                --self:OnHideTabNotice()
            elseif i == CommunityTotalTab.Social then
                self:OnHideTabSocial()
            elseif i == CommunityTotalTab.Friend then
                self:OnHideTabFriend()
            elseif i == CommunityTotalTab.Customer_Service then
                self:OnHideTabCustomerService()
            end
        end
    end
end

function UICommunityTotalView:InitContent()
    self.contentGuideBook = CommunityGuideBookLayout(self, self.config.contentGuideBook)
    self.contentNotice = CommunityNoticeLayout(self, self.config.contentNotice)
    self.contentFriend = CommunityFriendLayout(self, self.config.contentFriend)
    self.contentEvent = CommunityEventLayout(self, self.config.contentEvent)
    self.contentCustomerService = CommunityCustomerServiceLayout(self, self.config.contentCustomerService)
end

function UICommunityTotalView:OnClickTabSocial()
    if not self.contentSocial then
        local init = PrefabLoadUtils.Instantiate("popup_event_community", self.config.contentSocial)
        --- @type EventCommunityPopup
        self.contentSocial = EventCommunityPopup(init.transform)
    end
    self.contentSocial:OnShow()
end

function UICommunityTotalView:OnHideTabGuideBook()
    if self.contentGuideBook then
        self.contentGuideBook:OnHide()
    end
end

function UICommunityTotalView:OnHideTabEvent()
    if self.contentEvent then
        self.contentEvent:OnHide()
    end
end

function UICommunityTotalView:OnHideTabNotice()
    if self.contentNotice then
        self.contentNotice:OnHide()
    end
end

function UICommunityTotalView:OnHideTabSocial()
    if self.contentSocial then
        self.contentSocial:OnHide()
    end
end

function UICommunityTotalView:OnHideTabFriend()
    if self.contentFriend then
        self.contentFriend:OnHide()
    end
end

function UICommunityTotalView:OnHideTabCustomerService()
    if self.contentCustomerService then
        self.contentCustomerService:OnHide()
    end
end

--- @param obj UIEventPackageTabItem
function UICommunityTotalView:CheckNotiAll(obj, index)
    self:CheckNotiFriend(obj, index)
    self:CheckNotiSocial(obj, index)
    self:CheckNotiEvent(obj, index)
end

--- @param obj UIEventPackageTabItem
function UICommunityTotalView:CheckNotiFriend(obj, index)
    --- @type PlayerFriendInBound
    local friendData = zg.playerData:GetMethod(PlayerDataMethod.FRIEND)
    if friendData and index == CommunityTotalTab.Friend and obj then
        obj:EnableNoti(friendData:IsActiveNotification())
    end
end

--- @param obj UIEventPackageTabItem
function UICommunityTotalView:CheckNotiSocial(obj, index)
    ---@type EventCommunityInBound
    local eventInBound = zg.playerData:GetEvents().eventCommunityInBound
    if eventInBound and index == CommunityTotalTab.Social then
        obj:EnableNoti(eventInBound:HasNotification())
    end
end

--- @param obj UITopTabItem
function UICommunityTotalView:CheckNotiEvent(obj, index)
    if index == CommunityTotalTab.Event and obj then
        obj:EnableNoti(self.communityEventData:HasEventTabNotSeen())
    end
end

--- @return void
function UICommunityTotalView:SetSprite(index, isOn, image)
    local atlas = ResourceLoadUtils.LoadAtlas(ResourceLoadUtils.iconWiki)
    if isOn then
        isOn = 1
    else
        isOn = 0
    end
    image:SetNativeSize()
    image.sprite = atlas:GetSprite(index .. isOn)
end

--- @return void
function UICommunityTotalView:RefreshTabView(isKeepPosition)
    local temp = self.config.leftTabPosition.position
    self.uiScroll:Resize(tabCount)
    if isKeepPosition then
        ---@type UnityEngine_Vector3
        self.config.leftTabPosition.position = temp
    end
end

--- @return void
function UICommunityTotalView:InitListener()
    self.listenerNotiUI = RxMgr.notificationRequestCommunity:Subscribe(RxMgr.CreateFunction(self, self.RefreshTabView))
end

function UICommunityTotalView:OnReadyShow(tabIndex)
    self.uiScroll:Resize(tabCount)
    if tabIndex then
        self:ShowContent(tabIndex)
    else
        self:ShowContent(CommunityTotalTab.Guide_Book)
    end
    self.uiScroll:Resize(tabCount)
    self:InitListener()
end

--- @return void
function UICommunityTotalView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UICommunityTotal)
end

--- @return void
function UICommunityTotalView:RemoveListener()
    if self.listenerNotiUI then
        self.listenerNotiUI:Unsubscribe()
        self.listenerNotiUI = nil
    end
end

--- @return void
function UICommunityTotalView:Hide()
    self:RemoveListener()
    self.selectTab = CommunityTotalTab.Guide_Book
    --self.uiScroll:Hide()
    UIBaseView.Hide(self)
end

