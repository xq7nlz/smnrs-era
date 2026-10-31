--- hero_20001_skin_id_20001002_skill_impact
--- @class Hero20001SkinId20001002SkillImpactConfig
Hero20001SkinId20001002SkillImpactConfig = Class(Hero20001SkinId20001002SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero20001SkinId20001002SkillImpactConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 3.5
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Hit/crack/song", true, true, -20))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Hit/crack/wind", true, true, -5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Hit/crack/nen33", true, true, -4))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Hit/256_blast/smoke", true, true, -10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Hit/256_blast/ray_eflight_collum", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Hit/256_blast/ray_dust", true, true, 15))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Hit/hit/big_glow", true, true, 15))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Hit/hit/boom_exploder_light", true, true, 15))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Hit/hit/nen2", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Hit/hit/ground_pink", true, true, 4))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Hit/hit/wind", true, true, 10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Hit/smoke_circlemesh", true, true, -10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Egg_easter/nen", true, true, -20))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Egg_easter/flash", true, true, 11))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Egg_easter/flash/glow", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Egg_easter/flash/glow2", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Egg_easter/vong_vang1", true, true, -20))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Egg_easter/vong_vang1/vong_vang2", true, true, -15))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Egg_easter/vong_vang1/vong_tim", true, true, -10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Egg_easter/sao_nho", true, true, 9))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Egg_easter/egg", true, true, 11))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Egg_easter/egg/dot_top", true, true, 12))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Egg_easter/egg/sparks", true, true, 10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Egg_easter/egg/egg_glow", true, true, 12))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Egg_easter/nen_foot", true, true, -25))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Egg_easter/nen_foot/glow_foot", true, true, -24))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Egg_easter/nen_ground", true, true, -35))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Egg_easter/nen_ground/glow_ground", true, true, -19))
end

return Hero20001SkinId20001002SkillImpactConfig
