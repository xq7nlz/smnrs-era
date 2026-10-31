--- @class AnimEffectData
AnimEffectData = Class(AnimEffectData)

function AnimEffectData:Ctor()
    --- @type number
    self.frame = nil
    --- @type string
    self.effectType = nil
    --- @type string
    self.effectName = nil
    --- @type string
    self.anchorPath = nil
end