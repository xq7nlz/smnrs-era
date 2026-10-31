--- hero_50003_skin_id_50003002_attack_projectile
--- @class Hero50003SkinId50003002AttackProjectileConfig
Hero50003SkinId50003002AttackProjectileConfig = Class(Hero50003SkinId50003002AttackProjectileConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero50003SkinId50003002AttackProjectileConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = -1
	--- @type number
	self.delayDespawnOnRelease = -1
	--- @type number
	self.anchor = ClientConfigUtils.BODY_ANCHOR
	--- @type boolean
	self.isSyncLayerToTarget = false
	--- @type boolean
	self.isChildTarget = false
	--- @type UnityEngine_GameObject
	self.mainVisual = self.transform:Find("trail").gameObject

	--- @type number
	self.battleEffectType = ClientConfigUtils.DEFAULT_BATTLE_EFFECT_TYPE

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = nil
end

return Hero50003SkinId50003002AttackProjectileConfig
