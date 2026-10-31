--- @class ClientHero10013ActiveSkill : BaseSkillShow
ClientHero10013ActiveSkill = Class(ClientHero10013ActiveSkill, BaseSkillShow)

function ClientHero10013ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(20, function()
        self:Accost()
    end)
    self:AddFrameAction(77, function()
        self:Backward()
    end)
end

function ClientHero10013ActiveSkill:Accost()
    self.clientHero.clientHeroMovement:SetPosition(PositionConfig.GetBattleCentralPosition())
end

function ClientHero10013ActiveSkill:Backward()
    self.clientHero.clientHeroMovement:SetPosition(self.clientHero.originPosition)
end

--- @param actionResults List<BaseActionResult>
function ClientHero10013ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1, 1.5, 0.8)

end

function ClientHero10013ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero10013ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end