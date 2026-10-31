--- @class SoundCtrl : AudioBaseCtrl
SoundCtrl = Class(SoundCtrl, AudioBaseCtrl)

--- @param audioMgr AudioMgr
function SoundCtrl:Ctor(audioMgr)
    AudioBaseCtrl.Ctor(self, audioMgr)
end

--- @return void
--- @param audioClip UnityEngine_AudioClip
function SoundCtrl:Play(audioClip)
    if audioClip == nil then
        return
    end
    --- @type UnityEngine_AudioSource
    local audioSource = self.audioMgr:GetAudioSource(audioClip.name)
    audioSource:PlayOneShot(audioClip)
end