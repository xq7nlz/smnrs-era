--require "lua.client.data.CS.UnityEngine_Quaternion"

--- @class ClientHero50007001ActiveSkill : ClientHero50007ActiveSkill
ClientHero50007001ActiveSkill = Class(ClientHero50007001ActiveSkill, ClientHero50007ActiveSkill)


function ClientHero50007001ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
    self.effSkillName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_skill_explosion")
end

--- @param frameAnimLength number
--- @param frameEndTurn number
--- @param frameActionResult number
--- @param frameEffect number
function ClientHero50007001ActiveSkill:SetFrameActionEvent(frameAnimLength, frameEndTurn, frameActionResult, frameEffect)
    self:AddFrameAction(frameAnimLength, function()
        self:OnEndAnimation()
    end)
    if self.clientHero.heroModelType ~= HeroModelType.Full then
        return
    end
    self:AddFrameAction(frameEndTurn, function()
        self:OnCompleteActionTurn()
    end)
    self:AddFrameAction(frameActionResult-40, function()
        self:CastImpactFromConfig()
        self:CastSfxImpactFromConfig()
    end)
    self:AddFrameAction(frameActionResult, function()
        self.clientHero:TriggerActionResult()
    end)
    self:AddFrameAction(frameEffect, function()
        self:OnCastEffect()
    end)
    self:DeliverSetFrameAction()
end



--- @param effectType string
--- @param effectName string
function ClientHero50007001ActiveSkill:CastNewClientImpactOnTargets(effectType, effectName)
    for i = 1, self.listTargetHero:Count() do
        --- @type ClientEffect
        local fxImpact = self:GetClientEffect(effectType, effectName)
        if fxImpact ~= nil then
            local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
            fxImpact:SetToHeroAnchor(clientTargetHero,false, true)
            --fxImpact.config.transform.rotation = UnityEngine_Quaternion:Euler(0,0,0)
        end
    end
end