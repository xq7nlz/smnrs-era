--- @class BaseRangeAttack : BaseSkillShow
BaseRangeAttack = Class(BaseRangeAttack, BaseSkillShow)

--- @param clientHero ClientHero
function BaseRangeAttack:Ctor(clientHero)
    self.fxImpactName = ClientConfigUtils.EFFECT_IMPACT_RANGE
    BaseSkillShow.Ctor(self, clientHero, true)
end

function BaseRangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position")
    if self.projectileLaunchPos == nil then
        self.projectileLaunchPos = self.clientHero.components:GetHeroAnchor(ClientConfigUtils.BODY_ANCHOR)
    end
end

--- @param actionResults List<BaseActionResult>
function BaseRangeAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

--- @param counterAttackResult CounterAttackResult
function BaseRangeAttack:CounterAttackOnTarget(counterAttackResult)
    BaseSkillShow.CounterAttackOnTarget(self, counterAttackResult)
    self:DoAnimation()
end

function BaseRangeAttack:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, nil, nil, self.projectileLaunchPos.position)
end

return BaseRangeAttack