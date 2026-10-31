--- @class ClientHero40004MeleeAttack : BaseMeleeAttack
ClientHero40004MeleeAttack = Class(ClientHero40004MeleeAttack, BaseMeleeAttack)

function ClientHero40004MeleeAttack:DeliverCtor()
    --- @type UnityEngine_Vector3
    self.moveDest = nil
    --- @type number
    self.rangeAttack = U_Vector3(3, 0, 0)
end

function ClientHero40004MeleeAttack:DoActionOnListTarget()
    if self.listTargetHero:Count() > 0 then
        self:GetMoveDest(self.listTargetHero:Get(1))
        self:DoMovePosition(self.moveDest, function ()
            self:DoAnimation()
        end)
    end
end

--- @param targetHero BaseHero
function ClientHero40004MeleeAttack:GetMoveDest(targetHero)
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