--- @class SoundFrameData
SoundFrameData = Class(SoundFrameData)

function SoundFrameData:Ctor()
    --- @type number
    self.frame = nil
    --- @type string
    self.folderPath = nil
    --- @type string
    self.fileName = nil
end
