--- @class ClientHero20011ActiveSkill : BaseSkillShow
ClientHero20011ActiveSkill = Class(ClientHero20011ActiveSkill, BaseSkillShow)

function ClientHero20011ActiveSkill:DeliverCtor()
    self.fxSkillName = string.format("hero_%s_fx_skill_%s", self.baseHero.id, self.clientHero.skinName)
end

--- @param actionResults List<BaseActionResult>
function ClientHero20011ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.5, 1, 0.3)

end

function ClientHero20011ActiveSkill:OnCastEffect()
    --- @type ClientHero
    local clientTargetHero
    --- @type ClientEffect
    local fxSkill
    for i = 1, self.listTargetHero:Count() do
        fxSkill = self:GetClientEffect(AssetType.HeroBattleEffect, self.fxSkillName)
        if fxSkill ~= nil then
            clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
            fxSkill:SetToHeroAnchor(clientTargetHero)
        end
    end
end

function ClientHero20011ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero20011ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end