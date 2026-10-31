--- @class ClientHero10023ActiveSkill : BaseSkillShow
ClientHero10023ActiveSkill = Class(ClientHero10023ActiveSkill, BaseSkillShow)

function ClientHero10023ActiveSkill:DeliverCtor()
    self.effSkillName = "hero_10023_eff_skill_" .. self.clientHero.skinName
end

--- @param actionResults List<BaseActionResult>
function ClientHero10023ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1, 1.6, 0.3)

end

function ClientHero10023ActiveSkill:OnCastEffect()
    for i = 1, self.listTargetHero:Count() do
        local effect = self:GetClientEffect(AssetType.HeroBattleEffect, self.effSkillName)
        if effect ~= nil then
            local targetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
            effect:SetToHeroAnchor(targetHero)
        end
    end
end

function ClientHero10023ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero10023ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end