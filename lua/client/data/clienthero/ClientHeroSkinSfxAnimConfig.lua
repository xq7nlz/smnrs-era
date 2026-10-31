--- @class ClientHeroSkinSfxAnimConfig
ClientHeroSkinSfxAnimConfig = Class(ClientHeroSkinSfxAnimConfig)

--- @param gameObject UnityEngine_GameObject
function ClientHeroSkinSfxAnimConfig:Ctor(gameObject)
    --- @type Dictionary -- animName, SoundFrameEffectData
    self.sfxAnimConfigDict = Dictionary()
    self:_InitSfxAnimConfig(gameObject)
end

--- @param gameObject UnityEngine_GameObject
function ClientHeroSkinSfxAnimConfig:_InitSfxAnimConfig(gameObject)
    --- @type IS_Battle_PlaySoundEffectByFrame
    local csPlaySoundEffectByFrame = gameObject:GetComponent(ComponentName.PlaySoundEffectByFrame)
    if Main.IsNull(csPlaySoundEffectByFrame) then
        return
    end
    --- @type List
    local listSfx = csPlaySoundEffectByFrame.soundEffects
    for i = 0, listSfx.Count - 1 do
        local soundEffectData = listSfx[i]
        local anim = soundEffectData.animName

        --- @type SoundFrameEffectData
        local soundFrameEffectData = self.sfxAnimConfigDict:Get(anim)
        if soundFrameEffectData == nil then
            soundFrameEffectData = SoundFrameEffectData(anim)
            self.sfxAnimConfigDict:Add(anim, soundFrameEffectData)
        end
        local listFrameData = soundEffectData.listSoundFrameData
        for k = 0, listFrameData.Count - 1 do
            --- @type {frame, fixedFolderPath, fixedFileName}
            local frameData = listFrameData[k]
            soundFrameEffectData:AddFrameConfig(
                    frameData.frame,
                    frameData.fixedFolderPath,
                    frameData.fixedFileName)
        end
    end
end

function ClientHeroSkinSfxAnimConfig:GetSoundFrameEffectData()
    return self.sfxAnimConfigDict
end