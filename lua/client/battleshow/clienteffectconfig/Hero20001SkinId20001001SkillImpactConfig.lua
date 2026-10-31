--- hero_20001_skin_id_20001001_skill_impact
--- @class Hero20001SkinId20001001SkillImpactConfig
Hero20001SkinId20001001SkillImpactConfig = Class(Hero20001SkinId20001001SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero20001SkinId20001001SkillImpactConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 3
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ray_flash/flash", true, true, 11))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ray_flash/glow1 (1)/stone", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ray_flash/glow1 (1)/ray_eflight_collum", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ray_flash/glow1 (1)/ray_dust", true, true, 15))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ray_flash/hit/big_glow", true, true, 15))
end

return Hero20001SkinId20001001SkillImpactConfig
