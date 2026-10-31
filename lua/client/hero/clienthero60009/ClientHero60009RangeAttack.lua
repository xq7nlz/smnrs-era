--- @class ClientHero60009RangeAttack : BaseRangeAttack
ClientHero60009RangeAttack = Class(ClientHero60009RangeAttack, BaseRangeAttack)

function ClientHero60009RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end

function ClientHero60009RangeAttack:DeliverSetFrameAction()
    self:AddFrameAction(10, function()
        self:CastImpactFromConfig()
    end)
end

function ClientHero60009RangeAttack:OnCastEffect()

end

function ClientHero60009RangeAttack:OnTriggerActionResult()
    self:CastSfxImpactFromConfig()
    self.clientHero:TriggerActionResult()
end