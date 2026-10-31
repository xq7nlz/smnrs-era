--- @class ClientHero20018MeleeAttack : BaseMeleeAttack
ClientHero20018MeleeAttack = Class(ClientHero20018MeleeAttack, BaseMeleeAttack)

function ClientHero20018MeleeAttack:DeliverCtor()
    self.effectName = string.format("hero_%d_eff_atk", self.baseHero.id)
end

function ClientHero20018MeleeAttack:OnCastEffect()
    local effect = self:GetClientEffect(AssetType.HeroBattleEffect, self.effectName)
    effect:SetToHeroAnchor(self.clientHero)
end