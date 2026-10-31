--- hero_50011_skin_id_50011002_attack_projectile
--- @class Hero50011SkinId50011002AttackProjectileConfig
Hero50011SkinId50011002AttackProjectileConfig = Class(Hero50011SkinId50011002AttackProjectileConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero50011SkinId50011002AttackProjectileConfig:Ctor(transform)
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
	self.mainVisual = self.transform:Find("visual_ground").gameObject

	--- @type number
	self.battleEffectType = ClientConfigUtils.DEFAULT_BATTLE_EFFECT_TYPE

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = nil
end

return Hero50011SkinId50011002AttackProjectileConfig
