--- @class BattleTeam
BattleTeam = Class(BattleTeam)

--- @return void
--- @param teamId number
--- @param battle Battle
function BattleTeam:Ctor(teamId, battle)
    --- @type number
    self.teamId = teamId
    --- @type number
    self.formationId = -1

    --- @type Battle
    self.battle = battle

    --- @type BaseSummoner
    --- Summoner of team
    self.summoner = nil

    --- @type Dictionary<number, BaseHero>
    --- key: positionId
    self.frontLine = {}

    --- @type Dictionary<number, BaseHero>
    --- key: positionId
    self.backLine = {}

    --- @type HeroCompanionBuffData
    self.companionBuffData = nil

    --- @type BattleTeamInitializer
    self.battleTeamInitializer = BattleTeamInitializer(self)

    --- @type Dictionary
    self.buffDungeon = Dictionary()

    --- Created when start battle from linkingGroups
    --- @type List<BaseLinking>
    self.linkings = List()

    --- Init when create battle
    --- @type Dictionary<number, number> key: active group, value: tier level
    self.linkingGroups = Dictionary()

    --- @type List<BaseHero>
    self.heroList = List()
end

--- @return void
--- @param linking BaseLinking
function BattleTeam:AddLinking(linking)
    self.linkings:Add(linking)
end

---------------------------------------- Getters ----------------------------------------
--- @return List<BaseHero>
function BattleTeam:GetHeroList()
    return self.heroList
end

--- @return List<BaseHero>
--- @param effectType EffectType
function BattleTeam:GetHeroWithMark(effectType)
    local result = List()
    for i = 1, self.heroList:Count() do
        ---@type BaseHero
        local hero = self.heroList:Get(i)
        if hero:IsDead() == false and hero.effectController:IsContainEffectType(effectType) == true then
            result:Add(hero)
        end
    end

    return result
end

--- @return number
function BattleTeam:GetTotalNumberHeroes()
    return self.heroList:Count()
end

--- @return boolean
function BattleTeam:IsAllDead()
    for i = 1, self.heroList:Count() do
        ---@type BaseHero
        local hero = self.heroList:Get(i)
        if hero:IsDead() == false then
            return false
        end
    end

    return true
end

--- @return number
--- @param myHero BaseHero
function BattleTeam:GetAllyAliveCount(myHero)
    local allyAliveCount = 0
    for i = 1, self.heroList:Count() do
        ---@type BaseHero
        local hero = self.heroList:Get(i)
        if hero ~= myHero and hero:IsDead() == false then
            allyAliveCount = allyAliveCount + 1
        end
    end

    return allyAliveCount
end

--- @return HeroCompanionBuffData
function BattleTeam:GetCompanionBuffData()
    return self.companionBuffData
end

--- @return Dictionary
function BattleTeam:GetDungeonBuff()
    return self.buffDungeon
end

--- @return number
function BattleTeam:GetDefenderTowerLevel()
    return self.defenderTowerLevel
end

--- @return number
function BattleTeam:GetLandId()
    return self.landId
end

--- @return BaseSummoner
function BattleTeam:GetSummoner()
    return self.summoner
end

--- @return Dictionary<number, number>
function BattleTeam:GetLinkingGroups()
    return self.linkingGroups
end

---------------------------------------- Setters ----------------------------------------
--- @return void
--- @param formationId number
function BattleTeam:SetFormationId(formationId)
    self.formationId = formationId
end

--- @return void
--- @param buffDungeon table Dictionary <number, number>
function BattleTeam:SetDungeonBuff(buffDungeon)
    self.buffDungeon = buffDungeon
end

--- @param groups table Dictionary <number, number>
function BattleTeam:SetLinkingGroups(groups)
    self.linkingGroups = groups
end

--- @return void
--- @param summoner BaseHero
function BattleTeam:SetSummoner(summoner)
    self.summoner = summoner
end

--- @return void
--- @param hero BaseHero
function BattleTeam:AddHero(hero)
    if hero.positionInfo.isFrontLine then
        assert(self.frontLine[hero.positionInfo.position] == nil)
        self.frontLine[hero.positionInfo.position] = hero
    else
        assert(self.backLine[hero.positionInfo.position] == nil)
        self.backLine[hero.positionInfo.position] = hero
    end
end

--- @return void
function BattleTeam:CreateHeroList()
    for _, hero in pairs(self.frontLine) do
        self.heroList:Add(hero)
    end

    for _, hero in pairs(self.backLine) do
        self.heroList:Add(hero)
    end
end

---------------------------------------- Prepare battle ----------------------------------------
--- @return void
--- @param battleService BattleService
function BattleTeam:Init(battleService)
    --- @type List<BaseHero>
    for i = 1, self.heroList:Count() do
        ---@type BaseHero
        local hero = self.heroList:Get(i)
        self.battle.statisticsController:AddHero(hero)
    end

    self.battle.statisticsController:AddHero(self.summoner)

    self.battleTeamInitializer:Start(battleService)
end

--- @return void
function BattleTeam:PrepareBattle()
    self.battleTeamInitializer:PrepareBattle()
end

---------------------------------------- Listeners ----------------------------------------
--- @return void
--- @param round BattleRound
function BattleTeam:OnStartBattleRound(round)
    self.summoner.battleListener:OnStartBattleRound(round)
    for i = 1, self.heroList:Count() do
        ---@type BaseHero
        local hero = self.heroList:Get(i)
        hero.battleListener:OnStartBattleRound(round)

        EventUtils.TriggerEventRoundStart(hero, round)
    end
end

--- @return void
--- @param round BattleRound
function BattleTeam:OnEndBattleRound(round)
    self.summoner.battleListener:OnEndBattleRound(round)
    for i = 1, self.heroList:Count() do
        ---@type BaseHero
        local hero = self.heroList:Get(i)
        hero.battleListener:OnEndBattleRound(round)
    end
end

--- @return void
function BattleTeam:UpdateBeforeRound()
    for i = 1, self.heroList:Count() do
        ---@type BaseHero
        local hero = self.heroList:Get(i)
        hero:UpdateBeforeRound()
    end
end

--- @return void
function BattleTeam:UpdateAfterRound()
    for i = 1, self.heroList:Count() do
        ---@type BaseHero
        local hero = self.heroList:Get(i)
        hero:UpdateAfterRound()
    end
end

--- @return BaseHero
--- @param isFrontLine boolean
--- @param position number
function BattleTeam:GetHeroByLineAndPosition(isFrontLine, position)
    if isFrontLine == true then
        return self.frontLine[position]
    else
        return self.backLine[position]
    end
end