
--- @class AudioBaseCtrl
AudioBaseCtrl = Class(AudioBaseCtrl)

--- @return void
--- @param audioMgr AudioMgr
function AudioBaseCtrl:Ctor(audioMgr)
    --- @type AudioMgr
    self.audioMgr = audioMgr

    --- @type number
    self._volume = 1
end

--- @return void
function AudioBaseCtrl:Initialize()
    --- override if needed
end

--- @return void
--- @param audioClip UnityEngine_AudioClip
function AudioBaseCtrl:Play(audioClip)
    --- override if needed
end

--- @return void
function AudioBaseCtrl:Stop()
    --- override if needed
end

--- @return void
function AudioBaseCtrl:Pause()
    --- override if needed
end

--- @return void
function AudioBaseCtrl:Resume()
    --- override if needed
end


