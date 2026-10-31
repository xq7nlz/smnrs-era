require "lua.client.data.Casino.CasinoBaseConfig"
require "lua.client.data.Casino.CasinoPriceConfig"

--- @class CasinoDataConfig
CasinoDataConfig = Class(CasinoDataConfig)

--- @return void
function CasinoDataConfig:Ctor()
    --- @type CasinoBaseConfig
    self.casinoBaseConfig = self:GetCasinoBaseConfig()
    --- @type Dictionary --<id, List<CasinoPriceConfig>>
    self.casinoPriceDictionary = self:GetCasinoPriceDictionary()
end

--- @return CasinoBaseConfig
function CasinoDataConfig:GetCasinoBaseConfig()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.CASINO_CONFIG_PATH)
    --- @type CasinoBaseConfig
    local data = CasinoBaseConfig()
    data:ParseCsv(parsedData[1])
    return data
end

--- @return Dictionary<key, value>
function CasinoDataConfig:GetCasinoPriceDictionary()
    local dict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.CASINO_PRICE_PATH)
    for i = 1, #parsedData do
        --- @type CasinoPriceConfig
        local data = CasinoPriceConfig()
        data:ParseCsv(parsedData[i])
        local list
        if dict:IsContainKey(data.spinType) then
            list = dict:Get(data.spinType)
        else
            list = List()
            dict:Add(data.spinType, list)
        end
        list:Add(data)
    end
    return dict
end

return CasinoDataConfig

