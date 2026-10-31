--- @class ClientHero30011RangeAttack : BaseRangeAttack
ClientHero30011RangeAttack = Class(ClientHero30011RangeAttack, BaseRangeAttack)

function ClientHero30011RangeAttack:DeliverCtor()
    self.allowTrigger = false
    self.bulletSpeed = 17
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end

function ClientHero30011RangeAttack:DeliverSetFrameAction()
    local frame = 32
    for i = 1, 3 do
        self:AddFrameAction(frame, function()
            self:OnCastEffect()
        end)
        self:AddFrameAction(frame + self.bulletSpeed, function()
            self:TriggerDamage()
        end)
        frame = frame + 5
    end
end

function ClientHero30011RangeAttack:TriggerDamage()
    if self.allowTrigger == true then
        self:OnTriggerActionResult()
    end
end

function ClientHero30011RangeAttack:OnCastEffect()
    if self.allowTrigger == true then
        self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, self.bulletSpeed / 30, nil, self.projectileLaunchPos.position)
    end
end

--- @param clientTurnDetail ClientTurnDetail
function ClientHero30011RangeAttack:SetClientTurnDetail(clientTurnDetail)
    self.currentTurnDetail = clientTurnDetail
    local clientActionType = clientTurnDetail.actionType
    self:GetListTargetFromActions(clientTurnDetail.actionList)

    if clientActionType == ClientActionType.BASIC_ATTACK then
        self.allowTrigger = true
        self:CastOnTarget(clientTurnDetail.actionList)
    elseif clientActionType == ClientActionType.BONUS_ATTACK then
        local extraTurnInfo = self.currentTurnDetail.extraTurnInfo
        self.allowTrigger = extraTurnInfo ~= nil
    end
end

function ClientHero30011RangeAttack:OnTriggerActionResult()
    if self.currentTurnDetail == nil then
        return
    end
    local clientActionType = self.currentTurnDetail.actionType
    if clientActionType == ClientActionType.BASIC_ATTACK then
        BaseSkillShow.OnTriggerActionResult(self)
        local extraTurnInfo = self.currentTurnDetail.extraTurnInfo
        if extraTurnInfo ~= nil then
            self.clientHero:FinishActionTurn()
        else
            self.currentTurnDetail = nil
        end
    elseif clientActionType == ClientActionType.BONUS_ATTACK then
        local extraTurnInfo = self.currentTurnDetail.extraTurnInfo
        if extraTurnInfo ~= nil then
            self.clientHero:TriggerActionResult()
            if extraTurnInfo.numberBonusTurn ~= 0 then
                self.clientHero:FinishActionTurn()
            else
                self.allowTrigger = false
            end
        else
            self.currentTurnDetail = nil
        end
    end
end