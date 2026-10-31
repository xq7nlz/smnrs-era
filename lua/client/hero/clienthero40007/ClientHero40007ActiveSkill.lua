--- @class ClientHero40007ActiveSkill : BaseSkillShow
ClientHero40007ActiveSkill = Class(ClientHero40007ActiveSkill, BaseSkillShow)

--- @param clientHero ClientHero
function ClientHero40007ActiveSkill:Ctor(clientHero)
    BaseSkillShow.Ctor(self, clientHero)
    if self.clientHero.heroModelType ~= HeroModelType.Full then
        return
    end
end

--- @param actionResults List<BaseActionResult>
function ClientHero40007ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1.2, 1, 0.3)

end

function ClientHero40007ActiveSkill:OnCastEffect()
    --self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName)
end

function ClientHero40007ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero40007ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end