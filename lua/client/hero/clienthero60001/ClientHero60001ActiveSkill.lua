--- @class ClientHero60001ActiveSkill : BaseSkillShow
ClientHero60001ActiveSkill = Class(ClientHero60001ActiveSkill, BaseSkillShow)

function ClientHero60001ActiveSkill:DeliverCtor()
    self.moveSkill = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/move_skill")
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/bone_hand_laught/launch_position_skill")
    self.groundFxName = string.format("hero_%d_skill_hole", self.clientHero.baseHero.id)
end

--- @param actionResults List<BaseActionResult>
function ClientHero60001ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.5, 1, 0.3)

end

function ClientHero60001ActiveSkill:OnCastEffect()
    if self.baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
        self.moveSkill.position = PositionConfig.GetCenterTeamPosition(BattleConstants.DEFENDER_TEAM_ID)
    else
        self.moveSkill.position = PositionConfig.GetCenterTeamPosition(BattleConstants.ATTACKER_TEAM_ID)
    end
    self.moveSkill.position = self.moveSkill.position + U_Vector3.down
    local projectile = self:GetClientEffect(AssetType.HeroBattleEffect, self.projectileName)
    projectile:SetPosition(self.projectileLaunchPos.position)
    projectile:LookAtPosition(self.moveSkill.position)
    projectile:DoMoveTween(self.moveSkill.position, 5 / ClientConfigUtils.FPS, function()
        projectile:Release()
        local fxGround = self:GetClientEffect(AssetType.HeroBattleEffect, self.groundFxName)
        fxGround:SetPosition(self.moveSkill.position)
        fxGround:Play()
    end)
    projectile:Play()
end



function ClientHero60001ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero60001ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end