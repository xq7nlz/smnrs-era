--- hero_20010_skill_impact
--- @class Hero20010SkillImpactConfig
Hero20010SkillImpactConfig = Class(Hero20010SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero20010SkillImpactConfig:Ctor(transform)
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack", true, true, -6))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/gai", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/gai/gai_add", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/gai/gai (1)", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/gai/gai (1)/gai_add", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/gai/gai (2)", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/gai/gai (2)/gai_add", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/gai/gai (3)", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/gai/gai (4)", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/tam", true, true, -7))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/nen", true, true, -5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/weind2", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/wind", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/ray", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/blash", true, true, 4))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/blash/blash2", true, true, 4))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/dam_suc", true, true, 4))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/ray (1)", true, true, 4))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/nen (1)", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/fire", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/pulse_smoke", true, true, -2))
end

return Hero20010SkillImpactConfig
