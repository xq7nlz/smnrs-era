--- @class RaidData
RaidData = Class(RaidData)

function RaidData:Ctor()
    --- @type RaidModeType
    self.raidModeType = nil
    --- @type number
    self.raidModeStage = nil
end

return RaidData