--- @class ClientHero20024ActiveSkill : BaseSkillShow
ClientHero20024ActiveSkill = Class(ClientHero20024ActiveSkill, BaseSkillShow)

function ClientHero20024ActiveSkill:DeliverCtor()
    self.targetSkillBone = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/TargetSkill")
end

--- @param actionResults List<BaseActionResult>
function ClientHero20024ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.5, 1.5, 0.4)

end

function ClientHero20024ActiveSkill:OnCastEffect()
    local targetComponents = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1)).components
    local targetPosition = targetComponents:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
    self.clientHero.animation:UpdateLayer(targetComponents:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR).y, 2)
    self.targetSkillBone.position = targetPosition
end

function ClientHero20024ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero20024ActiveSkill:OnEndTurn()
    self.clientHero.animation:UpdateLayer(self.clientHero.originPosition.y, 0)
    BaseSkillShow.OnEndTurn(self)
end

function ClientHero20024ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end