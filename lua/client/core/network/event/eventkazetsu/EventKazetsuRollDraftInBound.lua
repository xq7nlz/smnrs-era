require "lua.client.core.network.playerData.unknown.ListNumberOutBound"
--- @class EventKazetsuRollDraftInBound
EventKazetsuRollDraftInBound = Class(EventKazetsuRollDraftInBound)

function EventKazetsuRollDraftInBound:Ctor()
    --- @type List<number>
    self.listHeroRoll = List()
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventKazetsuRollDraftInBound:IsAvailableToRequest()
    return true
end

--- @return void
--- @param onSuccess function
--- Get random list hero with element is selectionId from server
function EventKazetsuRollDraftInBound.RequestRollHeroes(callback)
    local onReceived = function(result)
        local selectionIdRandomPoolList = List()
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            --- @type number
            local sizeList = buffer:GetByte()
            for _ = 1, sizeList do
                local selectionId = buffer:GetInt()
                selectionIdRandomPoolList:Add(selectionId)
            end
        end
        local onSuccess = function()
            callback(selectionIdRandomPoolList)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(OpCode.EVENT_KAZETSU_TRIAL_ROLL_HERO, nil, onReceived)
end

----- @return void
----- @param onSuccess function
----- Get random list hero with element is selectionId from server
--function EventKazetsuRollDraftInBound.RequestSelectedHeroesWithState(callback)
--    local onReceived = function(result)
--        local selectedHeroWithStateList = List()
--        --- @param buffer UnifiedNetwork_ByteBuf
--        local onBufferReading = function(buffer)
--            --- @type number
--            local size = buffer:GetByte()
--            for i = 1, size do
--                local selectedHeroStage = {}
--                selectedHeroStage.selectHeroId = buffer:GetInt()
--                selectedHeroStage.hpPercent =  buffer:GetLong()/1000000000
--                selectedHeroStage.power =  buffer:GetByte()
--                selectedHeroWithStateList:Add(selectedHeroStage)
--            end
--        end
--        local onSuccess = function()
--            callback(selectedHeroWithStateList)
--        end
--        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
--    end
--    NetworkUtils.Request(OpCode.EVENT_KAZETSU_TRIAL_GET_STATE_LIST, nil, onReceived)
--end

--- @return void
--- @param listHeroSelected List<number>
--- @param onSuccess function
--- Send list hero with element is selectionId to server
function EventKazetsuRollDraftInBound.SendSelectedHeroes(listHeroSelected, callback)
    ----- @type EventKazetsuModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_KAZETSU)
    local isOpening = eventModel ~= nil and eventModel.timeData:IsOpening()
    if isOpening == true then
        if eventModel.eventKazetsuRollDraftInBound == nil then
            eventModel.eventKazetsuRollDraftInBound = EventKazetsuRollDraftInBound()
        end
        local onReceived = function(result)
            local selectedHeroWithStateList = List()
            --- @param buffer UnifiedNetwork_ByteBuf
            local onBufferReading = function(buffer)
                --- @type number
                local size = buffer:GetByte()
                for i = 1, size do
                    local selectedHeroStage = {}
                    selectedHeroStage.selectHeroId = buffer:GetInt()
                    selectedHeroStage.hpPercent =  buffer:GetLong()/1000000000
                    selectedHeroStage.power =  buffer:GetByte()
                    selectedHeroWithStateList:Add(selectedHeroStage)
                end
            end
            local onSuccess = function()
                callback(selectedHeroWithStateList)
            end
            NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
        end
        NetworkUtils.Request(OpCode.EVENT_KAZETSU_TRIAL_HERO_SELECT, ListNumberOutBound.CreateInstance(listHeroSelected), onReceived)
    end
end