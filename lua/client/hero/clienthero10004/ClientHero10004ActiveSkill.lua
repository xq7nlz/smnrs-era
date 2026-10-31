--- @class ClientHero10004ActiveSkill : BaseSkillShow
ClientHero10004ActiveSkill = Class(ClientHero10004ActiveSkill, BaseSkillShow)

function ClientHero10004ActiveSkill:DeliverCtor()
    self.effSkillName = string.format("hero_%d_eff_skill", self.baseHero.id)
end

function ClientHero10004ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(42, function()
        self:CastImpactFromConfig()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero10004ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero10004ActiveSkill:OnCastEffect()
    local opponentTeamId
    if self.baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
        opponentTeamId = BattleConstants.DEFENDER_TEAM_ID
    else
        opponentTeamId = BattleConstants.ATTACKER_TEAM_ID
    end
    local effSkill = self:GetClientEffect(AssetType.HeroBattleEffect, self.effSkillName)
    if effSkill ~= nil then
        effSkill:SetToHeroAnchor(self.clientHero)
        effSkill:SetPosition(PositionConfig.GetCenterTeamPosition(opponentTeamId))
        effSkill:Play()
    end
end

function ClientHero10004ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    self:CastSfxImpactFromConfig()
    self.clientHero:TriggerActionResult()
end