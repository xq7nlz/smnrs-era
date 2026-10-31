--- hero_50007_skin_id_50007001_skill_explosion
--- @class Hero50007SkinId50007001SkillExplosionConfig
Hero50007SkinId50007001SkillExplosionConfig = Class(Hero50007SkinId50007001SkillExplosionConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero50007SkinId50007001SkillExplosionConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 3
	--- @type number
	self.delayDespawnOnRelease = -1
	--- @type number
	self.anchor = ClientConfigUtils.BODY_ANCHOR
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

return Hero50007SkinId50007001SkillExplosionConfig
