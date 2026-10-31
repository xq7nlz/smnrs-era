--- @class ClientHero40004ActiveSkill : BaseSkillShow
ClientHero40004ActiveSkill = Class(ClientHero40004ActiveSkill, BaseSkillShow)

function ClientHero40004ActiveSkill:DeliverCtor()
    self.treeFxName = string.format("hero_%d_fx_skill", self.baseHero.id)
    --- @type UnityEngine_Vector3
    self.moveDest = nil
    --- @type number
    self.rangeAttack = U_Vector3(3.5, 0, 0)
end

function ClientHero40004ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(40, function()
        self:StartAccost()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero40004ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1.7, 0.5, 0.3, ClientConfigUtils.DEFAULT_COVER_ALPHA)


    self:GetMoveDest(self.listTargetHero:Get(1))
end

function ClientHero40004ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero40004ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

function ClientHero40004ActiveSkill:OnCastEffect()
    for i = 1, self.listTargetHero:Count() do
        local hero = self.listTargetHero:Get(i)
        local target = self.clientBattleShowController:GetClientHeroByBaseHero(hero)
        local fx = self:GetClientEffect(AssetType.HeroBattleEffect, self.treeFxName)

        fx:SetToHeroAnchor(target)
    end
end

function ClientHero40004ActiveSkill:StartAccost()
    self:DoMovePosition(self.moveDest, nil, 8.0 / ClientConfigUtils.FPS, DOTweenEase.OutSine)
end

--- @param targetHero BaseHero
function ClientHero40004ActiveSkill:GetMoveDest(targetHero)
    local teamId = targetHero.teamId
    local isFrontLine = targetHero.positionInfo.isFrontLine
    if teamId == BattleConstants.DEFENDER_TEAM_ID and isFrontLine == true then
        self.moveDest = PositionConfig.frontLinePos - self.rangeAttack
    elseif teamId == BattleConstants.DEFENDER_TEAM_ID and isFrontLine == false then
        self.moveDest = PositionConfig.backLinePos - self.rangeAttack
    elseif teamId == BattleConstants.ATTACKER_TEAM_ID and isFrontLine == true then
        self.moveDest = U_Vector3(-PositionConfig.frontLinePos.x, PositionConfig.frontLinePos.y, 0) + self.rangeAttack
    elseif teamId == BattleConstants.ATTACKER_TEAM_ID and isFrontLine == false then
        self.moveDest = U_Vector3(-PositionConfig.backLinePos.x, PositionConfig.backLinePos.y, 0) + self.rangeAttack
    end
end

function ClientHero40004ActiveSkill:OnEndAnimation()
    self.clientHero:PlayIdleAnimation()
    self:DoMovePosition(self.clientHero.originPosition, function()
        BaseSkillShow.OnEndAnimation(self)
        self:OnEndTurn()
    end)
end

function ClientHero40004ActiveSkill:OnCompleteActionTurn()

end
