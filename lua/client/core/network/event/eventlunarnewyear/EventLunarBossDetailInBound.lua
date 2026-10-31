require "lua.client.core.network.playerData.common.HeroStateInBound"
require "lua.client.core.network.event.eventLunarNewYear.EventLunarBossData"

--- @class EventLunarBossDetailInBound
EventLunarBossDetailInBound = Class(EventLunarBossDetailInBound)

--- @param buffer UnifiedNetwork_ByteBuf
function EventLunarBossDetailInBound:Ctor(buffer, chapter)
    --- @type List
    self.listHeroStateInBound = NetworkUtils.GetListDataInBound(buffer, HeroStateInBound.CreateByBuffer)
    --- @type number
    self.bossCreateTime = buffer:GetLong()
    --- @type EventLunarBossData
    self.eventLunarBossData = EventLunarBossData(buffer)
    --- @type number
    self.totalDamageDeal = buffer:GetLong()
    --- @type number
    self.playerDamageDeal = buffer:GetLong()
    --- @type boolean
    self.isClaim = buffer:GetBool()
    --- @type number
    self.lastTimeRequest = zg.timeMgr:GetServerTime()
    --- @type number
    self.chapter = chapter
    --XDebug.Log(LogUtils.ToDetail(self))
    --for i, v in ipairs(self.listHeroStateInBound:GetItems()) do
    --    XDebug.Log(LogUtils.ToDetail(v))
    --end
end

---@type EventLunarBossDetailInBound
function EventLunarBossDetailInBound:IsClearChapter()
    return self.chapter <= self.eventLunarBossData.recentPassedChap
end

---@type EventLunarBossDetailInBound
function EventLunarBossDetailInBound.GetCacheEventLunarBossDetailInBound(chapter)
    ---@type EventLunarBossDetailInBound
    local eventLunarBossDetailInBound = nil
    if zg.playerData.dictEventLunarBossDetailInBound ~= nil then
        eventLunarBossDetailInBound = zg.playerData.dictEventLunarBossDetailInBound:Get(chapter)
    end
    return eventLunarBossDetailInBound
end

function EventLunarBossDetailInBound.CheckData(chapter, callbackSuccess, callbackFailed)
    ---@type EventLunarBossDetailInBound
    local eventLunarBossDetailInBound = nil
    if zg.playerData.dictEventLunarBossDetailInBound == nil then
        zg.playerData.dictEventLunarBossDetailInBound = Dictionary()
    else
        eventLunarBossDetailInBound = zg.playerData.dictEventLunarBossDetailInBound:Get(chapter)
    end
    if callbackSuccess ~= nil then
        callbackSuccess(eventLunarBossDetailInBound, chapter)
    end
    if eventLunarBossDetailInBound == nil or eventLunarBossDetailInBound.lastTimeRequest == nil
            or (chapter > 0 and chapter == eventLunarBossDetailInBound.eventLunarBossData.currentChap
            and zg.timeMgr:GetServerTime() - eventLunarBossDetailInBound.lastTimeRequest > 30) then
        local onReceived = function(result)
            --- @param buffer UnifiedNetwork_ByteBuf
            local onBufferReading = function(buffer)
                eventLunarBossDetailInBound = EventLunarBossDetailInBound(buffer, chapter)
            end
            --- @param logicCode LogicCode
            local onSuccess = function()
                local chapterDetail = chapter
                if chapter <= 0 then
                    chapterDetail = eventLunarBossDetailInBound.eventLunarBossData.currentChap
                end
                zg.playerData.dictEventLunarBossDetailInBound:Add(chapterDetail , eventLunarBossDetailInBound)
                if callbackSuccess ~= nil then
                    callbackSuccess(eventLunarBossDetailInBound, chapterDetail)
                end
            end
            --- @param logicCode LogicCode
            local onFailed = function(logicCode)
                if callbackFailed ~= nil then
                    callbackFailed()
                end
            end
            NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
        end
        NetworkUtils.Request(OpCode.EVENT_LUNAR_NEW_YEAR_BOSS_DETAIL_GET, UnknownOutBound.CreateInstance(PutMethod.Int, chapter), onReceived)
    end
end