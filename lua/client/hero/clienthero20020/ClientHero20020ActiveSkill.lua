--- @class ClientHero20020ActiveSkill : BaseSkillShow
ClientHero20020ActiveSkill = Class(ClientHero20020ActiveSkill, BaseSkillShow)

function ClientHero20020ActiveSkill:DeliverCtor()
    self.launchPosition = self.clientHero.components:FindChildByPath("Model/launch_position").position
    self.effectName = string.format("hero_%d_eff_skill", self.baseHero.id)
end

--- @param actionResults List<BaseActionResult>
function ClientHero20020ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
    self:DoCoverBattle(0.4, 1, 0.4)

end

function ClientHero20020ActiveSkill:OnCastEffect()
    local effect = self:GetEffect(AssetType.HeroBattleEffect, self.effectName)
    if effect ~= nil then
        local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
        local targetPosition = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
        effect.configTable.mainEffFire.position = self.launchPosition
        effect.configTable.targetFire.position = targetPosition
    end
end

function ClientHero20020ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero20020ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

--- @return ClientEffect
--- @param effectType string
--- @param effectName string
function ClientHero20020ActiveSkill:GetEffect(effectType, effectName)
    local effect = zg.battleEffectMgr:GetClientEffect(effectType, effectName)
    if effect ~= nil then
        if effect.isInited == false or effect.configTable.mainEffFire == nil then
            local luaConfigFile = ResourceMgr.GetEffectLuaConfig(effectName)
            effect:InitRef(effectType, effectName, GeneralEffectPoolType.ClientEffect, luaConfigFile)
            effect.configTable.mainEffFire = effect:FindChildByPath("Model/SkeletonUtility-Root/root/main_eff_fire_1")
            effect.configTable.targetFire = effect:FindChildByPath("Model/SkeletonUtility-Root/root/target_fire")
            effect.isInited = true
        end
        effect:Play()
        return effect
    end
    return nil
end