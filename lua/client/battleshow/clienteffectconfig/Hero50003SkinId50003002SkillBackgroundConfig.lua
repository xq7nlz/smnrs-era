--- hero_50003_skin_id_50003002_skill_background
--- @class Hero50003SkinId50003002SkillBackgroundConfig
Hero50003SkinId50003002SkillBackgroundConfig = Class(Hero50003SkinId50003002SkillBackgroundConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero50003SkinId50003002SkillBackgroundConfig:Ctor(transform)
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
end

return Hero50003SkinId50003002SkillBackgroundConfig
