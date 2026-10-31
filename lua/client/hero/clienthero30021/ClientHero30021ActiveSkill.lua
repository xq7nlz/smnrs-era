--- @class ClientHero30021ActiveSkill : BaseSkillShow
ClientHero30021ActiveSkill = Class(ClientHero30021ActiveSkill, BaseSkillShow)

--- @param actionResults List<BaseActionResult>
function ClientHero30021ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1, 0.5, 0.3)

end

function ClientHero30021ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero30021ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end