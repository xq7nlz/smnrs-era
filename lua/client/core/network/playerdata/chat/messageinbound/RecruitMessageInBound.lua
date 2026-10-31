--- @class RecruitMessageInBound : MessageInBound
RecruitMessageInBound = Class(RecruitMessageInBound, MessageInBound)

function RecruitMessageInBound:Ctor()
    MessageInBound.Ctor(self)
    --- @type number
    self.guildLevel = nil
    --- @type string
    self.guildName = nil
end

--- @param json table
function RecruitMessageInBound:CreateByJson(json)
    self.guildLevel = tonumber(json['0'])
    self.guildName = json['1']
    self.message = json['2']
end