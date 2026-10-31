--- hero_10023_eff_skill_skin_2
--- @class Hero10023EffSkillSkin2Config
Hero10023EffSkillSkin2Config = Class(Hero10023EffSkillSkin2Config)

--- @return void
--- @param transform UnityEngine_Transform
function Hero10023EffSkillSkin2Config:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 1.533
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
	self.skeletonAnimation = self.transform:Find("visual"):GetComponent(ComponentName.Spine_Unity_SkeletonAnimation)
	self.defaultSpineAnim = "eff_skill"

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = nil
end

return Hero10023EffSkillSkin2Config
