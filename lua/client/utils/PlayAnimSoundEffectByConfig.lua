--- @class PlayAnimSoundEffectByConfig
PlayAnimSoundEffectByConfig = Class(PlayAnimSoundEffectByConfig)

--- @param sound IS_Battle_PlaySoundEffectByFrame
function PlayAnimSoundEffectByConfig:Ctor(sound)
    --- @type IS_Battle_PlaySoundEffectByFrame
    self.soundConfig = sound
end

--- @param animation string
function PlayAnimSoundEffectByConfig:PlaySoundByAnim(animation)
    if self.soundConfig ~= nil then
        self:Hide()
        for i = 1, self.soundConfig.soundEffects.Count do
            ---@type IS_Battle_SoundEffectData
            local soundEffectData = self.soundConfig.soundEffects[i-1]
            if soundEffectData.animName == animation then
                self.soundCoroutine = Coroutine.start(function()
                    local waitTime = 0
                    for j = 1, self.soundConfig.soundEffects.Count do
                        ---@type IS_Battle_SoundFrameData
                        local soundFrameData = soundEffectData.listSoundFrameData[j-1]
                        waitTime = soundFrameData.frame * 1.0 / ClientConfigUtils.FPS - waitTime
                        coroutine.waitforseconds(waitTime)
                        zg.audioMgr:PlaySound(soundFrameData.fixedFolderPath, soundFrameData.fixedFileName)
                    end
                end)
                break
            end
        end
    end
end

function PlayAnimSoundEffectByConfig:Hide()
    if self.soundCoroutine ~= nil then
        ClientConfigUtils.KillCoroutine(self.soundCoroutine)
    end
end