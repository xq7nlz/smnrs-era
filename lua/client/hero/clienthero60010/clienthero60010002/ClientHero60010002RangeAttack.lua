--- @class ClientHero60010002RangeAttack : ClientHero60010RangeAttack
ClientHero60010002RangeAttack = Class(ClientHero60010002RangeAttack, ClientHero60010RangeAttack)

function ClientHero60010002RangeAttack:DeliverCtor()
    self.fxImpactName = "hero_60010_skin_id_60010002_attack_impact"
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position")
    self.projectileName = "hero_60010_skin_id_60010002_attack_projectile"
end

function ClientHero60010002RangeAttack:GetFxImpactFromConfig()
end

--- @param frameAnimLength number
--- @param frameEndTurn number
--- @param frameActionResult number
--- @param frameEffect number
function ClientHero60010002RangeAttack:SetFrameActionEvent(frameAnimLength, frameEndTurn, frameActionResult, frameEffect)
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
