require "lua.client.scene.ui.common.BattleTeamView"
--- @class LineupItemView : UIPrefabView
LineupItemView = Class(LineupItemView, UIPrefabView)

function LineupItemView:Ctor()
    ---@type LineupItemConfig
    self.config = nil
    --- @type List
    self.listHero = List()
    --- @type HeroIconView
    self.summonerIconView = nil
    ---@type number
    self.lineupId = nil
    --- @type BattleTeamView
    self.battleTeamView = nil

    UIPrefabView.Ctor(self)
end

function LineupItemView:SetPrefabName()
    self.prefabName = 'lineup_item'
    self.uiPoolType = UIPoolType.LineupItemView
end


--- @return void
--- @param transform UnityEngine_Transform
function LineupItemView:SetConfig(transform)
    --- @type LineupItemConfig
    self.config = UIBaseConfig(transform)
    self.battleTeamView = BattleTeamView(self.config.lineupAnchor)
end

--- @return void
function LineupItemView:InitLocalization()
    self.config.textDetails.text = LanguageUtils.LocalizeCommon("detail")
end

--- @return void
--- @param battleTeamInfo BattleTeamInfo
--- @param lineupId number The id lineup corresponding with BattleTeamInfo (not team_id)
function LineupItemView:SetData(battleTeamInfo, lineupId)
    --- localize title text of lineup after get data
    self.config.textLineupName.text = LanguageUtils.LocalizeCommon("lineup_recommend_" .. lineupId)

    self:ShowLineup(battleTeamInfo)
end

--- @return void
--- @param battleTeamInfo BattleTeamInfo
--- Display summoner and hero lineup icon
function LineupItemView:ShowLineup(battleTeamInfo)
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
--- @param callback function the method need to be called when click on detail button
function LineupItemView:AddListener(callback)
    self.config.buttonDetails.onClick:RemoveAllListeners()
    self.config.buttonDetails.onClick:AddListener(callback)
end

--- @return void
function LineupItemView:ReturnPool()
    UIPrefabView.ReturnPool(self)
    if self.battleTeamView ~= nil then
        self.battleTeamView:Hide()
    end
end

return LineupItemView