--- @class ClientHero60008002ActiveSkill : MoveToPointThenCast
ClientHero60008002ActiveSkill = Class(ClientHero60008002ActiveSkill, MoveToPointThenCast)

function ClientHero60008002ActiveSkill:DeliverCtor()
    MoveToPointThenCast.DeliverCtor(self)
    --- @type UnityEngine_Vector3
    self.moveDest = nil
    --- @type number
    self.rangeAttack = U_Vector3(3.5, 0, 0)
end

--- @param actionResults List<BaseActionResult>
function ClientHero60008002ActiveSkill:CastOnTarget(actionResults)
    MoveToPointThenCast.CastOnTarget(self, actionResults)

    self:DoCoverBattle(1.6, 0.5, 0.4)
end

function ClientHero60008002ActiveSkill:MoveThenCast()
    --- @type BaseHero
    local baseTarget = self.listTargetHero:Get(1)
    local moveDest = PositionConfig.GetAccostOpponentLinePosition(baseTarget.teamId, baseTarget.positionInfo.isFrontLine, 2)
    self:DoMovePosition(moveDest, function()
        self:DoAnimation()
    end)
end

function ClientHero60008002ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    MoveToPointThenCast.OnTriggerActionResult(self)
end

function ClientHero60008002ActiveSkill:OnEndTurn()
    MoveToPointThenCast.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    MoveToPointThenCast.OnEndTurn(self)
end

--- @param targetHero BaseHero
function ClientHero60008002ActiveSkill:GetMoveDest(targetHero)
    local teamId = targetHero.teamId
    local isFrontLine = targetHero.positionInfo.isFrontLine
    local linePos = PositionConfig.GetLinePosition(teamId, isFrontLine)
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