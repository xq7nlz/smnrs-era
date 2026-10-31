require "lua.client.core.network.friend.FriendPointOutBound"

--- @class UIFriendListView
UIFriendListView = Class(UIFriendListView)

--- @return void
--- @param transform UnityEngine_Transform
function UIFriendListView:Ctor(transform, communityFriend)
    --- @type PlayerFriendInBound
    self.server = nil
    --- @type FriendConfig
    self.csv = nil
    ---@type CommunityFriendLayout
    self.communityFriend = communityFriend
    ---@type UIFriendListConfig
    self.config = UIBaseConfig(transform)
    ---@type MoneyBarLocalView
    self.friendPointBarView = MoneyBarLocalView(self.config.moneyFriendPoint)
    ---@type MoneyBarLocalView
    self.friendStaminaBarView = MoneyBarLocalView(self.config.moneyStamina)
    ---@type HeroLinkingInBound
    self.heroLinkingInBound = nil
    -- Scroll

    --- @param obj UIFriendItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        ---@type FriendData
        local friendData = self.server.listFriendData:Get(index + 1)
        ---@type boolean
        local stateFriendPoint = self.server.listFriendStates:Get(friendData.friendId)
        obj:SetDataFriendList(friendData, stateFriendPoint)

        obj.callbackClaimFriendPoint = function()
            self:ClaimFriendPoint(obj.friendData)
        end
        obj.callbackSendFriendPoint = function()
            self:SendFriendPoint(obj.friendData)
        end
        obj.callbackRemoveFriend = function()
            self:RemoveFriend(obj.friendData)
        end
        obj.callbackBlock = function(friendID)
            self:BlockFriend(friendID)
        end
    end

    --- @type UILoopScroll
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.UIFriendItemView, onCreateItem, onCreateItem)
    self.uiScroll:SetUpMotion(MotionConfig())

    self.config.buttonClaim.onClick:AddListener(function()
        self:OnClickClaimAll()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

--- @return void
function UIFriendListView:InitLocalization()
    self.config.localizeClaimAndSend.text = LanguageUtils.LocalizeCommon("claim_and_send")
end

--- @return void
--- @param canPlayMotion boolean
function UIFriendListView:Show(canPlayMotion)
    self.config.localizeClaimAndSend.text = LanguageUtils.LocalizeCommon("claim_and_send")
    self.canPlayMotion = canPlayMotion or false
    self.server = zg.playerData:GetMethod(PlayerDataMethod.FRIEND)
    self.csv = ResourceMgr.GetFriendConfig()
    self.heroLinkingInBound = zg.playerData:GetMethod(PlayerDataMethod.HERO_LINKING)
    if self.friendPointBarView ~= nil then
        self.friendPointBarView:SetIconData(MoneyType.FRIEND_POINT)
    end
    if self.friendStaminaBarView ~= nil then
        self.friendStaminaBarView:SetIconData(MoneyType.FRIEND_STAMINA)
    end
    if self.server ~= nil then
        self.uiScroll:Resize(self.server.listFriendData:Count())
        self.communityFriend.config.empty:SetActive(self.server.listFriendData:Count() <= 0)
    else
        self.uiScroll:Resize(0)
        self.communityFriend.config.empty:SetActive(false)
    end
    if self.canPlayMotion == true then
        self.uiScroll:PlayMotion()
        self.canPlayMotion = false
    end
end

---@return void
function UIFriendListView:Hide()
    self.uiScroll:Hide()
    if self.friendPointBarView ~= nil then
        self.friendPointBarView:RemoveListener()
    end
    if self.friendStaminaBarView ~= nil then
        self.friendStaminaBarView:RemoveListener()
    end
end

---@return void
function UIFriendListView:Refresh()
    self.uiScroll:RefreshCells(self.server.listFriendData:Count())
end

--- @return void
---@param listFriendId List
function UIFriendListView:ClaimListFriendPoint(listFriendId, callbackSuccess, callbackFailed)
    --TouchUtils.Disable()
    ---@type FriendPointOutBound
    local friendPointOutBound = FriendPointOutBound()
    for _, v in pairs(listFriendId:GetItems()) do
        friendPointOutBound.listFriendId:Add(v)
    end
    local callback = function(result)
        ---@type RewardInBound
        local rewardInBound
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            rewardInBound = RewardInBound.CreateByBuffer(buffer)
        end
        local onSuccess = function()
            print("Opcode")
            rewardInBound:AddToInventory()
            SmartPoolUtils.ShowReward1Item(rewardInBound:GetIconData())
            self.communityFriend:CheckNotificationAll()
            ---@param v FriendData
            for _, v in pairs(self.server.listFriendData:GetItems()) do
                if listFriendId:IsContainValue(v.friendId) == true then
                    v.stateClaimFriendPoint = RewardState.CLAIMED
                end
            end
            if callbackSuccess ~= nil then
                callbackSuccess()
            end
            self.server:CheckNotificationFriendList()
            self.uiScroll:RefreshCells()
        end
        local onFailed = function(logicCode)
            if callbackFailed ~= nil then
                callbackFailed(logicCode)
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FRIEND_POINT_CLAIM, friendPointOutBound, callback)
end

