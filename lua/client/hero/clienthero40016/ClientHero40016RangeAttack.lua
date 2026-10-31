--- @class ClientHero40016RangeAttack : BaseRangeAttack
ClientHero40016RangeAttack = Class(ClientHero40016RangeAttack, BaseRangeAttack)

function ClientHero40016RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end

--- @param actionResults List<BaseActionResult>
function ClientHero40016RangeAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end