--- @class ClientHero20002ActiveSkill : BaseSkillShow
ClientHero20002ActiveSkill = Class(ClientHero20002ActiveSkill, BaseSkillShow)

function ClientHero20002ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position_skill").position
end

function ClientHero20002ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(57, function()
        self:CastImpactFromConfig()
        self:CastSfxImpactFromConfig()
    end, "Impact")
end

--- @param actionResults List<BaseActionResult>
function ClientHero20002ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.5, 1, 0.3)

end

function ClientHero20002ActiveSkill:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName)
end

function ClientHero20002ActiveSkill:OnTriggerActionResult()
    --BaseSkillShow.OnTriggerActionResult(self)
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    self.clientHero:TriggerActionResult()
end

function ClientHero20002ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end