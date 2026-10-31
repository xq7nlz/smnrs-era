--- @class ClientHero50001ActiveSkill : BaseSkillShow
ClientHero50001ActiveSkill = Class(ClientHero50001ActiveSkill, BaseSkillShow)

--- @param actionResults List<BaseActionResult>
function ClientHero50001ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.8, 1, 0.3)

    self:CastImpactFromConfig()
end

function ClientHero50001ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)

    self:CastSfxImpactFromConfig()
    self.clientHero:TriggerActionResult()
end

function ClientHero50001ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

function ClientHero50001ActiveSkill:OnCastEffect()

end