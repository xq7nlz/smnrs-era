--- @class ClientHero10018ActiveSkill : BaseSkillShow
ClientHero10018ActiveSkill = Class(ClientHero10018ActiveSkill, BaseSkillShow)

function ClientHero10018ActiveSkill:DeliverCtor()
    self.effSkillName = string.format("hero_%d_eff_skill_%s", self.baseHero.id, self.clientHero.skinName)
    self.maskName = string.format("hero_%d_skill_mask", self.baseHero.id)
end

function ClientHero10018ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(0, function()
        self:CallMaskOnTargets()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero10018ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.5, 0.7, 0.3)


    self.clientHero.animation:ChangeSortingLayerId(ClientConfigUtils.EFFECT_LAYER_ID)
end

function ClientHero10018ActiveSkill:CallMaskOnTargets()
    for i = 1, self.listTargetHero:Count() do
        --- @type ClientHero
        local clientHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
        local effect = self:GetClientEffect(AssetType.HeroBattleEffect, self.maskName)
        effect:SetToHeroAnchor(clientHero)
    end
end

function ClientHero10018ActiveSkill:OnCastEffect()
    --- @type BaseHero
    local target = self.listTargetHero:Get(1)
    --- @type ClientHero
    local clientTarget = self.clientBattleShowController:GetClientHeroByBaseHero(target)
    --- @type ClientEffect
    local effect = self:GetClientEffect(AssetType.HeroBattleEffect, self.effSkillName)
    effect:SetToHeroAnchor(clientTarget)

    if target.teamId == BattleConstants.ATTACKER_TEAM_ID then
        if target.positionInfo.isFrontLine == true then
            effect:SetPosition(U_Vector3(-5.7, -0.63, 0))
        else
            effect:SetPosition(U_Vector3(-8, 0, 0))
        end
    else
        if target.positionInfo.isFrontLine == true then
            effect:SetPosition(U_Vector3(5.7, -0.63, 0))
        else
            effect:SetPosition(U_Vector3(8, 0, 0))
        end
    end
end

function ClientHero10018ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero10018ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end