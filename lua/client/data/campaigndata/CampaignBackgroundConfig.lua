--- @class CampaignBackgroundConfig
CampaignBackgroundConfig = Class(CampaignBackgroundConfig)

function CampaignBackgroundConfig:Ctor()
    --- @type Dictionary
    self.bgConfigDict = nil
    self:_InitConfig()
end

function CampaignBackgroundConfig:_InitConfig()
    self.bgConfigDict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.CAMPAIGN_BACKGROUND_CONFIG_PATH)
    local currentStageId
    for i = 1, #parsedData do
        local stageId = tonumber(parsedData[i].stage_id)
        local bgId = tonumber(parsedData[i].background_id)
        if MathUtils.IsNumber(stageId) == true then
            currentStageId = stageId
            local newList = List()
            newList:Add(bgId)
            self.bgConfigDict:Add(currentStageId, newList)
        else
            --- @type List
            local currentList = self.bgConfigDict:Get(currentStageId)
            if currentList ~= nil and currentList:IsContainValue(bgId) == false then
                currentList:Add(bgId)
                self.bgConfigDict:Add(currentStageId, currentList)
            end
        end
    end
end

--- @return number
--- @param stageId number
function CampaignBackgroundConfig:GetRandomBgByStage(stageId, fixedIndex)
    --- @type List
    local list = self.bgConfigDict:Get(stageId)
    if list ~= nil and list:Count() > 0 then
        local index = 1
        if fixedIndex == nil then
            index = (math.random(list:Count()))
        end
        return list:Get(index)
    end
    return 101
end