--- @class AnimEffectAction
AnimEffectAction = Class(AnimEffectAction)

--- @param animName string
--- @param animEffectData AnimEffectData
--- @param transform UnityEngine_Transform
function AnimEffectAction:Ctor(animName, animEffectData, transform)
    self.animName = animName
    self.parent = transform:Find(animEffectData.anchorPath)
    self.time = animEffectData.frame * 1.0 / ClientConfigUtils.FPS
    self.effectType = animEffectData.effectType
    self.effectName = animEffectData.effectName
end