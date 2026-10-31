--- hero_20001_skin_id_20001002_skill_eff
--- @class Hero20001SkinId20001002SkillEffConfig
Hero20001SkinId20001002SkillEffConfig = Class(Hero20001SkinId20001002SkillEffConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero20001SkinId20001002SkillEffConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 1.166
	--- @type number
	self.delayDespawnOnRelease = 0.2
	--- @type number
	self.anchor = ClientConfigUtils.FOOT_ANCHOR
	--- @type boolean
	self.isSyncLayerToTarget = true
	--- @type boolean
	self.isChildTarget = false
	--- @type UnityEngine_GameObject
	self.mainVisual = self.transform:Find("Model").gameObject

	--- @type number
	self.battleEffectType = ClientConfigUtils.SPINE_BATTLE_EFFECT_TYPE
	self.skeletonAnimation = self.transform:Find("Model"):GetComponent(ComponentName.Spine_Unity_SkeletonAnimation)
	self.defaultSpineAnim = "jump"

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = List()
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Model/SkeletonUtility-Root/bone_fx/bird", true, true, 0))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Model/SkeletonUtility-Root/bone_fx/bird/glow", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Model/SkeletonUtility-Root/bone_fx/bird/ground", true, true, -10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Model/SkeletonUtility-Root/bone_fx_jump/circle", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Model/SkeletonUtility-Root/bone_fx_jump/circle/dot", true, true, -3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Model/SkeletonUtility-Root/bone_fx_jump/circle/glow_ground", true, true, -5))
end

return Hero20001SkinId20001002SkillEffConfig
