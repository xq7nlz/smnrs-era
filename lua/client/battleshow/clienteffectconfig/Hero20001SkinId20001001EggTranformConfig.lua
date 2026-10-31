--- hero_20001_skin_id_20001001_egg_tranform
--- @class Hero20001SkinId20001001EggTranformConfig
Hero20001SkinId20001001EggTranformConfig = Class(Hero20001SkinId20001001EggTranformConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero20001SkinId20001001EggTranformConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 1
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "slash/hit", true, true, 10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "slash/hit/star", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "slash/hit/nen", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "slash/sparks", true, true, 5))
end

return Hero20001SkinId20001001EggTranformConfig
