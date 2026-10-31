
local CSV_PATH = "csv/tutorial/tutorial_summon_config.csv"

--- @class TutorialSummonConfig
TutorialSummonConfig = Class(TutorialSummonConfig)

function TutorialSummonConfig:Ctor()
    --- @type Dictionary  --<step, SummonType>
    self.dict = nil
    self.maxStep = 0
    self:ReadData()
end

function TutorialSummonConfig:ReadData()
    self.dict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CSV_PATH)
    for i = 1, #parsedData do
        local data = parsedData[i]
        local summonStep = tonumber(data.summon_step)
        local summonType = tonumber(data.summon_type)
        if self.maxStep < summonStep then
            self.maxStep = summonStep
        end
        self.dict:Add(summonStep, summonType)
    end
end

return TutorialSummonConfig