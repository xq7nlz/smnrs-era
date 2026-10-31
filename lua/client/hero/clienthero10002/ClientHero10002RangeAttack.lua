--- @class ClientHero10002RangeAttack : BaseRangeAttack
ClientHero10002RangeAttack = Class(ClientHero10002RangeAttack, BaseRangeAttack)

function ClientHero10002RangeAttack:DeliverCtor()
    BaseRangeAttack.DeliverCtor(self)
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/bone_gun_shooter/launch_position")
    self.skillTargetBone = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/skill_target")
end

--- @param actionResults List<BaseActionResult>
function ClientHero10002RangeAttack:CastOnTarget(actionResults)
    BaseRangeAttack.CastOnTarget(self, actionResults)
    if self.clientHero.heroModelType == HeroModelType.Full then
        local target = self.listTargetHero:Get(1)
        local clientTarget = self.clientBattleShowController:GetClientHeroByBaseHero(target)
        self.skillTargetBone.position = clientTarget.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
    end
end