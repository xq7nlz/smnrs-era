--- @class CostInBound
CostInBound = Class(CostInBound)

--- @return void
function CostInBound:Ctor()
    --- @type MoneyType
    self.moneyType = nil
    --- @type number
    self.value = nil
end


--- @return string
function CostInBound:ToString()
    return LogUtils.ToDetail(self)
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function CostInBound.CreateByBuffer(buffer)
    local data = CostInBound()

    --- @type MoneyType
    data.moneyType = buffer:GetByte()
    data.value = buffer:GetInt()

    return data
end

--- @return CostInBound
--- @param json table
function CostInBound.CreateByJson(json)
    local data = CostInBound()

    data.moneyType = json['0']
    data.value = json['1']

    return data
end