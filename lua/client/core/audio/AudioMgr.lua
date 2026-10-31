require "lua.client.core.audio.AudioBaseCtrl"
require "lua.client.core.audio.SoundCtrl"
require "lua.client.core.audio.MusicCtrl"
require "lua.client.config.const.SfxUiType"

--- @class AudioMgr
AudioMgr = Class(AudioMgr)

--- @return void
function AudioMgr:Ctor()
    --- @type SoundCtrl
    self.soundCtrl = nil
    --- @type MusicCtrl
    self.musicCtrl = nil
    --- @type UnityEngine_AudioSource[] List<UnityEngine_AudioSource>
    self._listFree = List()
    --- @type Dictionary
    self._listInUsed = Dictionary()
    --- @type UnityEngine_AudioSource
    self._playingMusicSource = nil
    --- @type Dictionary
    self._listMusicAudioSource = Dictionary()

    --- @type number
    self.soundVolume = 1
    --- @type number
    self.musicVolume = 1

    --- @type number
    self.isMuteSound = false
    --- @type number
    self.isMuteMusic = false

    --- @type UnityEngine_RectTransform
    self.root = nil

    self:Init()
end

--- @return void
function AudioMgr:Init()
    self.soundCtrl = SoundCtrl(self)
    self.musicCtrl = MusicCtrl(self)
    --- override if needed
    self.updateCoroutine = Coroutine.start(function()
        while (true) do
            coroutine.waitforseconds(0.5)
            self:Update()
        end
    end)

    self.root = U_GameObject("Audio").transform
    self.root:SetParent(uiCanvas.config.transform)

    self:SetSoundVolume(PlayerSettingData.soundValue, PlayerSettingData.isMuteSound)
    self:SetMusicVolume(PlayerSettingData.musicValue, PlayerSettingData.isMuteMusic)
end

--- @return void
function AudioMgr:Update()
    --- @type string[]
    local keyRemoveList
    for key, audioSource in pairs(self._listInUsed:GetItems()) do
        if audioSource.isPlaying == false then
            if keyRemoveList == nil then
                keyRemoveList = List()
            end
            keyRemoveList:Add(key)
        end
    end
    if keyRemoveList ~= nil then
        for i = 1, keyRemoveList:Count() do
            local key = keyRemoveList:Get(i)
            local audioSource = self._listInUsed:Get(key)
            audioSource.loop = false

            self._listFree:Add(audioSource)
            self._listInUsed:RemoveByKey(key)
        end
    end
end

--- @return UnityEngine_AudioSource
function AudioMgr:GetFreeAudioSource()
    --- @type UnityEngine_AudioSource
    local audioSource
    if self._listFree:Count() == 0 then
        audioSource = self.root.gameObject:AddComponent(ComponentName.UnityEngine_AudioSource)
        audioSource.loop = false
        audioSource.playOnAwake = false
    else
        audioSource = self._listFree:Get(1)
        self._listFree:RemoveByIndex(1)
    end

    return audioSource
end

--- @return UnityEngine_AudioSource
function AudioMgr:GetInUseAudioSource(name)
    return self._listInUsed:Get(name)
end

--- @return UnityEngine_AudioSource
function AudioMgr:GetAudioSource(name)
    local audioSource = self:GetInUseAudioSource(name)
    if audioSource == nil then
        audioSource = self:GetFreeAudioSource()
        self._listInUsed:Add(name, audioSource)
    end
    audioSource.volume = self.soundVolume
    return audioSource
end

--- @return UnityEngine_AudioSource
function AudioMgr:GetMusicAudioSource(name)
    local audioSource = self._listMusicAudioSource:Get(name)
    if audioSource == nil then
        --- @param source UnityEngine_AudioSource
        for keyName, source in pairs(self._listMusicAudioSource:GetItems()) do
            if source.isPlaying == false or keyName == name then
                audioSource = source
                self._listMusicAudioSource:RemoveByKey(keyName)
                break
            end
        end
        if audioSource == nil then
            audioSource = self:GetFreeAudioSource()
        end
        self._listMusicAudioSource:Add(name, audioSource)
    end
    audioSource.volume = self.soundVolume
    return audioSource
end

--- @param folderPath number
--- @param audioName string
function AudioMgr:PlaySound(folderPath, audioName)
    if self.isMuteSound == true or self.soundVolume == 0 then
        return
    end
    local onAudioLoaded = function(audioClip)
        if audioClip ~= nil then
            self.soundCtrl:Play(audioClip)
        end
    end
    ResourceLoadUtils.LoadAsyncBundleAudioClip(folderPath, audioName, onAudioLoaded)
end

--- @return void
--- @param name string
--- @param isLoop boolean
function AudioMgr:PlayMusic(name, isLoop)
    local onAudioLoaded = function(audioClip)
        self._playingMusicSource = self.musicCtrl:Play(audioClip, isLoop or true, self.musicVolume)
    end
    ResourceLoadUtils.LoadAsyncBundleAudioClip("Background", name, onAudioLoaded)
end

--- @param name string
function AudioMgr:StopMusic(name, onCompleteFadeOut)
    self.musicCtrl:Stop(name, self.musicVolume, onCompleteFadeOut)
end

--- @param sfxUiType SfxUiType
function AudioMgr:PlaySfxUi(sfxUiType)
    self:PlaySound(AssetType.UI, sfxUiType)
end

--- @param speed number
function AudioMgr:ChangeSoundSpeed(speed)
    for i = 1, self._listFree:Count() do
        self._listFree:Get(i).pitch = speed
    end
    for _, v in pairs(self._listInUsed:GetItems()) do
        v.pitch = speed
    end
    if self._playingMusicSource ~= nil then
        self._playingMusicSource.pitch = 1
    end
end

--- @param value number
--- @param isMuteSound boolean
function AudioMgr:SetSoundVolume(value, isMuteSound)
    self.isMuteSound = isMuteSound
    self.soundVolume = value
    if isMuteSound == true then
        self.soundVolume = 0
    end

    for i = 1, self._listFree:Count() do
        self._listFree:Get(i).volume = self.soundVolume
    end
    for _, v in pairs(self._listInUsed:GetItems()) do
        v.volume = self.soundVolume
    end
end

--- @param value number
--- @param isMuteMusic boolean
function AudioMgr:SetMusicVolume(value, isMuteMusic)
    self.musicVolume = value
    self.isMuteMusic = isMuteMusic
    if isMuteMusic == true then
        self.musicVolume = 0
    end
    if self._playingMusicSource ~= nil then
        self._playingMusicSource.volume = self.musicVolume
    end
end

--- @return void
function AudioMgr:OnDestroy()
    if self.updateCoroutine then
        Coroutine.stop(self.updateCoroutine)
        self.updateCoroutine = nil
    end
end