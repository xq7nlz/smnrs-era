--- @class EventFindeBossModel : EventPopupModel
EventFindeBossModel = Class(EventFindeBossModel, EventPopupModel)

function EventFindeBossModel:Ctor()
	EventPopupModel.Ctor(self)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventFindeBossModel:ReadInnerData(buffer)
	self.numberBuyBossTurn = buffer:GetByte()
end

function EventFindeBossModel:BuyBossTurnSuccess(boughtTurn)
	self.numberBuyBossTurn = self.numberBuyBossTurn + boughtTurn
end

--- @return EventFindeBossChallengeConfig
function EventFindeBossModel:GetConfig()
	return EventPopupModel.GetConfig(self)
end