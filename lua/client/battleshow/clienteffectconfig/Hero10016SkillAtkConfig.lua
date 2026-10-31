--- hero_10016_skill_atk
--- @class Hero10016SkillAtkConfig
Hero10016SkillAtkConfig = Class(Hero10016SkillAtkConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero10016SkillAtkConfig:Ctor(transform)
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ray/water_fail", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ray/water_fail2", true, true, 2))
	self.listEffectVisual:Add(SpriteEffectVisual(self.transform, "croconile", true, true, 1))
end

return Hero10016SkillAtkConfig
