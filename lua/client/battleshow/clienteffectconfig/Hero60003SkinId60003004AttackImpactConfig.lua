--- hero_60003_skin_id_60003004_attack_impact
--- @class Hero60003SkinId60003004AttackImpactConfig
Hero60003SkinId60003004AttackImpactConfig = Class(Hero60003SkinId60003004AttackImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero60003SkinId60003004AttackImpactConfig:Ctor(transform)
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
	self.isSyncLayerToTarget = true
	--- @type boolean
	self.isChildTarget = false
	--- @type UnityEngine_GameObject
	self.mainVisual = nil

	--- @type number
	self.battleEffectType = ClientConfigUtils.DEFAULT_BATTLE_EFFECT_TYPE

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = List()
end

return Hero60003SkinId60003004AttackImpactConfig
