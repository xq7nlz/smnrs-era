--- @class ClientHero50015ActiveSkill : BaseSkillShow
ClientHero50015ActiveSkill = Class(ClientHero50015ActiveSkill, BaseSkillShow)

function ClientHero50015ActiveSkill:DeliverCtor()
    self.effectName = string.format("hero_%d_active_effect", self.baseHero.id)
end

--- @param actionResults List<BaseActionResult>
function ClientHero50015ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1.6, 0.8, 0.4)

end

function ClientHero50015ActiveSkill:OnCastEffect()
    for i = 1, self.listTargetHero:Count() do
        local clientEffect = self:GetClientEffect(AssetType.HeroBattleEffect, self.effectName)
        if clientEffect ~= nil then
            local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
            clientEffect:UpdateSkin(self.clientHero.skinName)
            clientEffect:SetToHeroAnchor(clientTargetHero)
        end
    end
end

function ClientHero50015ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero50015ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end