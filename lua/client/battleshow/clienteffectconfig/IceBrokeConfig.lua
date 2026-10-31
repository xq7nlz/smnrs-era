--- ice_broke
--- @class IceBrokeConfig
IceBrokeConfig = Class(IceBrokeConfig)

--- @return void
--- @param transform UnityEngine_Transform
function IceBrokeConfig:Ctor(transform)
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
	self.isChildTarget = true
	--- @type UnityEngine_GameObject
	self.mainVisual = nil

	--- @type number
	self.battleEffectType = ClientConfigUtils.DEFAULT_BATTLE_EFFECT_TYPE

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = List()
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "smoke", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "smoke/smoke2", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "smoke/dust", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "smoke/stars", true, true, 3))
end

return IceBrokeConfig
