--- hero_50018_skill_projectile
--- @class Hero50018SkillProjectileConfig
Hero50018SkillProjectileConfig = Class(Hero50018SkillProjectileConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero50018SkillProjectileConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = -1
	--- @type number
	self.delayDespawnOnRelease = 0.5
	--- @type number
	self.anchor = ClientConfigUtils.BODY_ANCHOR
	--- @type boolean
	self.isSyncLayerToTarget = false
	--- @type boolean
	self.isChildTarget = false
	--- @type UnityEngine_GameObject
	self.mainVisual = self.transform:Find("butter").gameObject

	--- @type number
	self.battleEffectType = ClientConfigUtils.DEFAULT_BATTLE_EFFECT_TYPE

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = nil
end

return Hero50018SkillProjectileConfig
