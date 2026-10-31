--- @class ClientHero60021ActiveSkill : BaseSkillShow
ClientHero60021ActiveSkill = Class(ClientHero60021ActiveSkill, BaseSkillShow)

function ClientHero60021ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position_skill").position
end

--- @param actionResults List<BaseActionResult>
function ClientHero60021ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1, 1, 0.5)

end

function ClientHero60021ActiveSkill:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName)
end


function ClientHero60021ActiveSkill:OnTriggerActionResult()
    BaseSkillShow.OnTriggerActionResult(self)
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
end

function ClientHero60021ActiveSkill:ShakeOnDropArrow()
    self.clientBattleShowController:DoShake({ 1.3, 0.08, 0.15, 75, 0.1 })
end

function ClientHero60021ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

--- @param position Vector2
function ClientHero60021ActiveSkill:FallAnArrow(position)
    local effect = self:GetClientEffect(AssetType.HeroBattleEffect, self.effArrow)
    effect:SetPosition(position)
    effect:Play()
end