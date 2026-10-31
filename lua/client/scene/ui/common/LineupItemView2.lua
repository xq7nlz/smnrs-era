require "lua.client.scene.ui.common.BattleTeamView"
--- @class LineupItemView2 : LineupItemView
LineupItemView2 = Class(LineupItemView2, LineupItemView)

function LineupItemView2:SetPrefabName()
	self.prefabName = 'lineup_item_2'
	self.uiPoolType = UIPoolType.LineupItemView2
end

--- @return void
--- @param battleTeamInfo BattleTeamInfo
--- @param lineupId number The id lineup corresponding with BattleTeamInfo (not team_id)
function LineupItemView2:SetData(battleTeamInfo, lineupId)
	self:ShowLineup(battleTeamInfo)
end

--- @return void
--- @param battleTeamInfo BattleTeamInfo
--- Display summoner and hero lineup icon
function LineupItemView2:ShowLineup(battleTeamInfo)
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
		if heroBattleInfo.heroId ~= HeroConstants.FINDE_HERO_ID and heroBattleInfo.heroId ~= HeroConstants.KOZORG_HERO_ID then
			showPopupHeroInfo(heroBattleInfo)
		end
	end)
	for i = 1, battleTeamInfo.listHeroInfo:Count() do
		--- @type HeroBattleInfo
		local hero =  battleTeamInfo.listHeroInfo:Get(i)
		if hero.heroId ==  HeroConstants.FINDE_HERO_ID or hero.heroId == HeroConstants.KOZORG_HERO_ID then
			local frontLineLength = battleTeamInfo:GetLineLenght(true)
			local slotIndex = hero.position + (hero.isFrontLine and 0 or frontLineLength)
			self:ActiveFxHeroCard(slotIndex)
			break
		end
	end
	--- Set data icon for summoner
	self.battleTeamView.uiTeamView:SetSummonerInfo(battleTeamInfo.summonerBattleInfo)
	--- Disable unnecessary display
	self.battleTeamView.uiTeamView:ActiveBuff(false)
	self.battleTeamView.uiTeamView:ActiveLinking(false)
end

function LineupItemView2:ActiveFxHeroCard(slotIndex)
	--- @type UIFormationButtonSlotView
	local UIFormationButtonSlotView = self.battleTeamView.uiHeroSlotView.uiButtonSlotList:Get(6 - slotIndex)
	UIFormationButtonSlotView.iconView:ActiveFxHeroCard(true)
end

--- @return void
function LineupItemView2:Hide()
	if self.battleTeamView ~= nil then
		self.battleTeamView:Hide()
	end
end

--- @return void
--- @param callback function the method need to be called when click on detail button
function LineupItemView2:AddListener(callback)
end

--- @return void
function LineupItemView2:InitLocalization()
end
return LineupItemView2