--- hero_50006_skin_id_50006002_skill_impact
--- @class Hero50006SkinId50006002SkillImpactConfig
Hero50006SkinId50006002SkillImpactConfig = Class(Hero50006SkinId50006002SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero50006SkinId50006002SkillImpactConfig:Ctor(transform)
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl/ground_black", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl/ground_black/line_long", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl/ground_black/sparks_light", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl/ground_black/line", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl/ground_black/impact", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl/ground_black/sparks_black", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl/ground_black/nen_all2", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl/ground_black/dust", true, true, 10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl/ground_black/impact_ground", true, true, 4))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl/wirls", true, true, -6))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl/wirls/smoke", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl/wirls/trail (1)", true, true, 10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl/wirls/fire1_ad", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl/trail", true, true, 6))
end

return Hero50006SkinId50006002SkillImpactConfig
