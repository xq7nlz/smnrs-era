--- hero_30004_eff_attack
--- @class Hero30004EffAttackConfig
Hero30004EffAttackConfig = Class(Hero30004EffAttackConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero30004EffAttackConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 1
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
	self.battleEffectType = ClientConfigUtils.SPINE_BATTLE_EFFECT_TYPE
	self.skeletonAnimation = self.transform:Find("view"):GetComponent(ComponentName.Spine_Unity_SkeletonAnimation)
	self.defaultSpineAnim = "eff_attack"

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = nil
end

return Hero30004EffAttackConfig
