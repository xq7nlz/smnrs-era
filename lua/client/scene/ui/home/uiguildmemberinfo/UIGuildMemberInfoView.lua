---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiGuildMemberInfo.UIGuildMemberInfoConfig"
require "lua.client.scene.ui.common.BattleTeamView"

--- @class UIGuildMemberInfoView : UIBaseView
UIGuildMemberInfoView = Class(UIGuildMemberInfoView, UIBaseView)

--- @return void
--- @param model UIGuildMemberInfoModel
function UIGuildMemberInfoView:Ctor(model)
    --- @type UIGuildMemberInfoConfig
    self.config = nil
    --- @type BattleTeamView
    self.battleTeamView = nil
    --- @type VipIconView
    self.iconVip = nil
    UIBaseView.Ctor(self, model)
    --- @type UIGuildMemberInfoModel
    self.model = model
end

--- @return void
function UIGuildMemberInfoView:OnReadyCreate()
    ---@type UIGuildMemberInfoConfig
    self.config = UIBaseConfig(self.uiTransform)

    self:_InitButtonListener()
end

--- @return void
function UIGuildMemberInfoView:InitLocalization()
    self.config.localizeDefensiveLineup.text = LanguageUtils.LocalizeCommon("defense")
    self.config.localizeSendMail.text = LanguageUtils.LocalizeCommon("send_mail")
    self.config.localizeDemote.text = LanguageUtils.LocalizeCommon("demote")
    self.config.localizeKick.text = LanguageUtils.LocalizeCommon("kick")
    self.config.localizePromote.text = LanguageUtils.LocalizeCommon("promote")
end

function UIGuildMemberInfoView:_InitButtonListener()
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonAddFriend.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickAddFriend()
    end)
    self.config.buttonKick.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickKick()
    end)
    self.config.buttonPromote.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickChangeRole(true)
    end)
    self.config.buttonDemote.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickChangeRole(false)
    end)
    self.config.buttonSendMail.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSendMail()
    end)
end

function UIGuildMemberInfoView:OnClickAddFriend()
    FriendRequest.RequestAddFriend(self.model.guildMemberInfo.playerId, function()
        self:OnClickBackOrClose()
    end)
end

function UIGuildMemberInfoView:OnClickKick()
    local yesCallback = function()
        local onReceived = function(result)
            local onSuccess = function()
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("member_kick_guild"))
                self:OnReadyHide()
                RxMgr.updateGuildInfo:Next()
            end

            local onFailed = function(logicCode)
                SmartPoolUtils.LogicCodeNotification(logicCode)
                zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            end
            NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
        end
        NetworkUtils.Request(OpCode.GUILD_MEMBER_KICK, UnknownOutBound.CreateInstance(PutMethod.Long, self.model.guildMemberInfo.playerId), onReceived)
    end
    PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("wanna_kick_member"), nil, yesCallback)
end

--- @param isPromote boolean
function UIGuildMemberInfoView:OnClickChangeRole(isPromote)
    --- @type GuildRole
    local newMemberRole
    if isPromote == true then
        newMemberRole = GuildRole.SUB_LEADER
    else
        newMemberRole = GuildRole.MEMBER
    end

    local onSuccess = function()
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("member_role_changed"))
        self:OnReadyHide()
        RxMgr.updateGuildInfo:Next()
    end
    GuildBasicInfoInBound.RequestChangeMemberRole(self.model.guildMemberInfo.playerId, newMemberRole, onSuccess)
end

function UIGuildMemberInfoView:OnClickSendMail()
    PopupMgr.ShowPopup(UIPopupName.UIFriendMail, { ["id"] = self.model.guildMemberInfo.playerId })
end

