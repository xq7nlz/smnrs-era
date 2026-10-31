--- hero_10004_skin_id_10004001_attack_projectile
--- @class Hero10004SkinId10004001AttackProjectileConfig
Hero10004SkinId10004001AttackProjectileConfig = Class(Hero10004SkinId10004001AttackProjectileConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero10004SkinId10004001AttackProjectileConfig:Ctor(transform)
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
	self.mainVisual = self.transform:Find("bird").gameObject

	--- @type number
	self.battleEffectType = ClientConfigUtils.DEFAULT_BATTLE_EFFECT_TYPE

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = nil
end

return Hero10004SkinId10004001AttackProjectileConfig
