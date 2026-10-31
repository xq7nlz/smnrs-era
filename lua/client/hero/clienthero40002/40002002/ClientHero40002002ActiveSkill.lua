--- @class ClientHero40002002ActiveSkill : ClientHero40002ActiveSkill
ClientHero40002002ActiveSkill = Class(ClientHero40002002ActiveSkill, ClientHero40002ActiveSkill)

function ClientHero40002002ActiveSkill:DeliverCtor()
    self.effSkill = self.clientHero:GetEffectNameByFormat("hero_%s_%s_eff_skill")
end

--- @param actionResults List<BaseActionResult>
function ClientHero40002002ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1, 1.5, 0.6)

end

function ClientHero40002002ActiveSkill:OnCastEffect()
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

function ClientHero40002002ActiveSkill:OnTriggerActionResult()
    BaseSkillShow.OnTriggerActionResult(self)
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
end

function ClientHero40002002ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end