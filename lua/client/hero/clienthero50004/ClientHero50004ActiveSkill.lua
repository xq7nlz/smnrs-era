--- @class ClientHero50004ActiveSkill : BaseSkillShow
ClientHero50004ActiveSkill = Class(ClientHero50004ActiveSkill, BaseSkillShow)

--- @param actionResults List - BaseActionResult
function ClientHero50004ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
    self:DoCoverBattle(1, 1, 0.4)

end

function ClientHero50004ActiveSkill:OnCastEffect()
    self:CastImpactFromConfig()
end

function ClientHero50004ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    self:CastSfxImpactFromConfig()
    self.clientHero:TriggerActionResult()
end

function ClientHero50004ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

function ClientHero50004ActiveSkill:DeliverSetFrameAction()
    if self.clientHero.skinId == 50004001 then
        local offsetX = 0.5
        local offSet = U_Vector2(offsetX,0)
        if (self.baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID) then
            offSet = U_Vector2(-offsetX,0)
        end
        self:AddFrameAction(6, function()
            self:DoMovePosition(PositionConfig.GetBattleCentralPosition() + offSet, nil, 0.26)
        end)
    end
end

function ClientHero50004ActiveSkill:OnEndAnimation()
--[[    if self.clientHero.heroModelType ~= HeroModelType.Full then
        BaseSkillShow.OnEndAnimation(self)
        return
    end]]
    if self.clientHero.skinId == 50004001 then
        self:DoMovePosition(self.clientHero.originPosition, function()
            BaseSkillShow.OnEndAnimation(self)
            self:OnEndTurn()
        end)
    else
        if self.clientHero.heroModelType >= HeroModelType.Full then
            BaseSkillShow.OnEndAnimation(self)
            self:OnEndTurn()
            --return
        end
    end
end

function ClientHero50004ActiveSkill:OnCompleteActionTurn()
    if self.clientHero.skinId == 50004001 then

    else
        BaseSkillShow.OnCompleteActionTurn(self)
    end
end