--- hero_40010_skill_impact
--- @class Hero40010SkillImpactConfig
Hero40010SkillImpactConfig = Class(Hero40010SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero40010SkillImpactConfig:Ctor(transform)
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Halo/circle", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Halo/circle/smoke_stregth", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Halo/circle/circle_ground", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Halo/crack", true, true, -3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Halo/crack/crack_energy", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Halo/crack/blood_green", true, true, -2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Halo/crack/water", true, true, -2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Halo/crack/magic_buff", true, true, -1))
end

return Hero40010SkillImpactConfig
