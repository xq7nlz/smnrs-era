--- @class ClientHero60026ActiveSkill : BaseSkillShow
ClientHero60026ActiveSkill = Class(ClientHero60026ActiveSkill, BaseSkillShow)

function ClientHero60026ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position_skill").position
    self.projectileName = string.format("hero_%d_%s", self.baseHero.id, ClientConfigUtils.DEFAULT_SKILL_PROJECTILE)
    self.effectName = string.format("hero_%d_skill_fx", self.baseHero.id)
end

--- @param actionResults List<BaseActionResult>
function ClientHero60026ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.7, 0.9, 0.3)

end

function ClientHero60026ActiveSkill:OnCastEffect()
    local clientEffect = self:GetClientEffect(AssetType.HeroBattleEffect, self.effectName)
    local position = PositionConfig.GetOpponentCenterTeamPosition(self.baseHero.teamId)
    clientEffect:SetPosition(position)
    clientEffect:Play()
end

function ClientHero60026ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero60026ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end