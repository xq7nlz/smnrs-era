--- hero_60008_skin_id_60008002_attack_impact
--- @class Hero60008SkinId60008002AttackImpactConfig
Hero60008SkinId60008002AttackImpactConfig = Class(Hero60008SkinId60008002AttackImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero60008SkinId60008002AttackImpactConfig:Ctor(transform)
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl/glow1/smoke_mist", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl/dust_stone", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "ctrl/smoke", true, true, 4))
end

return Hero60008SkinId60008002AttackImpactConfig
