--- hero_60010_skin_id_60010001_attack_impact
--- @class Hero60010SkinId60010001AttackImpactConfig
Hero60010SkinId60010001AttackImpactConfig = Class(Hero60010SkinId60010001AttackImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero60010SkinId60010001AttackImpactConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 4
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

return Hero60010SkinId60010001AttackImpactConfig
