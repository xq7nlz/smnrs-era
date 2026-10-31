require "lua.client.config.battle.TeamPosition"
require "lua.client.config.battle.FormationPosition"
require "lua.client.data.Vector2"
require "lua.client.config.battle.FormationPositionConfig"

PositionConfig = {}

--- @type UnityEngine_Vector3
PositionConfig.frontLinePos = U_Vector3(2.4, -1.8, 0)
--- @type UnityEngine_Vector3
PositionConfig.backLinePos = U_Vector3(4.4, -1.8, 0)

--- @type TeamPosition
local attacker
--- @type TeamPosition
local defender
--- @type List
local listDemoPosition

--- @return void
local function InitAttackerTeam()
    ---@type FormationPosition
    local team41 = FormationPosition()
    team41:AddPosition(true, 1, Vector2(-5, -4.18))
    team41:AddPosition(true, 2, Vector2(-4.2, -2.38))
    team41:AddPosition(true, 3, Vector2(-3.4, -0.68))
    team41:AddPosition(true, 4, Vector2(-2.6, 0.92))
    team41:AddPosition(false, 1, Vector2(-7.2, -1.78))
    attacker:AddFormation(1, team41)

    ---@type FormationPosition
    local team14 = FormationPosition()
    team14:AddPosition(true, 1, Vector2(-2.6, -1.78))
    team14:AddPosition(false, 1, Vector2(-7.2, -4.18))
    team14:AddPosition(false, 2, Vector2(-6.4, -2.38))
    team14:AddPosition(false, 3, Vector2(-5.6, -0.68))
    team14:AddPosition(false, 4, Vector2(-4.2, 0.92))
    attacker:AddFormation(2, team14)

    ---@type FormationPosition
    local team32 = FormationPosition()
    team32:AddPosition(true, 1, Vector2(-3.8, -4.18))
    team32:AddPosition(true, 2, Vector2(-3.2, -1.58))
    team32:AddPosition(true, 3, Vector2(-2.6, 0.92))
    team32:AddPosition(false, 1, Vector2(-7.2, -3.78))
    team32:AddPosition(false, 2, Vector2(-6.2, -1.28))
    attacker:AddFormation(3, team32)

    ---@type FormationPosition
    local team23 = FormationPosition()
    team23:AddPosition(true, 1, Vector2(-3.2, -3.78))
    team23:AddPosition(true, 2, Vector2(-2.6, -1.28))
    team23:AddPosition(false, 1, Vector2(-7.2, -4.18))
    team23:AddPosition(false, 2, Vector2(-6, -1.58))
    team23:AddPosition(false, 3, Vector2(-4.8, 0.92))
    attacker:AddFormation(4, team23)

    ---@type FormationPosition
    local team10 = FormationPosition()
    team10:AddPosition(true, 1, Vector2(-5.5, -2.48))
    attacker:AddFormation(5, team10)

    ---@type FormationPosition
    local team01 = FormationPosition()
    team01:AddPosition(false, 1, Vector2(-5.5, -2.48))

    attacker:AddFormation(6, team01)

    attacker:SetSummonerPosition(Vector2(-7.7, 1.18))
end

--- @return void
local function InitDefenderTeam()
    ---@type FormationPosition
    local team41 = FormationPosition()
    team41:AddPosition(true, 1, Vector2(5, -4.18))
    team41:AddPosition(true, 2, Vector2(4.2, -2.38))
    team41:AddPosition(true, 3, Vector2(3.4, -0.68))
    team41:AddPosition(true, 4, Vector2(2.6, 0.92))
    team41:AddPosition(false, 1, Vector2(7.2, -1.78))
    defender:AddFormation(1, team41)

    ---@type FormationPosition
    local team14 = FormationPosition()
    team14:AddPosition(true, 1, Vector2(2.6, -1.78))
    team14:AddPosition(false, 1, Vector2(7.2, -4.18))
    team14:AddPosition(false, 2, Vector2(6.4, -2.38))
    team14:AddPosition(false, 3, Vector2(5.6, -0.68))
    team14:AddPosition(false, 4, Vector2(4.2, 0.92))
    defender:AddFormation(2, team14)

    ---@type FormationPosition
    local team32 = FormationPosition()
    team32:AddPosition(true, 1, Vector2(3.8, -4.18))
    team32:AddPosition(true, 2, Vector2(3.2, -1.58))
    team32:AddPosition(true, 3, Vector2(2.6, 0.92))
    team32:AddPosition(false, 1, Vector2(7.2, -3.78))
    team32:AddPosition(false, 2, Vector2(6.2, -1.28))
    defender:AddFormation(3, team32)

    ---@type FormationPosition
    local team23 = FormationPosition()
    team23:AddPosition(true, 1, Vector2(3.2, -3.78))
    team23:AddPosition(true, 2, Vector2(2.6, -1.28))
    team23:AddPosition(false, 1, Vector2(7.2, -4.18))
    team23:AddPosition(false, 2, Vector2(6, -1.58))
    team23:AddPosition(false, 3, Vector2(4.8, 0.92))
    defender:AddFormation(4, team23)

    ---@type FormationPosition
    local team10 = FormationPosition()
    team10:AddPosition(true, 1, Vector2(5.5, -2.48))
    defender:AddFormation(5, team10)

    ---@type FormationPosition
    local team01 = FormationPosition()
    team01:AddPosition(false, 1, Vector2(5.5, -2.48))
    defender:AddFormation(6, team01)

    defender:SetSummonerPosition(Vector2(7.7, 1.18))
end

--- @return void
local function InitTeam()
    InitAttackerTeam()
    InitDefenderTeam()
end

