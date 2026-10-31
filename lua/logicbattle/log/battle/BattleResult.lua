--- @class BattleResult
BattleResult = Class(BattleResult)

--- @return void
function BattleResult:Ctor()
    --- @type number
    self.seed = nil

    --- @type GameMode
    self.gameMode = GameMode.TEST

    --- @type number
    self.numberRounds = -1

    --- @type List<BaseActionResult>
    self.startBattleLogs = List()

    --- @type List<BattleRoundLog>
    self.battleRoundLogs = List()

    --- @type BattleTeamLog
    self.attackerTeamLog = BattleTeamLog(BattleConstants.ATTACKER_TEAM_ID)

    --- @type BattleTeamLog
    self.defenderTeamLog = BattleTeamLog(BattleConstants.DEFENDER_TEAM_ID)

    --- @type HeroCompanionBuffData
    self.attackerCompanionBuff = nil

    --- @type HeroCompanionBuffData
    self.defenderCompanionBuff = nil

    --- @type HeroStatusLog
    self.attackerSummonerStatusLog = nil

    --- @type HeroStatusLog
    self.defenderSummonerStatusLog = nil

    --- @type number
    self.winnerTeam = nil

    --- @type Dictionary<BaseHero, HeroStatistics>
    self.heroStatisticsDict = Dictionary()

    --- @type List<BaseLinking>
    self.attackerLinkings = nil

    --- @type List<BaseLinking>
    self.defenderLinkings = nil

    --- @type number
    self.numberRandomBeforeRun = 0

    --- @type number
    self.numberRandomAfterRun = 0

    --- @type number
    self.attackerPower = 0

    --- @type number
    self.defenderPower = 0
end

---------------------------------------- Getters ----------------------------------------
--- @return number
function BattleResult:GetWinnerTeam()
    return self.winnerTeam
end

--- @return number
function BattleResult:GetNumberRounds()
    return self.numberRounds
end

--- @return number
function BattleResult:GetWinnerTeam()
    return self.winnerTeam
end

--- @return number
function BattleResult:GetAttackerCompanionBuffId()
    if self.attackerCompanionBuff ~= nil then
        return self.attackerCompanionBuff.id
    end

    return BattleConstants.NOT_EXISTED_COMPANION_BUFF_ID
end

--- @return number
function BattleResult:GetDefenderCompanionBuffId()
    if self.defenderCompanionBuff ~= nil then
        return self.defenderCompanionBuff.id
    end

    return BattleConstants.NOT_EXISTED_COMPANION_BUFF_ID
end

--- @return number
function BattleResult:GetNumberAttackerHeroDead()
    local result = 0
    ---@param heroStatistics HeroStatistics
    for _, heroStatistics in pairs(self.heroStatisticsDict:GetItems()) do
        if heroStatistics.myHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
            if heroStatistics.myHero:IsDead() then
                result = result + 1
            end
        end
    end

    return result
end

--- @return number
function BattleResult:GetTotalDamageDealToDefender()
    local result = 0
    ---@param heroStatistics HeroStatistics
    for _, heroStatistics in pairs(self.heroStatisticsDict:GetItems()) do
        if heroStatistics.myHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
            result = result + heroStatistics.damageDeal
        end
    end

    return result
end

--- @return number
--- @param teamId number
function BattleResult:GetBattleTeamPower(teamId)
    if teamId ~= nil and teamId == BattleConstants.DEFENDER_TEAM_ID then
        return self.defenderPower
    end

    return self.attackerPower
end

---------------------------------------- Setters ----------------------------------------
--- @return void
--- @param seed number
function BattleResult:SetSeed(seed)
    self.seed = seed
end

--- @return void
--- @param numberRandom number
function BattleResult:SetNumberRandomBeforeRun(numberRandom)
    self.numberRandomBeforeRun = numberRandom
end

--- @return void
--- @param gameMode GameMode
function BattleResult:SetGameMode(gameMode)
    self.gameMode = gameMode
end

--- @return void
--- @param numberRounds number
function BattleResult:SetNumberRounds(numberRounds)
    self.numberRounds = numberRounds
end

--- @return void
--- @param resultLog BaseActionResult
function BattleResult:AddStartBattleLog(resultLog)
    self.startBattleLogs:Add(resultLog)
