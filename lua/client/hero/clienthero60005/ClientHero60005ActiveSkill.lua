--- @class ClientHero60005ActiveSkill : BaseSkillShow
ClientHero60005ActiveSkill = Class(ClientHero60005ActiveSkill, BaseSkillShow)

function ClientHero60005ActiveSkill:DeliverCtor()
    self.effectName = string.format("hero_%d_skill_impact", self.baseHero.id)
end

function ClientHero60005ActiveSkill:SetFx(fx)
    self.weaponFx = fx
end


function ClientHero60005ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(32, function()
        self:StartAccost()
    end)
    self:AddFrameAction(75, function()
        self.weaponFx.gameObject:SetActive(true)
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero60005ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
    self:DoCoverBattle(1.6, 0.5, 0.4)
end

function ClientHero60005ActiveSkill:DoAnimation()
    self.weaponFx.gameObject:SetActive(false)
    self.clientHero:PlayAnimation(self.animName, false, self.clientHero.mainTrackIndex)
    self.clientHero:PlayAnimationEffectByFrame(self.animName)
    self:PlayFrameAction(self.listFrameAction)
end

--function ClientHero60005ActiveSkill:StartAccost()
--    @type BaseHero
--    local baseTarget = self.listTargetHero:Get(1)
--    local moveDest = PositionConfig.GetAccostOpponentLinePosition(baseTarget.teamId, baseTarget.positionInfo.isFrontLine, 2)
--    self:DoMovePosition(moveDest, nil, 4 / ClientConfigUtils.FPS)
--end

function ClientHero60005ActiveSkill:StartAccost()
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self:AccostTarget(clientTargetHero, nil, nil, nil, 1 / ClientConfigUtils.FPS, DOTweenEase.OutSine)
end


function ClientHero60005ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero60005ActiveSkill:OnCompleteActionTurn()

end

function ClientHero60005ActiveSkill:OnEndAnimation()
    if self.clientHero.isPreviewOnly == true then
        BaseSkillShow.OnEndAnimation(self)
        return
    end
    if self.clientHero.isPlayingDead == true then
        self:OnEndTurn()
        return
    end

    self.clientHero:PlayIdleAnimation()
    self:DoMovePosition(self.clientHero.originPosition, function()
        BaseSkillShow.OnEndAnimation(self)
        self:OnEndTurn()
    end)
end

function ClientHero60005ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end