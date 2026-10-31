--- effect_type_569_competitor
--- @class EffectType569CompetitorConfig
EffectType569CompetitorConfig = Class(EffectType569CompetitorConfig)

--- @return void
--- @param transform UnityEngine_Transform
function EffectType569CompetitorConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 1
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "arcane_shield_lightning_sheet", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "arcane_shield_lightning_sheet/arcane_smoke_after", true, true, -2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "arcane_shield_lightning_sheet/arcane_smoke_fore", true, true, 2))
end

return EffectType569CompetitorConfig
