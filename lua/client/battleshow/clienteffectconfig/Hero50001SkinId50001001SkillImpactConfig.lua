--- hero_50001_skin_id_50001001_skill_impact
--- @class Hero50001SkinId50001001SkillImpactConfig
Hero50001SkinId50001001SkillImpactConfig = Class(Hero50001SkinId50001001SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero50001SkinId50001001SkillImpactConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 3
	--- @type number
	self.delayDespawnOnRelease = -1
	--- @type number
	self.anchor = ClientConfigUtils.BODY_ANCHOR
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "chop/heart", true, true, 10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "chop/heart_2", true, true, 10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "chop/heart_big", true, true, 20))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Star_marks", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Star_marks/ground", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Star_marks/glow", true, true, 4))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Star_marks/light_projectiletip7", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Star_marks/ray_projectiletip7", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Star_marks/arrow_barb", true, true, 5))
end

return Hero50001SkinId50001001SkillImpactConfig
