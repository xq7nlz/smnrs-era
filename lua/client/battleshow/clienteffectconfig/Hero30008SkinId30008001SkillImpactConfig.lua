--- hero_30008_skin_id_30008001_skill_impact
--- @class Hero30008SkinId30008001SkillImpactConfig
Hero30008SkinId30008001SkillImpactConfig = Class(Hero30008SkinId30008001SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero30008SkinId30008001SkillImpactConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 3
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
end

return Hero30008SkinId30008001SkillImpactConfig