--- @param result {guildMemberInBound, selfRole, memberRole, otherPlayerInfoInBound: OtherPlayerInfoInBound}
function UIGuildMemberInfoView:OnReadyShow(result)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    self.model.guildMemberInfo = result.guildMemberInBound
    self.model.selfRole = result.selfRole
    self.model.memberRole = result.memberRole

    self:ShowButtonByRole()
    self:ShowMemberInfo(result.otherPlayerInfoInBound)
end

function UIGuildMemberInfoView:ShowButtonByRole()
    self.config.buttonKick.gameObject:SetActive(false)
    self.config.buttonPromote.gameObject:SetActive(false)
    self.config.buttonDemote.gameObject:SetActive(false)

    if self.model.selfRole == GuildRole.LEADER then
        self.config.buttonKick.gameObject:SetActive(true)
        if self.model.memberRole == GuildRole.MEMBER then
            self.config.buttonPromote.gameObject:SetActive(true)
        end
        if self.model.memberRole == GuildRole.SUB_LEADER then
            self.config.buttonDemote.gameObject:SetActive(true)
        end
    elseif self.model.selfRole == GuildRole.SUB_LEADER then
        if self.model.memberRole == GuildRole.MEMBER then
            self.config.buttonKick.gameObject:SetActive(true)
        end
    end
    --- @type PlayerFriendInBound
    local playerFriendInBound = zg.playerData:GetMethod(PlayerDataMethod.FRIEND)
    self.config.buttonAddFriend.gameObject:SetActive(playerFriendInBound:IsContainFriend(self.model.guildMemberInfo.playerId) == false)
end

--- @param otherPlayerInfoInBound OtherPlayerInfoInBound
function UIGuildMemberInfoView:ShowMemberInfo(otherPlayerInfoInBound)
    self.config.textPlayerName.text = self.model.guildMemberInfo.playerName
    self.config.textPlayerId.text = string.format("%s: %s", LanguageUtils.LocalizeCommon("id"), UIUtils.SetColorString(UIUtils.color2, self.model.guildMemberInfo.playerId))
    self.config.textPlayerRole.text = string.format("%s: %s", LanguageUtils.LocalizeCommon("role"), UIUtils.SetColorString(UIUtils.color2, GuildRole.RoleName(self.model.memberRole)))
    if self.iconVip == nil then
        self.iconVip = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipIconView, self.config.playerAvatarAnchor)
    end
    self.iconVip:SetData2(self.model.guildMemberInfo.playerAvatar, self.model.guildMemberInfo.playerLevel)

    self:ViewMemberBattleTeam(otherPlayerInfoInBound)
end

--- @param otherPlayerInfoInBound OtherPlayerInfoInBound
function UIGuildMemberInfoView:ViewMemberBattleTeam(otherPlayerInfoInBound)
    --- @type SummonerBattleInfo
    local summonerBattleInfo = otherPlayerInfoInBound.summonerBattleInfoInBound.summonerBattleInfo
    --- @type BattleTeamInfo
    local battleTeamInfo = otherPlayerInfoInBound:CreateBattleTeamInfo(otherPlayerInfoInBound.playerLevel)

    self.battleTeamView = BattleTeamView(self.config.teamAnchor)
    self.battleTeamView:Show()

    self.battleTeamView:SetDataDefender(UIPoolType.HeroIconView, battleTeamInfo)
    self.battleTeamView.uiTeamView:SetSummonerInfo(summonerBattleInfo)
    self.battleTeamView.uiTeamView:ActiveBuff(false)
    self.battleTeamView.uiTeamView:ActiveLinking(false)

    local power = ClientConfigUtils.GetPowerByBattleTeamInfo(battleTeamInfo, false)
    self.config.textPlayerCp.text = tostring(math.floor(power))
end

function UIGuildMemberInfoView:Hide()
    UIBaseView.Hide(self)
    if self.battleTeamView ~= nil then
        self.battleTeamView:Hide()
        self.battleTeamView = nil
    end

    if self.iconVip ~= nil then
        self.iconVip:ReturnPool()
        self.iconVip = nil
    end
end