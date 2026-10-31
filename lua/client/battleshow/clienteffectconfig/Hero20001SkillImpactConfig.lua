--- hero_20001_skill_impact
--- @class Hero20001SkillImpactConfig
Hero20001SkillImpactConfig = Class(Hero20001SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero20001SkillImpactConfig:Ctor(transform)
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "light (1)/flash", true, true, 20))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "light (1)/smoke (1)", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "light (1)/smokeadp (1)", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "light (1)/fire (1)", true, true, 6))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "light (1)/spark (1)", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "light (1)/smoke (2)", true, true, 7))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "light (1)/glow_efap (1)", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "light (1)/glow_ef (1)", true, true, 7))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "light (1)/smoke_circle_ground (1)", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "light (1)/smoke_circle_ground (2)", true, true, 10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "light (1)/wind_ground", true, true, 35))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "light (1)/wind_center", true, true, 40))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen/glow_efap (1)", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen/glow_ef (1)", true, true, 15))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen/nen33 (1)", true, true, 15))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen/flash (1)", true, true, 10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen/spin", true, true, -3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen/spin/spin_shadow", true, true, -5))
end

return Hero20001SkillImpactConfig
