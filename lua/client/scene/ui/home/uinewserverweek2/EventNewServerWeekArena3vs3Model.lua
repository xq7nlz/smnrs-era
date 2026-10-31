--- @class EventNewServerWeekArena3vs3Model : EventPopupModel
EventNewServerWeekArena3vs3Model = Class(EventNewServerWeekArena3vs3Model, EventPopupModel)

function EventNewServerWeekArena3vs3Model:Ctor()
    --- @type List -- SingleArenaRanking
    self.listRanking = List()
    ---@type number
    self.rankingOrder = -2
    ---@type number
    self.elo = 0
    EventPopupModel.Ctor(self)
end

function EventNewServerWeekArena3vs3Model:ReadInnerData(buffer)
    --- @type List
    --self.listRanking = NetworkUtils.GetListDataInBound(buffer, SingleArenaRanking)

    ---@type number
    local size = buffer:GetByte()
    --XDebug.Log("Size List ARENA 3VS3 : " .. tostring(size))
    ---@type List
    self.listRanking = List()
    if size > 0 then
        for i = 1, size do
            local singleArenaRanking = SingleArenaRanking()
            singleArenaRanking:ReadBufferWithoutPower(buffer)
            self.listRanking:Add(singleArenaRanking)
        end
        else
       -- XDebug.Log("LIST EMPTY")
        return
    end

--[[    if (self.listRanking:Count() == 0) then
        return
    end]]
    self.rankingOrder = buffer:GetInt()
    if (self.rankingOrder == nil) then
    else
    end
    self.elo = buffer:GetInt()
    --XDebug.Log("ELO" .. tostring(self.elo))
end

--- @return EventNewServerWeekArenaConfig
function EventNewServerWeekArena3vs3Model:GetConfig()
    return EventPopupModel.GetConfig(self)
end