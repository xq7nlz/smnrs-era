--- hero_30006_skin_id_30006001_skill_impact
--- @class Hero30006SkinId30006001SkillImpactConfig
Hero30006SkinId30006001SkillImpactConfig = Class(Hero30006SkinId30006001SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero30006SkinId30006001SkillImpactConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 5
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole", true, true, -85))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole/weind2", true, true, -5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole/hand_ghost_Fore", true, true, 4))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole/hand_ghost_Fore/hand_ghost_ForeR", true, true, 4))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole/hand_ghost_Fore/hand_ghost_after", true, true, -5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole/hand_ghost_Fore/hand_ghost_after/hand_ghost_after2", true, true, -5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole/ground", true, true, -11))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole/thanhgia", true, true, -6))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole/thanhgia/thanhgia (1)", true, true, 50))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole/thanhgia/thanhgia (2)", true, true, -8))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole/arcane_enegy_fore", true, true, 40))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole/arcane_enegy_fore/arcane_smoke_after", true, true, -6))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole/arcane_enegy_fore/circle_mask", true, true, -100))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole/arcane_enegy_fore/circle_mask_light", true, true, -90))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole/arcane_enegy_fore/glow", true, true, -80))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "hole/ice_smoke", true, true, 10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "stone/gai", true, true, 38))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "stone/gai_add", true, true, 39))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "stone/weind2_impact", true, true, -5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "stone/nen_impact", true, true, -9))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "stone/splat1", true, true, 40))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "stone/splat2", true, true, 40))
end

return Hero30006SkinId30006001SkillImpactConfig
