--- hero_20007_skill_fox
--- @class Hero20007SkillFoxConfig
Hero20007SkillFoxConfig = Class(Hero20007SkillFoxConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero20007SkillFoxConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 3.38
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
	self.skeletonAnimation = self.transform:Find("Model"):GetComponent(ComponentName.Spine_Unity_SkeletonAnimation)
	self.defaultSpineAnim = "eff_fox1"

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = nil
end

return Hero20007SkillFoxConfig
