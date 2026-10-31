--- hero_40027_attack_impact_human
--- @class Hero40027AttackImpactHumanConfig
Hero40027AttackImpactHumanConfig = Class(Hero40027AttackImpactHumanConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero40027AttackImpactHumanConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 0.7
	--- @type number
	self.delayDespawnOnRelease = 0.5
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

return Hero40027AttackImpactHumanConfig
