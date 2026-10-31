--- hero_60010_skill_impact
--- @class Hero60010SkillImpactConfig
Hero60010SkillImpactConfig = Class(Hero60010SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero60010SkillImpactConfig:Ctor(transform)
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "black_hold", true, true, -20))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "black_hold/circle_around_pink", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "black_hold/glow", true, true, 30))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "black_hold/dot_center", true, true, -15))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "black_hold/star", true, true, -15))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "black_hold/frozen", true, true, -14))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "black_hold/circle_around_big", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "black_hold/wirl_around1", true, true, -14))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "black_hold/galaxy", true, true, -19))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground_black_explosion", true, true, -5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground_black_explosion/ground_pink", true, true, -3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground_black_explosion/glow", true, true, 20))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground_black_explosion/flare", true, true, 20))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground_black_explosion/wirl_around", true, true, 10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground_black_explosion/wirl_ground", true, true, -4))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground_black_explosion/dust_light", true, true, 10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground_black_explosion/dust_dark", true, true, 10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground_black_explosion/circle_wave", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground_black_explosion/sparks1", true, true, 10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground_black_explosion/sparks2", true, true, 10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground_black_explosion/sphere_exploder", true, true, 20))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground_black_explosion/blast", true, true, -5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground_black_explosion/circle_wave (1)", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground_black_explosion/flare (1)", true, true, 30))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground_black_explosion/sparks2 (1)", true, true, 10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground_black_explosion/sparks2 (2)", true, true, 4))
end

return Hero60010SkillImpactConfig
