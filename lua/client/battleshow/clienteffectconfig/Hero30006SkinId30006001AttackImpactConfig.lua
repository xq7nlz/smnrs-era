--- hero_30006_skin_id_30006001_attack_impact
--- @class Hero30006SkinId30006001AttackImpactConfig
Hero30006SkinId30006001AttackImpactConfig = Class(Hero30006SkinId30006001AttackImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero30006SkinId30006001AttackImpactConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 3
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

return Hero30006SkinId30006001AttackImpactConfig
