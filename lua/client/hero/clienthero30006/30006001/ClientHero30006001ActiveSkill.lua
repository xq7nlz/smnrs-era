--- @class ClientHero30006001ActiveSkill : BaseSkillShow
ClientHero30006001ActiveSkill = Class(ClientHero30006001ActiveSkill, BaseSkillShow)

--- @param actionResults List -- <BaseActionResult>
function ClientHero30006001ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1.3, 1, 0.5)

end

function ClientHero30006001ActiveSkill:OnCastEffect()
    local effectName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_environment")
    local effect = self:GetClientEffect(AssetType.HeroBattleEffect, effectName)
    effect:SetPosition(PositionConfig.GetBattleCentralPosition())
    effect:Play()

    self:CastImpactFromConfig()
end

function ClientHero30006001ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    self:CastSfxImpactFromConfig()
    self.clientHero:TriggerActionResult()
end

function ClientHero30006001ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end