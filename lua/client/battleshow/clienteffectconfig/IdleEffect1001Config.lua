--- idle_effect_1001
--- @class IdleEffect1001Config
IdleEffect1001Config = Class(IdleEffect1001Config)

--- @return void
--- @param transform UnityEngine_Transform
function IdleEffect1001Config:Ctor(transform)
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground/wave1", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground/wave1/wave2", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground/ring_lol224", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground/glow_center", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground/dust", true, true, 1))
end

return IdleEffect1001Config
