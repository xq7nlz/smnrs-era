--- hero_50006_skin_id_50006001_skill_impact
--- @class Hero50006SkinId50006001SkillImpactConfig
Hero50006SkinId50006001SkillImpactConfig = Class(Hero50006SkinId50006001SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero50006SkinId50006001SkillImpactConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 1.5
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glow2/nen_all2", true, true, -25))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glow2/impact_water", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glow2/ring_07_center", true, true, -20))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glow2/water_posion2", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glow2/water_posion_center", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glow2/water_smoke (1)", true, true, 10))
end

return Hero50006SkinId50006001SkillImpactConfig
