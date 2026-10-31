--- @class ClientHero60008ActiveSkill : BaseSkillShow
ClientHero60008ActiveSkill = Class(ClientHero60008ActiveSkill, BaseSkillShow)

function ClientHero60008ActiveSkill:DeliverCtor()
    self.effectName = string.format("hero_%d_skill_impact", self.baseHero.id)
end

function ClientHero60008ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(4, function()
        self:StartAccost()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero60008ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1.6, 0.5, 0.4)

end

function ClientHero60008ActiveSkill:StartAccost()
    --- @type BaseHero
    local baseTarget = self.listTargetHero:Get(1)
    local moveDest = PositionConfig.GetAccostOpponentLinePosition(baseTarget.teamId, baseTarget.positionInfo.isFrontLine, 2)
    self:DoMovePosition(moveDest, nil, 4 / ClientConfigUtils.FPS)
end

function ClientHero60008ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero60008ActiveSkill:OnCompleteActionTurn()

end

function ClientHero60008ActiveSkill:OnEndAnimation()
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

function ClientHero60008ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end