--- effect_type_2
--- @class EffectType2Config
EffectType2Config = Class(EffectType2Config)

--- @return void
--- @param transform UnityEngine_Transform
function EffectType2Config:Ctor(transform)
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
	self.listEffectVisual:Add(SpriteEffectVisual(self.transform, "Effect_Ice_Idle/ice_crack_shazi12", true, true, -2))
	self.listEffectVisual:Add(SpriteEffectVisual(self.transform, "Effect_Ice_Idle/Sealing_Crystal", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Effect_Ice_Idle/smoke", true, true, 2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Effect_Ice_Idle/ice_6629", true, true, 3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Effect_Ice_Idle/dust", true, true, 3))
end

return EffectType2Config
