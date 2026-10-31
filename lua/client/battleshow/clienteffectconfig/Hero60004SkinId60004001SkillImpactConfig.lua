--- hero_60004_skin_id_60004001_skill_impact
--- @class Hero60004SkinId60004001SkillImpactConfig
Hero60004SkinId60004001SkillImpactConfig = Class(Hero60004SkinId60004001SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero60004SkinId60004001SkillImpactConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 4
	--- @type number
	self.delayDespawnOnRelease = -1
	--- @type number
	self.anchor = ClientConfigUtils.FOOT_ANCHOR
	--- @type boolean
	self.isSyncLayerToTarget = true
	--- @type boolean
	self.isChildTarget = true
	--- @type UnityEngine_GameObject
	self.mainVisual = nil

	--- @type number
	self.battleEffectType = ClientConfigUtils.DEFAULT_BATTLE_EFFECT_TYPE

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = List()
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "wirl_tim", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "wirl_tim/nen1", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "wirl_tim/technology", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "wirl_tim/smoke_bacl", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "wirl_tim/wave (1)", true, true, 0))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "wirl_tim/circle", true, true, 0))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "wirl_tim/circle (1)", true, true, 0))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "wirl_tim/circle (2)", true, true, 0))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "wirl_tim/star_charge", true, true, 0))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "wirl_tim/star (1)", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "exploision_impact (1.25)", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "exploision_impact (1.25)/nen", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "exploision_impact (1.25)/skull_paricle (1.3)", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "exploision_impact (1.25)/skull_paricle ", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "exploision_impact (1.25)/flash_center_glow (1.25)", true, true, 11))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "exploision_impact (1.25)/smoke", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "exploision_impact (1.25)/smoke/smoke", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "exploision_impact (1.25)/smoke_bacl_flash2", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "exploision_impact (1.25)/smoke_bacl_flash2/smoke_bacl_flash3", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "exploision_impact (1.25)/circle_big", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "exploision_impact (1.25)/circle_big_ab", true, true, -2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "exploision_impact (1.25)/flash_crack", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "exploision_impact (1.25)/dust", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "exploision_impact (1.25)/wirl_black", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "exploision_impact (1.25)/wirl_black_ab", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "exploision_impact (1.25)/smoke_bacd_flash", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "exploision_impact (1.25)/ground_flash_black", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "exploision_impact (1.25)/flash_center", true, true, 10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "exploision_impact (1.25)/spark (1.28)", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "exploision_impact (1.25)/smoke_crack_548", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "exploision_impact (1.25)/shock_wave", true, true, 2))
end

return Hero60004SkinId60004001SkillImpactConfig
