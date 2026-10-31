--- hero_60003_skin_id_60003002_eff_skill
--- @class Hero60003SkinId60003002EffSkillConfig
Hero60003SkinId60003002EffSkillConfig = Class(Hero60003SkinId60003002EffSkillConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero60003SkinId60003002EffSkillConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 3
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
	self.defaultSpineAnim = "skill"

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = nil
end

return Hero60003SkinId60003002EffSkillConfig
