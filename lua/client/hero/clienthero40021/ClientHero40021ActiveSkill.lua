--- @class ClientHero40021ActiveSkill : BaseSkillShow
ClientHero40021ActiveSkill = Class(ClientHero40021ActiveSkill, BaseSkillShow)

function ClientHero40021ActiveSkill:DeliverCtor()
    self.effectName = string.format("hero_%d_eff_skill_%s", self.baseHero.id, self.clientHero.skinName)
end

--- @param actionResults List<BaseActionResult>
function ClientHero40021ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.5, 0.8, 0.3)

end

function ClientHero40021ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero40021ActiveSkill:OnCastEffect()
    --- @type ClientEffect
    local effectSkill
    --- @type ClientHero
    local clientTargetHero
    Coroutine.start(function()
        for i = 1, self.listTargetHero:Count() do
            effectSkill = self:GetClientEffect(AssetType.HeroBattleEffect, self.effectName)
            clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
            effectSkill:SetToHeroAnchor(clientTargetHero)
            coroutine.waitforseconds(0.1)
        end
    end)
end

function ClientHero40021ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end