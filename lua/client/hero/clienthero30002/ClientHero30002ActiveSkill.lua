--- @class ClientHero30002ActiveSkill : BaseSkillShow
ClientHero30002ActiveSkill = Class(ClientHero30002ActiveSkill, BaseSkillShow)

--- @param actionResults List<BaseActionResult>
function ClientHero30002ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1, 1, 0.4)

end

function ClientHero30002ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

function ClientHero30002ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end