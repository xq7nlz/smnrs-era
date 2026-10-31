--- @class ClientHero50011ActiveSkill : BaseSkillShow
ClientHero50011ActiveSkill = Class(ClientHero50011ActiveSkill, BaseSkillShow)

function ClientHero50011ActiveSkill:DeliverCtor()
    self.effectName = self.clientHero:GetEffectNameByFormat("hero_%s_skill_exploision")
end

--- @param actionResults List<BaseActionResult>
function ClientHero50011ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1.5, 0.9, 0.3, ClientConfigUtils.DEFAULT_COVER_ALPHA)

end

function ClientHero50011ActiveSkill:OnCastEffect()
    local effect = self:GetClientEffect(AssetType.HeroBattleEffect, self.effectName)
    effect:SetPosition(PositionConfig.GetOpponentCenterTeamPosition(self.baseHero.teamId))
    effect:Play()
end

function ClientHero50011ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero50011ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end