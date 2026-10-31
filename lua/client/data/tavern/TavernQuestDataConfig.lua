
--- @class TavernQuestDataConfig
TavernQuestDataConfig = Class(TavernQuestDataConfig)

--- @return void
function TavernQuestDataConfig:Ctor()
    --- @type number
    self.star = nil
    --- @type number
    self.time = nil
    --- @type number
    self.refreshGem = nil
    --- @type number
    self.speedUpGem = nil
end

--- @return void
--- @param data string
function TavernQuestDataConfig:ParseCsv(data)
    self.star = tonumber(data.star)
    self.time = tonumber(data.complete_time)
    self.refreshGem = tonumber(data.refresh_gem_price)
    self.speedUpGem = tonumber(data.speedup_gem_price)
end

return TavernQuestDataConfig