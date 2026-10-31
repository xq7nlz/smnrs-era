---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiFriend.UIFriendSearchConfig"

--- @class UIFriendSearchView
UIFriendSearchView = Class(UIFriendSearchView)

--- @return void
--- @param transform UnityEngine_Transform
function UIFriendSearchView:Ctor(transform, communityFriend)
    --- @type PlayerFriendInBound
    self.server = nil
    --- @type UIFriendView
    self.communityFriend = communityFriend
    --- @type UIFriendSearchConfig
    ---@type UIFriendSearchConfig
    self.config = UIBaseConfig(transform)
    --- @type List
    self.listFriend = List()
    --- @type boolean
    self.isFriendSearch = false
    --- @type PlayerFriendRecommendedInBound
    self.playerFriendRecommendedInBound = nil
    -- Scroll
    --- @param obj UIFriendItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        ---@type FriendRequestData
        local friendData = self.listFriend:Get(index + 1)
        obj:SetDataFriendSearch(friendData)

        obj.callbackApplyFriend = function(data)
            self:CallbackApplyFriendSuccess(data)
        end
        obj.callbackBlock = function()
            self:BlockFriend(obj.friendData)
        end
    end

    --- @type UILoopScroll
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.UIFriendItemView, onCreateItem, onCreateItem)
    self.uiScroll:SetUpMotion(MotionConfig())

    self.config.buttonApply.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickApply()
    end)
end

--- @return void
function UIFriendSearchView:InitLocalization()
    self.config.localizeApply.text = LanguageUtils.LocalizeCommon("apply")
    self.config.localizeRecommendedFriend.text = LanguageUtils.LocalizeCommon("recommended_friend")
    if self.config.localizePlaceholder then
        self.config.localizePlaceholder.text = LanguageUtils.LocalizeCommon("enter_text")
    end
    LanguageUtils.SetLocalizeInputField(self.config.inputField)
end

---@return number
function UIFriendSearchView:RequestData(callbackSuccess, callbackFailed)
    local callback = function(result)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            self.playerFriendRecommendedInBound:ReadBuffer(buffer)
        end
        local onSuccess = function()
            if self.config.gameObject.activeInHierarchy then
                self:ShowFriendRecommendation()
            end
            if callbackSuccess ~= nil then
                callbackSuccess()
            end
        end
        local onFailed = function(logicCode)
            if callbackFailed ~= nil then
                callbackFailed(logicCode)
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FRIEND_SEARCH_RECOMMENDATION, nil, callback)
end

--- @param canPlayMotion boolean
function UIFriendSearchView:Show(canPlayMotion)
    self.canPlayMotion = canPlayMotion or false
    self.server = zg.playerData:GetMethod(PlayerDataMethod.FRIEND)
    self.playerFriendRecommendedInBound = zg.playerData:GetPlayerFriendRecommendedInBound()
    self:InitLocalization()
    self.config.inputField.text = ""
    self.isFriendSearch = false
    if self.playerFriendRecommendedInBound == nil or self.playerFriendRecommendedInBound:IsAvailableToRequest() == true then
        self:RequestData()
    else
        self:ShowFriendRecommendation()
    end
    if self.canPlayMotion == true then
        self.uiScroll:PlayMotion()
        self.canPlayMotion = false
    end
end

--- @return void
function UIFriendSearchView:ShowFriendRecommendation()
    self.playerFriendRecommendedInBound:CheckInFriendList()
    self.listFriend = self.playerFriendRecommendedInBound.listFriendData
    self.uiScroll:Resize(self.listFriend:Count())
end

---@return void
function UIFriendSearchView:Hide()
    self.uiScroll:Hide()
    self.listFriend = nil
end

---@return void
function UIFriendSearchView:Refresh()
    --self.listFriend = PlayerData.playerFriendRecommendedInBound.listFriendData
    --self.uiScroll:Resize(self.listFriend:Count())
end

---@return void
--- @param friend FriendRequestData
function UIFriendSearchView:CallbackApplyFriendSuccess(friend)
    if self.isFriendSearch == true then
        self.uiScroll:Resize(0)
    else
        self.playerFriendRecommendedInBound.listFriendData:RemoveByReference(friend)
        self.listFriend = self.playerFriendRecommendedInBound.listFriendData
        self.uiScroll:RefreshCells(self.listFriend:Count())
    end
end

---@return void
--- @param friend FriendRequestData
function UIFriendSearchView:BlockFriend(friend)
    if self.isFriendSearch == false then
        self.listFriend = self.playerFriendRecommendedInBound.listFriendData
        self.uiScroll:RefreshCells(self.listFriend:Count())
    end
end

---@return number
function UIFriendSearchView:OnClickApply()
    if self.config.inputField.text ~= nil and self.config.inputField.text ~= "" then
        if self.config.inputField.text ~= tostring(PlayerSettingData.playerId) then
            local friendData
            local callback = function(result)
                --- @param buffer UnifiedNetwork_ByteBuf
                local onBufferReading = function(buffer)
                    local size = buffer:GetByte()
                    friendData = FriendRequestData.CreateByBuffer(buffer)
                    XDebug.Log("FriendData" .. LogUtils.ToDetail(friendData))
                end
                local onSuccess = function()
                    XDebug.Log("Search success")
                    self.listFriend = List()
                    self.listFriend:Add(friendData)
                    self.isFriendSearch = true
                    self.uiScroll:Resize(self.listFriend:Count())
                end
                local onFailed = function(logicCode)
                    if logicCode ~= LogicCode.FRIEND_REQUEST_ALREADY_EXISTED then
                        XDebug.Log("Search Failed")
                        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("search_failed"))
                        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
                    else
                        onSuccess()
                    end
                end
                NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
            end
            NetworkUtils.Request(OpCode.FRIEND_SEARCH, UnknownOutBound.CreateInstance(PutMethod.Long, tonumber(self.config.inputField.text)), callback)
        else
            XDebug.Log("Search Current Player")
        end
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("need_input_friend_id"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end
end