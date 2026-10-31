--- @class PlayerGuildWarRecord
PlayerGuildWarRecord = Class(PlayerGuildWarRecord)

function PlayerGuildWarRecord:Ctor()
    --- @type number
    self.lastTimeRequest = nil
    --- @type List
    self.listRecord = nil
end

--- @return boolean
function PlayerGuildWarRecord:IsAvailableToRequest()
    return self.lastTimeRequest == nil or zg.timeMgr:GetServerTime() - self.lastTimeRequest > TimeUtils.SecondAMin
end

--- @param listRecord List
function PlayerGuildWarRecord:SetListRecord(listRecord)
    if listRecord ~= nil then
        self.listRecord = listRecord
    else
        self.listRecord = List()
    end
    self.lastTimeRequest = zg.timeMgr:GetServerTime()
end