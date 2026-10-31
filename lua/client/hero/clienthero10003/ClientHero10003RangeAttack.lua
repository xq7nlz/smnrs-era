--- @class ClientHero10003RangeAttack : BaseRangeAttack
ClientHero10003RangeAttack = Class(ClientHero10003RangeAttack, BaseRangeAttack)

function ClientHero10003RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end

--- @param actionResults List<BaseActionResult>
function ClientHero10003RangeAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero10003RangeAttack:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, 10 / ClientConfigUtils.FPS)
end