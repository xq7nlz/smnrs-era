--- @class BaseMeleeAttack : BaseSkillShow
BaseMeleeAttack = Class(BaseMeleeAttack, BaseSkillShow)

--- @param clientHero ClientHero
function BaseMeleeAttack:Ctor(clientHero)
    self.fxImpactName = ClientConfigUtils.EFFECT_IMPACT_MELEE
    BaseSkillShow.Ctor(self, clientHero, true)
end

--- @param actionResults List<BaseActionResult>
function BaseMeleeAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoActionOnListTarget()
end

function BaseMeleeAttack:DoActionOnListTarget()
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self:AccostTarget(clientTargetHero, function ()
        self:DoAnimation()
    end)
end

--- @param counterAttackResult CounterAttackResult
function BaseMeleeAttack:CounterAttackOnTarget(counterAttackResult)
    BaseSkillShow.CounterAttackOnTarget(self, counterAttackResult)
    self:DoActionOnListTarget()
end

function BaseMeleeAttack:OnEndAnimation()
    if self.actionCoroutine == nil then
        return
    end
    if self.clientHero.heroModelType ~= HeroModelType.Full then
        BaseSkillShow.OnEndAnimation(self)
        return
    end
    if self.clientHero.isPlayingDead == true then
        BaseSkillShow.OnEndTurn(self)
        return
    end

    self.clientHero:PlayIdleAnimation()
    if self.bonusTurnNum > 0 then
        BaseSkillShow.OnEndTurn(self)
    else
        self:DoMovePosition(self.clientHero.originPosition, function()
            BaseSkillShow.OnEndAnimation(self)
            BaseSkillShow.OnEndTurn(self)
        end)
    end
end

function BaseMeleeAttack:OnCompleteActionTurn()

end

return BaseMeleeAttack