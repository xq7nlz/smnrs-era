--- @class ClientHero50010ActiveSkill : BaseSkillShow
ClientHero50010ActiveSkill = Class(ClientHero50010ActiveSkill, BaseSkillShow)

function ClientHero50010ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR)
    self.projectileName = string.format("hero_%d_%s", self.baseHero.id, ClientConfigUtils.DEFAULT_SKILL_PROJECTILE)
end

--- @param actionResults List<BaseActionResult>
function ClientHero50010ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1, 1, 0.3)

end

function ClientHero50010ActiveSkill:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, 0.7, ClientConfigUtils.FOOT_ANCHOR)
end

function ClientHero50010ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero50010ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

--- @param effectType string
--- @param effectName string
--- @param flyTime number
--- @param targetAnchorId number
function ClientHero50010ActiveSkill:CastNewProjectileOnTargets(effectType, effectName, flyTime, targetAnchorId)
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