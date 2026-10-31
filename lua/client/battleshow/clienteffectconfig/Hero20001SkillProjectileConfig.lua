--- hero_20001_skill_projectile
--- @class Hero20001SkillProjectileConfig
Hero20001SkillProjectileConfig = Class(Hero20001SkillProjectileConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero20001SkillProjectileConfig:Ctor(transform)
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
	self.isChildTarget = false
	--- @type UnityEngine_GameObject
	self.mainVisual = nil

	--- @type number
	self.battleEffectType = ClientConfigUtils.DEFAULT_BATTLE_EFFECT_TYPE

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = List()
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_projectile_20001/ctrl/aura/smoke_local", true, true, 4))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_projectile_20001/ctrl/aura/smoke", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_projectile_20001/ctrl/aura/wind_center", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_projectile_20001/ctrl/aura/wind_center/wind_1", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_projectile_20001/ctrl/aura/wind_center/wind_1/wind_1_ground", true, true, -5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_projectile_20001/ctrl/aura/fire", true, true, 4))
end

return Hero20001SkillProjectileConfig
