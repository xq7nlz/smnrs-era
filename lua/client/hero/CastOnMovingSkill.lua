--- @class CastOnMovingSkill : BaseSkillShow
CastOnMovingSkill = Class(CastOnMovingSkill, BaseSkillShow)

--- @param clientHero ClientHero
--- @param isBasicAttack boolean
--- @param startJumpFrame number
--- @param jumpDuration number
function CastOnMovingSkill:Ctor(clientHero, isBasicAttack, startJumpFrame, jumpDuration)
    self.startJumpFrame = startJumpFrame
    self.jumpDuration = jumpDuration

    BaseSkillShow.Ctor(self, clientHero, isBasicAttack)
end

function CastOnMovingSkill:DeliverSetFrameAction()
    self:AddFrameAction(self.startJumpFrame, function()
        self:StartAccost()
    end)
end

--- @param actionResults List<BaseActionResult>
function CastOnMovingSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function CastOnMovingSkill:StartAccost()
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self:AccostTarget(clientTargetHero, nil, nil, nil, self.jumpDuration / ClientConfigUtils.FPS, DOTweenEase.OutSine)
end

function CastOnMovingSkill:OnEndAnimation()
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

function CastOnMovingSkill:OnCompleteActionTurn()

end