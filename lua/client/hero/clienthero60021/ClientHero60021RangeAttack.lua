--- @class ClientHero60021RangeAttack : BaseRangeAttack
ClientHero60021RangeAttack = Class(ClientHero60021RangeAttack, BaseRangeAttack)

function ClientHero60021RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
    self.moveAttackBone = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/move_attack")
end

--- @param actionResults List<BaseActionResult>
function ClientHero60021RangeAttack:CastOnTarget(actionResults)
    BaseRangeAttack.CastOnTarget(self, actionResults)

    local targetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self.moveAttackBone.position = targetHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
end