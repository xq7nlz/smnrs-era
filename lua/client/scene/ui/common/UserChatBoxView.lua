---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiChat.UserChatViewConfig"

--- @class UserChatBoxView : UIPrefabView
UserChatBoxView = Class(UserChatBoxView, UIPrefabView)

--- @return void
function UserChatBoxView:Ctor()
    ---@type string
    self.prefabName = nil
    ---@type UIPoolType
    self.uiPoolType = nil
    ---@type UserChatViewConfig
    self.config = nil
    ---@type VipIconView
    self.userAvatar = nil
    ---@type ChatMessageInBound
    self.chatMessageInBound = nil

    UIPrefabView.Ctor(self)
end

--- @return void
function UserChatBoxView:SetPrefabName()
    self.prefabName = 'user_chat_box'
    self.uiPoolType = UIPoolType.UserChatBoxView
end

--- @return void
--- @param transform UnityEngine_Transform
function UserChatBoxView:SetConfig(transform)
    ---@type UserChatViewConfig
    self.config = UIBaseConfig(transform)
end

function UserChatBoxView:InitLocalization()
    self.config.localizeJoin.text = LanguageUtils.LocalizeCommon("join")
end

--- @param message ChatMessageInBound
function UserChatBoxView:SetData(message)
    self:IEShow(message)
end

---@param message ChatMessageInBound
function UserChatBoxView:IEShow(message)
    self.chatMessageInBound = message
    self:ShowUserChatBox()
    self:ShowUserAvatar()
end

--- @return void
function UserChatBoxView:ShowUserChatBox()
    ---@type string
    local message = self.chatMessageInBound.messageInBound.message

    --if self.chatMessageInBound.isSeen == false then
    --    message = ClientConfigUtils.FilterBannedWord(self.chatMessageInBound.chatMessage.messageOfGuildLeader)
    --    message = StringUtils.Wrap(StringUtils.SplitTooLongWord(message))
    --    self.chatMessageInBound.isSeen = true
    --end

    self.config.textChatGuest.text = message
    self.config.textGuestNameServer.text = string.format("%s <color=#bafe05>%s</color>",
            self.chatMessageInBound:GetName(), TimeUtils.GetTimeFromNow(self.chatMessageInBound.createdTimeInSeconds))
    --self.config.textChatTimeGuest.text = self:GetTimeFromNow(self.chatMessageInBound.createdTimeInSeconds)
    self:ShowRecruitInfo()
end

function UserChatBoxView:ShowRecruitInfo()
    self.config.buttonJoin.onClick:RemoveAllListeners()

    if self.chatMessageInBound.chatMessageType == ChatMessageType.GUILD_RECRUIT then
        --- @type RecruitMessageInBound
        local messageInBound = self.chatMessageInBound.messageInBound
        self.config.buttonJoin.transform.parent.gameObject:SetActive(true)
        local onJoinGuildButtonClick = function()
            GuildRequest.RequestJoin(self.chatMessageInBound.idOfGuild)
        end
        self.config.buttonJoin.onClick:AddListener(onJoinGuildButtonClick)

        local guild = string.format("[Lv.%d] %s", messageInBound.guildLevel, messageInBound.guildName)
        self.config.textGuildNameLevelGuest.text = guild
        self.config.textGuildNameLevelGuest.gameObject:SetActive(true)
    elseif self.chatMessageInBound.chatMessageType == ChatMessageType.DOMAIN_CREW_RECRUIT then
        --- @type DomainRecruitMessageInBound
        local messageInBound = self.chatMessageInBound.messageInBound

        self.config.buttonJoin.transform.parent.gameObject:SetActive(true)
        local onJoinGuildButtonClick = function()
            DomainInBound.RequestJoin(messageInBound.crewId)
        end
        self.config.buttonJoin.onClick:AddListener(onJoinGuildButtonClick)
        self.config.textGuildNameLevelGuest.text = messageInBound.crewName
        self.config.textGuildNameLevelGuest.gameObject:SetActive(true)
    else
        self.config.buttonJoin.transform.parent.gameObject:SetActive(false)
        self.config.textGuildNameLevelGuest.gameObject:SetActive(false)
    end
end

--- @return void
function UserChatBoxView:ShowUserAvatar()
    self.userAvatar = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipIconView, self.config.userAvatar)
    self.userAvatar:SetData2(self.chatMessageInBound:GetAvatar(), self.chatMessageInBound:GetLevel())
    local onUserAvatarClick = function()
        if self.chatMessageInBound.playerId ~= PlayerSettingData.playerId then
            self:ViewUserBattleTeam()
        else
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("player_already_show_info"))
        end
    end
    self.userAvatar:AddListener(onUserAvatarClick)
end

---@return void
function UserChatBoxView:ViewUserBattleTeam()
    local previewPlayerInfoDict = zg.playerData:GetChatData().previewPlayerInfoDict
    if previewPlayerInfoDict == nil then
        return
    end

    if previewPlayerInfoDict:IsContainKey(self.chatMessageInBound.playerId) == false then
        --- @param otherPlayerInfoInBound OtherPlayerInfoInBound
        local onGetOtherPlayerInfoSuccess = function(otherPlayerInfoInBound)
            previewPlayerInfoDict:Add(self.chatMessageInBound.playerId, otherPlayerInfoInBound)
            self:ShowUserBattleTeam(otherPlayerInfoInBound)
        end
        NetworkUtils.SilentRequestOtherPlayerInfoInBoundByGameMode(self.chatMessageInBound.playerId, GameMode.ARENA, onGetOtherPlayerInfoSuccess)
    else
        self:ShowUserBattleTeam(previewPlayerInfoDict:Get(self.chatMessageInBound.playerId))
    end
end

---@param otherPlayerInfoInBound OtherPlayerInfoInBound
---@return void
function UserChatBoxView:ShowUserBattleTeam(otherPlayerInfoInBound)
    --XDEbug.Log("UserChatBoxView:ShowUserBattleTeam")
    local data = {}
    data.playerId = self.chatMessageInBound.playerId
    data.userName = self.chatMessageInBound:GetName()
    data.avatar = self.chatMessageInBound:GetAvatar()
    data.level = self.chatMessageInBound:GetLevel()
    data.guildName = otherPlayerInfoInBound.guildName
    data.battleTeamInfo = otherPlayerInfoInBound:CreateBattleTeamInfo(data.level, 2)
    data.mastery = otherPlayerInfoInBound.summonerBattleInfoInBound.masteryDict
    data.canAdd = true
    data.canSendMail = true
    data.canBlock = true
    PopupMgr.ShowPopup(UIPopupName.UIPreviewFriend, data)
end

--- @return void
function UserChatBoxView:ReturnPool()
    UIPrefabView.ReturnPool(self)
    if self.userAvatar then
        self.userAvatar:ReturnPool()
        self.userAvatar = nil
    end
end

return UserChatBoxView

