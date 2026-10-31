require "lua.client.core.network.playerData.formation.TeamFormationInBound"

--- @class FormationInBound
FormationInBound = Class(FormationInBound)

--- @return void
function FormationInBound:Ctor()
    --- @type Dictionary --<FormationMode, TeamFormationInBound>
    self.teamDict = Dictionary()
    --- @type Dictionary --<team, TeamFormationInBound>
    self.arenaTeamDict = Dictionary()
end

--- @return TeamFormationInBound
function FormationInBound:GetArenaTeam(team, id)
    local mode = team * 1000 + id
    ---@type TeamFormationInBound
    local teamFormationInBound = self.arenaTeamDict:Get(mode)
    if teamFormationInBound == nil then
        teamFormationInBound = TeamFormationInBound()
        teamFormationInBound:SetDefaultTeam()
    end
    return teamFormationInBound
end

--- @param buffer UnifiedNetwork_ByteBuf
function FormationInBound:ReadBuffer(buffer)
    local size = buffer:GetByte()
    self.teamDict:Clear()
    for _ = 1, size do
        self.teamDict:Add(buffer:GetByte(), TeamFormationInBound.CreateByBuffer(buffer))
    end
    size = buffer:GetByte()
    self.arenaTeamDict:Clear()
    for _ = 1, size do
        self.arenaTeamDict:Add(buffer:GetShort(), TeamFormationInBound.CreateByBuffer(buffer))
    end

    self.teamDict:RemoveByKey(GameMode.DOMAINS)

    self:FixFormation(self.teamDict)
    self:FixFormation(self.arenaTeamDict)
end

--- @return void
--- @param dict Dictionary
function FormationInBound:FixFormation(dict)
    ---@param v TeamFormationInBound
    for _, v in pairs(dict:GetItems()) do
        local inBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
        if inBound ~= nil and ResourceMgr.GetFormationLockConfig().dict:Get(v.formationId) > inBound.level then
            v.formationId = ResourceMgr.GetFormationLockConfig().formationDefault
        end
    end
end

--- @return void
function FormationInBound:ToString()
    local str = "size: " .. self.teamDict:Count() .. "\n"
    for k, v in pairs(self.teamDict:GetItems()) do
        str = str .. string.format("key:%s, value: %s\n", k, v:ToString())
    end

    return str
end

--- @param teamFormationInBound TeamFormationInBound
function FormationInBound:AddTeamFormationInBound(gameMode, teamFormationInBound)
    self.teamDict:Add(gameMode, teamFormationInBound)
end

--- @return TeamFormationInBound
function FormationInBound:GetTeamFormationInBound(gameMode)
    return self.teamDict:Get(gameMode)
end

return FormationInBound