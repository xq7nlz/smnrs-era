--- @class StoneCostConfig
StoneCostConfig = Class(StoneCostConfig)

--- @return void
function StoneCostConfig:Ctor()
    --- @type number
    self.group = -1
    --- @type number
    self.upgradeGold = 0
    --- @type number
    self.upgradeDust = 0
    --- @type number
    self.keepProperty = 0
    --- @type number
    self.convertGold = 0
    --- @type number
    self.convertDust = 0
    --- @type number
    self.disableRate = 0
end

--- @return void
--- @param data string
function StoneCostConfig:ParseCsv(data)
    self.group = tonumber(data.group)
    self.upgradeGold = tonumber(data.upgrade_gold_price)
    self.upgradeDust = tonumber(data.upgrade_stone_dust_price)
    self.keepProperty = tonumber(data.keep_property_price)
    self.convertGold = tonumber(data.convert_gold_price)
    self.convertDust = tonumber(data.convert_stone_dust_price)
    self.disableRate = tonumber(data.disassemble_rate)
end