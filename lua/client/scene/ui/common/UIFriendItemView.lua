---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.UIFriendItemConfig"
require "lua.client.core.network.otherPlayer.OtherPlayerInfoInBound"
require "lua.client.core.network.friend.FriendRequest"

--- @class UIFriendItemView : MotionIconView
UIFriendItemView = Class(UIFriendItemView, MotionIconView)

--- @return void
function UIFriendItemView:Ctor()
    self:Init()
    ---@type VipIconView
    self.heroIconView = nil
    MotionIconView.Ctor(self)
end

--- @return void
function UIFriendItemView:Init()
    ---@type FriendData
    self.friendData = nil
    ---@type RewardState
    self.stateFriendPoint = nil

    self.callbackClaimFriendPoint = nil
    self.callbackSendFriendPoint = nil
    self.callbackApplyFriend = nil
    self.callbackConfirmFriend = nil
    self.callbackRemoveFriend = nil
    self.callbackAddFriend = nil
    self.callbackBlock = nil
end

--- @return void
function UIFriendItemView:SetPrefabName()
    self.prefabName = 'friend_item_view'
    self.uiPoolType = UIPoolType.UIFriendItemView
end

--- @return void
function UIFriendItemView:InitLocalization()
    self.config.localizeApply.text = LanguageUtils.LocalizeCommon("apply")
    self.config.localizeConfirm.text = LanguageUtils.LocalizeCommon("confirm")
    self.config.localizeDelete.text = LanguageUtils.LocalizeCommon("delete")
end

--- @return void
--- @param transform UnityEngine_Transform
function UIFriendItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    --- @type UIFriendItemConfig
    self.config = UIBaseConfig(transform)
    self.config.buttonPvp.onClick:AddListener(function()
        self:OnClickPVP()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.buttonHeart1.onClick:AddListener(function()
        self:OnClickHeart1()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.buttonHeart2.onClick:AddListener(function()
        self:OnClickHeart2()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)

    self.config.buttonApply.onClick:AddListener(function()
        self:OnClickApply()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)

    self.config.buttonConfirm.onClick:AddListener(function()
        self:OnClickConfirm()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.buttonDelete.onClick:AddListener(function()
        self:OnClickDelete()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

--- @return void
---@param friendData FriendData
---@param stateFriendPoint RewardState
function UIFriendItemView:SetDataFriendList(friendData, stateFriendPoint)
    self.friendData = friendData
    self.stateFriendPoint = stateFriendPoint
    self:UpdateUI()

    self.config.buttonFriendList:SetActive(true)
    self.config.buttonFriendAdd:SetActive(false)
    self.config.buttonApply.gameObject:SetActive(false)

    UIUtils.SetInteractableButton(self.config.buttonHeart1, (friendData.stateClaimFriendPoint == RewardState.AVAILABLE_TO_CLAIM))
    UIUtils.SetInteractableButton(self.config.buttonHeart2, (stateFriendPoint == nil or stateFriendPoint == true))
end

--- @return void
---@param friendData FriendRequestData
function UIFriendItemView:SetDataFriendSearch(friendData)
    self.friendData = friendData
    self:UpdateUI()
    local canAddFriend = true
    if zg.playerData:GetMethod(PlayerDataMethod.FRIEND) ~= nil then
        ---@param otherFriendData FriendData
        for _, otherFriendData in pairs(zg.playerData:GetMethod(PlayerDataMethod.FRIEND).listFriendData:GetItems()) do
            if otherFriendData.friendId == self.friendData.friendId then
                canAddFriend = false
                break
            end
        end
    end
    self.config.buttonFriendList:SetActive(false)
    self.config.buttonFriendAdd:SetActive(false)
    self.config.buttonApply.gameObject:SetActive(canAddFriend)
end

--- @return void
---@param friendData FriendRequestData
function UIFriendItemView:SetDataFriendAdd(friendData)
    self.friendData = friendData
    self:UpdateUI()
    self.config.buttonFriendList:SetActive(false)
    self.config.buttonFriendAdd:SetActive(true)
    self.config.buttonApply.gameObject:SetActive(false)
end

--- @return void
function UIFriendItemView:UpdateUI()
    self.config.textUserName.text = self.friendData.friendName
    self.config.textEventTimeJoin.text = UIUtils.SetColorString(UIUtils.color2, TimeUtils.GetDeltaTimeAgo(zg.timeMgr:GetServerTime() - self.friendData.lastLoginTime))
    if self.heroIconView == nil then
        self.heroIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipIconView, self.config.iconHero)
    end
    self.heroIconView:SetData2(self.friendData.friendAvatar, self.friendData.friendLevel)
    self.heroIconView:RemoveAllListeners()
    self.heroIconView:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickInfo()
    end)
end

--- @return void
function UIFriendItemView:ReturnPool()
    MotionIconView.ReturnPool(self)
    self:Init()
    if self.heroIconView ~= nil then
        self.heroIconView:ReturnPool()
        self.heroIconView = nil
    end
end

--- @return void
function UIFriendItemView:OnClickPVP()
    self.friendData:GetOtherPlayerInfoInBound(function(_otherPlayerInfoInBound)
        ---@type OtherPlayerInfoInBound
        local otherPlayerInfoInBound = _otherPlayerInfoInBound
        if otherPlayerInfoInBound.detailsTeamFormation.backLineDict:Count() > 0 or
                otherPlayerInfoInBound.detailsTeamFormation.frontLineDict:Count() > 0 then
            local data = {}
            data.gameMode = GameMode.FRIEND_BATTLE
            data.battleTeamInfo = otherPlayerInfoInBound:CreateBattleTeamInfo(self.friendData.friendLevel, BattleConstants.DEFENDER_TEAM_ID)
            data.callbackPlayBattle = function(uiFormationTeamData, callback)
                local callbackSuccess = function()
                    zg.playerData.rewardList = nil
                    ---@type BasicInfoInBound
                    local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
                    zg.battleMgr.attacker = {
                        ["avatar"] = basicInfoInBound.avatarData:GetMyPlayerAvatar(),
                        ["level"] = basicInfoInBound.level,
                        ["name"] = basicInfoInBound.name
                    }
                    zg.battleMgr.defender = {
                        ["avatar"] = otherPlayerInfoInBound.playerAvatar,
                        ["level"] = otherPlayerInfoInBound.playerLevel,
                        ["name"] = otherPlayerInfoInBound.playerName
                    }
                    if callback ~= nil then
                        callback()
                    end
                end

                callbackSuccess()
            end
            data.callbackClose = function()
                --TODO Logic cu
                --PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIFormation)
                --PopupMgr.ShowPopup(UIPopupName.UIFriend)
                --TODO Logic moi
                PopupMgr.ShowAndHidePopup(UIPopupName.UICommunityTotal, CommunityTotalTab.Friend, UIPopupName.UIFormation)
            end
            --TODO Logic cu
            --PopupMgr.ShowAndHidePopup(UIPopupName.UIFormation, data, UIPopupName.UIFriend, UIPopupName.UIMainArea)
            --TODO Logic moi
            PopupMgr.ShowAndHidePopup(UIPopupName.UIFormation, data, UIPopupName.UICommunityTotal)
        else
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("friend_not_save_formation"))
        end
    end)
