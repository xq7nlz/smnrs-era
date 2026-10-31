--- hero_50023_fxskill_skin_2
--- @class Hero50023FxskillSkin2Config
Hero50023FxskillSkin2Config = Class(Hero50023FxskillSkin2Config)

--- @return void
--- @param transform UnityEngine_Transform
function Hero50023FxskillSkin2Config:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 0.8
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
	self.skeletonAnimation = self.transform:Find("view (1)"):GetComponent(ComponentName.Spine_Unity_SkeletonAnimation)
	self.defaultSpineAnim = "fxskill"

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = nil
end

return Hero50023FxskillSkin2Config
