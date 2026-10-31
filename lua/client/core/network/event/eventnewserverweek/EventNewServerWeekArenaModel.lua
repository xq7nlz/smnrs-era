--- @class EventNewServerWeekArenaModel : EventPopupModel
EventNewServerWeekArenaModel = Class(EventNewServerWeekArenaModel, EventPopupModel)

function EventNewServerWeekArenaModel:Ctor()
    --- @type List -- SingleArenaRanking
    self.listRanking = List()
    ---@type number
    self.rankingOrder = -2
    ---@type number
    self.elo = 0
    EventPopupModel.Ctor(self)
end

function EventNewServerWeekArenaModel:ReadInnerData(buffer)
    --- @type List
    self.listRanking = NetworkUtils.GetListDataInBound(buffer, SingleArenaRanking)
    --XDebug.Log("list ranking count " .. tostring(self.listRanking:Count()))
    if (self.listRanking:Count() == 0) then
        return
    end
    self.rankingOrder = buffer:GetInt()
    if (self.rankingOrder == nil) then
        else
    end
    self.elo = buffer:GetInt()
end


--- @return EventNewServerWeekArenaConfig
function EventNewServerWeekArenaModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end