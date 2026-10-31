--- hero_30010_skill_impact
--- @class Hero30010SkillImpactConfig
Hero30010SkillImpactConfig = Class(Hero30010SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero30010SkillImpactConfig:Ctor(transform)
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glow/stone", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glow/nen1", true, true, -5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glow/nen2", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glow/stone_add", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glow/spark", true, true, 5))
end

return Hero30010SkillImpactConfig
