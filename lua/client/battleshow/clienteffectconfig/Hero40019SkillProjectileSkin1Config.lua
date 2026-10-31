--- hero_40019_skill_projectile_skin_1
--- @class Hero40019SkillProjectileSkin1Config
Hero40019SkillProjectileSkin1Config = Class(Hero40019SkillProjectileSkin1Config)

--- @return void
--- @param transform UnityEngine_Transform
function Hero40019SkillProjectileSkin1Config:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = -1
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

return Hero40019SkillProjectileSkin1Config
