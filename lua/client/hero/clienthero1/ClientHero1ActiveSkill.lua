--- @class ClientHero1ActiveSkill : SummonerSkillShow
ClientHero1ActiveSkill = Class(ClientHero1ActiveSkill, SummonerSkillShow)

function ClientHero1ActiveSkill:DeliverSetFrameActionWithVideo()
    self:AddFrameActionWithVideo(16, function()
        self:ShowCutSceneVideo()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero1ActiveSkill:CastOnTarget(actionResults)
    SummonerSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero1ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    self:CastSfxImpactFromConfig()
    self.clientHero:TriggerActionResult()
end

function ClientHero1ActiveSkill:OnCastEffect()
    local opponentTeamId
    if self.baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
        opponentTeamId = BattleConstants.DEFENDER_TEAM_ID
    else
        opponentTeamId = BattleConstants.ATTACKER_TEAM_ID
    end
    --- @type ClientEffect
    local fxImpact = self:GetClientEffect(self.fxImpactConfig.skill_impact_type, self.fxImpactConfig.skill_impact_name)
    if fxImpact ~= nil then
        fxImpact:SetPosition(PositionConfig.GetCenterTeamPosition(opponentTeamId))
        fxImpact:Play()
    end
end

function ClientHero1ActiveSkill:DarkScreenWithoutVideo()
    self.clientBattleShowController:DoCoverBattle(1.9, 0.5, 0.4)
    SummonerSkillShow.DarkScreenWithoutVideo(self)
end