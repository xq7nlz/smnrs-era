require "lua.client.core.network.playerData.domain.CrewMemberBasicInfo"

--- @class CrewInvitation
CrewInvitation = Class(CrewInvitation)

function CrewInvitation:Ctor(buffer)
    --- @type string
    self.crewId = nil
    --- @type number
    self.crewName = nil
    --- @type List
    self.listMember = List()

    if buffer ~= nil then
        self:ReadBuffer(buffer)
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function CrewInvitation:ReadBuffer(buffer)
    self.crewId = buffer:GetInt()
    self.crewName = buffer:GetString()
    self.leaderId = buffer:GetLong()
    self.listMember = NetworkUtils.GetListDataInBound(buffer, CrewMemberBasicInfo)

    self:SortByLeaderId()
end

function CrewInvitation:SortByLeaderId()
    local leader
    --- @param v CrewMemberBasicInfo
    for _, v in pairs(self.listMember:GetItems()) do
        if v.playerId == self.leaderId then
            leader = v
            self.listMember:RemoveByReference(v)
        end
    end
    if leader ~= nil then
        self.listMember:Insert(leader, 1)
    end
end