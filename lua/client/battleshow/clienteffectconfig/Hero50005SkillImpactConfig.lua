--- hero_50005_skill_impact
--- @class Hero50005SkillImpactConfig
Hero50005SkillImpactConfig = Class(Hero50005SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero50005SkillImpactConfig:Ctor(transform)
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "light", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "light/black_bg", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "light/fire_1", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "light/circle_center", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "light/circle", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "light (0.9)", true, true, 0))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "light (0.9)/light_collum", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "light (0.9)/line", true, true, 4))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "boom/circle", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "boom/crack", true, true, -4))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "boom/aura", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "boom/crack_light", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "boom/crack_Abyss", true, true, -5))
end

return Hero50005SkillImpactConfig
