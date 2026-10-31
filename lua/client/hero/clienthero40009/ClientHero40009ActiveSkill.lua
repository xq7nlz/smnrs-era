--- @class ClientHero40009ActiveSkill : BaseSkillShow
ClientHero40009ActiveSkill = Class(ClientHero40009ActiveSkill, BaseSkillShow)

function ClientHero40009ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end

--- @param actionResults List<BaseActionResult>
function ClientHero40009ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1, 0.5, 0.4)

end

function ClientHero40009ActiveSkill:OnCastEffect()
    --- @type ClientHero
    local target = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    for i = 1, 3 do
        local effectName = string.format("hero_%s_eff_skill_%s_%s", self.baseHero.id, i, self.clientHero.skinName)
        local effect = self:GetClientEffect(AssetType.HeroBattleEffect, effectName)
        effect:SetToHeroAnchor(target)
    end
end

function ClientHero40009ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero40009ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end