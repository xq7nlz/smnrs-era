--- @class UIGuildWarPhase3MainTopInfoView
UIGuildWarPhase3MainTopInfoView = Class(UIGuildWarPhase3MainTopInfoView)

--- @param transform UnityEngine_Transform
function UIGuildWarPhase3MainTopInfoView:Ctor(transform)
    --- @type UIGuildWarPhase3MainTopInfoConfig
    self.config = UIBaseConfig(transform)
end

--- @param guildWarInBound GuildWarInBound
function UIGuildWarPhase3MainTopInfoView:SetInfo(guildWarInBound, isMyGuild)
    self.config.textGuildName.text = guildWarInBound.guildName
    local guildWarConfig = ResourceMgr.GetGuildDataConfig():GetGuildWarDataConfig():GetGuildWarConfig()
    local maxNumberAttack = guildWarConfig.numberMemberJoin * guildWarConfig.numberAttackPerBattle
    local attackLeft = maxNumberAttack - guildWarInBound.numberAttack
    local color = UIUtils.green_light
    local isMyGuild = isMyGuild and UIUtils.ALLY_COLOR or UIUtils.OPPONENT_COLOR
    if attackLeft <= 0 then
        color = UIUtils.color7
    end
    self.config.textGuildName.color = isMyGuild
    self.config.textAttackPoint.text = UIUtils.SetColorString(color, string.format("%d/%d", attackLeft, maxNumberAttack))

    self.config.iconSymbol.sprite = ResourceLoadUtils.LoadGuildIcon(guildWarInBound.guildAvatar)
    self.config.iconSymbol:SetNativeSize()

    local maxPoint = ResourceMgr.GetGuildDataConfig():GetGuildWarDataConfig():GetGuildWarEloPositionConfig():GetTotalElo()
    self.config.pointBar.fillAmount = guildWarInBound:GetTotalElo() / maxPoint
    self.config.textRankingPointGuild.text = ""

    --local pointGained = maxPoint - guildWarInBound:GetTotalElo()
    --self.config.textRankingPointGuild.text = string.format("%s %s",
    --        LanguageUtils.LocalizeCommon("point_gained"), pointGained)
end

--- @param guildWarInBound GuildWarInBound
function UIGuildWarPhase3MainTopInfoView:SetPointGain(guildWarInBound)
    local maxPoint = ResourceMgr.GetGuildDataConfig():GetGuildWarDataConfig():GetGuildWarEloPositionConfig():GetTotalElo()
    local pointGained = maxPoint - guildWarInBound:GetTotalElo()
    self.config.textRankingPointGuild.text = string.format("%s %s",
            LanguageUtils.LocalizeCommon("point_gained"), UIUtils.SetColorString(UIUtils.green_light, pointGained))
end