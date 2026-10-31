--- @class ClientHero50012ActiveSkill : BaseSkillShow
ClientHero50012ActiveSkill = Class(ClientHero50012ActiveSkill, BaseSkillShow)

function ClientHero50012ActiveSkill:DeliverCtor()
    self.effectName = self.clientHero:GetEffectNameByFormat("hero_%d_eff_skill_%s")
end

--- @param actionResults List<BaseActionResult>
function ClientHero50012ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1, 0.5, 0.4)

end

function ClientHero50012ActiveSkill:OnCastEffect()
    for i = 1, self.listTargetHero:Count() do
        local effect = self:GetSkillEffect()
        if effect ~= nil then
            effect:SetToHeroAnchor(self.clientHero)
            local targetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
            local targetPos = targetHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
            effect.configTable.moveSkill.position = targetPos
        end
    end
end

function ClientHero50012ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero50012ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

--- @return ClientEffect
function ClientHero50012ActiveSkill:GetSkillEffect()
    local effect = self:GetClientEffect(AssetType.HeroBattleEffect, self.effectName)
    if effect == nil then
        return nil
    end
    if effect.configTable.moveSkill == nil then
        local moveSkillBone = effect.config.transform:Find("view/SkeletonUtility-Root/root/moveSkill")
        effect:AddConfigField("moveSkill", moveSkillBone)
    end
    return effect
end