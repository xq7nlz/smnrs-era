--- hero_40027_skin_id_40027001_skill_start
--- @class Hero40027SkinId40027001SkillStartConfig
Hero40027SkinId40027001SkillStartConfig = Class(Hero40027SkinId40027001SkillStartConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero40027SkinId40027001SkillStartConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 2
	--- @type number
	self.delayDespawnOnRelease = -1
	--- @type number
	self.anchor = ClientConfigUtils.FOOT_ANCHOR
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

return Hero40027SkinId40027001SkillStartConfig