end

--- @return void
--- @param battleRoundLog BattleRoundLog
function BattleResult:AddBattleRoundLog(battleRoundLog)
    self.battleRoundLogs:Add(battleRoundLog)
end

--- @return void
--- @param battle Battle
function BattleResult:SetStartBattleDetail(battle)
    local attackerTeam, defenderTeam = battle:GetTeam()

    self.attackerCompanionBuff = attackerTeam:GetCompanionBuffData()
    self.defenderCompanionBuff = defenderTeam:GetCompanionBuffData()

    self.attackerSummonerStatusLog = HeroStatusLog(attackerTeam:GetSummoner())
    self.defenderSummonerStatusLog = HeroStatusLog(defenderTeam:GetSummoner())

    self.attackerTeamLog:SetTeamBefore(attackerTeam)
    self.defenderTeamLog:SetTeamBefore(defenderTeam)

    self.attackerLinkings = attackerTeam.linkings
    self.defenderLinkings = defenderTeam.linkings
end

--- @return void
--- @param battle Battle
function BattleResult:SetEndBattleDetail(battle)
    self.attackerTeamLog:SetTeamAfter(battle:GetAttackerTeam())
    self.defenderTeamLog:SetTeamAfter(battle:GetDefenderTeam())

    self.winnerTeam = battle:GetWinnerTeam()
    self.heroStatisticsDict = battle.statisticsController.heroStatisticsDict

    self.numberRandomAfterRun = battle._randomHelper:GetNumberRandom()
end

--- @return Dictionary<number, HeroStatistics>
function BattleResult:GetHeroStatisticsDictData()
    local result = {}
    --- @param _baseHero BaseHero
    --- @param _heroStatistics HeroStatistics
    for _baseHero, _heroStatistics in pairs(self.heroStatisticsDict:GetItems()) do
        result[_baseHero:GetHeroUnique()] = _heroStatistics:GetData()
    end

    return result
end

--- @return BattleResult
function BattleResult:GetData()
    local data = {}
    data.seed = self.seed
    data.gameMode = self.gameMode
    data.numberRounds = self.numberRounds
    data.startBattleLogs = self.startBattleLogs:GetData()
    data.battleRoundLogs = self.battleRoundLogs:GetData()
    data.attackerTeamLog = self.attackerTeamLog:GetData()
    data.defenderTeamLog = self.defenderTeamLog:GetData()
    data.attackerSummonerStatusLog = self.attackerSummonerStatusLog:GetData()
    data.defenderSummonerStatusLog = self.defenderSummonerStatusLog:GetData()
    data.winnerTeam = self.winnerTeam
    data.heroStatisticsDict = self:GetHeroStatisticsDictData()
    data.numberRandomBeforeRun = self.numberRandomBeforeRun
    data.numberRandomAfterRun = self.numberRandomAfterRun
    data.attackerPower = self.attackerPower
    data.defenderPower = self.defenderPower

    return data
end

--- @return string
function BattleResult:ToClient()
    local dkjson = require("lua.libs.dkjson")
    local battleResultString = dkjson.encode(self:GetData())

    return battleResultString
end

