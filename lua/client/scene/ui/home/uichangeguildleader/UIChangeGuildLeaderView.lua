---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiChangeGuildLeader.UIChangeGuildLeaderConfig"

--- @class UIChangeGuildLeaderView : UIBaseView
UIChangeGuildLeaderView = Class(UIChangeGuildLeaderView, UIBaseView)

--- @return void
--- @param model UIChangeGuildLeaderModel
function UIChangeGuildLeaderView:Ctor(model)
    --- @type UIChangeGuildLeaderConfig
    self.config = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type GuildBasicInfoInBound
    self.guildBasicInfo = nil
    UIBaseView.Ctor(self, model)
    --- @type UIChangeGuildLeaderModel
    self.model = model
end

--- @return void
function UIChangeGuildLeaderView:OnReadyCreate()
    ---@type UIChangeGuildLeaderConfig
    self.config = UIBaseConfig(self.uiTransform)
    self:_InitButtonListener()
    self:_InitScrollView()
end

function UIChangeGuildLeaderView:_InitButtonListener()
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

function UIChangeGuildLeaderView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("guild_member_list")
end

function UIChangeGuildLeaderView:_InitScrollView()
    --- @param obj UIGuildMemberSlotItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type GuildMemberInBound
        local memberInfo = self.guildBasicInfo:GetMemberByIndex(dataIndex)
        if memberInfo ~= nil then
            local onSetLeader = nil
            if memberInfo.playerId ~= PlayerSettingData.playerId then
                onSetLeader = function()
                    self:OnSetMemberAsLeader(memberInfo)
                end
            end
            obj.popupName = UIPopupName.UIChangeGuildLeader
            obj:SetData(memberInfo, self.guildBasicInfo:GetMemberRoleById(memberInfo.playerId),
                    nil, nil, onSetLeader)
        end
    end
    --- @param obj UIGuildMemberSlotItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        onCreateItem(obj, index)
    end
    self.uiScroll = UILoopScroll(self.config.memberScroll, UIPoolType.MemberSlotItemView, onCreateItem, onUpdateItem)
end

--- @param memId number
function UIChangeGuildLeaderView:GetRoleName(memId)
    --- @type GuildRole
    local memberRole = self.guildBasicInfo:GetMemberRoleById(memId)
    return GuildRole.RoleName(memberRole)
end

function UIChangeGuildLeaderView:OnReadyShow()
    --- @type GuildBasicInfoInBound
    self.guildBasicInfo = zg.playerData:GetMethod(PlayerDataMethod.GUILD_BASIC_INFO)
    local guildInfoInBound = self.guildBasicInfo.guildInfo
    self.uiScroll:Resize(guildInfoInBound.listGuildMember:Count())
end

--- @param memberInfo GuildMemberInBound
function UIChangeGuildLeaderView:OnSetMemberAsLeader(memberInfo)
    local onAccept = function()
        local onSuccess = function()
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("member_role_changed"))
            self:OnReadyHide()
            RxMgr.updateGuildInfo:Next({ ['forceShowGuildInfo'] = true })
        end
        GuildBasicInfoInBound.RequestChangeMemberRole(memberInfo.playerId, GuildRole.LEADER, onSuccess)
    end
    local askConfirm = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("confirm_change_leader"),
            string.format("<color=#%s>%s</color>", UIUtils.color2, memberInfo.playerName),
            GuildRole.RoleName(GuildRole.LEADER))
    PopupUtils.ShowPopupNotificationYesNo(askConfirm, nil, onAccept)
end

