--- @class ClientHero10009RangeAttack : BaseRangeAttack
ClientHero10009RangeAttack = Class(ClientHero10009RangeAttack, BaseRangeAttack)

function ClientHero10009RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
    self.currentTurnDetail = nil
    self.targetPosition = nil
    --- @type ClientEffect
    self.projectile = nil
    self.fxImpactName = "impact_water"
    self.boucingTime = 0
end

--- @param clientTurnDetail ClientTurnDetail
function ClientHero10009RangeAttack:SetClientTurnDetail(clientTurnDetail)
    self.currentTurnDetail = clientTurnDetail
    local clientActionType = clientTurnDetail.actionType

    self:GetListTargetFromActions(clientTurnDetail.actionList)

    if clientActionType == ClientActionType.BASIC_ATTACK then
        self.boucingTime = 0
        self:DoAnimation()
    elseif clientActionType == ClientActionType.BOUNCING_DAMAGE then
        self.boucingTime = self.boucingTime + 1
        self:ScaleProjectile(1.2 - self.boucingTime * 0.2)

        local bounceToPosition = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
                .components:GetAnchorPosition(ClientConfigUtils.TORSO_ANCHOR)
        self.projectile.configTable.bounceBezier:DoBounceTarget(self.projectile.config.transform, self.targetPosition, bounceToPosition, 0.5, function()
            self:OnTriggerActionResult()
        end)
        self.targetPosition = bounceToPosition
    end
end

function ClientHero10009RangeAttack:OnTriggerActionResult()
    BaseSkillShow.OnTriggerActionResult(self)
    local clientActionType = self.currentTurnDetail.actionType
    if clientActionType == ClientActionType.BOUNCING_DAMAGE then
        local extraTurnInfo = self.currentTurnDetail.extraTurnInfo
        if extraTurnInfo.numberBonusTurn == 0 then
            self:ReleaseProjectile()
        end
        self.clientHero:FinishActionTurn()
    elseif clientActionType == ClientActionType.BASIC_ATTACK then
        local extraTurnInfo = self.currentTurnDetail.extraTurnInfo

        if extraTurnInfo ~= nil then
            self.clientHero:FinishActionTurn()
        else
            self.currentTurnDetail = nil
            self:ReleaseProjectile()
        end
    end
end

function ClientHero10009RangeAttack:OnCastEffect()
    if self.currentTurnDetail ~= nil then
        local bounceToPosition = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
                .components:GetAnchorPosition(ClientConfigUtils.TORSO_ANCHOR)
        self.projectile = self:GetProjectile(AssetType.HeroBattleEffect, self.projectileName)
        self.targetPosition = self.projectileLaunchPos
        self.projectile.configTable.bounceBezier:DoBounceTarget(self.projectile.config.transform, self.projectileLaunchPos, bounceToPosition, 0.7, function()
            self:OnTriggerActionResult()
        end)
        self.targetPosition = bounceToPosition
        self:ScaleProjectile(1.2)
    end
end

function ClientHero10009RangeAttack:OnEndTurn()
    if self.currentTurnDetail == nil then
        self.clientHero:FinishActionTurn()
    end
end

--- @param scale number
function ClientHero10009RangeAttack:ScaleProjectile(scale)
    local projectileScale = self.projectile.config.transform.localScale
    projectileScale.x = scale
    projectileScale.y = scale
    projectileScale.z = scale
    self.projectile.config.transform.localScale = projectileScale
end

--- @param killAction boolean
function ClientHero10009RangeAttack:ReleaseProjectile(killAction)
    if self.projectile ~= nil then
        SmartPool.Instance:DespawnGameObject(AssetType.GeneralBattleEffect, "bounce_bezier", self.projectile.configTable.bounceBezier.transform)
        self.projectile.configTable.bounceBezier:StopBounceTweener()
        self.projectile:Release()
        if killAction == true then
            self.projectile:KillAction()
        end
        self.projectile = nil
    end
end

--- @return ClientEffect
--- @param effectType number
--- @param effectName string
function ClientHero10009RangeAttack:GetProjectile(effectType, effectName)
    local effect = self:GetClientEffect(effectType, effectName)
    local bounceBezierObject = SmartPool.Instance:SpawnGameObject(AssetType.GeneralBattleEffect, "bounce_bezier")
    effect:AddConfigField("bounceBezier", bounceBezierObject:GetComponent(ComponentName.BezierSpline))
    effect:Play()
    return effect
end

function ClientHero10009RangeAttack:BreakSkillAction()
    BaseRangeAttack.BreakSkillAction(self)
    self:ReleaseProjectile(true)
end