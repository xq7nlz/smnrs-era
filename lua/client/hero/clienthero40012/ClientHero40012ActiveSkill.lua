--- @class ClientHero40012ActiveSkill : BaseSkillShow
ClientHero40012ActiveSkill = Class(ClientHero40012ActiveSkill, BaseSkillShow)

function ClientHero40012ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
    self.fxImpactName2 = string.format("hero_%d_skill_impact", self.baseHero.id)
end

function ClientHero40012ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(6, function()
        self:StartMove()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero40012ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero40012ActiveSkill:StartMove()
    self:DoMovePosition(PositionConfig.GetBattleCentralPosition(), function()
        self:DoCoverBattle(0.5, 1, 0.3)

    end, 11 / ClientConfigUtils.FPS)
end

function ClientHero40012ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero40012ActiveSkill:OnEndAnimation()
    if self.clientHero.heroModelType ~= HeroModelType.Full then
        BaseSkillShow.OnEndAnimation(self)
        return
    end
    if self.clientHero.isPlayingDead == true then
        BaseSkillShow.OnEndTurn(self)
        return
    end

    self:DoMovePosition(self.clientHero.originPosition, function()
        BaseSkillShow.OnEndAnimation(self)
        self:OnEndTurn()
    end)
end

function ClientHero40012ActiveSkill:OnCompleteActionTurn()

end

function ClientHero40012ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end