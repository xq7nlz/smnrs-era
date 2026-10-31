--- hero_60006_skill_dead_buff
--- @class Hero60006SkillDeadBuffConfig
Hero60006SkillDeadBuffConfig = Class(Hero60006SkillDeadBuffConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero60006SkillDeadBuffConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = -1
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl/light", true, true, 0))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl/light_ab", true, true, -10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl/ground", true, true, -2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl/spark", true, true, -3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl/bgr", true, true, -2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl/glow", true, true, 0))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl/star_ground", true, true, -1))
end

return Hero60006SkillDeadBuffConfig
