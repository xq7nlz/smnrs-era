require "lua.client.hero.ClientHero60004.ClientHero60004RangeAttack"
--- @class ClientHero60004001RangeAttack : ClientHero60004RangeAttack
ClientHero60004001RangeAttack = Class(ClientHero60004001RangeAttack, ClientHero60004RangeAttack)

function ClientHero60004001RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
    self.projectileName = "hero_60004_skin_id_60004001_attack_projectile"
    self.impactName = "hero_60004_skin_id_60004001_attack_impact"
end

function ClientHero60004001RangeAttack:CastImpactFromConfig()
    if self.fxImpactConfig ~= nil then
        self:CastNewClientImpactOnTargets(AssetType.HeroBattleEffect, self.impactName)
    end
end