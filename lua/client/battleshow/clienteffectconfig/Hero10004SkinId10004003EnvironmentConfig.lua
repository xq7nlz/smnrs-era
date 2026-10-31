--- hero_10004_skin_id_10004003_environment
--- @class Hero10004SkinId10004003EnvironmentConfig
Hero10004SkinId10004003EnvironmentConfig = Class(Hero10004SkinId10004003EnvironmentConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero10004SkinId10004003EnvironmentConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 2
	--- @type number
	self.delayDespawnOnRelease = -1
	--- @type number
	self.anchor = ClientConfigUtils.BODY_ANCHOR
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
end

return Hero10004SkinId10004003EnvironmentConfig
