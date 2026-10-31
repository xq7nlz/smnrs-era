require "lua.client.scene.ui.common.ArenaBootCampLeaderBoardItemView"
--- @class KazetsuBossLeaderBoardItemView : ArenaBootCampLeaderBoardItemView
KazetsuBossLeaderBoardItemView = Class(KazetsuBossLeaderBoardItemView, ArenaBootCampLeaderBoardItemView)
KazetsuBossLeaderBoardItemView.MaxTopRankHasIcon = 3

function KazetsuBossLeaderBoardItemView:Ctor(transform)
    --- @type VipIconView
    self.vipIconView = nil
    --- @type HeroIconView
    self.heroIconView = nil
    --- @type ItemsTableView
    self.itemsTableView = nil
    --- @type ArenaBootCampLeaderBoardItemConfig
    self.config = nil
    MotionIconView.Ctor(self,transform)
end



function KazetsuBossLeaderBoardItemView:SetPrefabName()
    self.prefabName = 'kazetsu_boss_leader_board_item'
    self.uiPoolType = UIPoolType.KazetsuBossLeaderBoardItemView
end


--- @param obj ArenaBootCampLeaderBoardItemView
--- @param singleArenaRanking SingleArenaRanking
--- @param rankValue number
--- @param isUser boolean
function KazetsuBossLeaderBoardItemView:SetItemViewData( singleArenaRanking, rankValue, isUser)
    if (rankValue > 0) then
        self:SetRankValue(rankValue,isUser)
    else
        self:SetRankValue(-1,true)
    end

    local arenaPoint = singleArenaRanking.score
    self:SetRecordInfo(arenaPoint,isUser)

    local rankIcon
    if (rankValue > 0 and rankValue <= LeaderBoardItemView.MaxTopRankHasIcon) then
        rankIcon = ResourceLoadUtils.LoadTopRankingIcon(rankValue)
    end
    self:SetRankIcon(rankIcon)
    self:SetBgText(isUser,singleArenaRanking.playerName)

    --- @type VipIconView
    local vipIconView = self:InitAvatarInfo(UIPoolType.VipIconView)

    --- @return number
    local avatar
    if (isUser) then
        avatar = singleArenaRanking.avatarData:GetMyPlayerAvatar()
    else
        avatar = singleArenaRanking.avatarData:GetOtherPlayerAvatar()
    end
    vipIconView:SetData2(avatar, singleArenaRanking.playerLevel)

    local rankIcon
    if (rankValue > 0 and rankValue <= LeaderBoardItemView.MaxTopRankHasIcon) then
        rankIcon = ResourceLoadUtils.LoadTopRankingIcon3V3(rankValue)
    end
    self:SetRankIcon(rankIcon)
end

return KazetsuBossLeaderBoardItemView