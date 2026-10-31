--- @class SoundFrameAction
SoundFrameAction = Class(SoundFrameAction)

--- @param soundFrameData SoundFrameData
function SoundFrameAction:Ctor(soundFrameData)
    self.animName = nil
    self.time = soundFrameData.frame * 1.0 / ClientConfigUtils.FPS
    self.folderPath = soundFrameData.folderPath
    self.fileName = soundFrameData.fileName
end