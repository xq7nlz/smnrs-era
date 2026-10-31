--- @class ClientHero30006ActiveSkill : BaseSkillShow
ClientHero30006ActiveSkill = Class(ClientHero30006ActiveSkill, BaseSkillShow)

--- @param actionResults List<BaseActionResult>
function ClientHero30006ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1.3, 1, 0.5)

end

function ClientHero30006ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero30006ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end