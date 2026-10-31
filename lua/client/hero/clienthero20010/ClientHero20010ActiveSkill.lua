--- @class ClientHero20010ActiveSkill : BaseSkillShow
ClientHero20010ActiveSkill = Class(ClientHero20010ActiveSkill, BaseSkillShow)

function ClientHero20010ActiveSkill:DeliverCtor()
    self.posAnchor = self.clientHero.components:FindChildByPath("Model/pos")
end

--- @param actionResults List<BaseActionResult>
function ClientHero20010ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.5, 1, 0.3)

end

function ClientHero20010ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero20010ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end