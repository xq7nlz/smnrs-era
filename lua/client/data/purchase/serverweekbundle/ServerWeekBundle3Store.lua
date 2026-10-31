local PATH = "csv/event/event_server_open_3/data_%d/bundle_pack.csv"

--- @class ServerWeekBundle3Store : EventStore
ServerWeekBundle3Store = Class(ServerWeekBundle3Store, EventStore)

function ServerWeekBundle3Store:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_NEW_SERVER_WEEK_3
    --- @type OpCode
    self.opCode = OpCode.EVENT_NEW_SERVER_OPEN_3_BUNDLE_PURCHASE
    --- @type string
    self.filePath = PATH
    --- @type EventServerWeek3Product
    self.pack = EventServerWeek3Product
end

--- @class EventServerWeek3Product : EventProduct
EventServerWeek3Product = Class(EventServerWeek3Product, EventProduct)

function EventServerWeek3Product:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_NEW_SERVER_OPEN_3_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_NEW_SERVER_WEEK_3
    self.numberSelect = 0
    ---@type List
    self.rewardPool = List()
end

--- @return void
function EventServerWeek3Product:ParseCsv(data)
    if (data.is_hot ~= nil) then
        self.isHot = MathUtils.ToBoolean(data.is_hot)
    end

    EventProduct.ParseCsv(self, data)
    if data.number_selection ~= nil then
        self.numberSelect = tonumber(data.number_selection)
    end
    if data.selection_res_type ~= nil then
        ---@type RewardInBound
        local reward = RewardInBound.CreateBySingleParam(data.selection_res_type, data.selection_res_id,
                data.selection_res_number,
                data.selection_res_data)
        reward.indexId = tonumber(data.selection_id)
        self.rewardPool:Add(reward)
    end
end