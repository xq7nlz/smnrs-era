--- hero_50015_active_effect
--- @class Hero50015ActiveEffectConfig
Hero50015ActiveEffectConfig = Class(Hero50015ActiveEffectConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero50015ActiveEffectConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 2.567
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
	self.battleEffectType = ClientConfigUtils.SPINE_BATTLE_EFFECT_TYPE
	self.skeletonAnimation = self.transform:Find("model"):GetComponent(ComponentName.Spine_Unity_SkeletonAnimation)
	self.defaultSpineAnim = "fx_skill"

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = List()
	self.listEffectVisual:Add(SpineEffectVisual(self.transform, "model", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "model/wind_ground", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "model/wind_ground/shadow", true, true, -8))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "model/wind_ground/circle549/light85", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "model/wind_ground/light85", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "model/wind_ground/light85/glow_foot", true, true, -5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "model/wind_ground/glow_ground", true, true, -5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "model/wind_ground/force1", true, true, -3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "model/wind_ground/xich", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "model/wind_ground/xich/xich1", true, true, 0))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "model/wind_ground/xich/xich2", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "model/wind_ground/force2", true, true, -3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "model/wind_ground/flare106", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "model/wind_ground/flare106/flare", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "model/wind_ground/flare106/glow_body", true, true, 1))
end

return Hero50015ActiveEffectConfig
