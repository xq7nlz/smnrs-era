--- hero_20001_skin_id_20001003_skill_impact
--- @class Hero20001SkinId20001003SkillImpactConfig
Hero20001SkinId20001003SkillImpactConfig = Class(Hero20001SkinId20001003SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero20001SkinId20001003SkillImpactConfig:Ctor(transform)
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
	self.isChildTarget = false
	--- @type UnityEngine_GameObject
	self.mainVisual = nil

	--- @type number
	self.battleEffectType = ClientConfigUtils.DEFAULT_BATTLE_EFFECT_TYPE

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = List()
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Impact/light/flash", true, true, 20))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Impact/light/smoke (1)", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Impact/light/smokeadp (1)", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Impact/light/spark (1)", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Impact/light/smoke (2)", true, true, 7))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Impact/light/glow_efap (1)", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Impact/light/glow_ef (1)", true, true, 7))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Impact/light/smoke_circle_ground (1)", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Impact/light/smoke_circle_ground (2)", true, true, 10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Impact/light/wind_ground", true, true, 35))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Impact/light/wind_center", true, true, 40))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Impact/nen", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Impact/nen/glow_efap (1)", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Impact/nen/nen33 (1)", true, true, 15))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Impact/nen/flash (1)", true, true, 10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Impact/nen/spin", true, true, -3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Impact/nen/spin/spin_shadow", true, true, -5))
end

return Hero20001SkinId20001003SkillImpactConfig
