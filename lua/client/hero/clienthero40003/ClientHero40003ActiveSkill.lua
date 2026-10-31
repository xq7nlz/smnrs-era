--- @class ClientHero40003ActiveSkill : BaseSkillShow
ClientHero40003ActiveSkill = Class(ClientHero40003ActiveSkill, BaseSkillShow)

function ClientHero40003ActiveSkill:DeliverCtor()
    --- @type List | ClientEffect
    self.listProjectile = List()
    self.listLaunchPos = List()
    for i = 1, 3 do
        local anchor = self.clientHero.components:FindChildByPath("Model/skill_launch_position_" .. i)
        self.listLaunchPos:Add(anchor)
    end
end

function ClientHero40003ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(40, function()
        self:OnCastEffect(1)
    end)
    self:AddFrameAction(41, function()
        self:OnCastEffect(2)
    end)
    self:AddFrameAction(42, function()
        self:OnCastEffect(3)
    end)
    self:AddFrameAction(51, function()
        self:CastImpactFromConfig()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero40003ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.8, 1.5, 0.3, ClientConfigUtils.DEFAULT_COVER_ALPHA)

end

function ClientHero40003ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    self:CastSfxImpactFromConfig()
    self.clientHero:TriggerActionResult()
end

--- @param index number
function ClientHero40003ActiveSkill:OnCastEffect(index)
    local target = self.listTargetHero:Get(index)
    if target ~= nil then
        local clientTarget = self.clientBattleShowController:GetClientHeroByBaseHero(target)
        local bounceToPosition = clientTarget.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR)
        local projectile = self:GetProjectile(AssetType.HeroBattleEffect, self.projectileName)
        projectile.configTable.bounceBezier:DoBounceTarget(projectile.config.transform,
                self.listLaunchPos:Get(index).position,
                bounceToPosition,
                10 / ClientConfigUtils.FPS,
                function()
                    self:ReleaseProjectile(projectile)
                end)
    end
end

--- @return ClientEffect
--- @param effectType number
--- @param effectName string
function ClientHero40003ActiveSkill:GetProjectile(effectType, effectName)
    local effect = self:GetClientEffect(effectType, effectName)
    local bounceBezierObject = SmartPool.Instance:SpawnGameObject(AssetType.GeneralBattleEffect, "bounce_bezier")
    effect:AddConfigField("bounceBezier", bounceBezierObject:GetComponent(ComponentName.BezierSpline))
    effect:Play()
    self.listProjectile:Add(effect)
    return effect
end

--- @param projectile ClientEffect
--- @param killAction boolean
function ClientHero40003ActiveSkill:ReleaseProjectile(projectile, killAction)
    if self.listProjectile:IsContainValue(projectile) then
        SmartPool.Instance:DespawnGameObject(AssetType.GeneralBattleEffect, "bounce_bezier", projectile.configTable.bounceBezier.transform)
        projectile.configTable.bounceBezier:StopBounceTweener()
        projectile:Release()
        if killAction == true then
            projectile:KillAction()
        end
        self.listProjectile:RemoveByReference(projectile)
    end
end

function ClientHero40003ActiveSkill:BreakSkillAction()
    if self.listProjectile ~= nil and self.listProjectile:Count() > 0 then
        for i = self.listProjectile:Count(), 1, -1 do
            self:ReleaseProjectile(self.listProjectile:Get(i), true)
        end
    end
    self.listProjectile = List()
    BaseSkillShow.BreakSkillAction(self)
end

function ClientHero40003ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end