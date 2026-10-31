--- effect_type_564
--- @class EffectType564Config
EffectType564Config = Class(EffectType564Config)

--- @return void
--- @param transform UnityEngine_Transform
function EffectType564Config:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = -1
	--- @type number
	self.delayDespawnOnRelease = -1
	--- @type number
	self.anchor = ClientConfigUtils.BODY_ANCHOR
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "transform/lightning_fore", true, true, 24))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "transform/lightning_after", true, true, 24))
end

return EffectType564Config
