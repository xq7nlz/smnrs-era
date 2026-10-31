--- @class Battle
Battle = Class(Battle)

--- @return void
function Battle:Ctor()
    --- @type boolean
    self.gameMode = GameMode.TEST

    --- @type boolean
    self.runMode = RunMode.FASTEST

    --- @type boolean
    self.battlePhase = BattlePhase.PREPARE_BATTLE

    --- @type RandomHelper
    self._randomHelper = RandomHelper()

    --- @type BattleTeam
    self._attackerTeam = BattleTeam(BattleConstants.ATTACKER_TEAM_ID, self)

    --- @type BattleTeam
    self._defenderTeam = BattleTeam(BattleConstants.DEFENDER_TEAM_ID, self)

    --- @type Dictionary<number, BaseHero>
    self.heroes = Dictionary()

    --- @type BattleRound
    self.battleRound = nil

    --- @type BattleResult
    self.battleResult = BattleResult()

    --- @type EventManager
    self.eventManager = EventManager(self)

    --- @type AuraManager
    self.auraManager = AuraManager(self.eventManager)

    --- @type BondManager
    self.bondManager = BondManager()

    --- @type StatisticsController
    self.statisticsController = StatisticsController(self)

    --- @type BattleService
    self.battleService = nil

    --- @type number
    self.numberRound = 0

    --- @type number
    self.numberTurn = 0
end

---------------------------------------- Getters ----------------------------------------
--- @return BattleTeam, BattleTeam
function Battle:GetTeam()
    return self._attackerTeam, self._defenderTeam
end

--- @return BattleTeam
function Battle:GetAttackerTeam()
    return self._attackerTeam
end

--- @return BattleTeam
function Battle:GetDefenderTeam()
    return self._defenderTeam
end

--- @return BattleTeam
function Battle:GetTeamById(teamId)
    if teamId == self._attackerTeam.teamId then
        return self._attackerTeam
    else
        return self._defenderTeam
    end
end

--- @return BattleTeam
function Battle:GetOppositeTeamById(teamId)
    if teamId == self._attackerTeam.teamId then
        return self._defenderTeam
    else
        return self._attackerTeam
    end
end

--- @return BattleResult
function Battle:GetResult()
    return self.battleResult
end

--- @return number
function Battle:GetWinnerTeam()
    --- Need check defender before attacker
    if self._defenderTeam:IsAllDead() then
        return BattleConstants.ATTACKER_TEAM_ID
    end

    if self._attackerTeam:IsAllDead() then
        return BattleConstants.DEFENDER_TEAM_ID
    end

    return BattleConstants.DEFENDER_TEAM_ID
end

--- @return RandomHelper
function Battle:GetRandomHelper()
    return self._randomHelper
end

--- @return GameMode
function Battle:GetGameMode()
    return self.gameMode
end

--- @return boolean
function Battle:CanRun(excludedRunMode)
    return self.runMode < excludedRunMode
end

--- @return BaseHero
function Battle:GetHeroByUniqueId(id)
    return self.heroes:Get(id)
end

---------------------------------------- Setters ----------------------------------------
--- @return void
--- @param gameMode GameMode
function Battle:SetGameMode(gameMode)
    self.gameMode = gameMode
    self.battleResult:SetGameMode(self.gameMode)
end

--- @return void
--- @param runMode RunMode
function Battle:SetRunMode(runMode)
    self.runMode = runMode
end

--- @return void
--- @param battlePhase BattlePhase
function Battle:SetBattlePhase(battlePhase)
    self.battlePhase = battlePhase
end

--- @return void
function Battle:SetHeroes()
    local setHeroInTeam = function(battleTeam)
        --- @param baseHero BaseHero
        for _, baseHero in ipairs(battleTeam:GetHeroList():GetItems()) do
            self.heroes:Add(baseHero:GetHeroUnique(), baseHero)
        end
        local summoner = battleTeam:GetSummoner()
        self.heroes:Add(summoner:GetHeroUnique(), summoner)
    end

    setHeroInTeam(self._attackerTeam)
    setHeroInTeam(self._defenderTeam)
