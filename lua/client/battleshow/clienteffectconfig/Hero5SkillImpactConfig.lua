--- hero_5_skill_impact
--- @class Hero5SkillImpactConfig
Hero5SkillImpactConfig = Class(Hero5SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero5SkillImpactConfig:Ctor(transform)
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Ctrl/arow_skyfly_fore", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Ctrl/arow_skyfly_fore/arow_dat", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Ctrl/arow_skyfly_fore/arow_dat/stone", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Ctrl/wind_ground/ray", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Ctrl/wind_ground/lightning", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Ctrl/wind_ground/glow_center", true, true, 0))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Ctrl/wind_ground/impact_ground", true, true, -5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Ctrl/wind_ground/crack_547", true, true, -2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Ctrl/wind_ground/boom_exploide", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Ctrl/wind_ground/dot", true, true, -1))
end

return Hero5SkillImpactConfig
