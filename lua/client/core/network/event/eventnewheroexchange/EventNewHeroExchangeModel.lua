--require("lua.client.core.network.event.EventExchangeModel")

--- @class EventNewHeroExchangeModel : EventPopupModel
EventNewHeroExchangeModel = Class(EventNewHeroExchangeModel, EventPopupModel)

function EventNewHeroExchangeModel:Ctor()
    --- @type Dictionary
    self.numberExchangeDict = Dictionary()
    EventPopupModel.Ctor(self)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventNewHeroExchangeModel:ReadInnerData(buffer)
    --self:ReadData(buffer)
    self.numberExchangeDict = Dictionary()
    local size = buffer:GetByte()
    --XDebug.Log("size" .. size)
    for _ = 1, size do
        local id = buffer:GetInt()
        local number = buffer:GetInt()
        self.numberExchangeDict:Add(id, number)
    end

end

function EventNewHeroExchangeModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

function EventNewHeroExchangeModel:GetNumberExchange(id)
    return self.numberExchangeDict:Get(id) or 0
end

function EventNewHeroExchangeModel:AddNumberExchange(id, number)
    local current = self:GetNumberExchange(id)
    self.numberExchangeDict:Add(id, current + number)
end