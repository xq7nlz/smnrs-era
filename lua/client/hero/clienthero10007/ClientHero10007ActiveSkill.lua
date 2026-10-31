--- @class ClientHero10007ActiveSkill : BaseSkillShow
ClientHero10007ActiveSkill = Class(ClientHero10007ActiveSkill, BaseSkillShow)

function ClientHero10007ActiveSkill:DeliverCtor()
    self.effectName2 = string.format("hero_%d_skill_impact", self.baseHero.id)
end

--- @param actionResults List<BaseActionResult>
function ClientHero10007ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.4, 0.7, 0.7)
end

function ClientHero10007ActiveSkill:OnCastEffect()
    self:CastNewClientImpactOnTargets(AssetType.HeroBattleEffect, self.effectName2)
end

function ClientHero10007ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

function ClientHero10007ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end