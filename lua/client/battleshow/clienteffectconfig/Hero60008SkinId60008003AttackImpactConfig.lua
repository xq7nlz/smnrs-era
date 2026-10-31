--- hero_60008_skin_id_60008003_attack_impact
--- @class Hero60008SkinId60008003AttackImpactConfig
Hero60008SkinId60008003AttackImpactConfig = Class(Hero60008SkinId60008003AttackImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero60008SkinId60008003AttackImpactConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 1
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

return Hero60008SkinId60008003AttackImpactConfig
