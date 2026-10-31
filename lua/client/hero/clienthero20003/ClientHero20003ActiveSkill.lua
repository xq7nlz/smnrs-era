--- @class ClientHero20003ActiveSkill : BaseSkillShow
ClientHero20003ActiveSkill = Class(ClientHero20003ActiveSkill, BaseSkillShow)

function ClientHero20003ActiveSkill:DeliverCtor()
    self.pigEffectName = string.format("hero_%d_pig_%s", self.baseHero.id, self.clientHero.skinName)
end

function ClientHero20003ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(19, function()
        self:StartAccost()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero20003ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1.5, 0.4, 0.2)

end

function ClientHero20003ActiveSkill:StartAccost()
    --- @type BaseHero
    local baseTarget = self.listTargetHero:Get(1)
    local moveDest = PositionConfig.GetAccostOpponentLinePosition(baseTarget.teamId, baseTarget.positionInfo.isFrontLine, 2)
    self:DoMovePosition(moveDest, nil, 13 / ClientConfigUtils.FPS, DOTweenEase.OutSine)
end

function ClientHero20003ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero20003ActiveSkill:OnEndAnimation()
    if self.clientHero.isPreviewOnly == true then
        BaseSkillShow.OnEndAnimation(self)
        return
    end
    if self.clientHero.isPlayingDead == true then
        self:OnEndTurn()
        return
    end

    self.clientHero:PlayIdleAnimation()
    self:DoMovePosition(self.clientHero.originPosition, function()
        BaseSkillShow.OnEndAnimation(self)
        self:OnEndTurn()
    end)
end

function ClientHero20003ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

function ClientHero20003ActiveSkill:OnCompleteActionTurn()

end