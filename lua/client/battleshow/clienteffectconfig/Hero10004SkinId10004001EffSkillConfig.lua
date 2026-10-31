--- hero_10004_skin_id_10004001_eff_skill
--- @class Hero10004SkinId10004001EffSkillConfig
Hero10004SkinId10004001EffSkillConfig = Class(Hero10004SkinId10004001EffSkillConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero10004SkinId10004001EffSkillConfig:Ctor(transform)
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
	self.isChildTarget = false
	--- @type UnityEngine_GameObject
	self.mainVisual = nil

	--- @type number
	self.battleEffectType = ClientConfigUtils.DEFAULT_BATTLE_EFFECT_TYPE

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = List()
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Ctrl/Ctrl (1)/dragon", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Ctrl/Ctrl (1)/wind_ground/smoke_circle_ground", true, true, -15))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Ctrl/Ctrl (1)/wind_ground/fragment", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Ctrl/Ctrl (1)/wind_ground/boom_exploide", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Ctrl/Ctrl (1)/wind_ground/tanbien2.0/arow_dat", true, true, 10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Ctrl/Ctrl (1)/wind_ground/light_dragon", true, true, -4))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Ctrl/Ctrl (1)/wind_ground/boom_exploide_impact", true, true, 2))
end

return Hero10004SkinId10004001EffSkillConfig
