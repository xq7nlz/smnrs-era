--- @class ClientHero10019ActiveSkill : BaseSkillShow
ClientHero10019ActiveSkill = Class(ClientHero10019ActiveSkill, BaseSkillShow)

function ClientHero10019ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
    self.listLaunchPos = List()

    for i = 1, 5 do
        self.listLaunchPos:Add(self.clientHero.components:FindChildByPath("Model/launch_position_" .. i).position)
    end
end

--- @param actionResults List<BaseActionResult>
function ClientHero10019ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.6, 0.6, 0.4)

end

function ClientHero10019ActiveSkill:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName)
end

function ClientHero10019ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero10019ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end