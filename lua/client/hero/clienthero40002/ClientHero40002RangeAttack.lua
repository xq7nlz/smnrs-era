--- @class ClientHero40002RangeAttack : BaseRangeAttack
ClientHero40002RangeAttack = Class(ClientHero40002RangeAttack, BaseRangeAttack)

function ClientHero40002RangeAttack:DeliverCtor()
    self.effAttack = string.format("hero_%d_eff_attack", self.baseHero.id)
end

function ClientHero40002RangeAttack:OnCastEffect()
    self:CastNewClientImpactOnTargets(AssetType.HeroBattleEffect, self.effAttack)
end

function ClientHero40002RangeAttack:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_NORMAL)
    BaseSkillShow.OnTriggerActionResult(self)
end