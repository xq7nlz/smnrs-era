--- @class ClientHero30007ActiveSkill : BaseSkillShow
ClientHero30007ActiveSkill = Class(ClientHero30007ActiveSkill, BaseSkillShow)

function ClientHero30007ActiveSkill:DeliverCtor()
    self.moveSkillBone = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/move_skill")
    self.breathTime = 1
end

function ClientHero30007ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(20, function()
        self:StartMoveBone()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero30007ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.4, 1.5, 0.4)

    self:SetMoveSkillBonePos()
end

function ClientHero30007ActiveSkill:SetMoveSkillBonePos()
    if self.clientHero.baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
        self.moveSkillBone.position = PositionConfig.GetCenterTeamPosition(BattleConstants.DEFENDER_TEAM_ID)
    else
        self.moveSkillBone.position = PositionConfig.GetCenterTeamPosition(BattleConstants.ATTACKER_TEAM_ID)
    end

    local startMove = self.moveSkillBone.position - U_Vector3.up * 1
    self.moveSkillBone.position = startMove
end

function ClientHero30007ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero30007ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

function ClientHero30007ActiveSkill:StartMoveBone()
    local endMove = self.moveSkillBone.position + U_Vector3.up * 7
    DOTweenUtils.DOMove(self.moveSkillBone, endMove, self.breathTime, U_Ease.Linear)
end