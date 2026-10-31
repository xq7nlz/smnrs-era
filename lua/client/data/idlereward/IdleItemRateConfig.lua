--- @class IdleItemRateConfig
IdleItemRateConfig = Class(IdleItemRateConfig)

--- @return void
function IdleItemRateConfig:Ctor()
    --- @type number
    self.group = -1
    --- @type number
    self.groupRate = -1
    --- @type number
    self.resourceType = -1
    --- @type number
    self.id = -1
    --- @type number
    self.number = 0
    --- @type number
    self.rate = 0
    --- @type number
    self.cacheRate = 0
    --- @type number
    self.initialProductionNumber = 0
    --- @type number
    self.productionNumber = 0
    --- @type number
    self.productionTime = 0
end

--- @return void
--- @param data string
function IdleItemRateConfig:ParseCsv(data)
    self.resourceType = tonumber(data.res_type)
    self.id = tonumber(data.res_id)
    self.number = tonumber(data.res_number)
    self.rate = tonumber(data.item_rate)
    self.initialProductionNumber = tonumber(data.initial_production_number)
    self.productionNumber = tonumber(data.production_number)
    self.productionTime = tonumber(data.production_time)
end