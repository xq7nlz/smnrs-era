--- hero_50001_skill_impact
--- @class Hero50001SkillImpactConfig
Hero50001SkillImpactConfig = Class(Hero50001SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero50001SkillImpactConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 3
	--- @type number
	self.delayDespawnOnRelease = -1
	--- @type number
	self.anchor = ClientConfigUtils.BODY_ANCHOR
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Star_marks", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Star_marks/ground", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Star_marks/glow", true, true, 4))
end

return Hero50001SkillImpactConfig
