--- @class ClientHero30003RangeAttack : BaseRangeAttack
ClientHero30003RangeAttack = Class(ClientHero30003RangeAttack, BaseRangeAttack)

----- @param actionResults List
--function ClientHero30003RangeAttack:CastOnTarget(actionResults)
--    BaseRangeAttack.CastOnTarget(self, actionResults)
--    --self:CastNewClientImpactOnTargets(self.fxImpactConfig.skill_impact_type, self.fxImpactConfig.skill_impact_name)
--end
--
----function ClientHero30003RangeAttack:OnTriggerActionResult()
----    self:CastSfxImpactFromConfig()
----    self.clientHero:TriggerActionResult()
----end