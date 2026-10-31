--- @class ClientHero30007001ActiveSkill : ClientHero30007ActiveSkill
ClientHero30007001ActiveSkill = Class(ClientHero30007001ActiveSkill, ClientHero30007ActiveSkill)

function ClientHero30007001ActiveSkill:DeliverCtor()
    ClientHero30007ActiveSkill.DeliverCtor(self)
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_attack_projectile")
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position")
    self.breathTime = 0.9
end

function ClientHero30007001ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(47, function()
        self:StartMoveBone()
    end)
end