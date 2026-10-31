--- hero_40004_fx_skill
--- @class Hero40004FxSkillConfig
Hero40004FxSkillConfig = Class(Hero40004FxSkillConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero40004FxSkillConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 1.6667
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
	self.skeletonAnimation = self.transform:Find("visual"):GetComponent(ComponentName.Spine_Unity_SkeletonAnimation)
	self.defaultSpineAnim = "animation"

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = List()
	self.listEffectVisual:Add(SpineEffectVisual(self.transform, "visual", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/ctrl/crack_blackearth", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/ctrl/stone", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/ctrl/ray", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/ctrl/dust", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "visual/ctrl/glow", true, true, 1))
end

return Hero40004FxSkillConfig
