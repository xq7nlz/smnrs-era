--- @class ClientHero50006003ActiveSkill : ClientHero50006ActiveSkill
ClientHero50006003ActiveSkill = Class(ClientHero50006003ActiveSkill, ClientHero50006ActiveSkill)

function ClientHero50006003ActiveSkill:DeliverCtor()
    ClientHero50006ActiveSkill.DeliverCtor(self)
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_skill_projectile")
    self.impactName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_skill_impact")
end

function ClientHero50006003ActiveSkill:CastImpactFromConfig()
    if self.fxImpactConfig ~= nil then
        self:CastNewClientImpactOnTargets(self.fxImpactConfig.skill_impact_type, self.impactName)
    end
end

function ClientHero50006003ActiveSkill:OnCastEffect()
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
            projectile:DoMoveTween(bounceToPosition, 0.3, function()
                self:OnTriggerActionResult(clientTurn)
            end)
        end
    end
end