--- hero_50003_skin_id_50003002_skill_impact
--- @class Hero50003SkinId50003002SkillImpactConfig
Hero50003SkinId50003002SkillImpactConfig = Class(Hero50003SkinId50003002SkillImpactConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero50003SkinId50003002SkillImpactConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 6
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
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "transform/shockwave", true, true, 15))
end

return Hero50003SkinId50003002SkillImpactConfig
