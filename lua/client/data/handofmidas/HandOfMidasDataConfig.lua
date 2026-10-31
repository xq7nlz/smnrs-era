require "lua.client.data.HandOfMidas.HandOfMidasData"

--- @class HandOfMidasDataConfig
HandOfMidasDataConfig = Class(HandOfMidasDataConfig)

---@return void
function HandOfMidasDataConfig:Ctor()
    ---@type number
    self.refreshInterval = nil
    ---@type Dictionary --HandOfMidasData
    self.dictData = Dictionary()
    self:ParseCsv()
end

---@return void
function HandOfMidasDataConfig:ParseCsv()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.HAND_OF_MIDAS_CONFIG)
    self.refreshInterval = tonumber(parsedData[1].refresh_interval)
    for i = 1, #parsedData do
        ---@type HandOfMidasData
        local data = HandOfMidasData()
        data:ParseCsv(parsedData[i])
        self.dictData:Add(data.id, data)
    end
end

return HandOfMidasDataConfig