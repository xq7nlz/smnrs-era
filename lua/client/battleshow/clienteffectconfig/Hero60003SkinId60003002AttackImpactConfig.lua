--- hero_60003_skin_id_60003002_attack_impact
--- @class Hero60003SkinId60003002AttackImpactConfig
Hero60003SkinId60003002AttackImpactConfig = Class(Hero60003SkinId60003002AttackImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero60003SkinId60003002AttackImpactConfig:Ctor(transform)
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Seal", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Seal/Seal_light", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Seal/ground", true, true, -2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Seal/glow", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Seal/glow_tex1", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Seal/glow_tex1/glow_tex2", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Seal/glow_tex1/glow_tex3", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Seal/glow_tex1/glow_tex4", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Seal/glow_tex1/glow_tex5", true, true, 2))
end

return Hero60003SkinId60003002AttackImpactConfig
