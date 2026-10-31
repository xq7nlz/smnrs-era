--- hero_30007_skin_id_30007002_attack_projectile
--- @class Hero30007SkinId30007002AttackProjectileConfig
Hero30007SkinId30007002AttackProjectileConfig = Class(Hero30007SkinId30007002AttackProjectileConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero30007SkinId30007002AttackProjectileConfig:Ctor(transform)
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
	self.mainVisual = self.transform:Find("Ice_bing10").gameObject

	--- @type number
	self.battleEffectType = ClientConfigUtils.DEFAULT_BATTLE_EFFECT_TYPE

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = nil
end

return Hero30007SkinId30007002AttackProjectileConfig
