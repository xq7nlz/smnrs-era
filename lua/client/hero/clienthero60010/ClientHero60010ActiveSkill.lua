--- @class ClientHero60010ActiveSkill : BaseSkillShow
ClientHero60010ActiveSkill = Class(ClientHero60010ActiveSkill, BaseSkillShow)

--- @param actionResults List<BaseActionResult>
function ClientHero60010ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1.2, 1, 0.3)

end

function ClientHero60010ActiveSkill:OnCastEffect()
    self:CastImpactFromConfig()
end

function ClientHero60010ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    self:CastSfxImpactFromConfig()
    self.clientHero:TriggerActionResult()
end

function ClientHero60010ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end