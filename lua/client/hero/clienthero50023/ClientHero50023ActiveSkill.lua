--- @class ClientHero50023ActiveSkill : BaseSkillShow
ClientHero50023ActiveSkill = Class(ClientHero50023ActiveSkill, BaseSkillShow)

function ClientHero50023ActiveSkill:DeliverCtor()
    self.fxSkillName = string.format("hero_%d_fxskill_%s", self.baseHero.id, self.clientHero.skinName)
end

--- @param actionResults List<BaseActionResult>
function ClientHero50023ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1, 1, 0.3)

end

function ClientHero50023ActiveSkill:OnCastEffect()
    --- @type ClientHero
    local clientTargetHero
    --- @type ClientEffect
    local fxskill
    for i = 1, self.listTargetHero:Count() do
        fxskill = self:GetClientEffect(AssetType.HeroBattleEffect, self.fxSkillName)
        if fxskill ~= nil then
            clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
            fxskill:SetToHeroAnchor(clientTargetHero)
        end
    end
end

function ClientHero50023ActiveSkill:OnTriggerActionResult()
    BaseSkillShow.OnTriggerActionResult(self)
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
end

function ClientHero50023ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end