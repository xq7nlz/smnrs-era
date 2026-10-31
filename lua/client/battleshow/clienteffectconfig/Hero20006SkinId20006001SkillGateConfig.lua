--- hero_20006_skin_id_20006001_skill_gate
--- @class Hero20006SkinId20006001SkillGateConfig
Hero20006SkinId20006001SkillGateConfig = Class(Hero20006SkinId20006001SkillGateConfig)

--- @return void
--- @param transform UnityEngine_Transform
function Hero20006SkinId20006001SkillGateConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform
	--- @type number
	self.timeLife = 3.333
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
	self.battleEffectType = ClientConfigUtils.SPINE_BATTLE_EFFECT_TYPE
	self.skeletonAnimation = self.transform:Find("Gate"):GetComponent(ComponentName.Spine_Unity_SkeletonAnimation)
	self.defaultSpineAnim = "start"

	--- @type List<ClientEffectVisual>
	self.listEffectVisual = List()
	self.listEffectVisual:Add(SpineEffectVisual(self.transform, "Gate", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Gate/fx_gate_ctrl", true, true, 1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Gate/fx_gate_ctrl/thunder_circle_after/glow_ab", true, true, -10))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Gate/fx_gate_ctrl/thunder_circle_after/thunder", true, true, -3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Gate/fx_gate_ctrl/thunder_circle_after/spark", true, true, -2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Gate/fx_gate_ctrl/thunder_circle_after/glow_blink", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Gate/fx_gate_ctrl/ctrl/circle_around", true, true, -6))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Gate/fx_gate_ctrl/ctrl/wirls", true, true, -5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Gate/fx_gate_ctrl/ctrl/wirls/wirls2", true, true, -5))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Gate/fx_gate_ctrl/ctrl/thunder", true, true, -3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Gate/fx_gate_ctrl/ctrl/smoke_big", true, true, -9))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Gate/fx_gate_ctrl/ctrl/glow_centre", true, true, -3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Gate/fx_gate_ctrl/ctrl/glow_add", true, true, -2))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Gate/fx_gate_ctrl/ctrl/glow_ab", true, true, -8))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Gate/fx_gate_ctrl/ctrl/dust", true, true, -4))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Gate/fx_gate_ctrl/ctrl/spark", true, true, -3))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Gate/fx_gate_ctrl/ctrl/flash_big", true, true, 0))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Gate/fx_gate_ctrl/ctrl/ray", true, true, -1))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Gate/fx_gate_ctrl/ctrl/thunder_energy_outside", true, true, -7))
	self.listEffectVisual:Add(ParticleEffectVisual(self.transform, "Gate/fx_gate_ctrl/ctrl/glow_ab", true, true, -8))
end

return Hero20006SkinId20006001SkillGateConfig
