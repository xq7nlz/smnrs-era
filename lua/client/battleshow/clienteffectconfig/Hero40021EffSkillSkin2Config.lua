--- hero_40021_eff_skill_skin_2
--- @class Hero40021EffSkillSkin2Config
Hero40021EffSkillSkin2Config = Class(Hero40021EffSkillSkin2Config)

--- @return void
--- @param transform UnityEngine_Transform
function Hero40021EffSkillSkin2Config:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 1.83
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
	self.defaultSpineAnim = "fx"

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = nil
end

return Hero40021EffSkillSkin2Config
