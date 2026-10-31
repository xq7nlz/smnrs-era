--- @class ClientHero30012ActiveSkill : BaseSkillShow
ClientHero30012ActiveSkill = Class(ClientHero30012ActiveSkill, BaseSkillShow)

function ClientHero30012ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(6, function()
        self:DoMovePosition(PositionConfig.GetBattleCentralPosition(), nil, 0.26)
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero30012ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.4, 0.8, 0.8)

end

function ClientHero30012ActiveSkill:OnEndAnimation()
    if self.clientHero.heroModelType ~= HeroModelType.Full then
        BaseSkillShow.OnEndAnimation(self)
        return
    end

    self:DoMovePosition(self.clientHero.originPosition, function()
        BaseSkillShow.OnEndAnimation(self)
        self:OnEndTurn()
    end)
end

function ClientHero30012ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero30012ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

function ClientHero30012ActiveSkill:OnCompleteActionTurn()

end