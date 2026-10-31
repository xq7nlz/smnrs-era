require "lua.client.battleShow.PlaySoundEffectByFrame.SoundFrameData"
require "lua.client.battleShow.PlaySoundEffectByFrame.SoundFrameEffectData"
require "lua.client.battleShow.PlaySoundEffectByFrame.SoundFrameAction"

--- @class PlaySoundEffectByFrame
PlaySoundEffectByFrame = Class(PlaySoundEffectByFrame)

--- @param clientHero ClientHero
function PlaySoundEffectByFrame:Ctor(clientHero)
    --- @type UnityEngine_GameObject
    self.gameObject = clientHero.gameObject
    --- @type Dictionary<string, SoundFrameEffectData>
    self.soundFrameEffectDict = nil
    self.soundCoroutine = nil
end

--- @param heroId number
--- @param skinName string
function PlaySoundEffectByFrame:CreateConfig(heroId, skinName)
    if self.soundFrameEffectDict == nil then
        self.soundFrameEffectDict = ResourceMgr.GetClientHeroConfig():GetSfxAnimConfig(self.gameObject, heroId, skinName)
    end
end

--- @param animation string
function PlaySoundEffectByFrame:PlaySoundByAnim(animation)
    if self.soundFrameEffectDict:IsContainKey(animation) == false then
        return
    end
    local soundFrameEffectQueue = self:CreateQueueFromConfig(animation)
    if soundFrameEffectQueue:Count() == 0 then
        return
    end
    ClientConfigUtils.KillCoroutine(self.soundCoroutine)
    self.soundCoroutine = Coroutine.start(function()
        coroutine.waitforseconds(soundFrameEffectQueue:Get(1).time)
        --- @type SoundFrameAction
        local soundFrameAction = soundFrameEffectQueue:Get(1)
        zg.audioMgr:PlaySound(soundFrameAction.folderPath, soundFrameAction.fileName)
        for i = 2, soundFrameEffectQueue:Count() do
            local waitTime = soundFrameEffectQueue:Get(i).time - soundFrameEffectQueue:Get(i - 1).time
            coroutine.waitforseconds(waitTime)
            soundFrameAction = soundFrameEffectQueue:Get(i)
            zg.audioMgr:PlaySound(soundFrameAction.folderPath, soundFrameAction.fileName)
        end
    end)
end

--- @param animation string
function PlaySoundEffectByFrame:CreateQueueFromConfig(animation)
    --- @type SoundFrameEffectData
    local soundFrameEffectData = self.soundFrameEffectDict:Get(animation)
    local listSoundFrameAction = List()
    --- @type SoundFrameData
    local soundFrameData
    for i = 1, soundFrameEffectData.listSoundFrameData:Count() do
        soundFrameData = soundFrameEffectData.listSoundFrameData:Get(i)
        --- @type SoundFrameAction
        local soundFrameAction = SoundFrameAction(soundFrameData)
        soundFrameAction.animName = animation
        listSoundFrameAction:Add(soundFrameAction)
    end
    return listSoundFrameAction
end

function PlaySoundEffectByFrame:ReturnPool()
    ClientConfigUtils.KillCoroutine(self.soundCoroutine)
end