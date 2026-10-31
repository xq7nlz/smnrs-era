--- @class ClientHero50025ActiveSkill : BaseSkillShow
ClientHero50025ActiveSkill = Class(ClientHero50025ActiveSkill, BaseSkillShow)

--- @param actionResults List<BaseActionResult>
function ClientHero50025ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.4, 0.8, 0.3)

end

function ClientHero50025ActiveSkill:OnCastEffect()

end

function ClientHero50025ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero50025ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end