--- hero_30006_skin_id_30006001_environment
--- @class Hero30006SkinId30006001EnvironmentConfig
Hero30006SkinId30006001EnvironmentConfig = Class(Hero30006SkinId30006001EnvironmentConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero30006SkinId30006001EnvironmentConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 4
	--- @type number
	self.delayDespawnOnRelease = -1
	--- @type number
	self.anchor = ClientConfigUtils.HEAD_ANCHOR
	--- @type boolean
	self.isSyncLayerToTarget = false
	--- @type boolean
	self.isChildTarget = false
	--- @type UnityEngine_GameObject
	self.mainVisual = nil

	--- @type number
	self.battleEffectType = ClientConfigUtils.DEFAULT_BATTLE_EFFECT_TYPE

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = nil
end

return Hero30006SkinId30006001EnvironmentConfig
