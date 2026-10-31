--- @class ClientHero10004003ActiveSkill : ClientHero10004ActiveSkill
ClientHero10004003ActiveSkill = Class(ClientHero10004003ActiveSkill, ClientHero10004ActiveSkill)

function ClientHero10004003ActiveSkill:DeliverCtor()
    self.effSkillName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_eff_skill")
end

function ClientHero10004003ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(55, function()
        self:CastNewClientImpactOnTargets(AssetType.HeroBattleEffect, "hero_10004_skin_id_10004003_skill_impact")
    end)
end

function ClientHero10004003ActiveSkill:OnCastEffect()
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

    self:SetEnvironment()
end

function ClientHero10004003ActiveSkill:SetEnvironment()
    local effectName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_environment")
    local effect = self:GetClientEffect(AssetType.HeroBattleEffect, effectName)
    effect:SetPosition(PositionConfig.GetBattleCentralPosition())
    effect:Play()
end

