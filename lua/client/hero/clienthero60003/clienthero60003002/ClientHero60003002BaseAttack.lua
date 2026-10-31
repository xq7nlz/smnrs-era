--- @class ClientHero60003002BaseAttack : BaseSkillShow
ClientHero60003002BaseAttack = Class(ClientHero60003002BaseAttack, BaseSkillShow)

--- @param clientHero ClientHero
function ClientHero60003002BaseAttack:Ctor(clientHero)
    BaseSkillShow.Ctor(self, clientHero, true)
end

--- @param frameAnimLength number
--- @param frameEndTurn number
--- @param frameActionResult number
--- @param frameEffect number
function ClientHero60003002BaseAttack:SetFrameActionEvent(frameAnimLength, frameEndTurn, frameActionResult, frameEffect)
    BaseSkillShow.SetFrameActionEvent(self, frameAnimLength, frameEndTurn, frameActionResult, frameEffect)
    if self.clientHero.heroModelType ~= HeroModelType.Full then
        return
    end
    self:AddFrameAction(21, function()
        self:StartAccost()
    end)
end

--- @param actionResults List -- <BaseActionResult>
function ClientHero60003002BaseAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero60003002BaseAttack:StartAccost()
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self:AccostTarget(clientTargetHero, nil, nil, nil,
            2.0 / ClientConfigUtils.FPS)
end

function ClientHero60003002BaseAttack:OnEndAnimation()
    if self.clientHero.heroModelType ~= HeroModelType.Full then
        BaseSkillShow.OnEndAnimation(self)
        return
    end
    if self.clientHero.isPlayingDead == true then
        BaseSkillShow.OnEndTurn(self)
        return
    end

    self:DoMovePosition(self.clientHero.originPosition, function()
        BaseSkillShow.OnEndAnimation(self)
        BaseSkillShow.OnEndTurn(self)
    end)
end

function ClientHero60003002BaseAttack:OnCompleteActionTurn()

end

function ClientHero60003002BaseAttack:OnCastEffect()
    self:CastImpactFromConfig()
end

function ClientHero60003002BaseAttack:OnTriggerActionResult()
    self:CastSfxImpactFromConfig()
    self.clientHero:TriggerActionResult()
end