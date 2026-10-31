--- @class EventMarketModel : EventPopupModel
EventMarketModel = Class(EventMarketModel, EventPopupModel)

function EventMarketModel:Ctor()
    EventPopupModel.Ctor(self)
    --- @type ModeShopDataInBound
    self.modeShopDataInBound = ModeShopDataInBound()
end

function EventMarketModel:ReadInnerData(buffer)
    self.modeShopDataInBound:ReadBuffer(buffer)
end

function EventMarketModel:RequestEventData(callback, forceUpdate)
    if self.modeShopDataInBound.listMarketItem == nil
            or forceUpdate == true then
        EventPopupModel.RequestEventData(self, callback)
    else
        callback()
    end
end

--- @return List
function EventMarketModel:GetListMarketItem()
    return self.modeShopDataInBound.marketItemList
end