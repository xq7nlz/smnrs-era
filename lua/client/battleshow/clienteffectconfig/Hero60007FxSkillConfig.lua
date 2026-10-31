--- hero_60007_fx_skill
--- @class Hero60007FxSkillConfig
Hero60007FxSkillConfig = Class(Hero60007FxSkillConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero60007FxSkillConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 0.633
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
	self.battleEffectType = ClientConfigUtils.SPINE_BATTLE_EFFECT_TYPE
	self.skeletonAnimation = self.transform:Find("visual"):GetComponent(ComponentName.Spine_Unity_SkeletonAnimation)
	self.defaultSpineAnim = "fx_lazer"

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = nil
end

return Hero60007FxSkillConfig
