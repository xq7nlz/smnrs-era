--- @class ClientHero50003001ActiveSkill : BaseSkillShow
ClientHero50003001ActiveSkill = Class(ClientHero50003001ActiveSkill, BaseSkillShow)

--- @param actionResults List<BaseActionResult>
function ClientHero50003001ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1, 1, 0.3)


    self:CastImpactFromConfig()
end

function ClientHero50003001ActiveSkill:OnCastEffect()

end

function ClientHero50003001ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    self.clientHero:TriggerActionResult()
    self:CastSfxImpactFromConfig()
end

function ClientHero50003001ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end