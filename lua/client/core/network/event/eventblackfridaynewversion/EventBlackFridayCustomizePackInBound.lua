--- @class EventBlackFridayCustomizePackInBound
EventBlackFridayCustomizePackInBound = Class(EventBlackFridayCustomizePackInBound)

function EventBlackFridayCustomizePackInBound:Ctor(id)
    --- @type number
    self.packId = id
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BLACK_FRIDAY_SALE)
    --- @type number
    self.numberOfBought = 0
    --- @type number
    self.resetTimeInSeconds = 0
    --- @type List<number>
    self.listOfSelectedItem = List() -- List item da chon
    --- @type CustomizeProduct
    --self.product = ResourceMgr.GetPurchaseConfig():GetEventBlackFridayNewBundleStore():GetPack(self.eventModel.timeData.dataId).packDict:Get(self.packId)
    --- @type number
    --self.stock = self.product.stock
end

--- @return boolean
function EventBlackFridayCustomizePackInBound:ReachedLimit()
    return self.numberOfBought == self.stock
end

function EventBlackFridayCustomizePackInBound:IncreaseNumberOfBought()
    self.numberOfBought = self.numberOfBought + 1
end

function EventBlackFridayCustomizePackInBound:GetNumberOfBought()
    return self.numberOfBought
end

--- @return EventBlackFridayCustomizePackInBound
--- @param buffer UnifiedNetwork_ByteBuf
function EventBlackFridayCustomizePackInBound.CreateByBuffer(buffer)
    local id = buffer:GetInt()
    --print("ID : " .. id)
    local statistics = EventBlackFridayCustomizePackInBound(id)

    statistics.numberOfBought = buffer:GetByte()
    --print("numberOfBought : " .. statistics.numberOfBought)
    statistics.resetTimeInSeconds = buffer:GetLong()
    statistics.listOfSelectedItem = List()
    local size = buffer:GetByte()
    for i = 1, size do
        statistics.listOfSelectedItem:Add(buffer:GetInt())
    end
    --print("List Of Selected Item : " .. LogUtils.ToDetail(statistics.listOfSelectedItem:GetItems()))
    return statistics
end