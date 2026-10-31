--- hero_40009_eff_skill_3_skin_1
--- @class Hero40009EffSkill3Skin1Config
Hero40009EffSkill3Skin1Config = Class(Hero40009EffSkill3Skin1Config)

--- @return void
--- @param transform UnityEngine_Transform
function Hero40009EffSkill3Skin1Config:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 2.167
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
	self.defaultSpineAnim = "skill_3"

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = nil
end

return Hero40009EffSkill3Skin1Config
