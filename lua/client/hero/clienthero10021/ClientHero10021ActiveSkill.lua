--- @class ClientHero10021ActiveSkill : BaseSkillShow
ClientHero10021ActiveSkill = Class(ClientHero10021ActiveSkill, BaseSkillShow)

--- @param actionResults List<BaseActionResult>
function ClientHero10021ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))

    self:AccostTarget(clientTargetHero, function ()
        self:DoAnimation()
    end)

    self:DoCoverBattle(0.3, 1, 0.4)

end

function ClientHero10021ActiveSkill:OnEndAnimation()
    if self.clientHero.heroModelType ~= HeroModelType.Full then
        BaseSkillShow.OnEndAnimation(self)
        return
    end
    if self.clientHero.isPlayingDead == true then
        BaseSkillShow.OnEndTurn(self)
        return
    end

    self.clientHero:PlayIdleAnimation()
    self:DoMovePosition(self.clientHero.originPosition, function()
        BaseSkillShow.OnEndAnimation(self)
        self:OnEndTurn()
    end)
end

function ClientHero10021ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero10021ActiveSkill:OnCompleteActionTurn()

end

function ClientHero10021ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end