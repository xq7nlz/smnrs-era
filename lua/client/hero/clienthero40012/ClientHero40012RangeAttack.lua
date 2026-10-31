--- @class ClientHero40012RangeAttack : BaseRangeAttack
ClientHero40012RangeAttack = Class(ClientHero40012RangeAttack, BaseRangeAttack)

function ClientHero40012RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end

function ClientHero40012RangeAttack:OnTriggerActionResult()
    BaseSkillShow.OnTriggerActionResult(self)
    self:CastNewClientImpactOnTargets(AssetType.GeneralBattleEffect, "impact_natural")
end