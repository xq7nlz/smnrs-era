--- hero_30008_skill_impact
--- @class Hero30008SkillImpactConfig
Hero30008SkillImpactConfig = Class(Hero30008SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero30008SkillImpactConfig:Ctor(transform)
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl_toxic_impact/blood_ring", true, true, -4))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl_toxic_impact/blood_foot", true, true, -5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl_toxic_impact/water010", true, true, 10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl_toxic_impact/blood_lol_top", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl_toxic_impact/smoke_ice_mist", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl_toxic_impact/smoke_ground", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl_toxic_impact/magic_debuff_toxic", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl_toxic_impact/buble", true, true, 10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl_toxic_impact/blood_mist_albed0", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl_toxic_impact/blood_lol591_ray", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl_toxic_impact/aura_ringwave", true, true, -10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl_toxic_impact/crack_smoke_tarven", true, true, -12))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl_toxic_impact/flash", true, true, -12))
end

return Hero30008SkillImpactConfig
