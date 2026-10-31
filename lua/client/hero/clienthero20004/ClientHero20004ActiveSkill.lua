--- @class ClientHero20004ActiveSkill : BaseSkillShow
ClientHero20004ActiveSkill = Class(ClientHero20004ActiveSkill, BaseSkillShow)

function ClientHero20004ActiveSkill:DeliverCtor()
    self.effSkillName = string.format("hero_%d_effect_skill", self.baseHero.id)
end

function ClientHero20004ActiveSkill:DeliverCtor()
    self:AddFrameAction(38, function()
        self:Accost()
    end)
    self:AddFrameAction(79, function()
        self:Backward()
    end)
end

function ClientHero20004ActiveSkill:Accost()
    local movePos --= PositionConfig.GetBattleCentralPosition()
    --movePos.y = movePos.y - 1

    if self.baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
        movePos = (U_Vector3(8, 0, 0))
    else
        movePos = (U_Vector3(-8, 0, 0))
    end
    self.clientHero.clientHeroMovement:SetPosition(movePos)
end

function ClientHero20004ActiveSkill:Backward()
    self.clientHero.clientHeroMovement:SetPosition(self.clientHero.originPosition)
end

--- @param actionResults List<BaseActionResult>
function ClientHero20004ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1, 1.6, 0.3)

end

function ClientHero20004ActiveSkill:OnCastEffect()

end

function ClientHero20004ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero20004ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end