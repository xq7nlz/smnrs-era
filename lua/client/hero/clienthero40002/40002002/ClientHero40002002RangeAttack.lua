--- @class ClientHero40002002RangeAttack : ClientHero40002RangeAttack
ClientHero40002002RangeAttack = Class(ClientHero40002002RangeAttack, ClientHero40002RangeAttack)

function ClientHero40002002RangeAttack:DeliverCtor()
    self.effAttack = self.clientHero:GetEffectNameByFormat("hero_%s_%s_eff_attack")
end

function ClientHero40002002RangeAttack:OnCastEffect()
    self:CastNewClientImpactOnTargets(AssetType.HeroBattleEffect, self.effAttack)
end

function ClientHero40002002RangeAttack:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_NORMAL)
    BaseSkillShow.OnTriggerActionResult(self)
end