--- @class MaintenanceMessageInBound : MessageInBound
MaintenanceMessageInBound = Class(MaintenanceMessageInBound, MessageInBound)

function MaintenanceMessageInBound:Ctor()
    MessageInBound.Ctor(self)
    --- @type number
    self.startTime = nil
    --- @type number
    self.endTime = nil
end

--- @param json table
function MaintenanceMessageInBound:CreateByJson(json)
    self.startTime = tonumber(json['0'])
    self.endTime = tonumber(json['1'])
end