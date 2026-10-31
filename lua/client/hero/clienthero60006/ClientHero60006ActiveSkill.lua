--- @class ClientHero60006ActiveSkill : BaseSkillShow
ClientHero60006ActiveSkill = Class(ClientHero60006ActiveSkill, BaseSkillShow)

function ClientHero60006ActiveSkill:DeliverSetFrameAction()
    local pos = PositionConfig.GetBattleCentralPosition()
    if self.baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
        pos = pos - U_Vector3.right * 1.5
    else
        pos = pos + U_Vector3.right * 1.5
    end
    self:AddFrameAction(20, function()
        self.clientHero.clientHeroMovement:SetPosition(pos)
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero60006ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(2, 0.4, 0.5)

end

function ClientHero60006ActiveSkill:OnEndAnimation()
    if self.clientHero.heroModelType ~= HeroModelType.Full then
        BaseSkillShow.OnEndAnimation(self)
        return
    end

    self:DoMovePosition(self.clientHero.originPosition, function()
        BaseSkillShow.OnEndAnimation(self)
        self:OnEndTurn()
    end)
end

function ClientHero60006ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake({ 1.3, 0.1, 0.4, 200, 0 })
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero60006ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

function ClientHero60006ActiveSkill:OnCompleteActionTurn()

end