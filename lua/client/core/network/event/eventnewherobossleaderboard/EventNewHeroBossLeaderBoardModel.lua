require "lua.client.core.network.event.eventNewHeroBossLeaderBoard.EventBossChallengeLeaderBoardInBound"

--- @class EventNewHeroBossLeaderBoardModel : EventPopupModel
EventNewHeroBossLeaderBoardModel = Class(EventNewHeroBossLeaderBoardModel, EventPopupModel)

function EventNewHeroBossLeaderBoardModel:Ctor()
    EventPopupModel.Ctor(self)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventNewHeroBossLeaderBoardModel:ReadInnerData(buffer)
    self.listRanking = NetworkUtils.GetListDataInBound(buffer, EventBossChallengeLeaderBoardInBound)
end