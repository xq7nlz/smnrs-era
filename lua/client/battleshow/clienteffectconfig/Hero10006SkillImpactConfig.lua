--- hero_10006_skill_impact
--- @class Hero10006SkillImpactConfig
Hero10006SkillImpactConfig = Class(Hero10006SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero10006SkillImpactConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 1
	--- @type number
	self.delayDespawnOnRelease = -1
	--- @type number
	self.anchor = ClientConfigUtils.BODY_ANCHOR
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "impact", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "impact/Center", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "impact/spark", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "impact/hit", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "impact/sparks_dust", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "impact/circle", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "impact/ray_hit", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "impact/ground_nen", true, true, 1))
end

return Hero10006SkillImpactConfig
