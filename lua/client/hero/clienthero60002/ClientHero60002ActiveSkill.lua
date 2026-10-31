--- @class ClientHero60002ActiveSkill : BaseSkillShow
ClientHero60002ActiveSkill = Class(ClientHero60002ActiveSkill, BaseSkillShow)

function ClientHero60002ActiveSkill:DeliverCtor()
    self.effectName = string.format("hero_%d_eff_skill_%s", self.baseHero.id, self.clientHero.skinName)
    if self.baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
        self.offsetStart = U_Vector3(3, 0.8, 0)
        self.offsetAccost = U_Vector3(-2, 0.35, 0)
    else
        self.offsetStart = U_Vector3(3, 0.8, 0)
        self.offsetAccost = U_Vector3(2, 0.35, 0)
    end
end

--- @param actionResults List<BaseActionResult>
function ClientHero60002ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.5, 1, 0.3)

end

function ClientHero60002ActiveSkill:OnCastEffect()
    for i = 1, self.listTargetHero:Count() do
        local effect = self:GetSkillEffect()
        if effect ~= nil then
            effect:SetToHeroAnchor(self.clientHero)
            local targetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
            local movePos = targetHero.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR)
            movePos = movePos + self.offsetAccost
            effect.configTable.moveSkill.transform:DOMove(movePos, 9.0 / ClientConfigUtils.FPS):SetDelay(26.0 / ClientConfigUtils.FPS)
        end
    end
end

function ClientHero60002ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero60002ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

--- @return ClientEffect
function ClientHero60002ActiveSkill:GetSkillEffect()
    local effect = self:GetClientEffect(AssetType.HeroBattleEffect, self.effectName)
    if effect == nil then
        return nil
    end
    if effect.configTable.moveSkill == nil then
        local moveSkillBone = effect.config.transform:Find("view/SkeletonUtility-Root/root/moveSkill")
        effect:AddConfigField("moveSkill", moveSkillBone)
    end
    effect.configTable.moveSkill.localPosition = self.offsetStart
    return effect
end