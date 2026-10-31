--- @class ClientHero30014ActiveSkill : BaseSkillShow
ClientHero30014ActiveSkill = Class(ClientHero30014ActiveSkill, BaseSkillShow)

--- @param actionResults List<BaseActionResult>
function ClientHero30014ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.8, 0.7, 0.4)

end

function ClientHero30014ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero30014ActiveSkill:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, 13.0 / ClientConfigUtils.FPS)
end

function ClientHero30014ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end