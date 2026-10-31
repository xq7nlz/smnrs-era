--- @class ClientHero10009ActiveSkill : BaseSkillShow
ClientHero10009ActiveSkill = Class(ClientHero10009ActiveSkill, BaseSkillShow)

function ClientHero10009ActiveSkill:DeliverCtor()
    self.fxImpactName = "impact_water"
    self.projectileLaunchPos = self.clientHero.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR)
end

--- @param actionResults List<BaseActionResult>
function ClientHero10009ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.5, 1, 0.3)

end

function ClientHero10009ActiveSkill:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, 0.7, ClientConfigUtils.FOOT_ANCHOR)
end

function ClientHero10009ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
    self:CastNewClientImpactOnTargets(AssetType.GeneralBattleEffect, self.fxImpactName)
end

--- @param effectType string
--- @param effectName string
--- @param flyTime number
--- @param targetAnchorId number
function ClientHero10009ActiveSkill:CastNewProjectileOnTargets(effectType, effectName, flyTime, targetAnchorId)
    flyTime = flyTime or ClientConfigUtils.PROJECTILE_FRY_TIME
    targetAnchorId = targetAnchorId or ClientConfigUtils.BODY_ANCHOR
    --- @type ClientHero
    local clientTargetHero
    --- @type ClientEffect
    local targetPosition
    for i = 1, self.listTargetHero:Count() do
        local projectile = self:GetClientEffect(effectType, effectName)
        if projectile ~= nil then
            clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
            targetPosition = clientTargetHero.components:GetAnchorPosition(targetAnchorId)
            projectile:SetPosition(self.projectileLaunchPos)
            projectile:DoMoveTween(targetPosition, flyTime, function ()
                projectile:Release()
            end)
            projectile:Play()
        end
    end
end

function ClientHero10009ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end