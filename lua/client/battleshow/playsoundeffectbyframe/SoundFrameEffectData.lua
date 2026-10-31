--- @class SoundFrameEffectData
SoundFrameEffectData = Class(SoundFrameEffectData)

--- @param animName string
function SoundFrameEffectData:Ctor(animName)
    --- @type string
    self.animName = animName
    --- @type List<SoundFrameData>
    self.listSoundFrameData = List()
end

--- @param frame number
--- @param folderPath string
--- @param fileName string
function SoundFrameEffectData:AddFrameConfig(frame, folderPath, fileName)
    local soundFrameData = SoundFrameData()
    soundFrameData.frame = frame

    soundFrameData.folderPath = folderPath
    soundFrameData.fileName = fileName

    self.listSoundFrameData:Add(soundFrameData)
end