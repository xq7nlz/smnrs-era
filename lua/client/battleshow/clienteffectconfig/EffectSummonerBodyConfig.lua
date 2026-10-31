--- effect_summoner_body
--- @class EffectSummonerBodyConfig
EffectSummonerBodyConfig = Class(EffectSummonerBodyConfig)

--- @return void
--- @param transform UnityEngine_Transform
function EffectSummonerBodyConfig:Ctor(transform)
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "trail043_R", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "sparks", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "sparks/line", true, true, 1))
end

return EffectSummonerBodyConfig
