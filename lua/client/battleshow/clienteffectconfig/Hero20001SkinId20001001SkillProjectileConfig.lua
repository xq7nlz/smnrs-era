--- hero_20001_skin_id_20001001_skill_projectile
--- @class Hero20001SkinId20001001SkillProjectileConfig
Hero20001SkinId20001001SkillProjectileConfig = Class(Hero20001SkinId20001001SkillProjectileConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero20001SkinId20001001SkillProjectileConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = -1
	--- @type number
	self.delayDespawnOnRelease = 0.8
	--- @type number
	self.anchor = ClientConfigUtils.FOOT_ANCHOR
	--- @type boolean
	self.isSyncLayerToTarget = true
	--- @type boolean
	self.isChildTarget = true
	--- @type UnityEngine_GameObject
	self.mainVisual = self.transform:Find("projectile").gameObject

	--- @type number
	self.battleEffectType = ClientConfigUtils.DEFAULT_BATTLE_EFFECT_TYPE

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = List()
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "stone", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "stone/ray_eflight_collum", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "stone/smoke", true, true, -10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "stone/flash", true, true, -5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "stone/glow", true, true, -30))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "stone/smoke2", true, true, 15))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "stone/beam21", true, true, 5))
end

return Hero20001SkinId20001001SkillProjectileConfig
