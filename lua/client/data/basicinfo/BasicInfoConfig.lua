--- @class BasicInfoConfig
BasicInfoConfig = Class(BasicInfoConfig)

--- @return void
function BasicInfoConfig:Ctor()
    ---@type number
    self.minCharacterOfName = nil
    ---@type number
    self.maxCharacterOfName = nil
    ---@type number
    self.changeNameGemPrice = nil

    self:InitData()
end

--- @return void
function BasicInfoConfig:InitData()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.BASIC_INFO_CONFIG_PATH)
    self:ParseCsv(parsedData[1])
end

--- @return void
--- @param data string
function BasicInfoConfig:ParseCsv(data)
    self.minCharacterOfName = tonumber(data["min_character_of_name"])
    self.maxCharacterOfName = tonumber(data["max_character_of_name"])
    self.changeNameGemPrice = tonumber(data["change_name_gem_price"])
end

return BasicInfoConfig