--- @class HandOfMidasData
HandOfMidasData = Class(HandOfMidasData)

---@return void
function HandOfMidasData:Ctor()
    ---@type number
    self.id = nil
    ---@type number
    self.gemPrice = nil
    ---@type number
    self.resourceType = nil
    ---@type number
    self.resourceId = nil
    ---@type string
    self.resourceNumber = nil
    ---@type boolean
    self.isWatchAds = false
end

---@return void
function HandOfMidasData:ParseCsv(data)
    self.id = tonumber(data.id)
    self.gemPrice = tonumber(data.gem_price)
    self.resourceType = tonumber(data.res_type)
    self.resourceId = tonumber(data.res_id)
    self.resourceNumber = data.res_number
    self.isWatchAds = data.is_watch_ads == "TRUE"
end

--- @return number
function HandOfMidasData:CalculateResource()
    if self.resourceType ~= ResourceType.Money or self.resourceId ~= MoneyType.GOLD then
        XDebug.Error(string.format("data is invalid: type[%s] id[%s]", tostring(self.resourceType), tostring(self.resourceId)))
        return 0
    else
        return MathUtils.Round(ClientMathUtils.ConvertingCalculation(self.resourceNumber))
    end
end