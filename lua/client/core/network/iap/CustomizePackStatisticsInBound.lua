--- @class CustomizePackStatisticsInBound
CustomizePackStatisticsInBound = Class(CustomizePackStatisticsInBound)

function CustomizePackStatisticsInBound:Ctor(id)
    --- @type number
    self.packId = id
    --- @type number
    self.numberOfBought = 0
    --- @type number
    self.resetTimeInSeconds = 0
    --- @type List<number>
    self.listOfSelectedItem = List() -- List item da chon
    --- @type CustomizeProduct
    self.product = ResourceMgr.GetPurchaseConfig()
            :GetCashShop():GetCustomizeProducts(self.packId)
    --- @type number
    self.stock = self.product.stock
end

--- @return boolean
function CustomizePackStatisticsInBound:ReachedLimit()
    return self.numberOfBought == self.stock
end

function CustomizePackStatisticsInBound:IncreaseNumberOfBought()
    self.numberOfBought = self.numberOfBought + 1
end

function CustomizePackStatisticsInBound:GetNumberOfBought()
    return self.numberOfBought
end

--- @return CustomizePackStatisticsInBound
--- @param buffer UnifiedNetwork_ByteBuf
function CustomizePackStatisticsInBound.CreateByBuffer(buffer)
    local id = buffer:GetInt()
    local statistics = CustomizePackStatisticsInBound(id)

    statistics.numberOfBought = buffer:GetByte()
    statistics.resetTimeInSeconds = buffer:GetLong()
    statistics.listOfSelectedItem = List()
    local size = buffer:GetByte()
    for i = 1, size do
        if (size == 1 and buffer:GetInt() == 0) then
            return statistics
        end
        statistics.listOfSelectedItem:Add(buffer:GetInt())
    end
    return statistics
end