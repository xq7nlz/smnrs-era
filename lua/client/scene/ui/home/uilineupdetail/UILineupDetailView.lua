require "lua.client.scene.ui.home.uiCompanionCollection.UICompanionBuffView"

--- @class UILineupDetailView : UIBaseView
UILineupDetailView = Class(UILineupDetailView, UIBaseView)

--- @param model UILineupDetailModel
function UILineupDetailView:Ctor(model)
	--- @type UILineupDetailConfig
	self.config = nil
	UIBaseView.Ctor(self, model)
	--- @type UILineupDetailModel
	self.model = model
	--- @type BattleTeamView
	self.battleTeamView = nil
	--- @type HeroCompanionBuffData
	self.companionBuffData = nil
	--- @type number
	self.lineupId = nil
end

function UILineupDetailView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)
	---@type BattleTeamView
	self.battleTeamView = BattleTeamView(self.config.lineupAnchor)
	--- @type UICompanionBuffView
	self.companionBuffView = UICompanionBuffView(self.config.companionBuffItem)

	self:InitButtons()
end

function UILineupDetailView:InitButtons()
	self.config.buttonClose.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.bgNone.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
end

function UILineupDetailView:OnClickBackOrClose()
	self:OnReadyHide()
	zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
end

--- @return void
--- Localize text display in screen
function UILineupDetailView:InitLocalization()
	self.config.companionTitle.text = LanguageUtils.LocalizeCommon("companion_buff")
end

--- @param data { battleTeamInfo BattleTeamInfo, lineupId number }
--- battleTeamInfo is data corresponding with lineupId
function UILineupDetailView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
	--- localize title text of lineup after get data
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("lineup_recommend_" .. data.lineupId)

	self:ShowLineup(data.battleTeamInfo)
end

--- @return void
--- @param battleTeamInfo BattleTeamInfo
--- Display summoner and hero lineup icon
function UILineupDetailView:ShowLineup(battleTeamInfo)
	self.battleTeamView:Hide()

	local teamPowerCalculator = TeamPowerCalculator()
	teamPowerCalculator:SetDefenderTeamInfo(battleTeamInfo)

	--- @type Dictionary<number, number>
	--- Collection power of each hero in lineup
	local powerMap = teamPowerCalculator:CalculatePowerDetail(ResourceMgr.GetServiceConfig():GetBattle(),
			ResourceMgr.GetServiceConfig():GetHeroes(), BattleConstants.DEFENDER_TEAM_ID)

	--- Calculate companion buff of lineup and show it to UI
	self:CreateCompanionBuff(battleTeamInfo)
	self.companionBuffView:SetData(self.companionBuffData, true)

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
--- @param battleTeamInfo BattleTeamInfo
--- Check faction of each hero and use it to calculate companion buff
function UILineupDetailView:CreateCompanionBuff(battleTeamInfo)
	local listHeroInfo = battleTeamInfo.listHeroInfo
	if listHeroInfo:Count() == FormationConstants.NUMBER_SLOT then
		local heroPerFactions = Dictionary()
		--- Add faction of each hero to an collection
		for i = 1, listHeroInfo:Count() do
			local hero = listHeroInfo:Get(i)
			local faction = ClientConfigUtils.GetFactionIdByHeroId(hero.heroId)
			local number = heroPerFactions:GetOrDefault(faction, 0)

			heroPerFactions:Add(faction, number + 1)
		end

		--- Get the companion buff by collection of hero's faction id
		self.companionBuffData = self:GetBestMatchCompanionBuff(heroPerFactions)
	end
end


--- @return HeroCompanionBuffData
--- @param heroPerFactions Dictionary<HeroFactionType, number>
--- Depend on collection of hero's faction id to return buff of that
function UILineupDetailView:GetBestMatchCompanionBuff(heroPerFactions)
	local hero =  ResourceMgr.GetServiceConfig():GetHeroes().heroCompanionBuffEntries
	for _, buff in pairs(hero:GetItems()) do
		if buff:IsMatch(heroPerFactions) then
			--- closest match to this companion buff
			return buff
		end
	end
	return nil
end

function UILineupDetailView:OnReadyHide()
	PopupMgr.HidePopup(self.model.uiName)
end

function UILineupDetailView:Hide()
	UIBaseView.Hide(self)
	--- Return all hero slot inside battleTeamView to pool
	if self.battleTeamView ~= nil then
		self.battleTeamView:Hide()
	end
end