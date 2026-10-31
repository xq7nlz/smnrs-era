require "lua.client.core.network.playerData.defenseMode.defenseRecordData.DefenseStageRecordData"

--- @class DefenseLandRecordData
DefenseLandRecordData = Class(DefenseLandRecordData)

function DefenseLandRecordData:Ctor(land)
    --- @type Dictionary
    self.stageRecordDict = Dictionary()
end

function DefenseLandRecordData:GetListStageRecord(isPlayerRecord, land, stage, callback)
    --- @type DefenseStageRecordData
    local stageRecordData = self.stageRecordDict:Get(stage)
    if stageRecordData == nil then
        stageRecordData = DefenseStageRecordData(stage)
        self.stageRecordDict:Add(stage, stageRecordData)
    end
    stageRecordData:GetListStageRecord(isPlayerRecord, land, stage, callback)
end