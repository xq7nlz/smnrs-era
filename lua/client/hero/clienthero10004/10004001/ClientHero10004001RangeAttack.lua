--- @class ClientHero10004001RangeAttack : ClientHero10004RangeAttack
ClientHero10004001RangeAttack = Class(ClientHero10004001RangeAttack, ClientHero10004RangeAttack)

function ClientHero10004001RangeAttack:DeliverCtor()
    ClientHero10004RangeAttack.DeliverCtor(self)
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_attack_projectile")
end

--- @param actionResults List<BaseActionResult>
function ClientHero10004001RangeAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero10004001RangeAttack:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName,
            5 / ClientConfigUtils.FPS,
            nil, self.projectileLaunchPos.position)
end