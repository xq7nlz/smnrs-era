local EVENT_LUNAR_PATH_BUNDLE = "csv/event/event_lunar_new_year_2022/data_%d/bundle_pack/lunar_exclusive_bundle_pack.csv"

--- @class LunarExclusiveStore : EventStore
LunarExclusiveStore = Class(LunarExclusiveStore, EventStore)
function LunarExclusiveStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_LUNAR_NEW_YEAR_2022
    --- @type OpCode
    self.opCode = OpCode.EVENT_LUNAR_2022_EXCLUSIVE_BUNDLE_PURCHASE
    --- @type string
    self.filePath = EVENT_LUNAR_PATH_BUNDLE
    --- @type EventLunarExclusiveProduct
    self.pack = EventLunarExclusiveProduct
end

--- @class EventLunarExclusiveProduct : EventProduct
EventLunarExclusiveProduct = Class(EventLunarExclusiveProduct, EventProduct)

function EventLunarExclusiveProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_LUNAR_2022_EXCLUSIVE_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_LUNAR_NEW_YEAR_2022
    ---@type List
    self.rewardPool = List()
end

--- @return void
function EventLunarExclusiveProduct :ParseCsv(data)
    if (data.profit ~= nil) then
        self.profit = tonumber(data.profit)
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