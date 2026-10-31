--- @class EventBirthdayWheelConfig
EventBirthdayWheelConfig = Class(EventBirthdayWheelConfig)

function EventBirthdayWheelConfig:Ctor(path)
    self.id = path
    --- @type MoneyType
    self.moneyType = nil
    --- @type number
    self.moneyValue = nil
    --- @type List
    self.listReward = List()
end

--- @return EventBirthdayWheelConfig
function EventBirthdayWheelConfig.CreateByParams(data)
    --XDebug.Log("data " .. LogUtils.ToDetail(data))
    local ins = EventBirthdayWheelConfig()
    if data ~= nil then
        ins.id = tonumber(data.round_id)
        ins.moneyType = tonumber(data.money_type)
        ins.moneyValue = tonumber(data.money_value)
        ins:AddReward(data)
    end

    return ins
end

function EventBirthdayWheelConfig:AddReward(data)
    if data.id ~= nil then
        if data.res_type ~= nil then
            self.listReward:Add(RewardInBound.CreateByParams(data))
        else
            self.listReward:Add(RewardInBound())
        end
    end
end