--- @return void
---@param listFriendId List
function UIFriendListView:SendListFriendPoint(listFriendId, callbackSuccess, callbackFailed)
    local callback = function(result)
        local onSuccess = function()
            ---@param v FriendData
            for _, v in pairs(listFriendId:GetItems()) do
                self.server.listFriendStates:Add(v, false)
            end
            if callbackSuccess ~= nil then
                callbackSuccess()
            end
            self.uiScroll:RefreshCells()
            self.server:CheckNotificationFriendList()
        end
        local onFailed = function(logicCode)
            if callbackFailed ~= nil then
                callbackFailed(logicCode)
            end
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    ---@type FriendPointOutBound
    local friendPointOutBound = FriendPointOutBound()
    for _, v in pairs(listFriendId:GetItems()) do
        friendPointOutBound.listFriendId:Add(v)
    end
    NetworkUtils.Request(OpCode.FRIEND_POINT_SEND, friendPointOutBound, callback)
end

--- @return void
function UIFriendListView.NotiClaimSuccess()
    SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("claim_success"))
end

--- @return void
function UIFriendListView.NotiSendSuccess()
    SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("send_success"))
end

--- @return void
function UIFriendListView.NotiClaimSendSuccess()
    SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("claim_send_success"))
end

--- @return void
function UIFriendListView.NotiClaimSendFailed()
    SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("can_not_claim_send"))
end

--- @return void
---@param friendData FriendData
function UIFriendListView:ClaimFriendPoint(friendData)
    ---@type List
    local listId = List()
    listId:Add(friendData.friendId)
    self:ClaimListFriendPoint(listId, function()
        --UIFriendListView.NotiClaimSuccess()
        self.server.receivedFriendPoint = self.server.receivedFriendPoint + 1
    end, SmartPoolUtils.LogicCodeNotification)
    self.communityFriend:CheckNotificationAll()
end

--- @return void
---@param friendData FriendData
function UIFriendListView:SendFriendPoint(friendData)
    ---@type List
    local listId = List()
    listId:Add(friendData.friendId)
    self:SendListFriendPoint(listId, function()
        UIFriendListView.NotiSendSuccess()
        self.server.sentFriendPoint = self.server.sentFriendPoint + 1
    end, SmartPoolUtils.LogicCodeNotification)
    self.communityFriend:CheckNotificationAll()
end

--- @return void
---@param friendData FriendData
function UIFriendListView:RemoveFriend(friendData)
    self.server:RemoveFriend(friendData)
    self.server:CheckNotificationFriendList()
    self.communityFriend:UpdateFriendCount()

    self.uiScroll:RefreshCells(self.server.listFriendId:Count())
    self.communityFriend.config.empty:SetActive(self.server.listFriendId:Count() <= 0)

    self.heroLinkingInBound:RemoveHeroFriendInLinkingByFriendId(friendData.friendId)
    --self:Show()
end

--- @return void
---@param friendID number
function UIFriendListView:BlockFriend(friendID)
    XDebug.Log("friend id: " .. tonumber(friendID))
    self.heroLinkingInBound:RemoveHeroFriendInLinkingByFriendId(friendID)

    self.communityFriend:UpdateFriendCount()
    self.uiScroll:RefreshCells(self.server.listFriendId:Count())
    --self:Show()
end

--- @return void
function UIFriendListView:OnClickClaimAll()
    ---@type FriendConfig
    local friendConfig = ResourceMgr.GetFriendConfig()

    ---@type List
    local listClaimId = List()
    local countClaim = self.server.receivedFriendPoint
    ---@param v FriendData
    for _, v in pairs(self.server.listFriendData:GetItems()) do
        if v.stateClaimFriendPoint == RewardState.AVAILABLE_TO_CLAIM and countClaim < friendConfig.friendPointDailyLimit then
            listClaimId:Add(v.friendId)
            countClaim = countClaim + 1
        end
    end

    ---@type List
    local listSendId = List()
    local countSend = self.server.sentFriendPoint

    for i = self.server.listFriendData:Count(), 1, -1 do
        ---@type FriendData
        local v = self.server.listFriendData:Get(i)
        if self.server.listFriendStates:Get(v.friendId) ~= false and countSend < friendConfig.friendPointDailyLimit then
            listSendId:Add(v.friendId)
            countSend = countSend + 1
        end
    end
    -----@param v FriendData
    --for _, v in pairs(self.server.listFriendData:GetItems()) do
    --    if self.server.listFriendStates:Get(v.friendId) ~= false and countSend < friendConfig.friendPointDailyLimit then
    --        listSendId:Add(v.friendId)
    --        countSend = countSend + 1
    --    end
    --end

    local claim = function(success, failed)
        if listClaimId:Count() > 0 then
            self:ClaimListFriendPoint(listClaimId, function()
                self.server.receivedFriendPoint = countClaim
                self.communityFriend:FakeDisableNoti()
                self.server:CheckNotificationFriendList()
                self.communityFriend.view:RefreshTabView(true)
                RxMgr.notificationRequestCommunityTotal:Next()
                if success ~= nil then
                    success()
                end
            end, failed)
        else
            if failed ~= nil then
                failed()
            end
        end
    end

    local send = function(success, failed)
        if listSendId:Count() > 0 then
            self:SendListFriendPoint(listSendId, function()
                self.server.sentFriendPoint = countSend
                self.communityFriend:FakeDisableNoti()
                self.server:CheckNotificationFriendList()
                self.communityFriend.view:RefreshTabView(true)
                RxMgr.notificationRequestCommunityTotal:Next()
                if success ~= nil then
                    success()
                end
            end, failed)
        else
            if failed ~= nil then
                failed()
            end
        end
    end

    claim(function()
        send(UIFriendListView.NotiClaimSendSuccess, UIFriendListView.NotiClaimSuccess)
    end, function()
        send(UIFriendListView.NotiClaimSendSuccess, UIFriendListView.NotiClaimSendFailed)
    end)

end