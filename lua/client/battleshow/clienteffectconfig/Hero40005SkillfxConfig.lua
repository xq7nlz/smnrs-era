--- hero_40005_skillfx
--- @class Hero40005SkillfxConfig
Hero40005SkillfxConfig = Class(Hero40005SkillfxConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero40005SkillfxConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 2
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "stone_circle", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "stone_circle/stone_plane", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "stone_circle/smoke", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "stone_circle/ground_nen", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "stone_circle/dot_ground", true, true, -5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "stone_circle/ray", true, true, -3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "stone_circle/smoke_circle_ground", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "stone_circle/glow_center", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "stone_circle/flash", true, true, 1))
end

return Hero40005SkillfxConfig
