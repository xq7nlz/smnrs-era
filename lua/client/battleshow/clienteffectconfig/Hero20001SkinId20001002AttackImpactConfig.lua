--- hero_20001_skin_id_20001002_attack_impact
--- @class Hero20001SkinId20001002AttackImpactConfig
Hero20001SkinId20001002AttackImpactConfig = Class(Hero20001SkinId20001002AttackImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero20001SkinId20001002AttackImpactConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 1.5
	--- @type number
	self.delayDespawnOnRelease = -1
	--- @type number
	self.anchor = ClientConfigUtils.BODY_ANCHOR
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

return Hero20001SkinId20001002AttackImpactConfig
