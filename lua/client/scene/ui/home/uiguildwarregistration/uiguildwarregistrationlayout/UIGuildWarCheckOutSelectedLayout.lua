--- @class UIGuildWarCheckOutSelectedLayout : UIGuildWarRegistrationLayout
UIGuildWarCheckOutSelectedLayout = Class(UIGuildWarCheckOutSelectedLayout, UIGuildWarRegistrationLayout)

--- @param view UIGuildWarRegistrationView
function UIGuildWarCheckOutSelectedLayout:Ctor(view)
    --- @type GuildWarEloPositionConfig
    self.eloPositionConfig = ResourceMgr.GetGuildDataConfig():GetGuildWarDataConfig():GetGuildWarEloPositionConfig()
    UIGuildWarRegistrationLayout.Ctor(self, view)
end

function UIGuildWarCheckOutSelectedLayout:OnShow()
    self.view.currentPhase = GuildWarPhase.SETUP_DEFENDER
    UIGuildWarRegistrationLayout.OnShow(self)
    self:SetDataSelectedForGuildWar()
    self.config.buttonCheckOutDefender.gameObject:SetActive(true)
end

function UIGuildWarCheckOutSelectedLayout:SetDataSelectedForGuildWar()
    self:_InitScrollMember()
    self.view.scrollMember:Resize(self.view.guildWarInBound:GetListSelectedMemberInGuildWar():Count())
end

function UIGuildWarCheckOutSelectedLayout:_InitScrollMember()
    --- @param obj UIGuildWarRegistrationItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type GuildWarPlayerInBound
        local guildWarPlayerInBound = self.view.guildWarInBound:GetListSelectedMemberInGuildWar():Get(dataIndex)
        obj:SetData(guildWarPlayerInBound, self.view.guildBasicInfo:GetMemberRoleById(guildWarPlayerInBound.compactPlayerInfo.playerId))
        obj:SetMedalData(true)
        obj:SetBattleTeamViewPosition(false)
        local elo = self.eloPositionConfig:GetEloByPosition(dataIndex)
        obj:SetMedalData(dataIndex, elo)
    end
    self.view.scrollMember = UILoopScroll(self.config.scrollMember, UIPoolType.GuildWarRegistrationItem, onCreateItem)
end


function UIGuildWarCheckOutSelectedLayout:ShowMessage()
    local message
    if self.view.guildWarInBound:CountSelectedForGuildWar() > 0 then
        message = LanguageUtils.LocalizeCommon("guild_war_setup_can_be_modified")
        message = string.gsub(message, "{1}", UIUtils.SetColorString(UIUtils.color7, LanguageUtils.LocalizeCommon("guild_war_phase_3_name")))
    else
        message = LanguageUtils.LocalizeCommon("message_phase_2")
        message = string.gsub(message, "{1}", UIUtils.SetColorString(UIUtils.color7, LanguageUtils.LocalizeCommon("guild_war_phase_2_name")))
    end
    self.config.localizePhaseMessage.text = message
end

function UIGuildWarCheckOutSelectedLayout:OnDefenderUpdated()
    self.view.scrollMember:Resize(self.view.guildWarInBound:GetListSelectedMemberInGuildWar():Count())
end