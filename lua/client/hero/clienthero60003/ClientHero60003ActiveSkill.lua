--- @class ClientHero60003ActiveSkill : BaseSkillShow
ClientHero60003ActiveSkill = Class(ClientHero60003ActiveSkill, BaseSkillShow)

function ClientHero60003ActiveSkill:DeliverCtor()
    self.targetAttackBone = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/target_attack")
    self.effectName = string.format("hero_%d_eff_skill", self.baseHero.id)
end

function ClientHero60003ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(52, function()
        self:Shake()
    end)
    self:AddFrameAction(62, function()
        self:Shake()
    end)
end

function ClientHero60003ActiveSkill:Shake()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
end

--- @param actionResults List<BaseActionResult>
function ClientHero60003ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1, 1, 0.3)

end

function ClientHero60003ActiveSkill:OnTriggerActionResult()
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero60003ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

function ClientHero60003ActiveSkill:OnCastEffect()
    local effect = self:GetSkillEffect()
    effect:SetToHeroAnchor(self.clientHero)
    local target = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    effect.configTable.targetSkill1.position = target.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR)
    if self.listTargetHero:Count() > 1 then
        target = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(2))
    end
    effect.configTable.targetSkill2.position = target.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR)
end

--- @return ClientEffect
function ClientHero60003ActiveSkill:GetSkillEffect()
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