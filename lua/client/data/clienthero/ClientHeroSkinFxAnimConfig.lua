require "lua.client.battleShow.PlayAnimEffectByFrame.AnimFrameEffectData"

--- @class ClientHeroSkinFxAnimConfig
ClientHeroSkinFxAnimConfig = Class(ClientHeroSkinFxAnimConfig)

--- @param gameObject UnityEngine_GameObject
function ClientHeroSkinFxAnimConfig:Ctor(gameObject)
    --- @type Dictionary -- animName, AnimFrameEffectData
    self.fxAnimConfigDict = Dictionary()
    self:_InitAnimFameEffectConfig(gameObject)
end

--- @param gameObject UnityEngine_GameObject
function ClientHeroSkinFxAnimConfig:_InitAnimFameEffectConfig(gameObject)
    --- @type IS_Battle_PlayEffectByFrame
    local csPlayEffectByFrame = gameObject:GetComponent(ComponentName.PlayEffectByFrame)
    if Main.IsNull(csPlayEffectByFrame) then
        return
    end
    --- @type List
    local listEffect = csPlayEffectByFrame.effects
    for i = 0, listEffect.Count - 1 do
        local effectData = listEffect[i]
        local anim = effectData.animName

        --- @type AnimFrameEffectData
        local animFrameEffectData = self.fxAnimConfigDict:Get(anim)
        if animFrameEffectData == nil then
            animFrameEffectData = AnimFrameEffectData(anim)
            self.fxAnimConfigDict:Add(anim, animFrameEffectData)
        end
        local listFrameData = effectData.listFrameData
        for k = 0, listFrameData.Count - 1 do
            --- @type {frame, effectType, effectName, anchorPath}
            local frameData = listFrameData[k]
            animFrameEffectData:AddFrameConfig(
                    frameData.frame,
                    frameData.anchorPath,
                    frameData.effectType,
                    frameData.effectName)
        end
    end
end

--- @return Dictionary
function ClientHeroSkinFxAnimConfig:GetAnimFrameEffectData()
    return self.fxAnimConfigDict
end