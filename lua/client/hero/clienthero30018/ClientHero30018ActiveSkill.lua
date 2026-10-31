--- @class ClientHero30018ActiveSkill : BaseSkillShow
ClientHero30018ActiveSkill = Class(ClientHero30018ActiveSkill, BaseSkillShow)

function ClientHero30018ActiveSkill:DeliverCtor()
    self.targetSkillBone = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/TargetSkill")
end

--- @param actionResults List<BaseActionResult>
function ClientHero30018ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:PutBoneOnPosition()

    self:DoCoverBattle(0.5, 1, 0.3)

end

function ClientHero30018ActiveSkill:OnTriggerActionResult()
    BaseSkillShow.OnTriggerActionResult(self)
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
end

function ClientHero30018ActiveSkill:PutBoneOnPosition()
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    local targetPosition = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR)
    targetPosition.y = targetPosition.y - ClientConfigUtils.OFFSET_ACCOST_Y
    if self.baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
        targetPosition.x = targetPosition.x - ClientConfigUtils.OFFSET_ACCOST_X
    else
        targetPosition.x = targetPosition.x + ClientConfigUtils.OFFSET_ACCOST_X
    end
    self.targetSkillBone.position = targetPosition
    self.clientHero.animation:UpdateLayer(targetPosition.y)
end

function ClientHero30018ActiveSkill:OnEndTurn()
    self.clientHero.animation:UpdateLayer(self.clientHero.originPosition.y)
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end