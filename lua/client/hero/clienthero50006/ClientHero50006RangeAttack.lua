--- @class ClientHero50006RangeAttack : BaseRangeAttack
ClientHero50006RangeAttack = Class(ClientHero50006RangeAttack, BaseRangeAttack)

function ClientHero50006RangeAttack:DeliverCtor()
    BaseRangeAttack.DeliverCtor(self)

    --- @type ClientTurnDetail
    self.currentTurnDetail = nil

    --- @type Dictionary
    self.projectileIdDict = Dictionary()
    --- @type Dictionary
    self.nextProjectileTargetId = Dictionary()

    --- @type Dictionary
    self.triggeredActionResultDict = Dictionary()
end

--- @param clientTurnDetail ClientTurnDetail
function ClientHero50006RangeAttack:SetClientTurnDetail(clientTurnDetail)
    self.currentTurnDetail = clientTurnDetail
    local clientActionType = clientTurnDetail.actionType

    self:GetListTargetFromActions(clientTurnDetail.actionList)

    if clientActionType == ClientActionType.BASIC_ATTACK
            or clientActionType == ClientActionType.USE_SKILL then
        self.triggeredActionResultDict:Clear()

        self:DoAnimation()

        self:CreateProjectileIdDict()

    elseif clientActionType == ClientActionType.BOUNCING_DAMAGE then
        self:DoBouncing(clientTurnDetail)
    end
end

--- @par listBaseActionResult List
function ClientHero50006RangeAttack:CreateProjectileIdDict()
    self.projectileIdDict:Clear()

    self.nextProjectileTargetId:Clear()

    for i = 1, self.listTargetHero:Count() do
        local projectile = self:GetClientEffect(AssetType.HeroBattleEffect, self.projectileName)
        self.projectileIdDict:Add(i, projectile)
        projectile:SetActive(false)
        self.nextProjectileTargetId:Add(i, self.listTargetHero:Get(i))
    end
end

--- @param clientTurnDetail ClientTurnDetail
function ClientHero50006RangeAttack:DoBouncing(clientTurnDetail)
    self.nextProjectileTargetId = Dictionary()

    for i = 1, clientTurnDetail.actionList:Count() do
        --- @type BouncingDamageResult
        local bouncingDamageResult = clientTurnDetail.actionList:Get(i)
        if bouncingDamageResult.type == ActionResultType.BOUNCING_DAMAGE then
            local projectileId = bouncingDamageResult.bouncingId
            local target = bouncingDamageResult.target

            self.nextProjectileTargetId:Add(projectileId, target)
            local bounceToPosition = self.clientBattleShowController:GetClientHeroByBaseHero(target)
                                         .components:GetAnchorPosition(ClientConfigUtils.TORSO_ANCHOR)
            --- @type ClientEffect
            local projectile = self.projectileIdDict:Get(projectileId)
            projectile:DoMoveTween(bounceToPosition, 0.5, function()
                self:OnTriggerActionResult(clientTurnDetail.clientTurn)
            end)
        end
    end

    --- @param v ClientEffect
    for k, v in pairs(self.projectileIdDict:GetItems()) do
        if self.nextProjectileTargetId:IsContainKey(k) == false then
            v:ReturnPool()
            self.projectileIdDict:RemoveByKey(k)
        end
    end
end

--- @param clientTurn number
function ClientHero50006RangeAttack:OnTriggerActionResult(clientTurn)
    if self.triggeredActionResultDict:IsContainKey(clientTurn) then
        return
    end
    self.triggeredActionResultDict:Add(clientTurn, true)
    BaseRangeAttack.OnTriggerActionResult(self)

    local clientActionType = self.currentTurnDetail.actionType

    if clientActionType == ClientActionType.BOUNCING_DAMAGE then
        local extraTurnInfo = self.currentTurnDetail.extraTurnInfo
        if extraTurnInfo.numberBonusTurn == 0 then
            self:ReleaseProjectile()
        end
        self.clientHero:FinishActionTurn()
    elseif clientActionType == ClientActionType.BASIC_ATTACK
            or clientActionType == ClientActionType.USE_SKILL then
        local extraTurnInfo = self.currentTurnDetail.extraTurnInfo
        if extraTurnInfo ~= nil then
            self.clientHero:FinishActionTurn()
        else
            self.currentTurnDetail = nil
            self:ReleaseProjectile()
        end
    end
end

function ClientHero50006RangeAttack:OnCastEffect()
    if self.currentTurnDetail ~= nil then
        local clientTurn = self.currentTurnDetail.clientTurn

        --- @param v BaseHero
        for k, v in pairs(self.nextProjectileTargetId:GetItems()) do
            --- @type ClientEffect
            local projectile = self.projectileIdDict:Get(k)
            local bounceToPosition = self.clientBattleShowController:GetClientHeroByBaseHero(v)
                                         .components:GetAnchorPosition(ClientConfigUtils.TORSO_ANCHOR)
            projectile:SetPosition(self.projectileLaunchPos.position)
            projectile:Play()
            projectile:DoMoveTween(bounceToPosition, 0.5, function()
                self:OnTriggerActionResult(clientTurn)
            end)
        end
    end
end

function ClientHero50006RangeAttack:OnEndTurn()
    if self.currentTurnDetail == nil then
        self.clientHero:FinishActionTurn()
    end
end

--- @param killAction boolean
function ClientHero50006RangeAttack:ReleaseProjectile(killAction)
    if self.projectileIdDict ~= nil then
        --- @param v ClientEffect
        for _, v in pairs(self.projectileIdDict:GetItems()) do
            if killAction then
                v:KillAction()
                v:ReturnPool()
            else
                v:Release()
            end
        end
        self.projectileIdDict:Clear()
    end

    if self.nextProjectileTargetId ~= nil then
        self.nextProjectileTargetId:Clear()
    end
end