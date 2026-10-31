--- @class ClientHero60003002ActiveSkill : BaseSkillShow
ClientHero60003002ActiveSkill = Class(ClientHero60003002ActiveSkill, BaseSkillShow)

function ClientHero60003002ActiveSkill:DeliverCtor()
    self.targetAttackBone = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/target_attack")
    self.effectName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_eff_skill")
end

function ClientHero60003002ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(52, function()
        self:Shake()
    end)
    self:AddFrameAction(67, function()
        self:Shake()
    end)
end

function ClientHero60003002ActiveSkill:Shake()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
end

--- @param actionResults List<BaseActionResult>
function ClientHero60003002ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1, 1, 0.3)
end

function ClientHero60003002ActiveSkill:OnTriggerActionResult()
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero60003002ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

function ClientHero60003002ActiveSkill:OnCastEffect()
    local effect = self:GetSkillEffect()
    effect:SetToHeroAnchor(self.clientHero)
    local target = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    effect.configTable.targetSkill1.position = target.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR)
    if self.listTargetHero:Count() > 1 then
        target = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(2))
    end
    effect.configTable.targetSkill2.position = target.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR)

    self:SetEnvironment()
end

--- @return ClientEffect
function ClientHero60003002ActiveSkill:GetSkillEffect()
    local effect = self:GetClientEffect(AssetType.HeroBattleEffect, self.effectName)
    if effect == nil then
        return nil
    end
    if effect.configTable.targetSkill1 == nil
            or effect.configTable.targetSkill2 == nil then
        local targetSkill1 = effect.config.transform:Find("view/SkeletonUtility-Root/root/target_skill_1")
        effect:AddConfigField("targetSkill1", targetSkill1)
        local targetSkill2 = effect.config.transform:Find("view/SkeletonUtility-Root/root/target_skill_2")
        effect:AddConfigField("targetSkill2", targetSkill2)
    end
    return effect
end

function ClientHero60003002ActiveSkill:SetEnvironment()
    local effectName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_environment")
    local effect = self:GetClientEffect(AssetType.HeroBattleEffect, effectName)
    effect:SetPosition(PositionConfig.GetBattleCentralPosition())
    effect:Play()
end