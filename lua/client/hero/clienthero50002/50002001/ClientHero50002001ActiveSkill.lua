--- @class ClientHero50002001ActiveSkill : BaseSkillShow
ClientHero50002001ActiveSkill = Class(ClientHero50002001ActiveSkill, CastOnMovingSkill)

--- @param clientHero ClientHero
function ClientHero50002001ActiveSkill:Ctor(clientHero)
    CastOnMovingSkill.Ctor(self, clientHero, false, 7, 15)

    --- @type ClientHeroAnimation
    self.animation = ClientHeroAnimation(self.clientHero, 1)
    self.animation:Init(self.clientHero.gameObject.transform:GetChild(1).gameObject)
    self.pos = PositionConfig.GetBattleCentralPosition()
end

function ClientHero50002001ActiveSkill:StartAccost()
    self:DoMovePosition(self.pos, nil, self.jumpDuration / ClientConfigUtils.FPS)

    if self.animation ~= nil then
        self.animation:PlayAnimation("skill", false)
        self.animation:SetFlipByTeamId(self.baseHero.teamId)
        self:SetEnvironment()
    end
end

--- @param actionResults List<BaseActionResult>
function ClientHero50002001ActiveSkill:CastOnTarget(actionResults)
    CastOnMovingSkill.CastOnTarget(self, actionResults)

    self:DoCoverBattle(1.5, 1, 1)
end

function ClientHero50002001ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero50002001ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

function ClientHero50002001ActiveSkill:SetEnvironment()
    local effectName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_environment")
    local effect = self:GetClientEffect(AssetType.HeroBattleEffect, effectName)
    effect:SetPosition(PositionConfig.GetBattleCentralPosition())
    effect:Play()
end