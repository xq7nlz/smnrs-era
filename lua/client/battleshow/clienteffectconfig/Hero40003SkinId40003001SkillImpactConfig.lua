--- hero_40003_skin_id_40003001_skill_impact
--- @class Hero40003SkinId40003001SkillImpactConfig
Hero40003SkinId40003001SkillImpactConfig = Class(Hero40003SkinId40003001SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero40003SkinId40003001SkillImpactConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 3
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/wind_ground/boom_exploide_impact", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/wind_ground/fireworks/sparks", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/wind_ground/fireworks/firework2", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/wind_ground/fireworks/firework2/sparks_worls", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/wind_ground/fireworks/firework2/ground", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/wind_ground/fire", true, true, 9))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/wind_ground/arow_dat", true, true, 12))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/wind_ground/smoke", true, true, 9))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/wind_ground/stone_l", true, true, 20))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/wind_ground/stone_center", true, true, 15))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/wind_ground/stone_r", true, true, 22))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/wind_spawn/ray_flash", true, true, 11))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/wind_spawn/smoke_cartoon", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/wind_spawn/stone_l", true, true, 20))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/wind_spawn/stone_r", true, true, 15))
end

return Hero40003SkinId40003001SkillImpactConfig
