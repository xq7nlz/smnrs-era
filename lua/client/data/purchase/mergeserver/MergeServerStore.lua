local PATH = "csv/event/event_server_merge/data_%d/limited_bundle.csv"

--- @class MergeServerStore : EventStore
MergeServerStore = Class(MergeServerStore, EventStore)

function MergeServerStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_MERGE_SERVER
    --- @type OpCode
    self.opCode = OpCode.EVENT_SERVER_MERGE_BUNDLE_PURCHASE
    --- @type string
    self.filePath = PATH
    --- @type EventMergeServerProduct
    self.pack = EventMergeServerProduct
end

--- @class EventMergeServerProduct : EventProduct
EventMergeServerProduct = Class(EventMergeServerProduct, EventProduct)

function EventMergeServerProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_SERVER_MERGE_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_MERGE_SERVER
    self.numberSelect = 0
    ---@type List
    self.rewardPool = List()
end

--- @return void
function EventMergeServerProduct:ParseCsv(data)
    EventProduct.ParseCsv(self, data)
    if data.number_selection ~= nil then
        self.numberSelect = tonumber(data.number_selection)
    end
    if data.selection_res_type ~= nil then
        local reward = RewardInBound.CreateBySingleParam(data.selection_res_type, data.selection_res_id,
                data.selection_res_number,
                data.selection_res_data)
        reward.indexId = tonumber(data.selection_id)
        self.rewardPool:Add(reward)
    end
end