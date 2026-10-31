--- hero_30022_attack_projectile_skin_1
--- @class Hero30022AttackProjectileSkin1Config
Hero30022AttackProjectileSkin1Config = Class(Hero30022AttackProjectileSkin1Config)

--- @return void
--- @param transform UnityEngine_Transform
function Hero30022AttackProjectileSkin1Config:Ctor(transform)
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
	self.mainVisual = self.transform:Find("New Sprite").gameObject

	--- @type number
	self.battleEffectType = ClientConfigUtils.DEFAULT_BATTLE_EFFECT_TYPE

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = nil
end

return Hero30022AttackProjectileSkin1Config
