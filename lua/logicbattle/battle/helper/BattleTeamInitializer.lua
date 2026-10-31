--- @class BattleTeamInitializer
BattleTeamInitializer = Class(BattleTeamInitializer)

--- @return void
--- @param team BattleTeam
function BattleTeamInitializer:Ctor(team)
    --- @type BattleTeam
    self.team = team

    --- @type Battle
    self.battle = team.battle

    --- @type HeroDataService
    self.heroDataService = nil

    --- @type ItemDataService
    self.itemDataService = nil

    --- @type DungeonDataService
    self.dungeonDataService = nil

    --- @type PredefineTeamDataService
    self.predefineTeamDataService = nil

    --- @type FormationData
    self.formationData = nil
end

---------------------------------------- Public methods ----------------------------------------
--- @return void
--- @param battleService BattleService
function BattleTeamInitializer:Start(battleService)
    self.heroDataService = battleService:GetHeroDataService()
    self.itemDataService = battleService:GetItemDataService()
    self.dungeonDataService = battleService:GetDungeonDataService()
    self.predefineTeamDataService = battleService:GetPredefineTeamDataService()

    self.formationData = self.heroDataService:GetFormationData(self.team.formationId)

    self:BindingDataToSummoner()
    self:BindingDataToHero()

    self:CreateCompanionBuff()

    self:InitSummoner(self.formationData.frontLine, self.formationData.backLine)
    self:InitHero(self.formationData.frontLine, self.formationData.backLine)

    self:InitDungeonBuff()
end

--- @return void
function BattleTeamInitializer:PrepareBattle()
    self.team.summoner.skillController:Init()

    local heroList = self.team:GetHeroList()
    for i = 1, heroList:Count() do
        ---@type BaseHero
        local hero = heroList:Get(i)
        hero.skillController:Init()
    end
end

---------------------------------------- Binding data ----------------------------------------
--- @return void
function BattleTeamInitializer:BindingDataToSummoner()
    --- id is same as class (HeroClassType)
    local dataEntry = self.heroDataService:GetSummonerDataEntry(self.team.summoner.id)
    self.team.summoner:SetHeroDataEntry(dataEntry)
end

--- @return void
function BattleTeamInitializer:BindingDataToHero()
    local heroList = self.team:GetHeroList()
    for i = 1, heroList:Count() do
        ---@type BaseHero
        local hero = heroList:Get(i)
        local dataEntry = self.heroDataService:GetHeroDataEntry(hero.id)
        hero:SetHeroDataEntry(dataEntry)
    end
end

--- @return void
function BattleTeamInitializer:CreateCompanionBuff()
    local heroList = self.team:GetHeroList()
    if heroList:Count() == FormationConstants.NUMBER_SLOT then
        --- @type Dictionary<HeroFactionType, number>
        local heroPerFactions = Dictionary()
        for i = 1, heroList:Count() do
            ---@type BaseHero
            local hero = heroList:Get(i)
            --- @type HeroFactionType
            local faction = hero.originInfo.faction

            local number = heroPerFactions:GetOrDefault(faction, 0)
            heroPerFactions:Add(faction, number + 1)
        end

        self.team.companionBuffData = self.heroDataService:GetBestMatchCompanionBuff(heroPerFactions)
    end
end

---------------------------------------- Init ----------------------------------------
--- @return void
--- @param numberFrontLine number
--- @param numberBackLine number
function BattleTeamInitializer:InitSummoner(numberFrontLine, numberBackLine)
    --- Summoner
    local initializer = self.team.summoner:CreateInitializer()
    initializer:SetData(self.battle, self.heroDataService, self.itemDataService, self.predefineTeamDataService)
    initializer:SetFormation(self.heroDataService, self.team.formationId, numberFrontLine, numberBackLine)
end

--- @return void
--- @param numberFrontLine number
--- @param numberBackLine number
function BattleTeamInitializer:InitHero(numberFrontLine, numberBackLine)
    local heroList = self.team:GetHeroList()
    for i = 1, heroList:Count() do
        ---@type BaseHero
        local hero = heroList:Get(i)
        local initializer = hero:CreateInitializer()
        initializer:SetData(self.battle, self.heroDataService, self.itemDataService, self.predefineTeamDataService)
        initializer:SetFormation(self.heroDataService, self.team.formationId, numberFrontLine, numberBackLine)

        if self.team.companionBuffData ~= nil then
            initializer:SetCompanionBuff(self.team.companionBuffData.bonuses)
        end
    end
end

--- @return void
function BattleTeamInitializer:InitDungeonBuff()
    if self.team:GetDungeonBuff():Count() > 0 then
        local statChangerDungeonHelper = StatChangerDungeonHelper(self.team)
        statChangerDungeonHelper:InitDungeonBuff(self.dungeonDataService)
    end
end
