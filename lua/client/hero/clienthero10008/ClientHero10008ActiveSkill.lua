--- @class ClientHero10008ActiveSkill : BaseSkillShow
ClientHero10008ActiveSkill = Class(ClientHero10008ActiveSkill, BaseSkillShow)

--- @param clientHero ClientHero
function ClientHero10008ActiveSkill:Ctor(clientHero)
    BaseSkillShow.Ctor(self, clientHero)
    if self.clientHero.heroModelType ~= HeroModelType.Full then
        return
    end
end

--- @param actionResults List<BaseActionResult>
function ClientHero10008ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1.2, 1, 0.4)

end

function ClientHero10008ActiveSkill:OnCastEffect()
    --self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect)
end

function ClientHero10008ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero10008ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end