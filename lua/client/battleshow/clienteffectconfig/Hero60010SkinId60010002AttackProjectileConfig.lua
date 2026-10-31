--- hero_60010_skin_id_60010002_attack_projectile
--- @class Hero60010SkinId60010002AttackProjectileConfig
Hero60010SkinId60010002AttackProjectileConfig = Class(Hero60010SkinId60010002AttackProjectileConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero60010SkinId60010002AttackProjectileConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = -1
	--- @type number
	self.delayDespawnOnRelease = 0.8
	--- @type number
	self.anchor = ClientConfigUtils.BODY_ANCHOR
	--- @type boolean
	self.isSyncLayerToTarget = false
	--- @type boolean
	self.isChildTarget = false
	--- @type UnityEngine_GameObject
	self.mainVisual = self.transform:Find("visualadd").gameObject

	--- @type number
	self.battleEffectType = ClientConfigUtils.DEFAULT_BATTLE_EFFECT_TYPE

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = nil
end

return Hero60010SkinId60010002AttackProjectileConfig
