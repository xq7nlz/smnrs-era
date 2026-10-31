--- @class ClientHero60022ActiveSkill : BaseSkillShow
ClientHero60022ActiveSkill = Class(ClientHero60022ActiveSkill, BaseSkillShow)

function ClientHero60022ActiveSkill:DeliverCtor()
    self.effSkillName = string.format("hero_%d_eff_skill_%s", self.baseHero.id, self.clientHero.skinName)
end

--- @param actionResults List<BaseActionResult>
function ClientHero60022ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1, 0.5, 0.4)

end

function ClientHero60022ActiveSkill:OnCastEffect()
    for i = 1, self.listTargetHero:Count() do
        local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
        local effSkill = self:GetClientEffect(AssetType.HeroBattleEffect, self.effSkillName)
        effSkill:SetToHeroAnchor(clientTargetHero)
        self:AdjustEffSkillPosition(effSkill)
    end
end

function ClientHero60022ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero60022ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

--- @param effSkill ClientEffect
function ClientHero60022ActiveSkill:AdjustEffSkillPosition(effSkill)
    local pos = effSkill:GetPosition()
    if self.baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
        pos.x = pos.x - ClientConfigUtils.OFFSET_ACCOST_X
    else
        pos.x = pos.x + ClientConfigUtils.OFFSET_ACCOST_X
    end
    effSkill:SetPosition(pos)
end