require "lua.client.data.Event.EventHalloween.EventHalloweenLoginDataConfig"

--- @class EventXmasLoginDataConfig : EventHalloweenLoginDataConfig
EventXmasLoginDataConfig = Class(EventXmasLoginDataConfig, EventHalloweenLoginDataConfig)

function EventXmasLoginDataConfig:Ctor(list, rewardInBound)
    EventHalloweenLoginDataConfig.Ctor(self, list,rewardInBound)
end