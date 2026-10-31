--- @class DomainCrewInBound
DomainCrewInBound = Class(DomainCrewInBound)

--- @param buffer UnifiedNetwork_ByteBuf
function DomainCrewInBound:Ctor(buffer)
    --- @type number
    self.crewId = nil
    --- @type number
    self.leaderId = nil
    --- @type number
    self.name = nil
    --- @type number
    self.description = nil
    --- @type boolean
    self.isInBattle = nil
    --- @type number
    self.createdTime = nil
    --- @type List -- DomainsCrewMember
    self.listMember = nil

    if buffer then
        self:ReadBuffer(buffer)
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function DomainCrewInBound:ReadBuffer(buffer)
    self.crewId = buffer:GetInt()
    self.leaderId = buffer:GetLong()
    self.name = buffer:GetString()
    self.description = buffer:GetString(false)
    self.isInBattle = buffer:GetBool()
    self.createdTime = buffer:GetLong()

    self.listMember = NetworkUtils.GetListDataInBound(buffer, DomainsCrewMember)
    self:SortListMemberByLeader()
end

function DomainCrewInBound:SortListMemberByLeader()
    for i = 1, self.listMember:Count() do
        --- @type DomainsCrewMember
        local leaderMember = self.listMember:Get(i)
        if self.leaderId == leaderMember.playerId and i ~= 1 then
            leaderMember.isReady = true;
            self.listMember:RemoveByIndex(i)
            self.listMember:Insert(leaderMember, 1)
            break
        end
    end
end

function DomainCrewInBound:ChangeLeader(newLeaderId)
    self.leaderId = newLeaderId
    self:SortListMemberByLeader()
end