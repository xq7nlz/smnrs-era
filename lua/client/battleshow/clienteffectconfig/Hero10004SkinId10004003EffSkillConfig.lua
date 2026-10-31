--- hero_10004_skin_id_10004003_eff_skill
--- @class Hero10004SkinId10004003EffSkillConfig
Hero10004SkinId10004003EffSkillConfig = Class(Hero10004SkinId10004003EffSkillConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero10004SkinId10004003EffSkillConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 4
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

return Hero10004SkinId10004003EffSkillConfig
