local PATH = "csv/event/event_server_open/data_%d/bundle_pack.csv"

--- @class ServerWeekBundleStore : EventStore
ServerWeekBundleStore = Class(ServerWeekBundleStore, EventStore)

function ServerWeekBundleStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_NEW_SERVER_WEEK
    --- @type OpCode
    self.opCode = OpCode.EVENT_NEW_SERVER_OPEN_BUNDLE_PURCHASE
    --- @type string
    self.filePath = PATH
    --- @type EventServerWeekProduct
    self.pack = EventServerWeekProduct
end

--- @class EventServerWeekProduct : EventProduct
EventServerWeekProduct = Class(EventServerWeekProduct, EventProduct)

function EventServerWeekProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_NEW_SERVER_OPEN_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_NEW_SERVER_WEEK
    self.numberSelect = 0
    ---@type List
    self.rewardPool = List()
end

--- @return void
function EventServerWeekProduct:ParseCsv(data)
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


function EventServerWeekProduct:ClaimAndShowRewardList()
    ---@type List <RewardInBound>
    local rewardList = List()
    for i, v in ipairs(self.rewardList:GetItems()) do
        rewardList:Add(v)
    end
    if self.bonusReward ~= nil then
        rewardList:Add(self.bonusReward)
    end
    if self.listSelectReward ~= nil then
        for i, v in ipairs(self.listSelectReward:GetItems()) do
            rewardList:Add(v)
        end
    end
    XDebug.Log("claim select" .. tostring(self.numberSelect))
    if (self.numberSelect > 0) then -- http://35.198.248.251/root/idle-summoner/-/issues/4433
        require "lua.client.core.network.event.eventNewServerWeek.EventNewServerWeekModel"
        ---@type EventNewServerWeekModel
        local eventNewServerWeekModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_SERVER_WEEK)
        if (eventNewServerWeekModel ~= nil) then
            --for i = 1, self.numberSelect do
            local selectId = eventNewServerWeekModel:GetSelectItemID(self.id)

            if (selectId ~= nil) then
                    rewardList:Add(self.rewardPool:Get(selectId))
                XDebug.Log("selectId" .. tostring(selectId))
                else
                XDebug.Log("selectId nil")
            end
            --end
        end

    end
    PopupUtils.ClaimAndShowRewardList(rewardList)
end