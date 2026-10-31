--- @class ClientHero40008ActiveSkill : BaseSkillShow
ClientHero40008ActiveSkill = Class(ClientHero40008ActiveSkill, BaseSkillShow)

--- @param actionResults List<BaseActionResult>
function ClientHero40008ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1, 1, 0.3)

end

function ClientHero40008ActiveSkill:OnCastEffect()
    self:CastImpactFromConfig()
end

function ClientHero40008ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)

    self:CastSfxImpactFromConfig()
    self.clientHero:TriggerActionResult()
end

function ClientHero40008ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end