--- @class EventServerOpenMarketItem
EventServerOpenMarketItem = Class(EventServerOpenMarketItem)

function EventServerOpenMarketItem:Ctor()
    --- @type number
    self.id = nil
    --- @type number
    self.currentStock = nil
    --- @type number
    self.maxStock = nil
    ---@type ServerOpenMarket
    self.serverOpenMarket = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
---@param dict Dictionary
function EventServerOpenMarketItem.CreateBuffer(buffer, dict)
    ---@type EventServerOpenMarketItem
    local data = EventServerOpenMarketItem()
    data.id = buffer:GetByte()
    data.currentStock = buffer:GetByte()
    data.maxStock = buffer:GetByte()
    if dict ~= nil then
        data.serverOpenMarket = dict:Get(data.id)
    end
    return data
end

return EventServerOpenMarketItem