require "lua.client.hero.ClientHero60003.ClientHero60003002.ClientHero60003002BaseAttack"
--- @class ClientHero60003004BaseAttack : ClientHero60003002BaseAttack
ClientHero60003004BaseAttack = Class(ClientHero60003004BaseAttack, ClientHero60003002BaseAttack)

function ClientHero60003004BaseAttack:DeliverCtor()
    self.fxImpactName2 = "hero_60003_skin_id_60003004_attack_impact"
end

function ClientHero60003004BaseAttack:OnCastEffect()
    self:CastNewClientImpactOnTargets(AssetType.HeroBattleEffect, self.fxImpactName2)
end