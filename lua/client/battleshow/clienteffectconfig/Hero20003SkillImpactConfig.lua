--- hero_20003_skill_impact
--- @class Hero20003SkillImpactConfig
Hero20003SkillImpactConfig = Class(Hero20003SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero20003SkillImpactConfig:Ctor(transform)
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack", true, true, -10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/gai", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/gai/gai_add", true, true, 6))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/gai/gai1", true, true, 7))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/gai/gai2", true, true, 8))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/gai/Stone_before", true, true, 10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/gai/Stone_before/Stone_2", true, true, 9))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/gai/blash", true, true, 9))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/gai/blash/blash2", true, true, 9))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/gai/blash/hit_black", true, true, 7))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/gai/blash/ray (1)", true, true, 9))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/Glow/smoke", true, true, -5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole_crack/Glow/nen", true, true, -9))
end

return Hero20003SkillImpactConfig
