--- @class ClientHero40023ActiveSkill : BaseSkillShow
ClientHero40023ActiveSkill = Class(ClientHero40023ActiveSkill, BaseSkillShow)

function ClientHero40023ActiveSkill:DeliverCtor()
    self.moveBone = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/move")
    self.moveTweener = nil
    self.effectName = string.format("hero_%d_skill_impact", self.baseHero.id)
end

function ClientHero40023ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(5, function()
        self:StartAccost()
    end)
    self:AddFrameAction(37, function()
        self:StartBackward()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero40023ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.4, 0.4, 0.2)

end

function ClientHero40023ActiveSkill:StartAccost()
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    local targetPosition = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR)
    if self.baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
        targetPosition.x = targetPosition.x - 1.5
    else
        targetPosition.x = targetPosition.x + 1.5
    end
    self.moveTweener = self.moveBone:DOMove(targetPosition, 18.0 / ClientConfigUtils.FPS)--:SetEase(self.ease.Linear)
end

function ClientHero40023ActiveSkill:StartBackward()
    self.moveTweener = self.moveBone:DOMove(self.clientHero.originPosition, 3.0 / ClientConfigUtils.FPS)
end

function ClientHero40023ActiveSkill:OnTriggerActionResult()
    BaseSkillShow.OnTriggerActionResult(self)
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
end

function ClientHero40023ActiveSkill:OnCastEffect()
    self:CastNewClientImpactOnTargets(AssetType.HeroBattleEffect, self.effectName)
end

function ClientHero40023ActiveSkill:OnCompleteActionTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnCompleteActionTurn(self)
end

function ClientHero40023ActiveSkill:ResetMoveBone()
    self.moveBone.localPosition = U_Vector3.zero
end

function ClientHero40023ActiveSkill:BreakSkillAction()
    BaseSkillShow.BreakSkillAction(self)
    ClientConfigUtils.KillTweener(self.moveTweener)
    self:ResetMoveBone()
end