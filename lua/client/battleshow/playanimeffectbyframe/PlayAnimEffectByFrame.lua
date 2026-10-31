require "lua.client.battleShow.PlayAnimEffectByFrame.AnimFrameEffectData"
require "lua.client.battleShow.PlayAnimEffectByFrame.AnimEffectData"
require "lua.client.battleShow.PlayAnimEffectByFrame.AnimEffectAction"

--- @class PlayAnimEffectByFrame
PlayAnimEffectByFrame = Class(PlayAnimEffectByFrame)

--- @param clientHero ClientHero
function PlayAnimEffectByFrame:Ctor(clientHero)
    --- @type ClientHero
    self.clientHero = clientHero
    --- @type ClientHeroAnimation
    self.clientHeroAnimation = clientHero.animation
    --- @type UnityEngine_GameObject
    self.gameObject = clientHero.gameObject
    --- @type UnityEngine_GameObject
    self.transform = self.gameObject.transform

    --- @type Dictionary --<string, AnimFrameEffectData>
    self.animFrameEffectDict = nil
    self.animEffectCoroutine = nil

    self._deltaTime = 1.0 / ClientConfigUtils.FPS
    --- @type string
    self._playingAnim = nil
    --- @type List<table{[UnityEngine_GameObject], [AnimEffectData]}>
    self._playingEffectTable = Dictionary()
end

--- @param heroId number
--- @param skinName string
function PlayAnimEffectByFrame:CreateConfig(heroId, skinName)
    if self.animFrameEffectDict == nil then
        self.animFrameEffectDict = ResourceMgr.GetClientHeroConfig():GetFxAnimConfig(self.gameObject, heroId, skinName)
    end
end

--- @param animName string
function PlayAnimEffectByFrame:PlayAnimEffectByName(animName)
    self:StopPlayingEffect()
    if self.animFrameEffectDict:IsContainKey(animName) == false then
        return
    end

    self.animEffectCoroutine = Coroutine.start(function()
        --- @type List<AnimEffectAction>
        local animEffectQueue = self:CreateQueueFromConfig(animName)

        if animEffectQueue:Count() == 0 then
            return
        end
        --- @type AnimEffectAction
        local animEffectAction
        local elapse = 0
        while true do
            for i = animEffectQueue:Count(), 1, -1 do
                animEffectAction = animEffectQueue:Get(i)
                if animEffectAction.time <= elapse then
                    local test = ResourceMgr.GetEffectLuaConfig(animEffectAction.effectName)
                    if test ~= nil then
                        local battleEffect = zg.battleEffectMgr:GetClientEffect(AssetType.HeroBattleEffect, animEffectAction.effectName, true)
                        battleEffect:SetToHeroAnchor(self.clientHero,false,true)
                        self._playingEffectTable:Add(battleEffect.gameObject, animEffectAction)
                    else
                        --- @param gameObject UnityEngine_GameObject
                        local onSpawned = function(gameObject)
                            if gameObject ~= nil then
                                gameObject.transform:SetParent(zgUnity.transform)
                                gameObject.transform.localScale = self.clientHero.components:GetScaleFactor()
                                gameObject:SetActive(true)
                                self._playingEffectTable:Add(gameObject, animEffectAction)
                            end
                        end

                        SmartPool.Instance:SpawnGameObjectAsync(AssetType.HeroBattleEffect,
                                animEffectAction.effectName,
                                onSpawned)
                    end
                    animEffectQueue:RemoveByIndex(i)
                end
            end
            --- @param go UnityEngine_GameObject
            --- @param tempAnim AnimEffectAction
            for go, tempAnim in pairs(self._playingEffectTable:GetItems()) do
                if go.activeSelf == true and tempAnim.animName == self.clientHeroAnimation._playingAnimation then
                    if tempAnim.parent then
                        go.transform.position = tempAnim.parent.position
                        go.transform.rotation = tempAnim.parent.rotation
                    end
                else
                    self._playingEffectTable:RemoveByKey(go)
                    local test = ResourceMgr.GetEffectLuaConfig(animEffectAction.effectName)
                    if test == nil then
                        SmartPool.Instance:DespawnGameObject(AssetType.HeroBattleEffect, tempAnim.effectName, go.transform)
                    end
                end
            end
            coroutine.yield(nil)
            elapse = elapse + U_Time.deltaTime
        end
    end)
end

function PlayAnimEffectByFrame:StopPlayingEffect()
    ClientConfigUtils.KillCoroutine(self.animEffectCoroutine)
    for go, table in pairs(self._playingEffectTable:GetItems()) do
        SmartPool.Instance:DespawnGameObject(AssetType.HeroBattleEffect, table.effectName, go.transform)
    end
    self._playingEffectTable:Clear()
end

--- @returnn List<AnimEffectAction>
--- @param animName string
function PlayAnimEffectByFrame:CreateQueueFromConfig(animName)
    self._playingEffectTable:Clear()

    --- @type AnimFrameEffectData
    local animFrameEffectData = self.animFrameEffectDict:Get(animName)
    --- @type List<AnimEffectAction>
    local listAnimEffectAction = List()
    --- @type AnimEffectData
    local animEffectData
    --- @type AnimEffectAction
    local animEffectAction
    for i = 1, animFrameEffectData.listAnimEffectData:Count() do
        animEffectData = animFrameEffectData.listAnimEffectData:Get(i)
        animEffectAction = AnimEffectAction(animName, animEffectData, self.transform)
        listAnimEffectAction:Add(animEffectAction)
    end
    return listAnimEffectAction
end

function PlayAnimEffectByFrame:ReturnPool()
    self:StopPlayingEffect()
end
