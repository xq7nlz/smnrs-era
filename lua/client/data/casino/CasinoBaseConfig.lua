--- @class CasinoBaseConfig
CasinoBaseConfig = Class(CasinoBaseConfig)

--- @return void
function CasinoBaseConfig:Ctor()
    ---@type number
    self.numberReward = nil
    ---@type number
    self.basicCasinoBuyChipPrice = nil
    ---@type number
    self.basicCasinoFreeRefreshInterval = nil
    ---@type number
    self.basicCasinoRefreshGemPrice = nil
    ---@type number
    self.basicCasinoMaxFreeRefresh = nil
    ---@type number
    self.premiumCasinoFreeRefreshInterval = nil
    ---@type number
    self.premiumCasinoRefreshGemPrice = nil
    ---@type number
    self.premiumCasinoMaxFreeRefresh = nil
    ---@type number
    self.numberBuyBasicChip = nil
    ---@type number
    self.numberAdBasic = nil
    ---@type number
    self.numberAdPremium = nil
end

--- @return void
--- @param data string
function CasinoBaseConfig:ParseCsv(data)
    self.numberReward = tonumber(data["number_reward"])
    self.basicCasinoBuyChipPrice = tonumber(data["basic_casino_buy_chip_price"])
    self.basicCasinoFreeRefreshInterval = tonumber(data["basic_casino_free_refresh_interval"])
    self.basicCasinoRefreshGemPrice = tonumber(data["basic_casino_refresh_gem_price"])
    self.basicCasinoMaxFreeRefresh = tonumber(data["basic_casino_max_free_refresh"])
    self.premiumCasinoFreeRefreshInterval = tonumber(data["premium_casino_free_refresh_interval"])
    self.premiumCasinoRefreshGemPrice = tonumber(data["premium_casino_refresh_gem_price"])
    self.premiumCasinoMaxFreeRefresh = tonumber(data["premium_casino_max_free_refresh"])
    self.numberBuyBasicChip = tonumber(data["number_buy_basic_chip"])
    self.numberAdBasic = tonumber(data["number_ad_basic"])
    self.numberAdPremium = tonumber(data["number_ad_premium"])
end