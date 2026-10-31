--- @class ClientHero30027MeleeAttack : BaseMeleeAttack
ClientHero30027MeleeAttack = Class(ClientHero30027MeleeAttack, BaseMeleeAttack)

function ClientHero30027MeleeAttack:DoActionOnListTarget()
    self:RemoveAllCCEffect()
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self:AccostTarget(clientTargetHero, function()
        self:DoAnimation()
    end)
end

function ClientHero30027MeleeAttack:RemoveAllCCEffect()
    self.clientHero.clientHeroEffectMgr.hardCcEffectMgr:Release()
end
