--- hero_10005_skin_id_10005002_skill_projectile
--- @class Hero10005SkinId10005002SkillProjectileConfig
Hero10005SkinId10005002SkillProjectileConfig = Class(Hero10005SkinId10005002SkillProjectileConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero10005SkinId10005002SkillProjectileConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = -1
	--- @type number
	self.delayDespawnOnRelease = 0.8
	--- @type number
	self.anchor = ClientConfigUtils.BODY_ANCHOR
	--- @type boolean
	self.isSyncLayerToTarget = true
	--- @type boolean
	self.isChildTarget = true
	--- @type UnityEngine_GameObject
	self.mainVisual = self.transform:Find("baseball").gameObject

	--- @type number
	self.battleEffectType = ClientConfigUtils.DEFAULT_BATTLE_EFFECT_TYPE

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = List()
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "baseball/mesh/black", true, true, 5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "baseball/mesh/yellow", true, true, 5))
end

return Hero10005SkinId10005002SkillProjectileConfig
