--- @class ClientHero20019ActiveSkill : BaseSkillShow
ClientHero20019ActiveSkill = Class(ClientHero20019ActiveSkill, BaseSkillShow)

function ClientHero20019ActiveSkill:DeliverCtor()
    --- @type UnityEngine_Vector3
    self.moveDest = nil
    --- @type number
    self.rangeAttack = U_Vector3(3, 0, 0)
end

--- @param actionResults List<BaseActionResult>
function ClientHero20019ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)

    self:GetMoveDest(self.listTargetHero:Get(1))
    self:DoMovePosition(self.moveDest, function()
        self:DoAnimation()
        self:DoCoverBattle(0.5, 0.8, 0.3)

    end)
end

function ClientHero20019ActiveSkill:OnCastEffect()

end

function ClientHero20019ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero20019ActiveSkill:OnEndAnimation()
    if self.clientHero.heroModelType ~= HeroModelType.Full then
        BaseSkillShow.OnEndAnimation(self)
        return
    end

    self:DoMovePosition(self.clientHero.originPosition, function()
        BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
        BaseSkillShow.OnEndAnimation(self)
        BaseSkillShow.OnEndTurn(self)
    end)
end

function ClientHero20019ActiveSkill:OnCompleteActionTurn()

end

--- @param targetHero BaseHero
function ClientHero20019ActiveSkill:GetMoveDest(targetHero)
    local teamId = targetHero.teamId
    local isFrontLine = targetHero.positionInfo.isFrontLine
    if teamId == BattleConstants.DEFENDER_TEAM_ID and isFrontLine == true then
        self.moveDest = PositionConfig.frontLinePos - self.rangeAttack
    elseif teamId == BattleConstants.DEFENDER_TEAM_ID and isFrontLine == false then
        self.moveDest = PositionConfig.backLinePos - self.rangeAttack
    elseif teamId == BattleConstants.ATTACKER_TEAM_ID and isFrontLine == true then
        self.moveDest = U_Vector3(-PositionConfig.frontLinePos.x, PositionConfig.frontLinePos.y, 0) + self.rangeAttack
    elseif teamId == BattleConstants.ATTACKER_TEAM_ID and isFrontLine == false then
        self.moveDest = U_Vector3(-PositionConfig.backLinePos.x, PositionConfig.backLinePos.y, 0) + self.rangeAttack
    end
end