--- hero_50006_skin_id_50006002_environment
--- @class Hero50006SkinId50006002EnvironmentConfig
Hero50006SkinId50006002EnvironmentConfig = Class(Hero50006SkinId50006002EnvironmentConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero50006SkinId50006002EnvironmentConfig:Ctor(transform)
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
	self.isSyncLayerToTarget = true
	--- @type boolean
	self.isChildTarget = true
	--- @type UnityEngine_GameObject
	self.mainVisual = nil

	--- @type number
	self.battleEffectType = ClientConfigUtils.DEFAULT_BATTLE_EFFECT_TYPE

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = List()
end

return Hero50006SkinId50006002EnvironmentConfig
