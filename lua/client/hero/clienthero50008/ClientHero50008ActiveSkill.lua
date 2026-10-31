--- @class ClientHero50008ActiveSkill : BaseSkillShow
ClientHero50008ActiveSkill = Class(ClientHero50008ActiveSkill, BaseSkillShow)

function ClientHero50008ActiveSkill:DeliverCtor()
    self.normalColor = U_Color(0, 0, 0, 0)
    self.shaderColor = U_Color(1, 0.59, 0.17, 0)
end

function ClientHero50008ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(10, function()
        self:FadeInColor()
    end)
    self:AddFrameAction(60, function()
        self:FadeOutColor()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero50008ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1, 1, 0.3)

end

function ClientHero50008ActiveSkill:OnCastEffect()
    --self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName)
end

function ClientHero50008ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero50008ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

function ClientHero50008ActiveSkill:FadeInColor()
    local fadeInFrame = 30
    self.clientHero.animation:TweenShaderColorById(ClientConfigUtils.FIELD_COLOR_BLACK_ID, self.normalColor, self.shaderColor, fadeInFrame / ClientConfigUtils.FPS)
end

function ClientHero50008ActiveSkill:FadeOutColor()
    local fadeOutFrame = 15
    self.clientHero.animation:TweenShaderColorById(ClientConfigUtils.FIELD_COLOR_BLACK_ID, self.shaderColor, self.normalColor, fadeOutFrame / ClientConfigUtils.FPS)
end