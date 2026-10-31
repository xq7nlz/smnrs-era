require "lua.client.hero.ClientHero30003.ClientHero30003RangeAttack"
--- @class ClientHero30003001RangeAttack : ClientHero30003RangeAttack
ClientHero30003001RangeAttack = Class(ClientHero30003001RangeAttack, ClientHero30003RangeAttack)

function ClientHero30003001RangeAttack:DeliverCtor()
	ClientHero30003RangeAttack.DeliverCtor(self)
	self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_attack_projectile")
end