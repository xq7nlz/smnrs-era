--- @class ClientHero10004RangeAttack : BaseRangeAttack
ClientHero10004RangeAttack = Class(ClientHero10004RangeAttack, BaseRangeAttack)

function ClientHero10004RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position")
end

--- @param actionResults List<BaseActionResult>
function ClientHero10004RangeAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero10004RangeAttack:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName,
            5 / ClientConfigUtils.FPS,
            nil, self.projectileLaunchPos.position)
end