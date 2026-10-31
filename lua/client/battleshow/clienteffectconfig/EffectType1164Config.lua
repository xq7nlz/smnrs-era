--- effect_type_116_4
--- @class EffectType1164Config
EffectType1164Config = Class(EffectType1164Config)

--- @return void
--- @param transform UnityEngine_Transform
function EffectType1164Config:Ctor(transform)
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "crack", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "crack/wind (1)", true, true, 9))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "crack/loc (1)", true, true, 6))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "crack/ground", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "crack/ground/ground_adp", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "crack/spark", true, true, 10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "crack/nho (1)", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "crack/nho (1)/nhoadp (1)", true, true, 2))
end

return EffectType1164Config
