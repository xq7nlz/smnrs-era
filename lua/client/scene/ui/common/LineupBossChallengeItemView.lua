require "lua.client.scene.ui.common.BattleTeamView"
--- @class LineupBossChallengeItemView : LineupItemView
LineupBossChallengeItemView = Class(LineupBossChallengeItemView, LineupItemView)

function LineupBossChallengeItemView:SetPrefabName()
	self.prefabName = 'boss_challenge_lineup_item'
	self.uiPoolType = UIPoolType.LineupBossChallengeItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function LineupBossChallengeItemView:SetConfig(transform)
	--- @type BossChallengeLineupItemConfig
	self.config = UIBaseConfig(transform)
	self.battleTeamView = BattleTeamView(self.config.lineupAnchor)
end

--- @return void
--- @param battleTeamInfo BattleTeamInfo
--- @param lineupId number The id lineup corresponding with BattleTeamInfo (not team_id)
function LineupBossChallengeItemView:SetData(battleTeamInfo)
	self.config.prefabTeamInfo:SetActive(false)
	self:ShowLineup(battleTeamInfo)
end

--- @return void
function LineupBossChallengeItemView:SetDataLoopTower()
	self.config.prefabTeamInfo:SetActive(true)
	self.battleTeamView:Hide()
end

--- @return void
--- @param battleTeamInfo BattleTeamInfo
--- Display summoner and hero lineup icon
function LineupBossChallengeItemView:ShowLineup(battleTeamInfo)
	self.battleTeamView:Hide()
	zg.battleMgr:RequireBattleTeam(battleTeamInfo)
	local teamPowerCalculator = TeamPowerCalculator()
	teamPowerCalculator:SetDefenderTeamInfo(battleTeamInfo)
	--- @type Dictionary -- <number, number>
	--- Collection power of each hero in lineup
	local powerMap = teamPowerCalculator:CalculatePowerDetail(ResourceMgr.GetServiceConfig():GetBattle(),
			ResourceMgr.GetServiceConfig():GetHeroes(), BattleConstants.DEFENDER_TEAM_ID)

	--- @param heroBattleInfo HeroBattleInfo
	--- Callback help show up popup hero info with power and skill
	local showPopupHeroInfo = function(heroBattleInfo)
		local battleSlot = ClientConfigUtils.GetSlotNumberByPositionInfo(battleTeamInfo.formation,
				heroBattleInfo.isFrontLine,
				heroBattleInfo.position)
		if heroBattleInfo ~= nil then
			local data = {}
			data.heroResource = HeroResource.CreateInstanceByHeroBattleInfo(heroBattleInfo)
			data.power = powerMap:Get(battleSlot)
			data.statDict = ClientConfigUtils.GetHeroStatDictByHeroBattleInfo(heroBattleInfo, teamPowerCalculator)
			PopupMgr.ShowPopup(UIPopupName.UIHeroSummonInfo, data)
		end
	end

	self.battleTeamView:Show()
	self.battleTeamView:HideTeamBackground()
	--- Set data icon for all hero
	self.battleTeamView:SetDataDefender(UIPoolType.HeroIconView, battleTeamInfo, function(slotIndex)
		--- @type HeroBattleInfo
		local heroBattleInfo = ClientConfigUtils.GetHeroBattleInfoInBattleTeamInfoBySlotIndex(battleTeamInfo, slotIndex)
		showPopupHeroInfo(heroBattleInfo)
	end)

	--- Set data icon for summoner
	self.battleTeamView.uiTeamView:SetSummonerInfo(battleTeamInfo.summonerBattleInfo)
	--- Disable unnecessary display
	self.battleTeamView.uiTeamView:ActiveBuff(false)
	self.battleTeamView.uiTeamView:ActiveLinking(false)
end

--- @return void
function LineupBossChallengeItemView:Hide()
	if self.battleTeamView ~= nil then
		self.battleTeamView:Hide()
	end
end

--- @return void
--- @param callback function the method need to be called when click on detail button
function LineupBossChallengeItemView:AddListener(callback)
end

--- @return void
function LineupBossChallengeItemView:InitLocalization()
end
return LineupBossChallengeItemView