--- @class UIGuildLogItemView : IconView
UIGuildLogItemView = Class(UIGuildLogItemView, IconView)

function UIGuildLogItemView:Ctor()
    IconView.Ctor(self)
end

function UIGuildLogItemView:SetPrefabName()
    self.prefabName = 'guild_log_item_view'
    self.uiPoolType = UIPoolType.GuildLogItem
end

--- @param transform UnityEngine_Transform
function UIGuildLogItemView:SetConfig(transform)
    --- @type UIGuildLogItemViewConfig
    ---@type UIGuildLogItemViewConfig
    self.config = UIBaseConfig(transform)
end

--- @param parent UnityEngine_RectTransform
--- @param data {firstPlayerId, firstPlayerName, logActionType, createdTimeInSec, secondPlayerId, secondPlayerName}
function UIGuildLogItemView:SetData(parent, data)
    self.config.guildLogItemView:SetParent(parent)
    self.config.guildLogItemView.anchoredPosition3D = U_Vector3.zero
    self.config.textLog.text = self:GetTextFromAction(data)
    self.config.gameObject:SetActive(true)
end

--- @return string
--- @param data {firstPlayerId, firstPlayerName, logActionType, createdTimeInSec, secondPlayerId, secondPlayerName}
function UIGuildLogItemView:GetTextFromAction(data)
    local content
    local localize = ""
    --- @type GuildLogActionType
    local logActionType = data.logActionType
    if logActionType == GuildLogActionType.JOIN_GUILD then
        localize = StringUtils.FormatLocalize(LanguageUtils.LocalizeCommon("guild_log_join"),
                UIUtils.SetColorString(UIUtils.color2, data.firstPlayerName))
    elseif logActionType == GuildLogActionType.LEAVE_GUILD then
        localize = StringUtils.FormatLocalize(LanguageUtils.LocalizeCommon("guild_log_leave"),
                UIUtils.SetColorString(UIUtils.color2, data.firstPlayerName))
    elseif logActionType == GuildLogActionType.ASSIGN_LEADER then
        localize = StringUtils.FormatLocalize(LanguageUtils.LocalizeCommon("guild_log_assign_leader"),
                UIUtils.SetColorString(UIUtils.color2, data.firstPlayerName),
                UIUtils.SetColorString(UIUtils.color2, data.secondPlayerName))
    elseif logActionType == GuildLogActionType.ASSIGN_SUB_LEADER then
        localize = StringUtils.FormatLocalize(LanguageUtils.LocalizeCommon("guild_log_assign_sub_leader"),
                UIUtils.SetColorString(UIUtils.color2, data.firstPlayerName),
                UIUtils.SetColorString(UIUtils.color2, data.secondPlayerName))
    elseif logActionType == GuildLogActionType.KICK_OUT then
        localize = StringUtils.FormatLocalize(LanguageUtils.LocalizeCommon("guild_log_kick_out"),
                UIUtils.SetColorString(UIUtils.color2, data.firstPlayerName))
    end
    content = string.format("<size=32>%s</size>", localize)
    content = string.format("* %s>\n%s", content, TimeUtils.GetTimeFromDateTime(data.createdTimeInSec))
    return content
end

return UIGuildLogItemView