FormationPositionConfig = {}

---@type TeamPosition
local attacker
---@type TeamPosition
local defender

--- @return void
local function InitAttackerTeam()
    ---@type FormationPosition
    local team41 = FormationPosition()
    team41:AddPosition(true, 1, Vector2(-4.91, -3.5))
    team41:AddPosition(true, 2, Vector2(-3.8, -1.86))
    team41:AddPosition(true, 3, Vector2(-2.74, -0.15))
    team41:AddPosition(true, 4, Vector2(-1.57, 1.47))
    team41:AddPosition(false, 1, Vector2(-6.1, -0.78))
    attacker:AddFormation(1, team41)

    ---@type FormationPosition
    local team14 = FormationPosition()
    team14:AddPosition(true, 1, Vector2(-2.8, -0.95))
    team14:AddPosition(false, 1, Vector2(-7.06, -3.34))
    team14:AddPosition(false, 2, Vector2(-5.94, -1.7))
    team14:AddPosition(false, 3, Vector2(-4.89, 0))
    team14:AddPosition(false, 4, Vector2(-3.72, 1.626))
    attacker:AddFormation(2, team14)

    ---@type FormationPosition
    local team32 = FormationPosition()
    team32:AddPosition(true, 1, Vector2(-4.06, -2.64))
    team32:AddPosition(true, 2, Vector2(-3.01, -0.93))
    team32:AddPosition(true, 3, Vector2(-1.84, 0.69))
    team32:AddPosition(false, 1, Vector2(-6.3, -1.6))
    team32:AddPosition(false, 2, Vector2(-5.2, 0.05))
    attacker:AddFormation(3, team32)

    ---@type FormationPosition
    local team23 = FormationPosition()
    team23:AddPosition(true, 1, Vector2(-3.5, -1.98))
    team23:AddPosition(true, 2, Vector2(-2.45, -0.34))
    team23:AddPosition(false, 1, Vector2(-6.98, -2.63))
    team23:AddPosition(false, 2, Vector2(-5.82, -0.98))
    team23:AddPosition(false, 3, Vector2(-4.56, 0.6))
    attacker:AddFormation(4, team23)

    ---@type FormationPosition
    local team10 = FormationPosition()
    team10:AddPosition(true, 1, Vector2(-5.5, -2.48))
    attacker:AddFormation(5, team10)

    ---@type FormationPosition
    local team01 = FormationPosition()
    team01:AddPosition(false, 1, Vector2(-5.5, -2.48))

    attacker:AddFormation(6, team01)

    attacker:SetSummonerPosition(Vector2(-7.7, 1.9))
end

--- @return void
local function InitDefenderTeam()
    ---@type FormationPosition
    local team41 = FormationPosition()
    team41:AddPosition(true, 1, Vector2(5.7, -3.5))
    team41:AddPosition(true, 2, Vector2(4.6, -1.86))
    team41:AddPosition(true, 3, Vector2(3.54, -0.15))
    team41:AddPosition(true, 4, Vector2(2.37, 1.47))
    team41:AddPosition(false, 1, Vector2(6.9, -0.78))
    defender:AddFormation(1, team41)

    ---@type FormationPosition
    local team14 = FormationPosition()
    team14:AddPosition(true, 1, Vector2(2.8, -0.95))
    team14:AddPosition(false, 1, Vector2(7.06, -3.34))
    team14:AddPosition(false, 2, Vector2(5.94, -1.7))
    team14:AddPosition(false, 3, Vector2(4.89, 0))
    team14:AddPosition(false, 4, Vector2(3.72, 1.626))
    defender:AddFormation(2, team14)

    ---@type FormationPosition
    local team32 = FormationPosition()
    team32:AddPosition(true, 1, Vector2(4.06, -2.64))
    team32:AddPosition(true, 2, Vector2(3.01, -0.93))
    team32:AddPosition(true, 3, Vector2(1.84, 0.69))
    team32:AddPosition(false, 1, Vector2(6.3, -1.6))
    team32:AddPosition(false, 2, Vector2(5.2, 0.05))
    defender:AddFormation(3, team32)

    ---@type FormationPosition
    local team23 = FormationPosition()
    team23:AddPosition(true, 1, Vector2(3.5, -1.98))
    team23:AddPosition(true, 2, Vector2(2.45, -0.34))
    team23:AddPosition(false, 1, Vector2(6.98, -2.63))
    team23:AddPosition(false, 2, Vector2(5.82, -0.98))
    team23:AddPosition(false, 3, Vector2(4.56, 0.6))
    defender:AddFormation(4, team23)

    ---@type FormationPosition
    local team10 = FormationPosition()
    team10:AddPosition(true, 1, Vector2(5.5, -2.48))
    defender:AddFormation(5, team10)

    ---@type FormationPosition
    local team01 = FormationPosition()
    team01:AddPosition(false, 1, Vector2(5.5, -2.48))
    defender:AddFormation(6, team01)

    defender:SetSummonerPosition(Vector2(7.7, 1.9))
end

--- @return void
local function InitTeam()
    InitAttackerTeam()
    InitDefenderTeam()
end

---@return void
local function Init()
    attacker = TeamPosition()
    defender = TeamPosition()

    InitTeam()
end

--- @param teamId number
--- @param formationId number
function FormationPositionConfig.GetTeamFormation(teamId, formationId)
    if teamId == BattleConstants.ATTACKER_TEAM_ID then
        return attacker:GetFormation(formationId)
    else
        return defender:GetFormation(formationId)
    end
end

function FormationPositionConfig.GetBattleCentralPosition()
    return Vector2(0, -2)
end

--- @param baseHero BaseHero
function FormationPositionConfig.GetHeroPosition(baseHero)
    local position
    if baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
        if baseHero:IsSummoner() == true then
            position = Vector2.Clone(attacker:GetSummonerPosition())
        else
            position = Vector2.Clone(attacker:GetFormation(baseHero.positionInfo.formationId):GetPosition(baseHero.positionInfo.isFrontLine, baseHero.positionInfo.position))
        end
    else
        if baseHero:IsSummoner() == true then
            position = Vector2.Clone(defender:GetSummonerPosition())
        else
            position = Vector2.Clone(defender:GetFormation(baseHero.positionInfo.formationId):GetPosition(baseHero.positionInfo.isFrontLine, baseHero.positionInfo.position))
        end
    end
    return position
end

--- @return UnityEngine_Vector3
--- @param isAttackerTeam boolean
function FormationPositionConfig.GetSummonerPosition(isAttackerTeam)
    if isAttackerTeam == true then
        return Vector2.Clone(attacker:GetSummonerPosition())
    else
        return Vector2.Clone(defender:GetSummonerPosition())
    end
end

--- @return UnityEngine_Vector2
--- @param teamId number
function FormationPositionConfig.GetCenterTeamPosition(teamId)
    if teamId == BattleConstants.ATTACKER_TEAM_ID then
        return Vector2(-4.5, 0)
    else
        return Vector2(4.5, 0)
    end
end

Init()