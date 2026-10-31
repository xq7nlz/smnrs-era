require "lua.client.scene.ui.common.ArenaBootCampLeaderBoardItemView"
--- @class BirthdayBossLeaderBoardItemView : ArenaBootCampLeaderBoardItemView
BirthdayBossLeaderBoardItemView = Class(BirthdayBossLeaderBoardItemView, ArenaBootCampLeaderBoardItemView)
BirthdayBossLeaderBoardItemView.MaxTopRankHasIcon = 3

function BirthdayBossLeaderBoardItemView:Ctor(transform)
	--- @type VipIconView
	self.vipIconView = nil
	--- @type HeroIconView
	self.heroIconView = nil
	--- @type ItemsTableView
	self.itemsTableView = nil
	--- @type BirthdayBossLeaderBoardItemConfig
	self.config = nil
	MotionIconView.Ctor(self, transform)
end

function BirthdayBossLeaderBoardItemView:SetPrefabName()
	self.prefabName = 'birthday_boss_leader_board_item'
	self.uiPoolType = UIPoolType.BirthdayBossLeaderBoardItemView
end

--- @param obj ArenaBootCampLeaderBoardItemView
--- @param singleArenaRanking SingleArenaRanking
--- @param rankValue number
--- @param isUser boolean
function BirthdayBossLeaderBoardItemView:SetItemViewData(singleArenaRanking, rankValue, isUser)
	if (rankValue > 0) then
		self:SetRankValue(rankValue, isUser)
	else
		self:SetRankValue(-1, true)
	end

	local arenaPoint = singleArenaRanking.score
	self:SetRecordInfo(arenaPoint, isUser)

	local rankIcon
	if (rankValue > 0 and rankValue <= LeaderBoardItemView.MaxTopRankHasIcon) then
		rankIcon = ResourceLoadUtils.LoadTopRankingIcon(rankValue)
	end
	self:SetRankIcon(rankIcon)
	self:SetBgText(isUser, singleArenaRanking.playerName)

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
    self.config.factionIcon.sprite = ResourceLoadUtils.LoadFactionIcon(singleArenaRanking.factionId)
    self.config.heroNameTxt.text = LanguageUtils.LocalizeFaction(singleArenaRanking.factionId)
    self.config.heroNameTxt.color = UIUtils.text_dark_color_with_faction_type[singleArenaRanking.factionId]

	self:SetRankIcon(rankIcon)
end

return BirthdayBossLeaderBoardItemView