--- @class ClientHero20023RangeAttack : BaseSkillShow
ClientHero20023RangeAttack = Class(ClientHero20023RangeAttack, BaseSkillShow)

function ClientHero20023RangeAttack:DeliverCtor()
    self.targetAttack = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/target_attack")
end

--- @param actionResults List<BaseActionResult>
function ClientHero20023RangeAttack:CastOnTarget(actionResults)
    BaseRangeAttack.CastOnTarget(self, actionResults)
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self.targetAttack.position = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
end