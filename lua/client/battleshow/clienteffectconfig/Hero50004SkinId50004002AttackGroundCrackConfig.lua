--- hero_50004_skin_id_50004002_attack_ground_crack
--- @class Hero50004SkinId50004002AttackGroundCrackConfig
Hero50004SkinId50004002AttackGroundCrackConfig = Class(Hero50004SkinId50004002AttackGroundCrackConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero50004SkinId50004002AttackGroundCrackConfig:Ctor(transform)
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
	self.isSyncLayerToTarget = false
	--- @type boolean
	self.isChildTarget = false
	--- @type UnityEngine_GameObject
	self.mainVisual = nil

	--- @type number
	self.battleEffectType = ClientConfigUtils.DEFAULT_BATTLE_EFFECT_TYPE

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = nil
end

return Hero50004SkinId50004002AttackGroundCrackConfig
