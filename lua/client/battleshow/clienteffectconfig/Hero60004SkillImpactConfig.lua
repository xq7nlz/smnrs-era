--- hero_60004_skill_impact
--- @class Hero60004SkillImpactConfig
Hero60004SkillImpactConfig = Class(Hero60004SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero60004SkillImpactConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 4
	--- @type number
	self.delayDespawnOnRelease = -1
	--- @type number
	self.anchor = ClientConfigUtils.FOOT_ANCHOR
	--- @type boolean
	self.isSyncLayerToTarget = true
	--- @type boolean
	self.isChildTarget = true
	--- @type UnityEngine_GameObject
	self.mainVisual = nil

	--- @type number
	self.battleEffectType = ClientConfigUtils.DEFAULT_BATTLE_EFFECT_TYPE

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = List()
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "wirl_tim/smoke_before", true, true, 4))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "wirl_tim/smoke_before/skull1", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "wirl_tim/smoke_bacl", true, true, 7))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen1", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen1/nen", true, true, 4))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen1/vong_vang1", true, true, -20))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen1/vong_vang1/vong_vang2", true, true, -5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen1/vong_vang1/vong_tim", true, true, -10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen1/sao_nho", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen1/sao_nho/sao_lon", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen1/tam32", true, true, 11))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen1/tam32/tam1", true, true, 11))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen1/tam32/tam_black", true, true, 12))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "exploision_impact/flash_center", true, true, 12))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "exploision_impact/skull2 (1)", true, true, 3))
end

return Hero60004SkillImpactConfig
