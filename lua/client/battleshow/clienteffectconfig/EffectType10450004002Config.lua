--- effect_type_104_50004002
--- @class EffectType10450004002Config
EffectType10450004002Config = Class(EffectType10450004002Config)

--- @return void
--- @param transform UnityEngine_Transform
function EffectType10450004002Config:Ctor(transform)
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Oderus_shield_light/ground_body/stars", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Oderus_shield_light/ground_foot_circle", true, true, -30))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Oderus_shield_light/ground_foot_circle/shield_circle_magic", true, true, -15))
	self.listEffectVisual:Add(SpriteEffectVisual(self.transform, "Oderus_shield_light/ctrl_shield_grimm/shield_grimm", true, true, 30))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Oderus_shield_light/ctrl_shield_grimm/shield_grimm/shield_ringht", true, true, 25))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Oderus_shield_light/ctrl_shield_grimm/shield_grimm/shield_left", true, true, 25))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Oderus_shield_light/ctrl_shield_grimm/shield_grimm/lightning_fore", true, true, 24))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Oderus_shield_light/ctrl_shield_grimm/shield_grimm/lightning_after", true, true, 24))
end

return EffectType10450004002Config
