--- effect_type_31
--- @class EffectType31Config
EffectType31Config = Class(EffectType31Config)

--- @return void
--- @param transform UnityEngine_Transform
function EffectType31Config:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = -1
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "curse_mask/ctrl_smoke/arcane_smoke_after", true, true, -2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "curse_mask/ctrl_smoke/arcane_smoke_fore", true, true, 22))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "curse_mask/arcane_energy_smoke", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "curse_mask/decal_foot", true, true, -10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "curse_mask/Aura_mist_smoke_before", true, true, 20))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "curse_mask/Aura_mist_smoke_after", true, true, -2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "curse_mask/shadow_snoke_foot", true, true, -5))
end

return EffectType31Config
