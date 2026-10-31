---@class TeamPosition
TeamPosition = Class(TeamPosition)

---@return void
function TeamPosition:Ctor()
    self.formation = {}
    --- @type Vector2
    self.summonerPosition = {}
end

---@return void
---@param formationId number
---@param formation FormationPosition
function TeamPosition:AddFormation(formationId, formation)
    self.formation[formationId] = formation
end

---@return FormationPosition
---@param formationId
function TeamPosition:GetFormation(formationId)
    return self.formation[formationId]
end

--- @param summonerPosition Vector2
function TeamPosition:SetSummonerPosition(summonerPosition)
    self.summonerPosition = summonerPosition
end

--- @return Vector2
function TeamPosition:GetSummonerPosition()
    return self.summonerPosition
end

---@return void
function TeamPosition:Print()
    XDebug.Log("Team Position")
    for i, v in pairs(self.formation) do
        v:Print()
    end
end