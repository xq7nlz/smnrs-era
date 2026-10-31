--- @class AnimFrameEffectData
AnimFrameEffectData = Class(AnimFrameEffectData)

--- @param animName string
function AnimFrameEffectData:Ctor(animName)
    --- @type string
    self.animName = animName
    --- @type List<AnimEffectData>
    self.listAnimEffectData = List()
end

--- @param frame number
--- @param anchorPath string
--- @param effectType string
--- @param effectName string
function AnimFrameEffectData:AddFrameConfig(frame, anchorPath, effectType, effectName)
    local animEffectData = AnimEffectData()
    animEffectData.frame = frame
    animEffectData.effectType = effectType
    animEffectData.effectName = effectName
    animEffectData.anchorPath = anchorPath
    self.listAnimEffectData:Add(animEffectData)
end