local function InitDemoPos()
    listDemoPosition = List()
    listDemoPosition:Add(U_Vector3(-2, -1.4, 0))
    listDemoPosition:Add(U_Vector3(-6.5, -2.5, 0))
    listDemoPosition:Add(U_Vector3(-4.7, 0, 0))
end

---@return void
local function Init()
    attacker = TeamPosition()
    defender = TeamPosition()
    InitDemoPos()
    InitTeam()
end

--- @param teamId number
--- @param formationId number
function PositionConfig.GetTeamFormation(teamId, formationId)
    if teamId == BattleConstants.ATTACKER_TEAM_ID then
        return attacker:GetFormation(formationId)
    else
        return defender:GetFormation(formationId)
    end
end

function PositionConfig.GetBattleCentralPosition()
    return Vector2(0, -2)
end

--- @param baseHero BaseHero
function PositionConfig.GetHeroPosition(baseHero)
    --- @type FormationPosition
    local formationPosition

    if baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
        if baseHero:IsSummoner() == true then
            return Vector2.Clone(attacker:GetSummonerPosition())
        end
        formationPosition = attacker:GetFormation(baseHero.positionInfo.formationId)
    else
        if baseHero:IsSummoner() == true then
            return Vector2.Clone(defender:GetSummonerPosition())
        end
        formationPosition = defender:GetFormation(baseHero.positionInfo.formationId)
    end
    if formationPosition == nil then
        XDebug.Error("Position not found")
        return U_Vector2(0, 0)
    end
    return formationPosition:GetPosition(baseHero.positionInfo.isFrontLine, baseHero.positionInfo.position)
end

--- @return UnityEngine_Vector2
--- @param teamId number
--- @param formationId number
--- @param positionId number
function PositionConfig.GetPosition(teamId, formationId, isFrontLine, positionId)
    --- @type FormationPosition
    local formationPosition
    if teamId == BattleConstants.ATTACKER_TEAM_ID then
        formationPosition = attacker:GetFormation(formationId)
    else
        formationPosition = defender:GetFormation(formationId)
    end
    if formationPosition == nil then
        XDebug.Error("Position not found")
        return U_Vector2(0, 0)
    end
    return formationPosition:GetPosition(isFrontLine, positionId)
end

--- @return UnityEngine_Vector3
--- @param isAttackerTeam boolean
function PositionConfig.GetSummonerPosition(isAttackerTeam)
    if isAttackerTeam == true then
        return Vector2.Clone(attacker:GetSummonerPosition())
    else
        return Vector2.Clone(defender:GetSummonerPosition())
    end
end

--- @return UnityEngine_Vector2
--- @param teamId number
function PositionConfig.GetCenterTeamPosition(teamId)
    if teamId == BattleConstants.ATTACKER_TEAM_ID then
        return Vector2(-4.5, 0)
    else
        return Vector2(4.5, 0)
    end
end

--- @return UnityEngine_Vector2
--- @param teamId number
function PositionConfig.GetDivineShieldTeamPosition(teamId)
    if teamId == BattleConstants.ATTACKER_TEAM_ID then
        return Vector2(-1.37, -1.37)
    else
        return Vector2(1.37, -1.37)
    end
end

--- @return UnityEngine_Vector2
--- @param allyTeamId number
function PositionConfig.GetOpponentCenterTeamPosition(allyTeamId)
    if allyTeamId == BattleConstants.ATTACKER_TEAM_ID then
        return PositionConfig.GetCenterTeamPosition(BattleConstants.DEFENDER_TEAM_ID)
    else
        return PositionConfig.GetCenterTeamPosition(BattleConstants.ATTACKER_TEAM_ID)
    end
end

--- @return UnityEngine_Vector2
--- @param teamId number
function PositionConfig.GetLinePosition(teamId, isFrontLine)
    if teamId == BattleConstants.DEFENDER_TEAM_ID then
        if isFrontLine then
            return PositionConfig.frontLinePos
        end
        return PositionConfig.backLinePos
    else
        if isFrontLine then
            return U_Vector3(-PositionConfig.frontLinePos.x, PositionConfig.frontLinePos.y, PositionConfig.frontLinePos.z)
        end
        return U_Vector3(-PositionConfig.backLinePos.x, PositionConfig.backLinePos.y, PositionConfig.backLinePos.z)
    end
end

--- @return UnityEngine_Vector2
--- @param teamId number
function PositionConfig.GetOpponentLinePosition(teamId, isFrontLine)
    if teamId == BattleConstants.ATTACKER_TEAM_ID then
        return PositionConfig.GetLinePosition(BattleConstants.DEFENDER_TEAM_ID, isFrontLine)
    else
        return PositionConfig.GetLinePosition(BattleConstants.ATTACKER_TEAM_ID, isFrontLine)
    end
end

--- @return UnityEngine_Vector2
--- @param opponentTeamId number
function PositionConfig.GetAccostOpponentLinePosition(opponentTeamId, isFrontLine, offset)
    offset = offset or 0
    local opponentLinePosition = PositionConfig.GetLinePosition(opponentTeamId, isFrontLine)
    if opponentTeamId == BattleConstants.ATTACKER_TEAM_ID then
        opponentLinePosition = opponentLinePosition + U_Vector3.right * offset
    else
        opponentLinePosition = opponentLinePosition + U_Vector3.left * offset
    end
    return opponentLinePosition
end

--- @return UnityEngine_Vector3
--- @param index number
function PositionConfig.GetDemoPosByIndex(index)
    if index > 0 and index <= listDemoPosition:Count() then
        return listDemoPosition:Get(index)
    end
    return listDemoPosition:Get(1)
end

Init()