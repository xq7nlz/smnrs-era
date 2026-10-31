--- @class ClientHero60018ActiveSkill : BaseSkillShow
ClientHero60018ActiveSkill = Class(ClientHero60018ActiveSkill, BaseSkillShow)

--- @param actionResults List<BaseActionResult>
function ClientHero60018ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1, 1, 0.3)

end

function ClientHero60018ActiveSkill:OnCastEffect()
    --self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName)
end

function ClientHero60018ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero60018ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end