--- hero_60003_skin_id_60003002_environment
--- @class Hero60003SkinId60003002EnvironmentConfig
Hero60003SkinId60003002EnvironmentConfig = Class(Hero60003SkinId60003002EnvironmentConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero60003SkinId60003002EnvironmentConfig:Ctor(transform)
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

return Hero60003SkinId60003002EnvironmentConfig
