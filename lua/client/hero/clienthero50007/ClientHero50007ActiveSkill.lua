--- @class ClientHero50007ActiveSkill : BaseSkillShow
ClientHero50007ActiveSkill = Class(ClientHero50007ActiveSkill, BaseSkillShow)

function ClientHero50007ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
    self.effSkillName = self.clientHero:GetEffectNameByFormat("hero_%s_skill_explosion")
end

--- @param actionResults List<BaseActionResult>
function ClientHero50007ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.5, 0.5, 0.3)

end

--function ClientHero50007ActiveSkill:OnCastEffect()
--    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName,
--            ClientConfigUtils.PROJECTILE_FRY_TIME, ClientConfigUtils.FOOT_ANCHOR)
--end

function ClientHero50007ActiveSkill:OnCastEffect()
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


function ClientHero50007ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero50007ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end