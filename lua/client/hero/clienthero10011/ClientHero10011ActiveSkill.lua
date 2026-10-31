--- @class ClientHero10011ActiveSkill : BaseSkillShow
ClientHero10011ActiveSkill = Class(ClientHero10011ActiveSkill, BaseSkillShow)

function ClientHero10011ActiveSkill:DeliverCtor()
    self.launchAnchor = self.clientHero.components:FindChildByPath("Model/skill_launch_position")
    self.projectileLaunchPos = self.clientHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
end

--- @param actionResults List<BaseActionResult>
function ClientHero10011ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1, 1.5, 0.4, ClientConfigUtils.DEFAULT_COVER_ALPHA)

end

function ClientHero10011ActiveSkill:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, nil, nil, self.launchAnchor.position)
end

function ClientHero10011ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero10011ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end