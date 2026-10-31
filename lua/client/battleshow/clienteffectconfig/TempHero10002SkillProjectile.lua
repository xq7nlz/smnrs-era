--- @class TempHero10002SkillProjectile
TempHero10002SkillProjectileConfig = Class(TempHero10002SkillProjectileConfig)

--- @return void
--- @param transform UnityEngine_Transform
function TempHero10002SkillProjectileConfig:Ctor(transform)
    --- @type UnityEngine_GameObject
    self.gameObject = transform.gameObject
    --- @type UnityEngine_Transform
    self.transform = transform.transform
    --- @type number
    self.timeLife = -1
    --- @type number
    self.delayDespawnOnRelease = -1
    --- @type number
    self.anchor = ClientConfigUtils.BODY_ANCHOR
    --- @type boolean
    self.isSyncLayerToTarget = false
    --- @type boolean
    self.isChildTarget = false
    --- @type UnityEngine_GameObject
    self.mainVisual = self.transform:Find("").gameObject

    --- @type number
    self.battleEffectType = ClientConfigUtils.SPINE_BATTLE_EFFECT_TYPE
    self.skeletonAnimation = self.transform:Find(""):GetComponent(ComponentName.Spine_Unity_SkeletonAnimation)
    self.defaultSpineAnim = "animation"

    --- @type List<ClientEffectVisual>
    self.listEffectVisual = List()
    self.listEffectVisual:Add(SpineEffectVisual(self.transform, "", true, true, -1))
    self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "", true, true, 1))
end
