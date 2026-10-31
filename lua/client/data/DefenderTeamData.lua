--- @class DefenderTeamData
DefenderTeamData = Class(DefenderTeamData)

---@return void
function DefenderTeamData:Ctor(data)
    --- @type number
    self.stage = nil
    --- @type PredefineTeamData
    self.predefineTeamData = nil
    ---@type number
    self.powerTeam = nil

    self:ParseCsv(data)
end

function DefenderTeamData:ParseCsv(data)
    self:SetStageId(data)
    self:SetPredefineTeamData(data)
end

function DefenderTeamData:SetPredefineTeamData(data)
    self.predefineTeamData = PredefineTeamData.CreateByCsv(data)
end

function DefenderTeamData:SetStageId(data)
    if data[PredefineConstants.STAGE_TAG] ~= nil then
        ---@type number
        self.stage = tonumber(data[PredefineConstants.STAGE_TAG])
    end
end

--- @return PredefineTeamData
function DefenderTeamData:GetPredefineTeamData()
    return self.predefineTeamData
end

--- @return BattleTeamInfo
function DefenderTeamData:GetBattleTeamInfo()
    return ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfo(self.predefineTeamData)
end

---@return number
function DefenderTeamData:GetPowerTeam()
    if self.powerTeam == nil then
        --- @type BattleTeamInfo
        local battleTeamInfo = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfoByDefenderTeamData(self)
        self.powerTeam = ClientConfigUtils.GetPowerByBattleTeamInfo(battleTeamInfo)
    end
    return self.powerTeam
end

--- @return boolean
function DefenderTeamData:HasBoss()
    return (self.predefineTeamData.bossSlotId ~= nil and self.predefineTeamData.bossSlotId ~= PredefineConstants.NON_BOSS_SLOT)
end

--- @return BattleTeamInfo
--- @param predefineTeamData PredefineTeamData
function DefenderTeamData.GetBattleTeamInfoByPredefineTeam(predefineTeamData)
    return ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfo(predefineTeamData)
end

