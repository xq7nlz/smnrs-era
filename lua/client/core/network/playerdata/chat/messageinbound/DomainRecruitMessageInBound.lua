--- @class DomainRecruitMessageInBound : MessageInBound
DomainRecruitMessageInBound = Class(DomainRecruitMessageInBound, MessageInBound)

function DomainRecruitMessageInBound:Ctor()
    MessageInBound.Ctor(self)
    --- @type number
    self.crewId = nil
    --- @type string
    self.crewName = nil
    --- @type string
    self.message = nil
end

--- @param json table
function DomainRecruitMessageInBound:CreateByJson(json)
    self.crewId = tonumber(json['0'])
    self.crewName = json['1']
    self.message = json['2']
end