--- @class BattleTeamLog
BattleTeamLog = Class(BattleTeamLog)

--- @return void
--- @param teamId number
function BattleTeamLog:Ctor(teamId)
    --- @type number
    self.teamId = teamId

    --- @type List<HeroStatusLog>
    self.beforeLogs = List()
    --- @type List<HeroStatusLog>
    self.afterLogs = List()
end

--- @return void
--- @param team BattleTeam
function BattleTeamLog:SetTeamBefore(team)
    self:SetTeam(team, self.beforeLogs)
end

--- @return void
--- @param team BattleTeam
function BattleTeamLog:SetTeamAfter(team)
    self:SetTeam(team, self.afterLogs)
end

--- @return void
--- @param team BattleTeam
--- @type List<HeroStatusLog> List
function BattleTeamLog:SetTeam(team, logs)
    local summoner = team:GetSummoner()
    local summonerStatusLog = HeroStatusLog(summoner)
    logs:Add(summonerStatusLog)

    for _, hero in pairs(team.frontLine) do
        local heroStatusLog = HeroStatusLog(hero)
        logs:Add(heroStatusLog)
    end

    for _, hero in pairs(team.backLine) do
        local heroStatusLog = HeroStatusLog(hero)
        logs:Add(heroStatusLog)
    end
end

--- @return BattleTeamLog
function BattleTeamLog:GetData()
    local data = {}

    data.teamId = self.teamId
    data.beforeLogs = self.beforeLogs:GetData()
    data.afterLogs = self.afterLogs:GetData()

    return data
end

---------------------------------------- ToString ----------------------------------------
--- @return string
--- @param runMode RunMode
function BattleTeamLog:ToStringBefore(runMode)
    local result
    if self.teamId == BattleConstants.ATTACKER_TEAM_ID then
        result = "\n<> BEFORE ATTACKER TEAM\n"
    else
        result = "\n<> BEFORE DEFENDER TEAM\n"
    end

    for i = 1, self.beforeLogs:Count() do
        local hero = self.beforeLogs:Get(i)
        result = result .. hero:ToString(runMode)
    end

    return result
end

--- @return string
--- @param runMode RunMode
function BattleTeamLog:ToStringAfter(runMode)
    local result
    if self.teamId == BattleConstants.ATTACKER_TEAM_ID then
        result = "\n<> AFTER ATTACKER TEAM\n"
    else
        result = "\n<> AFTER DEFENDER TEAM\n"
    end

    for i = 1, self.afterLogs:Count() do
        local hero = self.afterLogs:Get(i)
        result = result .. hero:ToString(runMode)
    end

    return result
end