--- hero_60010_skin_id_60010002_skill_impact
--- @class Hero60010SkinId60010002SkillImpactConfig
Hero60010SkinId60010002SkillImpactConfig = Class(Hero60010SkinId60010002SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero60010SkinId60010002SkillImpactConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 6
	--- @type number
	self.delayDespawnOnRelease = -1
	--- @type number
	self.anchor = ClientConfigUtils.HEAD_ANCHOR
	--- @type boolean
	self.isSyncLayerToTarget = false
	--- @type boolean
	self.isChildTarget = true
	--- @type UnityEngine_GameObject
	self.mainVisual = nil

	--- @type number
	self.battleEffectType = ClientConfigUtils.DEFAULT_BATTLE_EFFECT_TYPE

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = nil
end

return Hero60010SkinId60010002SkillImpactConfig
