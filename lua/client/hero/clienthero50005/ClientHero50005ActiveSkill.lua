--- @class ClientHero50005ActiveSkill : BaseSkillShow
ClientHero50005ActiveSkill = Class(ClientHero50005ActiveSkill, BaseSkillShow)

function ClientHero50005ActiveSkill:DeliverCtor()
    self.effectName = string.format("hero_%d_skill_impact", self.baseHero.id)
end

--- @param actionResults List<BaseActionResult>
function ClientHero50005ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.7, 0.7, 0.5)

end

function ClientHero50005ActiveSkill:OnCastEffect()
    self:CastNewClientImpactOnTargets(AssetType.HeroBattleEffect, self.effectName)
end

function ClientHero50005ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero50005ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end