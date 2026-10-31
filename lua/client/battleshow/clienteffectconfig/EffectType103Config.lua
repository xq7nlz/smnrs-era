--- effect_type_103
--- @class EffectType103Config
EffectType103Config = Class(EffectType103Config)

--- @return void
--- @param transform UnityEngine_Transform
function EffectType103Config:Ctor(transform)
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Oderus_shield_light/ground_body/shield_circle_magic", true, true, 50))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Oderus_shield_light/ground_body/stars", true, true, 3))
end

return EffectType103Config
