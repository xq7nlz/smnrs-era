--- hero_40011_skill_impact
--- @class Hero40011SkillImpactConfig
Hero40011SkillImpactConfig = Class(Hero40011SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero40011SkillImpactConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 2
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glow1/stone", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glow1/stoneR", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glow1/stone_frag", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glowL/stoneR", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "dust_stone", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "smoke", true, true, 4))
end

return Hero40011SkillImpactConfig
