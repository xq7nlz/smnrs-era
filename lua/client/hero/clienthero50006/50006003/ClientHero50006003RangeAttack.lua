--- @class ClientHero50006003RangeAttack : ClientHero50006RangeAttack
ClientHero50006003RangeAttack = Class(ClientHero50006003RangeAttack, ClientHero50006RangeAttack)

function ClientHero50006003RangeAttack:DeliverCtor()
    ClientHero50006RangeAttack.DeliverCtor(self)
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_attack_projectile")
    self.impactName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_attack_impact")
end

function ClientHero50006003RangeAttack:CastImpactFromConfig()
    if self.fxImpactConfig ~= nil then
        self:CastNewClientImpactOnTargets(AssetType.HeroBattleEffect, self.impactName)
    end
end

function ClientHero50006003RangeAttack:OnCastEffect()
    if self.currentTurnDetail ~= nil then
        local clientTurn = self.currentTurnDetail.clientTurn

        --- @param v BaseHero
        for k, v in pairs(self.nextProjectileTargetId:GetItems()) do
            --- @type ClientEffect
            local projectile = self.projectileIdDict:Get(k)
            local bounceToPosition = self.clientBattleShowController:GetClientHeroByBaseHero(v)
                                         .components:GetAnchorPosition(ClientConfigUtils.TORSO_ANCHOR)
            projectile:SetPosition(self.projectileLaunchPos.position)
            projectile:Play()
            projectile:DoMoveTween(bounceToPosition,  0.3, function()
                self:OnTriggerActionResult(clientTurn)
            end)
        end
    end
end