--- hero_50008_skill_impact
--- @class Hero50008SkillImpactConfig
Hero50008SkillImpactConfig = Class(Hero50008SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero50008SkillImpactConfig:Ctor(transform)
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "crack_impact3/crack12", true, true, -4))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "crack_impact3/crack_light", true, true, -2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "crack_impact3/glow", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "crack_impact3/smoke", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "crack_impact3/puse_big", true, true, 0))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "crack_impact3/ray", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "crack_impact3/glow_aura", true, true, 0))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "crack_impact3/flash", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "crack_impact3/lighting_shhet", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "crack_impact3/flash_big", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "crack_impact3/crack_light2", true, true, -3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "crack_impact3/crack_explo", true, true, -4))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "crack_impact3/shockwave", true, true, 2))
end

return Hero50008SkillImpactConfig
