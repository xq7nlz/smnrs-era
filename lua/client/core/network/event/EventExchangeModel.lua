--- @class EventExchangeModel : EventPopupModel
EventExchangeModel = Class(EventExchangeModel, EventPopupModel)

function EventExchangeModel:Ctor()
    --- @type Dictionary
    self.numberExchangeDict = Dictionary()
    EventPopupModel.Ctor(self)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventExchangeModel:ReadData(buffer)
    EventPopupModel.ReadData(self, buffer)
    if self.hasData == true then
        self.numberExchangeDict = Dictionary()
        local size = buffer:GetByte()
        for _ = 1, size do
            self.numberExchangeDict:Add(buffer:GetInt(), buffer:GetInt())
        end
    end
end

function EventExchangeModel:GetNumberExchange(id)
    return self.numberExchangeDict:Get(id) or 0
end

function EventExchangeModel:AddNumberExchange(id, number)
    local current = self:GetNumberExchange(id)
    self.numberExchangeDict:Add(id, current + number)
end