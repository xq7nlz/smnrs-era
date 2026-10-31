--- hero_30011_skill_impact
--- @class Hero30011SkillImpactConfig
Hero30011SkillImpactConfig = Class(Hero30011SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero30011SkillImpactConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 4
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "flash/exploision_impact/tam", true, true, 12))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "flash/exploision_impact/flash_center", true, true, 12))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "flash/smoke_before", true, true, 4))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "flash/smoke_before/skull1", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "flash/smoke_before/skull2", true, true, 3))
end

return Hero30011SkillImpactConfig
