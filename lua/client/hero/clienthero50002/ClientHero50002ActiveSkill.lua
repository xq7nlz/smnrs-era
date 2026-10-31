--- @class ClientHero50002ActiveSkill : BaseSkillShow
ClientHero50002ActiveSkill = Class(ClientHero50002ActiveSkill, BaseSkillShow)

--- @param actionResults List<BaseActionResult>
function ClientHero50002ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1.5, 1, 1)

end

function ClientHero50002ActiveSkill:OnCastEffect()
end

function ClientHero50002ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero50002ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end