--- @class ArenaDataInBound
ArenaDataInBound = Class(ArenaDataInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ArenaDataInBound:ReadBuffer(buffer)
    --- @type number
    self.containData = buffer:GetBool()
    if self.containData == true then
        --- @type number
        self.eloPoint = buffer:GetInt()
        --- @type number
        self.turnBoughtDaily = buffer:GetByte()
        --- @type number
        self.regenTime = buffer:GetLong()
    end
    self.lastRequest = zg.timeMgr:GetServerTime()

    self:InitRegenTime()
end

function ArenaDataInBound:InitRegenTime()
    self.regenTimeData = RegenTimeData()
    self.regenTimeData.max = ResourceMgr.GetArenaConfig().maxTicket
    self.regenTimeData.step = ResourceMgr.GetArenaConfig().ticketRegenInterval
    self.regenTimeData.getLastRegenTime = function()
        return self.regenTime
    end
    self.regenTimeData.setLastRegenTime = function(time)
        self.regenTime = time
    end
    InventoryUtils.AddRegenTimeData(ResourceType.Money, MoneyType.ARENA_TICKET, self.regenTimeData)
end

--- @return boolean
function ArenaDataInBound:NeedRequest()
    return self.lastRequest == nil or zg.timeMgr:GetServerTime() - self.lastRequest > 30
end

function ArenaDataInBound.Validate(callback)
    --- @type ArenaDataInBound
    local arenaDataInBound = zg.playerData:GetMethod(PlayerDataMethod.ARENA)
    if arenaDataInBound == nil or arenaDataInBound:NeedRequest() then
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.ARENA }, callback)
    else
        if callback then
            callback()
        end
    end
end