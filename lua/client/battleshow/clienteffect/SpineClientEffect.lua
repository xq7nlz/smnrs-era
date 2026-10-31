--- @class SpineClientEffect : ClientEffect
SpineClientEffect = Class(SpineClientEffect, ClientEffect)

--- @param gameObject UnityEngine_GameObject
function SpineClientEffect:Ctor()
    ClientEffect.Ctor(self)
end

--- @param configTable table
function SpineClientEffect:InitConfig(configTable)
    ClientEffect.InitConfig(self, configTable)
    local skeletonAnimation = self.transform:Find(configTable.skeleton_animation):GetComponent(ComponentName.Spine_Unity_SkeletonAnimation)
    self:AddConfigField("skeleton_animation", skeletonAnimation)
end

function SpineClientEffect:Play()
    ClientEffect.Play(self)
    self.config.skeleton_animation.AnimationState:ClearTracks()
    self.config.skeleton_animation.AnimationState:SetAnimation(0, self.config.defaultSpineAnim, false)
end