--- @class TempleSummonData
TempleSummonData = Class(TempleSummonData)

--- @return void
function TempleSummonData:Ctor()
    --- @type Dictionary --- rate summon fragment and convert rate
    self.convertPrice = nil
    --- @type Dictionary
    self.summonPrice = nil
end

--- @return Dictionary
--- @param star number
function TempleSummonData:GetConvertPrice(star)
    if self.convertPrice == nil then
        self:_InitConvertPrice()
    end
    return self.convertPrice:Get(star).price
end

--- @return Dictionary
--- @param quantity number
function TempleSummonData:GetSummonPrice(quantity)
    if self.summonPrice == nil then
        self:_InitSummonPrice()
    end
    return self.summonPrice:Get(quantity).moneyValue
end

--- @return Dictionary
--- @param quantity number
function TempleSummonData:GetSummonPriceByGem(quantity)
    if self.summonPrice == nil then
        self:_InitSummonPrice()
    end
    return self.summonPrice:Get(quantity).gemPrice
end

--- @return void
function TempleSummonData:_InitConvertPrice()
    local content = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.TEMPLE_CONVERT_PRICE)
    self.convertPrice = Dictionary()
    for i, v in ipairs(content) do
        local star = tonumber(v.star)
        local data = {}
        data.price = tonumber(v.money_value)
        data.moneyType = tonumber(v.money_type)
        self.convertPrice:Add(star, data)
    end
end

--- @return void
function TempleSummonData:_InitSummonPrice()
    local content = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.TEMPLE_SUMMON_PRICE)
    self.summonPrice = Dictionary()
    for i, v in ipairs(content) do
        local data = {}
        data.moneyType = tonumber(v.money_type)
        data.moneyValue = tonumber(v.money_value)
        data.gemPrice = tonumber(v.gem_price)
        data.vipLevel = tonumber(v.vip_level_required_use_gem)
        self.summonPrice:Add(tonumber(v.summon_number), data)
    end
end

return TempleSummonData