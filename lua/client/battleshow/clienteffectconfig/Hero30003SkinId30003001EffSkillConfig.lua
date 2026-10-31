--- hero_30003_skin_id_30003001_eff_skill
--- @class Hero30003SkinId30003001EffSkillConfig
Hero30003SkinId30003001EffSkillConfig = Class(Hero30003SkinId30003001EffSkillConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero30003SkinId30003001EffSkillConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 5
	--- @type number
	self.delayDespawnOnRelease = -1
	--- @type number
	self.anchor = ClientConfigUtils.TORSO_ANCHOR
	--- @type boolean
	self.isSyncLayerToTarget = true
	--- @type boolean
	self.isChildTarget = false
	--- @type UnityEngine_GameObject
	self.mainVisual = nil

	--- @type number
	self.battleEffectType = ClientConfigUtils.SPINE_BATTLE_EFFECT_TYPE
	self.skeletonAnimation = self.transform:Find("GameObject"):GetComponent(ComponentName.Spine_Unity_SkeletonAnimation)
	self.defaultSpineAnim = "skill"

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = List()
end

return Hero30003SkinId30003001EffSkillConfig
