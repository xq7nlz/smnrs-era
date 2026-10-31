--- @class ClientHero40011ActiveSkill : BaseSkillShow
ClientHero40011ActiveSkill = Class(ClientHero40011ActiveSkill, BaseSkillShow)

--- @param actionResults List<BaseActionResult>
function ClientHero40011ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.4, 1, 0.4)

    self:StartMove()
end

function ClientHero40011ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero40011ActiveSkill:OnEndAnimation()
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
        self:OnEndTurn()
    end)
end

function ClientHero40011ActiveSkill:OnCompleteActionTurn()

end

function ClientHero40011ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

function ClientHero40011ActiveSkill:StartMove()
    --- @type BaseHero
    local baseTarget = self.listTargetHero:Get(1)
    local moveDest = PositionConfig.GetOpponentLinePosition(self.baseHero.teamId, baseTarget.positionInfo.isFrontLine)
    if baseTarget.teamId == BattleConstants.ATTACKER_TEAM_ID then
        moveDest = moveDest + U_Vector3.right * 2.5
    else
        moveDest = moveDest + U_Vector3.left * 2.5
    end
    self:DoMovePosition(moveDest, nil, 5 / ClientConfigUtils.FPS, DOTweenEase.OutSine)
end