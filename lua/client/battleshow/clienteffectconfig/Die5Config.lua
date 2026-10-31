--- die_5
--- @class Die5Config
Die5Config = Class(Die5Config)

--- @return void
--- @param transform UnityEngine_Transform
function Die5Config:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 3
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Halo", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Halo/lightting_ground", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Halo/lightting_center", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Halo/ground_collum", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Halo/ground_collum/ground_collum2", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Halo/line", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Halo/stars_trail", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Halo/decal", true, true, -3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Halo/glow_foot", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Halo/stars_trail2", true, true, 2))
end

return Die5Config
