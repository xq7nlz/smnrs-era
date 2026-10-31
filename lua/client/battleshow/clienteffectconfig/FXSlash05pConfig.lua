--- FX_Slash_05p
--- @class FXSlash05pConfig
FXSlash05pConfig = Class(FXSlash05pConfig)

--- @return void
--- @param transform UnityEngine_Transform
function FXSlash05pConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = -1
	--- @type number
	self.delayDespawnOnRelease = -1
	--- @type number
	self.anchor = ClientConfigUtils.HEAD_ANCHOR
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Trail2", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "sparks", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "chop_glow", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "chop_glow/ring_wirl", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "chop_glow/smoke_bacl", true, true, 1))
end

return FXSlash05pConfig
