--- hero_40003_skill_impact
--- @class Hero40003SkillImpactConfig
Hero40003SkillImpactConfig = Class(Hero40003SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero40003SkillImpactConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 2.235
	--- @type number
	self.delayDespawnOnRelease = -1
	--- @type number
	self.anchor = ClientConfigUtils.FOOT_ANCHOR
	--- @type boolean
	self.isSyncLayerToTarget = true
	--- @type boolean
	self.isChildTarget = false
	--- @type UnityEngine_GameObject
	self.mainVisual = nil

	--- @type number
	self.battleEffectType = ClientConfigUtils.SPINE_BATTLE_EFFECT_TYPE
	self.skeletonAnimation = self.transform:Find("visual"):GetComponent(ComponentName.Spine_Unity_SkeletonAnimation)
	self.defaultSpineAnim = "attack"

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = List()
	self.listEffectVisual:Add(SpineEffectVisual(self.transform, "visual", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/flare_flash", true, true, -5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/flare_flash/D_ring2", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/flare_flash/glow", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/flare_flash/flash", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/flare_flash/smoke_circle_ground", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/flare_flash/circle", true, true, -2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/flare_flash/hat", true, true, 7))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/flare_flash/hat/hat_goc", true, true, 6))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/flare_flash/hat/glow_center", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/flare_flash/hat/glow_center (1)", true, true, 4))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/flare_flash/hat/glow_halfAB", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/flare_flash/hat/glow_up", true, true, 6))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/flare_flash/water008_explosion_tree", true, true, 10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/flare_flash/water008_explosion_tree/water_smoke", true, true, 10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/flare_flash/water008_explosion_tree/ray_flash", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/flare_flash/water008_explosion_tree/glow_ground0.45", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/flare_flash/water008_explosion_tree/flash_0.45", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/flare_flash/water008_explosion_tree/smoke_ground", true, true, 4))
end

return Hero40003SkillImpactConfig
