--- hero_50004_skill_impact
--- @class Hero50004SkillImpactConfig
Hero50004SkillImpactConfig = Class(Hero50004SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero50004SkillImpactConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 2.5
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_vk/Ellipse 2 copy 3", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_vk/Ellipse 2 copy 3/Cross", true, true, 4))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_vk/smoke_boom", true, true, 6))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_vk/smoke_boom/ray_y", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_vk/smoke_boom/glow_horo", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_vk/smoke_boom/ray", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_vk/smoke_boom/circle", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_vk/smoke_boom/dust_line", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_vk/smoke_boom/crack", true, true, -3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_vk/smoke_boom/aura", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_vk/smoke_boom/sparks", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_vk/smoke_boom/smoke", true, true, 7))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_vk/smoke_boom/dustcfx", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_vk/smoke_boom/crack_light2", true, true, -2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_vk/smoke_boom/ground_crack_shadow", true, true, -3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_vk/smoke_boom/stone", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_vk/smoke_boom/smoke_circle_ground", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_vk/smoke_boom/crack_stone", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_vk/smoke_boom/crack_stone918", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_vk/smoke_boom/light", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_vk/light (0.1)", true, true, -3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_vk/light (0.1)/dot", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_vk/light (0.1)/light_collum", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_vk/light (0.1)/line", true, true, 4))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_vk/light (0.1)/glow_cross", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "anim_vk/light (0.1)/light_collum_mid", true, true, -2))
end

return Hero50004SkillImpactConfig
