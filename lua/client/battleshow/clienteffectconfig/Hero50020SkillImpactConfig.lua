--- hero_50020_skill_impact
--- @class Hero50020SkillImpactConfig
Hero50020SkillImpactConfig = Class(Hero50020SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero50020SkillImpactConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 2.5
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "boom/circle", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "boom/smoke", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "boom/stone85", true, true, 4))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "boom/base_ground", true, true, -5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "boom/beam", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "boom/khien50020", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "boom/fragment", true, true, 6))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "boom/ray_light", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "boom/khien50020_light", true, true, 2))
end

return Hero50020SkillImpactConfig
