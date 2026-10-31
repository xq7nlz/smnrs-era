--- @class ClientHero40026ActiveSkill : BaseSkillShow
ClientHero40026ActiveSkill = Class(ClientHero40026ActiveSkill, BaseSkillShow)

function ClientHero40026ActiveSkill:DeliverCtor()
    self.moveSkillBone = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/move_skill")
    self:SetSkillBonePosition()
    self.fxImpactName = string.format("hero_%d_skill_impact", self.baseHero.id)
end

--- @param actionResults List<BaseActionResult>
function ClientHero40026ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1, 1, 0.3)

end

function ClientHero40026ActiveSkill:SetSkillBonePosition()
    local opponentTeamId = BattleConstants.ATTACKER_TEAM_ID
    if self.baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
        opponentTeamId = BattleConstants.DEFENDER_TEAM_ID
    end
    self.moveSkillBone.position = PositionConfig.GetCenterTeamPosition(opponentTeamId)
    if opponentTeamId == BattleConstants.ATTACKER_TEAM_ID then
        self.moveSkillBone.position = self.moveSkillBone.position + U_Vector3.right
    else
        self.moveSkillBone.position = self.moveSkillBone.position + U_Vector3.left
    end
    self.moveSkillBone.position = self.moveSkillBone.position + U_Vector3.down * 2
end

function ClientHero40026ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    self:CastImpactOnSkillBone()
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero40026ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

function ClientHero40026ActiveSkill:CastImpactOnSkillBone()
    local effect = self:GetClientEffect(AssetType.HeroBattleEffect, self.fxImpactName)
    effect:SetPosition(self.moveSkillBone.position)
    effect:Play()
end