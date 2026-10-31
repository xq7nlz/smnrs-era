--- hero_10004_skill_impact
--- @class Hero10004SkillImpactConfig
Hero10004SkillImpactConfig = Class(Hero10004SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero10004SkillImpactConfig:Ctor(transform)
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Ctrl/arow_skyfly_fore", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Ctrl/wind_ground/fragment", true, true, 10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Ctrl/wind_ground/ray", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Ctrl/wind_ground/impact_ground", true, true, -5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Ctrl/wind_ground/boom_exploide", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Ctrl/wind_ground/tanbien/arow_dat", true, true, 5))
end

return Hero10004SkillImpactConfig
