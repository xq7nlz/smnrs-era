--- @class ClientHero20025ActiveSkill : BaseSkillShow
ClientHero20025ActiveSkill = Class(ClientHero20025ActiveSkill, BaseSkillShow)

function ClientHero20025ActiveSkill:DeliverCtor()
    self.moveSkill = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/move_skill")
    self.launchBone = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/fx_bone")
end

--- @param actionResults List<BaseActionResult>
function ClientHero20025ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self.moveSkill.transform.position = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)

    self:DoCoverBattle(0.7, 0.5, 0.2)

end

function ClientHero20025ActiveSkill:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, nil, nil, self.launchBone.position)
end

function ClientHero20025ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero20025ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end