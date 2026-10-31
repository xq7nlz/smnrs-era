---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiFriend.UIFriendAddConfig"
require "lua.client.core.network.friend.FriendAddOutBound"

--- @class UIFriendAddView
UIFriendAddView = Class(UIFriendAddView)

--- @return void
--- @param transform UnityEngine_Transform
function UIFriendAddView:Ctor(transform, communityFriend)
    --- @type PlayerFriendInBound
    self.server = nil
    ---@type CommunityFriendLayout
    self.communityFriend = communityFriend
    ---@type UIFriendAddConfig
    ---@type UIFriendAddConfig
    self.config = UIBaseConfig(transform)
    ---@type List
    self.listFriend = nil

    --- Scroll
    --- @param obj UIFriendItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        ---@type FriendRequestData
        local friendData = self.server.listFriendRequestData:Get(index + 1)
        obj:SetDataFriendAdd(friendData)
        obj.callbackConfirmFriend = function(isAccept)
            self:ConfirmFriendData(obj.friendData, isAccept)
        end
        obj.callbackBlock = function()
            self:BlockFriend(obj.friendData)
        end
    end

    --- @type UILoopScroll
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.UIFriendItemView, onCreateItem, onCreateItem)
    self.uiScroll:SetUpMotion(MotionConfig())

    self.config.buttonDeleteAll.onClick:AddListener(function()
        self:OnClickDeleteAll()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

--- @return void
function UIFriendAddView:InitLocalization()
    self.config.localizeDeleteAll.text = LanguageUtils.LocalizeCommon("delete_all")
end

--- @param canPlayMotion boolean
function UIFriendAddView:Show(canPlayMotion)
    self.canPlayMotion = canPlayMotion or false
    self.server = zg.playerData:GetMethod(PlayerDataMethod.FRIEND)
    local totalCount = self.server.listFriendRequestData:Count()
    self.config.textReceivedApplications.text = LanguageUtils.LocalizeCommon("received_applications") .. ": " .. UIUtils.SetColorString(UIUtils.green_dark, totalCount)
    self.uiScroll:Resize(totalCount)
    self.communityFriend.config.empty:SetActive(totalCount <= 0)
    self:CheckStateButton()
    if self.canPlayMotion == true then
        self.uiScroll:PlayMotion()
        self.canPlayMotion = false
    end
    self:InitLocalization()
end

---@return void
function UIFriendAddView:Hide()
    self.uiScroll:Hide()
    self.listFriend = nil
    self.communityFriend.config.empty:SetActive(false)
end

--- @return void
---@param friendData FriendRequestData
function UIFriendAddView:BlockFriend(friendData)
    self:Refresh()
end

---@return void
function UIFriendAddView:Refresh()
    local totalCount = self.server.listFriendRequestData:Count()
    self.config.textReceivedApplications.text = LanguageUtils.LocalizeCommon("received_applications") .. ": " .. totalCount
    self.uiScroll:RefreshCells(totalCount)
    self.communityFriend.config.empty:SetActive(totalCount <= 0)
    self:CheckStateButton()
end

---@return void
function UIFriendAddView:CheckStateButton()
    local totalCount = self.server.listFriendRequestData:Count()
    if totalCount > 0 then
        UIUtils.SetInteractableButton(self.config.buttonDeleteAll, true)
    else
        UIUtils.SetInteractableButton(self.config.buttonDeleteAll, false)
    end
end

--- @return void
---@param listFriendId List
---@param isAccept boolean
function UIFriendAddView:RequestFriend(listFriendId, isAccept)
    local callback = function(result)
        local onSuccess = function()
            if isAccept == true then
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("add_friend_success"))

                -- REQUEST LIST SUPPORT HERO
                ---@type HeroLinkingInBound
                local heroLinkingInBound = zg.playerData:GetMethod(PlayerDataMethod.HERO_LINKING)
                if heroLinkingInBound ~= nil then
                    heroLinkingInBound.needUpdateListSupport = true
                end
            end
            PlayerDataRequest.RequestAndCallback(
                    { PlayerDataMethod.FRIEND }, function()
                        self.communityFriend:UpdateFriendCount()
                        self.communityFriend:CheckNotificationAll()
                        self:Refresh()
                    end)
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    ---@type FriendAddOutBound
    local friendAddOutBound = FriendAddOutBound()
    for _, v in pairs(listFriendId:GetItems()) do
        friendAddOutBound.listFriendId:Add(v)
    end
    friendAddOutBound.isAccept = isAccept
    NetworkUtils.Request(OpCode.FRIEND_REQUEST_MANAGE, friendAddOutBound, callback)
end

--- @return void
---@param friendData FriendData
function UIFriendAddView:ConfirmFriendData(friendData, isAccept)
    ---@type List
    local listId = List()
    listId:Add(friendData.friendId)
    self:RequestFriend(listId, isAccept)
end

---@return number
function UIFriendAddView:OnClickDeleteAll()
    ---@type List
    local listId = List()
    ---@param v FriendRequestData
    for _, v in pairs(self.server.listFriendRequestData:GetItems()) do
        listId:Add(v.friendId)
    end
    if listId:Count() > 0 then
        PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("do_want_delete_all"), nil, function()
            self:RequestFriend(listId, false)
            self.communityFriend:CheckNotificationAll()
        end)
    else

    end
end