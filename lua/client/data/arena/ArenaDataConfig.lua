--- @class ArenaDataConfig
ArenaDataConfig = Class(ArenaDataConfig)

--- @return void
function ArenaDataConfig:Ctor()
    ---@type number
    self.singleTurnFreeDaily = nil
    ---@type number
    self.singlePassMaxBuy = nil
    ---@type number
    self.gemPrice = nil
    ---@type number
    self.maxItem = nil
    ---@type number
    self.maxTicket = nil
    ---@type number
    self.ticketRegenInterval = nil

    self:InitData()
end

--- @return void
function ArenaDataConfig:InitData()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.ARENA_DATA_PATH)
    self:ParseCsv(parsedData[1])
end

--- @return void
--- @param data string
function ArenaDataConfig:ParseCsv(data)
    self.singleTurnFreeDaily = tonumber(data["number_free_challenge_daily_limit"])
    self.singlePassMaxBuy = tonumber(data["number_ticket_buy_daily_limit"])
    self.gemPrice = tonumber(data["gem_price"])
    self.maxItem = tonumber(data["max_item"])
    self.maxTicket = tonumber(data["max_ticket"])
    self.ticketRegenInterval = tonumber(data["ticket_regen_interval"])
end

return ArenaDataConfig