--- hero_20002_skin_id_20002001_skill_projectile
--- @class Hero20002SkinId20002001SkillProjectileConfig
Hero20002SkinId20002001SkillProjectileConfig = Class(Hero20002SkinId20002001SkillProjectileConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero20002SkinId20002001SkillProjectileConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = -1
	--- @type number
	self.delayDespawnOnRelease = 0.5
	--- @type number
	self.anchor = ClientConfigUtils.BODY_ANCHOR
	--- @type boolean
	self.isSyncLayerToTarget = false
	--- @type boolean
	self.isChildTarget = false
	--- @type UnityEngine_GameObject
	self.mainVisual = self.transform:Find("main").gameObject

	--- @type number
	self.battleEffectType = ClientConfigUtils.DEFAULT_BATTLE_EFFECT_TYPE

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = nil
end

return Hero20002SkinId20002001SkillProjectileConfig
