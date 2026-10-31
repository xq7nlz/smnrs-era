--- hero_60014_skill_impact
--- @class Hero60014SkillImpactConfig
Hero60014SkillImpactConfig = Class(Hero60014SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero60014SkillImpactConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 1.5
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "boom/crack", true, true, -5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "boom/crack_light", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "boom/halo_crack", true, true, -2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "boom/circle_dark", true, true, -3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "boom/circle_black", true, true, -5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "boom/magic_buff", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "boom/water", true, true, -2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "boom/smoke_bg", true, true, -5))
end

return Hero60014SkillImpactConfig
