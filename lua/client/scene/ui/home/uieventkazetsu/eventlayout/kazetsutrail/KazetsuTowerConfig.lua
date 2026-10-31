require "lua.client.data.DefenderTeamData"
--- @class KazetsuTowerConfig : CampaignStageConfig
KazetsuTowerConfig = Class(KazetsuTowerConfig , CampaignStageConfig)

function KazetsuTowerConfig:Ctor()
    --- @type Dictionary --<number, DefenderTeamData>
    self._dataDictionary = Dictionary()
    --- @type List
    self.stageList = List()
end

--- @return number
function KazetsuTowerConfig:GetNumberStageByCurrentStage(stageId)
    local dificult, map, stage = ClientConfigUtils.GetIdFromStageId(stageId)
    return self:GetNumberStageByMap(dificult, map)
end

--- @data string
function KazetsuTowerConfig:ParseCsv(parsedData, dataId)
    for k, v in ipairs(parsedData) do
        local stageId = tonumber(v['stage'])
        if MathUtils.IsInteger(stageId) then
            local data = DefenderTeamData(v)
            self._dataDictionary:Add(data.stage, data)
        end
    end
    --self:_InitPowerTeam(dataId)
end


--- @return number
function KazetsuTowerConfig:GetTotalTower()
   return  self._dataDictionary:Count()
end

--- @return void
function KazetsuTowerConfig:_InitPowerTeam(dataId)
    local data
    if dataId ~= nil then
        data = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.CAMPAIGN_DEFENDER_POWER_PATH_AB_Test:format(dataId))
    else
        data = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.CAMPAIGN_DEFENDER_POWER_PATH)
    end
    for i = 1, #data do
        local v = data[i]
        self._dataDictionary:Get(tonumber(v.stage)).powerTeam = v.power
    end
end