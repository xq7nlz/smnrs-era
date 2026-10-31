--- hero_20014_eff_skill
--- @class Hero20014EffSkillConfig
Hero20014EffSkillConfig = Class(Hero20014EffSkillConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero20014EffSkillConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 0.967
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
	self.skeletonAnimation = self.transform:Find("Model"):GetComponent(ComponentName.Spine_Unity_SkeletonAnimation)
	self.defaultSpineAnim = "animation"

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = List()
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Model/bone_fx/anim_projectile/ctrl/visual (1)/smoke", true, true, 9))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Model/bone_fx/anim_projectile/ctrl/visual (1)/et_trail", true, true, 9))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Model/bone_fx/anim_projectile/ctrl/visual (1)/fire_trail", true, true, 6))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Model/bone_fx/anim_projectile/ctrl/visual (1)/cang_glow", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Model/bone_fx/anim_projectile/ctrl/spark_trail", true, true, 4))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Model/bone_fx/anim_projectile/ctrl/fragment", true, true, 10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Model/bone_fx/anim_projectile/ctrl/dust", true, true, 10))
end

return Hero20014EffSkillConfig
