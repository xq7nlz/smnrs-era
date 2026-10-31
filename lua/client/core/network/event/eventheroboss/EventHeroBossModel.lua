--- @class EventHeroBossModel : EventPopupModel
EventHeroBossModel = Class(EventHeroBossModel, EventPopupModel)

function EventHeroBossModel:Ctor()
	EventPopupModel.Ctor(self)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventHeroBossModel:ReadInnerData(buffer)
	self.numberBuyBossTurn = buffer:GetByte()
end

function EventHeroBossModel:BuyBossTurnSuccess(boughtTurn)
	self.numberBuyBossTurn = self.numberBuyBossTurn + boughtTurn
end

--- @return EventFindeBossChallengeConfig
function EventHeroBossModel:GetConfig()
	return EventPopupModel.GetConfig(self)
end