end

--- @return void
function UIFriendItemView:OnClickHeart1()
    if self.callbackClaimFriendPoint ~= nil then
        self.callbackClaimFriendPoint()
    end
end

--- @return void
function UIFriendItemView:OnClickHeart2()
    if self.callbackSendFriendPoint ~= nil then
        self.callbackSendFriendPoint()
    end
end

--- @return void
function UIFriendItemView:OnClickApply()
    FriendRequest.RequestAddFriend(self.friendData.friendId,
            function()
                if self.callbackApplyFriend ~= nil then
                    self.callbackApplyFriend(self.friendData)
                end
            end
    )
end

--- @return void
function UIFriendItemView:OnClickConfirm()
    if self.callbackConfirmFriend ~= nil then
        self.callbackConfirmFriend(true)
    end
end

--- @return void
function UIFriendItemView:OnClickDelete()
    if self.callbackConfirmFriend ~= nil then
        self.callbackConfirmFriend(false)
    end
end

--- @return void
function UIFriendItemView:OnClickInfo()
    self.friendData:GetOtherPlayerInfoInBound(function(_otherPlayerInfoInBound)
        ---@type OtherPlayerInfoInBound
        local otherPlayerInfoInBound = _otherPlayerInfoInBound
        local data = {}
        data.callbackRemoveFriend = function()
            if self.callbackRemoveFriend ~= nil then
                self.callbackRemoveFriend(self.friendData)
            end
        end
        data.callbackAddFriend = function()
            if self.callbackApplyFriend ~= nil then
                self.callbackApplyFriend(self.friendData)
            end
        end
        data.callbackBlock = self.callbackBlock
        data.playerId = self.friendData.friendId
        data.userName = self.friendData.friendName
        data.avatar = self.friendData.friendAvatar
        data.level = self.friendData.friendLevel
        data.guildName = otherPlayerInfoInBound.guildName
        data.battleTeamInfo = otherPlayerInfoInBound:CreateBattleTeamInfo(self.friendData.friendLevel, BattleConstants.DEFENDER_TEAM_ID)
        data.mastery = otherPlayerInfoInBound.summonerBattleInfoInBound.masteryDict
        data.canAdd = true
        data.canDelete = true
        data.canBlock = true
        data.canSendMail = true
        PopupMgr.ShowPopup(UIPopupName.UIPreviewFriend, data)
    end)
end

return UIFriendItemView