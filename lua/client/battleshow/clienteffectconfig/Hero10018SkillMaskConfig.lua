--- hero_10018_skill_mask
--- @class Hero10018SkillMaskConfig
Hero10018SkillMaskConfig = Class(Hero10018SkillMaskConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero10018SkillMaskConfig:Ctor(transform)
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "an", true, true, -2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "an/circle_toa", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "an/circle_mask", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "an/glow", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "an/ground", true, true, -3))
end

return Hero10018SkillMaskConfig
