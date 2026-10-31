--- hero_30027_skin_id_30027001_attack_impact
--- @class Hero30027SkinId30027001AttackImpactConfig
Hero30027SkinId30027001AttackImpactConfig = Class(Hero30027SkinId30027001AttackImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero30027SkinId30027001AttackImpactConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 2
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

return Hero30027SkinId30027001AttackImpactConfig
