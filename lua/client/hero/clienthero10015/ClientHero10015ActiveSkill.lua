--- @class ClientHero10015ActiveSkill : BaseSkillShow
ClientHero10015ActiveSkill = Class(ClientHero10015ActiveSkill, BaseSkillShow)

function ClientHero10015ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position")
    self.targetAttackBone = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/target_skill")
    --- @type ClientHero
    self.currentTarget = nil
    --- @type number
    self.targetIndex = 1
end

function ClientHero10015ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(38, function()
        self:SwitchTarget()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero10015ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
    self.targetIndex = 1

    self:DoCoverBattle(0.5, 1, 0.3)


    self.currentTarget = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self.targetAttackBone.position = self.currentTarget.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
end

function ClientHero10015ActiveSkill:OnCastEffect()
    local targetHero
    local clientTargetHero
    local targetPosition
    local projectile = self:GetClientEffect(AssetType.HeroBattleEffect, self.projectileName)
    if projectile ~= nil then
        targetHero = self.listTargetHero:Get(self.targetIndex)
        clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(targetHero)
        targetPosition = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
        projectile:SetPosition(self.projectileLaunchPos.position)
        projectile:LookAtPosition(targetPosition)
        projectile:DoMoveTween(targetPosition, ClientConfigUtils.PROJECTILE_FRY_TIME, function ()
            projectile:Release()
            self:CastImpactOnTarget(clientTargetHero)
            self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
        end)
        projectile:Play()
    end
end

function ClientHero10015ActiveSkill:OnTriggerActionResult()
    self.clientHero:TriggerActionResult()
end

--- @param clientTargetHero ClientHero
function ClientHero10015ActiveSkill:CastImpactOnTarget(clientTargetHero)
    if self.fxImpactConfig == nil then
        return
    end
    local fxImpact = self:GetClientEffect(self.fxImpactConfig.skill_impact_type, self.fxImpactConfig.skill_impact_name)
    if fxImpact ~= nil then
        fxImpact:SetToHeroAnchor(clientTargetHero)
    end
end

function ClientHero10015ActiveSkill:SwitchTarget()
    self.targetIndex = self.targetIndex + 1
    if self.targetIndex > self.listTargetHero:Count() then
        self.targetIndex = self.listTargetHero:Count()
    end
    self.currentTarget = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(self.targetIndex))
    self.targetAttackBone.position = self.currentTarget.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)

    self:OnCastEffect()
end

function ClientHero10015ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end