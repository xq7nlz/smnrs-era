--- @class ClientHero20008ActiveSkill : BaseSkillShow
ClientHero20008ActiveSkill = Class(ClientHero20008ActiveSkill, BaseSkillShow)

function ClientHero20008ActiveSkill:DeliverCtor()
    self.targetBone = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/target")
    self.projectileLaunchPos = self.targetBone:Find("skill_launch_position")
end

--- @param actionResults List<BaseActionResult>
function ClientHero20008ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self.targetBone.position = PositionConfig.GetBattleCentralPosition() + U_Vector3.up * 3

    self:DoCoverBattle(0.7, 1.5, 0.3, ClientConfigUtils.DEFAULT_COVER_ALPHA)

end

function ClientHero20008ActiveSkill:OnCastEffect()
    self:CastImpactFromConfig()
end

function ClientHero20008ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    self:CastSfxImpactFromConfig()
    self.clientHero:TriggerActionResult()
end

function ClientHero20008ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end