--- hero_50003_skin_id_50003001_skill_impact
--- @class Hero50003SkinId50003001SkillImpactConfig
Hero50003SkinId50003001SkillImpactConfig = Class(Hero50003SkinId50003001SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero50003SkinId50003001SkillImpactConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 6
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
	self.battleEffectType = ClientConfigUtils.DEFAULT_BATTLE_EFFECT_TYPE

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = List()
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen1", true, true, -7))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen1/nen", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen1/vong_vang1", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen1/vong_vang1/vong_vang2", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen1/vong_vang1/vong_tim", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen1/vong_vang1/nen_mesh", true, true, -20))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen1/sao_nho", true, true, 9))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen1/sao_nho/sao_lon", true, true, 9))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen1/tam32", true, true, 11))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen1/tam32/tam1", true, true, 11))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen1/tam32/tam2", true, true, 11))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen1/tam32/dot_top", true, true, 6))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen1/tam32/dot_top (1)", true, true, 7))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen1/flower", true, true, 9))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen1/flower/floweradv", true, true, 12))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen1/flower/flowerla_l", true, true, -5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen1/flower/flowerla_r", true, true, -5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen1/flower/star_flower_foot", true, true, 15))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen1/leaf_flower_star", true, true, 4))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen1/leaf_flower_star/sparks", true, true, 4))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "nen1/smoke", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ice/shoc", true, true, 15))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ice/leaf_flower", true, true, 20))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ice/leaf_flower_big", true, true, 20))
end

return Hero50003SkinId50003001SkillImpactConfig
