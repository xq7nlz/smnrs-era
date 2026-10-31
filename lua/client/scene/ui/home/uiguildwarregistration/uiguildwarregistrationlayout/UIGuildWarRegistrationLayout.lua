--- @class UIGuildWarRegistrationLayout
UIGuildWarRegistrationLayout = Class(UIGuildWarRegistrationLayout)

--- @param view UIGuildWarRegistrationView
function UIGuildWarRegistrationLayout:Ctor(view)
    --- @type UIGuildWarRegistrationView
    self.view = view
    --- @type UIGuildWarRegistrationModel
    self.model = view.model
    --- @type UIGuildWarRegistrationConfig
    self.config = view.config
end

function UIGuildWarRegistrationLayout:OnShow()
    self:ShowGuildInfo()
    self:ShowMessage()
end

function UIGuildWarRegistrationLayout:OnHide()

end

function UIGuildWarRegistrationLayout:ShowGuildInfo()
    self.config.iconGuild.sprite = ResourceLoadUtils.LoadGuildIcon(self.view.guildBasicInfo.guildInfo.guildAvatar)
    self.config.iconGuild:SetNativeSize()
    self.config.guildName.text = self.view.guildBasicInfo.guildInfo.guildName

    local registeredMember = self.view.guildWarInBound:CountTotalParticipants()
    local minRequire = self.view.csvConfig:GetGuildWarConfig().numberMemberJoin
    local color = UIUtils.color2
    if registeredMember < minRequire then
        color = UIUtils.color7
    end
    self.config.registrationCount.text = string.format("%s: <color=#%s>%d/%d</color>", LanguageUtils.LocalizeCommon("registered_member"), color,
            registeredMember, self.view.csvConfig:GetGuildWarConfig().numberMemberJoin)
end

function UIGuildWarRegistrationLayout:ShowMessage()
    local message = string.format(LanguageUtils.LocalizeCommon("message_phase_" .. self.view.currentPhase))
    message = string.gsub(message, "{1}", UIUtils.SetColorString(UIUtils.color7, tostring(self.view.csvConfig:GetGuildWarConfig().numberMemberJoin)))
    message = string.gsub(message, "{2}", UIUtils.SetColorString(UIUtils.color7, LanguageUtils.LocalizeCommon("guild_war_phase_2_name")))
    self.config.localizePhaseMessage.text = message
end

function UIGuildWarRegistrationLayout:OnDefenderUpdated()
    self.view:OnClickBackOrClose()
end

--- @class GuildWarRegistrationLayoutType
GuildWarRegistrationLayoutType = {
    CHECK_OUT_REGISTRATION = 1,
    CHECK_OUT_SELECTED = 2,
}
