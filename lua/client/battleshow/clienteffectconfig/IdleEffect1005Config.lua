--- idle_effect_1005
--- @class IdleEffect1005Config
IdleEffect1005Config = Class(IdleEffect1005Config)

--- @return void
--- @param transform UnityEngine_Transform
function IdleEffect1005Config:Ctor(transform)
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground", true, true, -10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground/sparks", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground/fire_hitfx", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground/smoke_wave", true, true, -2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground/wave_ray", true, true, -12))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground/ring_lol225", true, true, -5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground/glow_center", true, true, -4))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ground/new66", true, true, -1))
end

return IdleEffect1005Config
