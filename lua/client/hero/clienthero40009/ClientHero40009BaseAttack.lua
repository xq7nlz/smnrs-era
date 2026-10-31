--- @class ClientHero40009BaseAttack : BaseSkillShow
ClientHero40009BaseAttack = Class(ClientHero40009BaseAttack, BaseSkillShow)

--- @param clientHero ClientHero
function ClientHero40009BaseAttack:Ctor(clientHero)
    BaseSkillShow.Ctor(self, clientHero, true)
end

function ClientHero40009BaseAttack:DeliverCtor()
    self.allowTrigger = false
end

function ClientHero40009BaseAttack:DeliverSetFrameAction()
    self:AddFrameAction(17, function()
        self:StartAccost()
    end)
    self:AddFrameAction(27, function()
        self:TriggerDamage()
    end)
    self:AddFrameAction(37, function()
        self:TriggerDamage()
    end)
    self:AddFrameAction(46, function()
        self:TriggerDamage()
    end)
end

function ClientHero40009BaseAttack:TriggerDamage()
    if self.allowTrigger == true then
        self:OnTriggerActionResult()
    end
end

--- @param actionResults List<BaseActionResult>
function ClientHero40009BaseAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero40009BaseAttack:StartAccost()
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self:AccostTarget(clientTargetHero, nil, self.offsetAccostX + 0.5, nil,
            5 / ClientConfigUtils.FPS, DOTweenEase.OutSine)
end

function ClientHero40009BaseAttack:OnEndAnimation()
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
        BaseSkillShow.OnEndTurn(self)
    end)
end

function ClientHero40009BaseAttack:OnCompleteActionTurn()

end

--- @param clientTurnDetail ClientTurnDetail
function ClientHero40009BaseAttack:SetClientTurnDetail(clientTurnDetail)
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

function ClientHero40009BaseAttack:OnTriggerActionResult()
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