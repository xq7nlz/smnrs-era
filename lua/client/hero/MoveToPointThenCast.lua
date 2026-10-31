--- @class MoveToPointThenCast : BaseSkillShow
MoveToPointThenCast = Class(MoveToPointThenCast, BaseSkillShow)

--- @param clientHero ClientHero
--- @param isBasicAttack boolean
function MoveToPointThenCast:Ctor(clientHero, isBasicAttack)
    BaseSkillShow.Ctor(self, clientHero, isBasicAttack)
end

--- @param actionResults List<BaseActionResult>
function MoveToPointThenCast:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:MoveThenCast()
end

function MoveToPointThenCast:MoveThenCast()
    self:DoMovePosition(PositionConfig.GetBattleCentralPosition(), function()
        self:DoAnimation()
    end)
end

function MoveToPointThenCast:OnEndAnimation()
    if self.actionCoroutine == nil then
        return
    end
    if self.clientHero.heroModelType ~= HeroModelType.Full then
        self:OnEndAnimation()
        return
    end
    if self.clientHero.isPlayingDead == true then
        self:OnEndTurn()
        return
    end

    self.clientHero:PlayIdleAnimation()
    if self.bonusTurnNum > 0 then
        self:OnEndTurn()
    else
        self:DoMovePosition(self.clientHero.originPosition, function()
            self:OnEndAnimation()
            self:OnEndTurn()
        end)
    end
end

function MoveToPointThenCast:OnCompleteActionTurn()

end