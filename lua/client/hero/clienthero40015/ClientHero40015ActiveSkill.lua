--- @class ClientHero40015ActiveSkill : BaseSkillShow
ClientHero40015ActiveSkill = Class(ClientHero40015ActiveSkill, BaseSkillShow)

function ClientHero40015ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(26, function()
        self:StartAccost()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero40015ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.5, 1, 0.3)

end

function ClientHero40015ActiveSkill:OnTriggerActionResult()
    BaseSkillShow.OnTriggerActionResult(self)
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
end

function ClientHero40015ActiveSkill:OnEndAnimation()
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

function ClientHero40015ActiveSkill:OnCompleteActionTurn()

end

function ClientHero40015ActiveSkill:StartAccost()
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self:AccostTarget(clientTargetHero, nil, nil, nil, 8.0 / ClientConfigUtils.FPS, DOTweenEase.OutSine)
end