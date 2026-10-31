--- @class ClientHero5ActiveSkill : SummonerSkillShow
ClientHero5ActiveSkill = Class(ClientHero5ActiveSkill, SummonerSkillShow)

function ClientHero5ActiveSkill:DeliverCtor()
    SummonerSkillShow.DeliverCtor(self)
    self.effSkillName = string.format("hero_%d_eff_skill", self.baseHero.id)
end

function ClientHero5ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(75, function()
        self:CastImpactEffect()
    end)
end

function ClientHero5ActiveSkill:DeliverSetFrameActionWithVideo()
    self:AddFrameActionWithVideo(20, function()
        self:ShowCutSceneVideo()
    end)
    self:AddFrameActionWithVideo(150, function()
        self:CastImpactEffect()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero5ActiveSkill:CastOnTarget(actionResults)
    SummonerSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero5ActiveSkill:OnCastEffect()
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

function ClientHero5ActiveSkill:OnTriggerActionResult()
    self.clientHero:TriggerActionResult()
end

function ClientHero5ActiveSkill:DarkScreenWithoutVideo()
    self.clientBattleShowController:DoCoverBattle(2, 0.5, 0.4)
    SummonerSkillShow.DarkScreenWithoutVideo(self)
end

function ClientHero5ActiveSkill:CastImpactEffect()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    self:CastImpactFromConfig()
    self:CastSfxImpactFromConfig()
end