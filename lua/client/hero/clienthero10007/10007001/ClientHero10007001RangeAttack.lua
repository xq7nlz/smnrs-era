--- @class ClientHero10007001RangeAttack : BaseRangeAttack
ClientHero10007001RangeAttack = Class(ClientHero10007001RangeAttack, BaseRangeAttack)

function ClientHero10007001RangeAttack:DeliverCtor()
    self.fxImpactName = "hero_10007_skin_id_10007001_attack_impact"
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position")
    self.projectileName = "hero_10007_skin_id_10007001_attack_projectile"
end

function ClientHero10007001RangeAttack:GetFxImpactFromConfig()
end

function ClientHero10007001RangeAttack:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, 10 / ClientConfigUtils.FPS, nil, self.projectileLaunchPos.position)
end

--- @param frameAnimLength number
--- @param frameEndTurn number
--- @param frameActionResult number
--- @param frameEffect number
function ClientHero10007001RangeAttack:SetFrameActionEvent(frameAnimLength, frameEndTurn, frameActionResult, frameEffect)
    self:AddFrameAction(frameAnimLength, function()
        self:OnEndAnimation()
    end)
    if self.clientHero.heroModelType ~= HeroModelType.Full then
        return
    end
    self:AddFrameAction(frameEndTurn, function()
        self:OnCompleteActionTurn()
    end)
    self:AddFrameAction(frameActionResult, function()
        self:CastNewClientImpactOnTargets(AssetType.HeroBattleEffect, self.fxImpactName)
        self:OnTriggerActionResult()
    end)
    self:AddFrameAction(frameEffect, function()
        self:OnCastEffect()
    end)
    self:DeliverSetFrameAction()
end