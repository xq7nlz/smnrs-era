--- hero_40001_skill_impact
--- @class Hero40001SkillImpactConfig
Hero40001SkillImpactConfig = Class(Hero40001SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero40001SkillImpactConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 0.667
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
	self.skeletonAnimation = self.transform:Find("view (1)"):GetComponent(ComponentName.Spine_Unity_SkeletonAnimation)
	self.defaultSpineAnim = "eff_attack"

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = nil
end

return Hero40001SkillImpactConfig
