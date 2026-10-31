--- hero_20001_skin_id_20001002_attack_projectile
--- @class Hero20001SkinId20001002AttackProjectileConfig
Hero20001SkinId20001002AttackProjectileConfig = Class(Hero20001SkinId20001002AttackProjectileConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero20001SkinId20001002AttackProjectileConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = -1
	--- @type number
	self.delayDespawnOnRelease = 1
	--- @type number
	self.anchor = ClientConfigUtils.BODY_ANCHOR
	--- @type boolean
	self.isSyncLayerToTarget = false
	--- @type boolean
	self.isChildTarget = false
	--- @type UnityEngine_GameObject
	self.mainVisual = self.transform:Find("Model").gameObject

	--- @type number
	self.battleEffectType = ClientConfigUtils.SPINE_BATTLE_EFFECT_TYPE
	self.skeletonAnimation = self.transform:Find("Model"):GetComponent(ComponentName.Spine_Unity_SkeletonAnimation)
	self.defaultSpineAnim = "move"

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = nil
end

return Hero20001SkinId20001002AttackProjectileConfig