---------------------------------------- ToString ----------------------------------------
--- @return string
--- @param runMode RunMode
function BattleResult:ToString(runMode)
    local result = string.format("\n<> SEED = %s\n", self.seed)

    result = result .. string.format("<> NUMBER RANDOM BEFORE RUN: %s\n", self.numberRandomBeforeRun)
    result = result .. string.format("<> NUMBER RANDOM AFTER RUN: %s\n", self.numberRandomAfterRun)

    result = result .. string.format("<> GAME MODE: %s\n", self.gameMode)

    if runMode < RunMode.FAST then
        result = result .. "---------------------------------------- START BATTLE ----------------------------------------\n"
        if self.attackerCompanionBuff ~= nil then
            result = result .. "<> ATTACKER COMPANION BUFF: " .. self.attackerCompanionBuff:ToString()
        else
            result = result .. "<> ATTACKER COMPANION BUFF: no buff\n"
        end

        if self.defenderCompanionBuff ~= nil then
            result = result .. "<> DEFENDER COMPANION BUFF: " .. self.defenderCompanionBuff:ToString()
        else
            result = result .. "<> DEFENDER COMPANION BUFF: no buff\n"
        end

        result = result .. self:ToLinkingDetail(self.attackerLinkings, true)
        result = result .. self:ToLinkingDetail(self.defenderLinkings, false)

        result = result .. self.attackerSummonerStatusLog:ToString(RunMode.TEST)
        result = result .. self.defenderSummonerStatusLog:ToString(RunMode.TEST)

        result = result .. self.attackerTeamLog:ToStringBefore(RunMode.TEST)
        result = result .. self.defenderTeamLog:ToStringBefore(RunMode.TEST)

        result = result .. string.format("\nPREPARE BATTLE\n")
        result = result .. "****************************************************************************************************************************************************************\n"

        for i = 1, self.startBattleLogs:Count() do
            local log = self.startBattleLogs:Get(i)
            result = result .. log:ToString()
        end

        for i = 1, self.battleRoundLogs:Count() do
            local log = self.battleRoundLogs:Get(i)
            result = result .. log:ToString(runMode)
        end

        result = result .. "---------------------------------------- END BATTLE ----------------------------------------\n"
        result = result .. self.attackerTeamLog:ToStringAfter(runMode)
        result = result .. self.defenderTeamLog:ToStringAfter(runMode)

        result = result .. "<> STATISTICS:\n"
        for _, hero in pairs(self.heroStatisticsDict:GetItems()) do
            result = result .. hero:ToString()
        end
    end

    result = result .. string.format("\n<> WINNER: %s\n", self.winnerTeam)

    return result
end

--- @return string
--- @param runMode RunMode
function BattleResult:ToShortString(runMode)
    local result = string.format("\n<> SEED = %s\n", self.seed)

    result = result .. string.format("<> NUMBER RANDOM BEFORE RUN: %s\n", self.numberRandomBeforeRun)
    result = result .. string.format("<> NUMBER RANDOM AFTER RUN: %s\n", self.numberRandomAfterRun)

    result = result .. string.format("<> GAME MODE: %s\n", self.gameMode)

    if runMode < RunMode.FAST then
        result = result .. "---------------------------------------- START BATTLE ----------------------------------------\n"
        if self.attackerCompanionBuff ~= nil then
            result = result .. "<> ATTACKER COMPANION BUFF: " .. self.attackerCompanionBuff:ToString()
        else
            result = result .. "<> ATTACKER COMPANION BUFF: no buff\n"
        end

        if self.defenderCompanionBuff ~= nil then
            result = result .. "<> DEFENDER COMPANION BUFF: " .. self.defenderCompanionBuff:ToString()
        else
            result = result .. "<> DEFENDER COMPANION BUFF: no buff\n"
        end

        result = result .. self:ToLinkingDetail(self.attackerLinkings, true)
        result = result .. self:ToLinkingDetail(self.defenderLinkings, false)

        result = result .. self.attackerSummonerStatusLog:ToString(RunMode.TEST)
        result = result .. self.defenderSummonerStatusLog:ToString(RunMode.TEST)

        result = result .. self.attackerTeamLog:ToStringBefore(RunMode.TEST)
        result = result .. self.defenderTeamLog:ToStringBefore(RunMode.TEST)

        result = result .. "---------------------------------------- END BATTLE ----------------------------------------\n"
        result = result .. self.attackerTeamLog:ToStringAfter(runMode)
        result = result .. self.defenderTeamLog:ToStringAfter(runMode)
    end

    result = result .. string.format("\n<> WINNER: %s\n", self.winnerTeam)

    return result
end

--- @return string
--- @param linkings List<BaseLinking>
--- @param isAttacker boolean
function BattleResult:ToLinkingDetail(linkings, isAttacker)
    local result
    if isAttacker == true then
        result = "<> ATTACKER "
    else
        result = "<> DEFENDER "
    end

    if linkings:Count() > 0 then
        result = result .. "LINKING: "
        for i = 1, linkings:Count() do
            local linking = linkings:Get(i)
            result = result .. string.format("%s (%s), ", linking.name, linking.id)
        end
        result = result .. "\n"
    else
        result = result .. "LINKING: no link\n"
    end

    return result
end