--- battle_spawn_hero
--- @class BattleSpawnHeroConfig
BattleSpawnHeroConfig = Class(BattleSpawnHeroConfig)

--- @return void
--- @param transform UnityEngine_Transform
function BattleSpawnHeroConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 1.5
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "collum_ground/sparks", false, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "collum_ground/line_spawn", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "collum_ground/decal/glow", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "collum_ground/decal/beam", true, true, -1))
end

return BattleSpawnHeroConfig
