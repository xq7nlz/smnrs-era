--- hero_2_skill_impact
--- @class Hero2SkillImpactConfig
Hero2SkillImpactConfig = Class(Hero2SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero2SkillImpactConfig:Ctor(transform)
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
	self.isChildTarget = true
	--- @type UnityEngine_GameObject
	self.mainVisual = nil

	--- @type number
	self.battleEffectType = ClientConfigUtils.DEFAULT_BATTLE_EFFECT_TYPE

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = List()
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground_dot/Sword", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground_dot/Sword/Sword_Adp", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground_dot/beam", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground_dot/light85", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground_dot/glow3", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground_dot/base_light", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground_dot/base_ground", true, true, -5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground_dot/wind_ground/smoke", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground_dot/wind_ground/dot", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground_dot/stone", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground_dot/crack", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground_dot/smoke_circle_ground (1)", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground_dot/circle (1)", true, true, -1))
end

return Hero2SkillImpactConfig
