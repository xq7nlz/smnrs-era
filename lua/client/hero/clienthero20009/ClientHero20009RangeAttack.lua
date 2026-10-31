--- @class ClientHero20009RangeAttack : BaseRangeAttack
ClientHero20009RangeAttack = Class(ClientHero20009RangeAttack, BaseRangeAttack)

function ClientHero20009RangeAttack:DeliverCtor()
    self.targetFxBone = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/target_fx")
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end

function ClientHero20009RangeAttack:OnCastEffect()
    local opponentPos = PositionConfig.GetOpponentCenterTeamPosition(self.baseHero.teamId)

    self.targetFxBone.position = opponentPos
end