--- hero_40027_skin_id_40027001_attack_impact_dragon
--- @class Hero40027SkinId40027001AttackImpactDragonConfig
Hero40027SkinId40027001AttackImpactDragonConfig = Class(Hero40027SkinId40027001AttackImpactDragonConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero40027SkinId40027001AttackImpactDragonConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 2
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

return Hero40027SkinId40027001AttackImpactDragonConfig
