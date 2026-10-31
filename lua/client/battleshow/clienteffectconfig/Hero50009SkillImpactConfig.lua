--- hero_50009_skill_impact
--- @class Hero50009SkillImpactConfig
Hero50009SkillImpactConfig = Class(Hero50009SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero50009SkillImpactConfig:Ctor(transform)
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctl/glow_ef/ray_flash (1)", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "tiasang/chop1/flash (1)", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "tiasang/chop1/impact_shot", true, true, 1))
end

return Hero50009SkillImpactConfig
