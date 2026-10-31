--- @class ClientHero40002ActiveSkill : BaseSkillShow
ClientHero40002ActiveSkill = Class(ClientHero40002ActiveSkill, BaseSkillShow)

function ClientHero40002ActiveSkill:DeliverCtor()
    self.effSkill = string.format("hero_%d_eff_skill", self.baseHero.id)
end

--- @param actionResults List<BaseActionResult>
function ClientHero40002ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1, 1.5, 0.6)

end

function ClientHero40002ActiveSkill:OnCastEffect()
    local opponentTeamId
    if self.baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
        opponentTeamId = BattleConstants.DEFENDER_TEAM_ID
    else
        opponentTeamId = BattleConstants.ATTACKER_TEAM_ID
    end
    local effSkill = self:GetClientEffect(AssetType.HeroBattleEffect, self.effSkill)
    if effSkill ~= nil then
        effSkill:SetPosition(PositionConfig.GetCenterTeamPosition(opponentTeamId))
        effSkill:Play()
    end
end

function ClientHero40002ActiveSkill:OnTriggerActionResult()
    BaseSkillShow.OnTriggerActionResult(self)
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
end

function ClientHero40002ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end