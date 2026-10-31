--- effect_type_116_2
--- @class EffectType1162Config
EffectType1162Config = Class(EffectType1162Config)

--- @return void
--- @param transform UnityEngine_Transform
function EffectType1162Config:Ctor(transform)
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
	self.isChildTarget = false
	--- @type UnityEngine_GameObject
	self.mainVisual = nil

	--- @type number
	self.battleEffectType = ClientConfigUtils.DEFAULT_BATTLE_EFFECT_TYPE

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = List()
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "arcane_shield_lightning_sheet", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "arcane_shield_lightning_sheet/arcane_smoke_after", true, true, -2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "arcane_shield_lightning_sheet/arcane_smoke_fore", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Zyx_taget", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "preparation_n_sheet", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "decal_zyx_after", true, true, -3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "glow_decal_zyx", true, true, -3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ice_smoke", true, true, -2))
end

return EffectType1162Config
