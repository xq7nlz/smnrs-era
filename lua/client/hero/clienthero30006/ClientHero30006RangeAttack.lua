--- @class ClientHero30006RangeAttack : BaseRangeAttack
ClientHero30006RangeAttack = Class(ClientHero30006RangeAttack, BaseRangeAttack)

function ClientHero30006RangeAttack:DeliverCtor()
    BaseRangeAttack.DeliverCtor(self)
    --- @type ClientEffect
    self.projectile = nil
end

--- @param actionResults List<BaseActionResult>
function ClientHero30006RangeAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero30006RangeAttack:OnCastEffect()
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    local targetPosition = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
    self.projectile = self:GetEffect(AssetType.HeroBattleEffect, self.projectileName)
    self.projectile.configTable.bounceBezier:DoBounceTarget(self.projectile.config.transform, self.projectileLaunchPos.position, targetPosition, 0.5, function ()
        self:OnTriggerActionResult()
        self:ReleaseProjectile()
    end)
end

--- @return ClientEffect
--- @param effectType number
--- @param effectName string
function ClientHero30006RangeAttack:GetEffect(effectType, effectName)
    local effect = self:GetClientEffect(effectType, effectName)
    local bounceBezierObject = SmartPool.Instance:SpawnGameObject(AssetType.GeneralBattleEffect, "bounce_bezier")
    effect:AddConfigField("bounceBezier", bounceBezierObject:GetComponent(ComponentName.BezierSpline))
    effect:Play()
    return effect
end

function ClientHero30006RangeAttack:BreakSkillAction()
    BaseRangeAttack.BreakSkillAction(self)
    self:ReleaseProjectile(true)
end

--- @param killAction boolean
function ClientHero30006RangeAttack:ReleaseProjectile(killAction)
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