--- hero_20006_skin_id_20006001_skill_projectile
--- @class Hero20006SkinId20006001SkillProjectileConfig
Hero20006SkinId20006001SkillProjectileConfig = Class(Hero20006SkinId20006001SkillProjectileConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero20006SkinId20006001SkillProjectileConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = -1
	--- @type number
	self.delayDespawnOnRelease = 1.5
	--- @type number
	self.anchor = ClientConfigUtils.BODY_ANCHOR
	--- @type boolean
	self.isSyncLayerToTarget = false
	--- @type boolean
	self.isChildTarget = false
	--- @type UnityEngine_GameObject
	self.mainVisual = self.transform:Find("ctrl").gameObject

	--- @type number
	self.battleEffectType = ClientConfigUtils.DEFAULT_BATTLE_EFFECT_TYPE

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = nil
end

return Hero20006SkinId20006001SkillProjectileConfig
