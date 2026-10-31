--- @class ClientHero30001ActiveSkill : BaseSkillShow
ClientHero30001ActiveSkill = Class(ClientHero30001ActiveSkill, BaseSkillShow)

function ClientHero30001ActiveSkill:SetOffsetAccostX()
    BaseSkillShow.SetOffsetAccostX(self, 3.5)
end

function ClientHero30001ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(45, function()
        self:StartAccost()
    end)
end

function ClientHero30001ActiveSkill:StartAccost()
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self:AccostTarget(clientTargetHero, nil, nil, nil, 3.0 / ClientConfigUtils.FPS, DOTweenEase.OutSine)
end

--- @param actionResults List<BaseActionResult>
function ClientHero30001ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1.5, 1, 0.4, ClientConfigUtils.DEFAULT_COVER_ALPHA)

end

function ClientHero30001ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero30001ActiveSkill:OnCompleteActionTurn()

end

function ClientHero30001ActiveSkill:OnEndAnimation()
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

function ClientHero30001ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end