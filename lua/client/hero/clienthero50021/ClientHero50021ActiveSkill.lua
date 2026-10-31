--- @class ClientHero50021ActiveSkill : BaseSkillShow
ClientHero50021ActiveSkill = Class(ClientHero50021ActiveSkill, BaseSkillShow)

function ClientHero50021ActiveSkill:DeliverCtor()
    self.targetAttackBone = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/target_attack")
end

--- @param actionResults List<BaseActionResult>
function ClientHero50021ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.5, 0.6, 0.4)


    local targetPosition = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
                               .components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
    self.targetAttackBone.position = targetPosition
end

function ClientHero50021ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero50021ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

function ClientHero50021ActiveSkill:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName)
end