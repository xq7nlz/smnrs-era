--- @class MusicCtrl : AudioBaseCtrl
MusicCtrl = Class(MusicCtrl, AudioBaseCtrl)

MusicCtrl.splashMusic = "m_splash"
MusicCtrl.mainMenuMusic = "m_main_menu"

--- @param audioMgr AudioMgr
function MusicCtrl:Ctor(audioMgr)
    --- @type DG_Tweening_Tweener
    self.fadeTweener = nil
    AudioBaseCtrl.Ctor(self, audioMgr)
end

--- @return void
--- @param audioClip UnityEngine_AudioClip
function MusicCtrl:Play(audioClip, loop, volume)
    --- @type UnityEngine_AudioSource
    local audioSource = self.audioMgr:GetMusicAudioSource(audioClip.name)
    audioSource.clip = audioClip

    if loop == true then
        audioSource.loop = true
    end

    audioSource.volume = 0
    audioSource:Play()

    audioSource:DOFade(volume, 2)
    return audioSource
end

--- @param name string
function MusicCtrl:Stop(name, musicVolume, onCompleteFadeOut)
    local audioSource = self.audioMgr:GetMusicAudioSource(name)
    audioSource.volume = musicVolume
    if audioSource ~= nil then
        self:KillFadeTweener()
        self.fadeTweener = audioSource:DOFade(0, 2):OnComplete(function ()
            audioSource:Stop()
            audioSource.clip = nil
            if onCompleteFadeOut ~= nil then
                 onCompleteFadeOut()
            end
        end)
    end
end

function MusicCtrl:KillFadeTweener()
    if self.fadeTweener ~= nil then
        self.fadeTweener:Kill()
        self.fadeTweener = nil
    end
end