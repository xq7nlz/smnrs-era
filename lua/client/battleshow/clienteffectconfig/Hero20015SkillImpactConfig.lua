--- hero_20015_skill_impact
--- @class Hero20015SkillImpactConfig
Hero20015SkillImpactConfig = Class(Hero20015SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero20015SkillImpactConfig:Ctor(transform)
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "fire_hell/xoay1", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "fire_hell/fire_circle_L", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "fire_hell/fire_circle_R", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "fire_hell/vong", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "fire_hell/Collum_light", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "fire_hell/dust_circle_3D", true, true, -2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "impact/dust_circle_3D", true, true, -2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "impact/sparks1", true, true, -1))
end

return Hero20015SkillImpactConfig
