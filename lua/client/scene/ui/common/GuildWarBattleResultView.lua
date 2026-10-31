--- @class GuildWarBattleResultView : IconView
GuildWarBattleResultView = Class(GuildWarBattleResultView , IconView)

function GuildWarBattleResultView:Ctor()
    IconView.Ctor(self)
    self.callbackGoToMail = nil
end

--- @return void
function GuildWarBattleResultView:SetPrefabName()
    self.prefabName = 'guild_war_result'
    self.uiPoolType = UIPoolType.GuildWarBattleResultView
end

--- @return void
--- @param transform UnityEngine_Transform
function GuildWarBattleResultView:SetConfig(transform)
    assert(transform)
    ---@type UIGuildWarResultConfig
    self.config = UIBaseConfig(transform)
    self.config.buttonGoToMail.onClick:AddListener(function ()
        self:OnClickGoToMail()
    end)
end

--- @return void
function GuildWarBattleResultView:OnClickGoToMail()
    FeatureMapping.GoToFeature(FeatureType.MAIL, false, self.callbackGoToMail)
end

--- @return void
function GuildWarBattleResultView:InitLocalization()
    local localizeElo = LanguageUtils.LocalizeCommon("point")
    self.config.textRankingPointGuild1.text = localizeElo
    self.config.textRankingPointGuild2.text = localizeElo
    self.config.textReward.text = LanguageUtils.LocalizeCommon("reward")
    self.config.textGoMail.text = LanguageUtils.LocalizeCommon("go_to_mail")
end

--- @return void
--- @param data GuildWarPreviousBattleResultInBound
function GuildWarBattleResultView:SetData(data, callbackGoToMail)
    local role = ClientConfigUtils.GetGuildRole()

    self.callbackGoToMail = callbackGoToMail
    self.config.icon1.sprite = ResourceLoadUtils.LoadGuildIcon(data.guildParticipant1.guildAvatar)
    self.config.icon2.sprite = ResourceLoadUtils.LoadGuildIcon(data.guildParticipant2.guildAvatar)
    self.config.textGuildName1.text = data.guildParticipant1.guildName
    self.config.textGuildName2.text = data.guildParticipant2.guildName
    self.config.textRankingPoint1.text = data.guildParticipant1.elo
    self.config.textRankingPoint2.text = data.guildParticipant2.elo

    local ranking = data.rank + 1

    ---@type RankingRewardByRangeConfig
    local rewardRanking = ResourceMgr.GetGuildDataConfig():GetGuildWarDataConfig()
                                     :GetGuildWarBattleRewardConfig(data.isParticipant, data.isWin):GetRankingRewardByRangeConfig(ranking)
    if rewardRanking ~= nil then
        ---@type List
        self.listReward = List()
        for _, v in pairs(rewardRanking:GetListRewardItemIconByGuildRole(role):GetItems()) do
            ---@type IconView
            local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.rewardAnchor)
            iconView:SetIconData(v)
            iconView:RegisterShowInfo()
            self.listReward:Add(iconView)
        end
    end
end

--- @return void
function GuildWarBattleResultView:ReturnPool()
    IconView.ReturnPool(self)
    if self.listReward ~= nil then
        ---@param v ItemIconView
        for i, v in ipairs(self.listReward:GetItems()) do
            v:ReturnPool()
        end
        self.listReward:Clear()
    end
end

return GuildWarBattleResultView