--- @class ClientHero60016ActiveSkill : BaseSkillShow
ClientHero60016ActiveSkill = Class(ClientHero60016ActiveSkill, BaseSkillShow)

function ClientHero60016ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position_2").position
    self.projectileName = string.format("hero_%d_projectile", self.baseHero.id)
end

--- @param actionResults List<BaseActionResult>
function ClientHero60016ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero60016ActiveSkill:OnCastEffect()
    local clientTargetHero
    local effect

    for i = 1, self.listTargetHero:Count() do
        clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
        effect = self:GetEffect(AssetType.HeroBattleEffect, self.projectileName)
        effect.configTable.lightningStart.position = self.projectileLaunchPos
        effect.configTable.lightningEnd.position = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
    end
end

function ClientHero60016ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

--- @return ClientEffect
--- @param effectType string
--- @param effectName string
function ClientHero60016ActiveSkill:GetEffect(effectType, effectName)
    local effect = zg.battleEffectMgr:GetClientEffect(effectType, effectName)
    if effect ~= nil then
        if effect.isInited == false or effect.configTable.lightningStart == nil then
            local luaConfigFile = ResourceMgr.GetEffectLuaConfig(effectName)
            effect:InitRef(effectType, effectName, GeneralEffectPoolType.ClientEffect, luaConfigFile)

            effect.configTable.lightningStart = effect:FindChildByPath("lightning_start")
            effect.configTable.lightningEnd = effect:FindChildByPath("lightning_end")
            effect.isInited = true
        end
        effect:Play()
        return effect
    end
    return nil
end