end

---------------------------------------- Battle Phases ----------------------------------------
--- @return void
--- @param battleService BattleService
function Battle:PrepareBattle(battleService)
    self.battleService = battleService
    self.battleResult:SetNumberRandomBeforeRun(self._randomHelper:GetNumberRandom())

    self._attackerTeam:Init(battleService)
    self._defenderTeam:Init(battleService)

    self._attackerTeam:PrepareBattle()
    self._defenderTeam:PrepareBattle()

    local linkingManager = LinkingManager()
    linkingManager:PrepareBattle(self.battleService, self._attackerTeam, self._defenderTeam)
end

--- @return void
function Battle:OnStartBattle()
    self.battleResult:SetStartBattleDetail(self)
end

--- @return void
function Battle:OnEndBattle()
    self.battleResult:SetEndBattleDetail(self)
end

--- @return void
function Battle:Resolve()
    for _ = 1, BattleConstants.MAX_ROUND do
        if self:ResolveByRound() then
            break
        end
    end
end

--- @return boolean battle is ended or not
function Battle:ResolveByRound()
    self.numberRound = self.numberRound + 1
    self.numberTurn = 0

    local round = BattleRound(self.numberRound, self)
    self.battleRound = round

    --print(string.format("\nROUND: %s\n", self.numberRound))
    round:OnStartBattleRound(self)
    local isEndBattle = round:Resolve(self)
    round:OnEndBattleRound(self)

    self.battleResult:AddBattleRoundLog(round.battleRoundLog)
    self.battleResult:SetNumberRounds(self.numberRound)

    return isEndBattle
end

------------------------------------------ Set Info -----------------------------------------
--- @return void
--- @param attackerTeamInfo BattleTeamInfo
--- @param defenderTeamInfo BattleTeamInfo
--- @param randomHelper RandomHelper
function Battle:SetTeamInfo(attackerTeamInfo, defenderTeamInfo, randomHelper)
    attackerTeamInfo:InitTeam(self._attackerTeam)
    defenderTeamInfo:InitTeam(self._defenderTeam)

    self._randomHelper = randomHelper
    self._randomHelper:Init()

    self.battleResult:SetSeed(self._randomHelper:GetSeed())
end

--- @return void
--- @param attackerTeamInfo BattleTeamInfo
function Battle:SetAttackerTeamInfo(attackerTeamInfo)
    attackerTeamInfo:InitTeam(self._attackerTeam)
end

--- @return void
--- @param defenderTeamInfo BattleTeamInfo
function Battle:SetDefenderTeamInfo(defenderTeamInfo)
    XDebug.Log("Set SetDefenderTeamInfo")
    defenderTeamInfo:InitTeam(self._defenderTeam)
end

---------------------------------------- Parse Csv ----------------------------------------
--- @return void
--- @param battleCsv string
--- @param masteryCsv string
function Battle:ParseCsv(battleCsv, masteryCsv)
    local battleCsvParser = BattleCsvParser(self)
    battleCsvParser:ParseCsv(battleCsv, masteryCsv)
end

--- @return HeroState
--- @param battleTeamInfo BattleTeamInfo
--- @param index number
function Battle:GetHeroState(battleTeamInfo, index)
    --- @type BattleTeam
    local team = self:GetTeamById(battleTeamInfo.teamId)

    ---@type List <HeroBattleInfo>
    local listHeroInfo = battleTeamInfo:GetListHero()

    ---@type HeroBattleInfo
    local heroBattleInfo = listHeroInfo:Get(index)
    if heroBattleInfo == nil then
        return nil
    else
        local heroInBattle = team:GetHeroByLineAndPosition(heroBattleInfo.isFrontLine, heroBattleInfo.position)
        if heroInBattle == nil then
            return nil
        end

        local heroState = HeroState()
        heroState:SetPosition(heroBattleInfo.isFrontLine, heroBattleInfo.position)
        heroState:SetState(heroInBattle.hp:GetStatPercent(), heroInBattle.power:GetValue(), heroInBattle.hp:GetValue())
        return heroState
    end
end
