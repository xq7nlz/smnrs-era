--- hero_20001_skin_id_20001003_skill_projectile
--- @class Hero20001SkinId20001003SkillProjectileConfig
Hero20001SkinId20001003SkillProjectileConfig = Class(Hero20001SkinId20001003SkillProjectileConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero20001SkinId20001003SkillProjectileConfig:Ctor(transform)
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Anim_projectile_20001003/Ctrl/tonardo/fire (1)", true, true, 4))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Anim_projectile_20001003/Ctrl/tonardo/fire (1)/fire", true, true, 4))
end

return Hero20001SkinId20001003SkillProjectileConfig
