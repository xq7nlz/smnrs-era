--- @class ClientHero30017ActiveSkill : BaseSkillShow
ClientHero30017ActiveSkill = Class(ClientHero30017ActiveSkill, BaseSkillShow)

function ClientHero30017ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(20, function()
        self:StartAccost()
    end)
end

function ClientHero30017ActiveSkill:StartAccost()
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self:AccostTarget(clientTargetHero, nil, nil, nil, 20 / ClientConfigUtils.FPS, DOTweenEase.OutSine)
end

--- @param actionResults List<BaseActionResult>
function ClientHero30017ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero30017ActiveSkill:OnEndAnimation()
    if self.clientHero.heroModelType ~= HeroModelType.Full then
        BaseSkillShow.OnEndAnimation(self)
        return
    end
    if self.clientHero.isPlayingDead == true then
        BaseSkillShow.OnEndTurn(self)
        return
    end

    self.clientHero:PlayIdleAnimation()
    self:DoMovePosition(self.clientHero.originPosition, function()
        BaseSkillShow.OnEndAnimation(self)
        BaseSkillShow.OnEndTurn(self)
    end)
end

function ClientHero30017ActiveSkill:OnCompleteActionTurn()

end