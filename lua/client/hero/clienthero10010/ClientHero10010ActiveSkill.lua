--- @class ClientHero10010ActiveSkill : BaseSkillShow
ClientHero10010ActiveSkill = Class(ClientHero10010ActiveSkill, BaseSkillShow)

function ClientHero10010ActiveSkill:DeliverCtor()
    self.effectName = self.clientHero:GetEffectNameByFormat("hero_%s_active_effect")
end

--- @param actionResults List<BaseActionResult>
function ClientHero10010ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.5, 1.5, 0.5)

end

function ClientHero10010ActiveSkill:OnCastEffect()
    for i = 1, self.listTargetHero:Count() do
        local effect = self:GetClientEffect(AssetType.HeroBattleEffect, self.effectName)
        if effect ~= nil then
            local target = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
            effect:SetToHeroAnchor(target)
            effect:UpdateSkin(self.clientHero.defaultSkinName)
        end
    end
end

function ClientHero10010ActiveSkill:OnTriggerActionResult()
    BaseSkillShow.OnTriggerActionResult(self)
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
end

function ClientHero10010ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end