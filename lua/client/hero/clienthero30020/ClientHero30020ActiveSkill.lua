--- @class ClientHero30020ActiveSkill : BaseSkillShow
ClientHero30020ActiveSkill = Class(ClientHero30020ActiveSkill, BaseSkillShow)

function ClientHero30020ActiveSkill:DeliverCtor()
    self.targetSkillBone = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/TargetSkill")
end

--- @param actionResults List<BaseActionResult>
function ClientHero30020ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.5, 0.8, 0.3)

end

function ClientHero30020ActiveSkill:OnCastEffect()
    if self.listTargetHero:Count() == 0 then
        return
    end
    --- @type ClientHero
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self.clientHero.animation:UpdateLayer(clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR).y, 2)
    self.targetSkillBone.position = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
end

function ClientHero30020ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero30020ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    self.clientHero.animation:UpdateLayer(self.clientHero.originPosition.y, 0)
    BaseSkillShow.OnEndTurn(self)
end