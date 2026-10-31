--- hero_4_skill_impact
--- @class Hero4SkillImpactConfig
Hero4SkillImpactConfig = Class(Hero4SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero4SkillImpactConfig:Ctor(transform)
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
	self.isChildTarget = true
	--- @type UnityEngine_GameObject
	self.mainVisual = nil

	--- @type number
	self.battleEffectType = ClientConfigUtils.DEFAULT_BATTLE_EFFECT_TYPE

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = List()
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hero3_shadow", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hero3_shadow/hero3_shadow2", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "boom/crack_black2", true, true, -5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "boom/crack_black2/crack_ground", true, true, -2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "boom/crack_black2/crack_groundlight", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "boom/crack_black2/circle_ground", true, true, 0))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "boom/crack_black2/aura_black", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "boom/crack_black2/circle_center", true, true, 0))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "boom/crack_black2/circle_ground_black", true, true, 0))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "boom/halo", true, true, 3))
end

return Hero4SkillImpactConfig
