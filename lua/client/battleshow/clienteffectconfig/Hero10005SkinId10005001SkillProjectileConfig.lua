--- hero_10005_skin_id_10005001_skill_projectile
--- @class Hero10005SkinId10005001SkillProjectileConfig
Hero10005SkinId10005001SkillProjectileConfig = Class(Hero10005SkinId10005001SkillProjectileConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero10005SkinId10005001SkillProjectileConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = -1
	--- @type number
	self.delayDespawnOnRelease = 0.8
	--- @type number
	self.anchor = ClientConfigUtils.FOOT_ANCHOR
	--- @type boolean
	self.isSyncLayerToTarget = true
	--- @type boolean
	self.isChildTarget = true
	--- @type UnityEngine_GameObject
	self.mainVisual = self.transform:Find("projectile").gameObject

	--- @type number
	self.battleEffectType = ClientConfigUtils.DEFAULT_BATTLE_EFFECT_TYPE

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = List()
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "stone", true, true, -1))
end

return Hero10005SkinId10005001SkillProjectileConfig
