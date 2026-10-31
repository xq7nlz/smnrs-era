--- hero_10009_skill_impact
--- @class Hero10009SkillImpactConfig
Hero10009SkillImpactConfig = Class(Hero10009SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero10009SkillImpactConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 2
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
	self.battleEffectType = ClientConfigUtils.DEFAULT_BATTLE_EFFECT_TYPE

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = List()
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ray_flash/crack", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ray_flash/crack/water", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ray_flash/crack/circle", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ray_flash/crack/decal", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ray_flash/crack/song", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ray_flash/crack/wind", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ray_flash/crack/nen33", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ray_flash/crack/song (1)", true, true, -1))
end

return Hero10009SkillImpactConfig
