--- hero_20006_skill_gate
--- @class Hero20006SkillGateConfig
Hero20006SkillGateConfig = Class(Hero20006SkillGateConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero20006SkillGateConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 3.333
	--- @type number
	self.delayDespawnOnRelease = -1
	--- @type number
	self.anchor = ClientConfigUtils.FOOT_ANCHOR
	--- @type boolean
	self.isSyncLayerToTarget = true
	--- @type boolean
	self.isChildTarget = false
	--- @type UnityEngine_GameObject
	self.mainVisual = nil

	--- @type number
	self.battleEffectType = ClientConfigUtils.SPINE_BATTLE_EFFECT_TYPE
	self.skeletonAnimation = self.transform:Find("Gate"):GetComponent(ComponentName.Spine_Unity_SkeletonAnimation)
	self.defaultSpineAnim = "start"

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = List()
	self.listEffectVisual:Add(SpineEffectVisual(self.transform, "Gate", true, true, -1))
end

return Hero20006SkillGateConfig
