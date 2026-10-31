--- hero_40027_skill_egg_energy
--- @class Hero40027SkillEggEnergyConfig
Hero40027SkillEggEnergyConfig = Class(Hero40027SkillEggEnergyConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero40027SkillEggEnergyConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 1.5
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

return Hero40027SkillEggEnergyConfig
