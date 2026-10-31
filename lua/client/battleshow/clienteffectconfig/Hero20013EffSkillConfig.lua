--- hero_20013_eff_skill
--- @class Hero20013EffSkillConfig
Hero20013EffSkillConfig = Class(Hero20013EffSkillConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero20013EffSkillConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 3.067
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
	self.skeletonAnimation = self.transform:Find("model"):GetComponent(ComponentName.Spine_Unity_SkeletonAnimation)
	self.defaultSpineAnim = "skill1"

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = nil
end

return Hero20013EffSkillConfig
