--- @class AttackerTeamStageConfig
AttackerTeamStageConfig = Class(AttackerTeamStageConfig)

---@return void
function AttackerTeamStageConfig:Ctor(data)
    --- @type number
    self.id = tonumber(data.id)
    --- @type number
    self.tower = tonumber(data.road)
    --- @type PredefineTeamData
    self.predefineTeamData = PredefineTeamData.CreateByCsv(data)
end

--- @return PredefineTeamData
function AttackerTeamStageConfig:GetBattleTeamInfo(teamId)
    return ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfo(self.predefineTeamData, teamId)
end

---@return number
function AttackerTeamStageConfig:GetStage()
    return math.floor(self.id / 1000)
end

---@return number
function AttackerTeamStageConfig:GetWave()
    return self.id % 1000
end

---@return number
function AttackerTeamStageConfig:GetPowerTeam()
    if self.powerTeam == nil then
        --- @type BattleTeamInfo
        local battleTeamInfo = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfo(self.predefineTeamData)
        self.powerTeam = ClientConfigUtils.GetPowerByBattleTeamInfo(battleTeamInfo)
    end
    return self.powerTeam
end