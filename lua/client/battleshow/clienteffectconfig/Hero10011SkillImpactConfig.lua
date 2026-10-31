--- hero_10011_skill_impact
--- @class Hero10011SkillImpactConfig
Hero10011SkillImpactConfig = Class(Hero10011SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero10011SkillImpactConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 2
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glow/ground", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glow/mesh1", true, true, 10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glow/mesh1/black", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glow/mesh1/yellow", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glow/ground2", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glow/ray", true, true, 12))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glow/impact_R", true, true, 12))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glow/ray_flash", true, true, 10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glow/circle_center", true, true, 13))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glow/circle_mid", true, true, 12))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glow/smoke_circle_ground", true, true, 13))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glow/ray_foot", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glow/rayL", true, true, 12))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glow/ray_line", true, true, 12))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glow/smoke", true, true, 0))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glow/flash", true, true, 15))
end

return Hero10011SkillImpactConfig
