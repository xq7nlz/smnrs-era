--- @class ClientHero10007001ActiveSkill : BaseSkillShow
ClientHero10007001ActiveSkill = Class(ClientHero10007001ActiveSkill, BaseSkillShow)

function ClientHero10007001ActiveSkill:DeliverCtor()
    self.fxImpactName = "hero_10007_skin_id_10007001_skill_impact"
    self.effectName2 = "hero_10007_skin_id_10007001_skill_impact"
end

--- @param actionResults List<BaseActionResult>
function ClientHero10007001ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.4, 0.7, 0.7)
end

function ClientHero10007001ActiveSkill:OnCastEffect()
    self:CastNewClientImpactOnTargets(AssetType.HeroBattleEffect, self.effectName2)
end

function ClientHero10007001ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

function ClientHero10007001ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end