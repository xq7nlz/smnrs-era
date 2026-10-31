--- hero_60021_eff_arrow
--- @class Hero60021EffArrowConfig
Hero60021EffArrowConfig = Class(Hero60021EffArrowConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero60021EffArrowConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 0.833
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
	self.skeletonAnimation = self.transform:Find("eff_arrow"):GetComponent(ComponentName.Spine_Unity_SkeletonAnimation)
	self.defaultSpineAnim = "eff_skill"

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = nil
end

return Hero60021EffArrowConfig
