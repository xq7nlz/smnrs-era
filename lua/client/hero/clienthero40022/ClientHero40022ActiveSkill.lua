--- @class ClientHero40022ActiveSkill : BaseSkillShow
ClientHero40022ActiveSkill = Class(ClientHero40022ActiveSkill, BaseSkillShow)

function ClientHero40022ActiveSkill:DeliverCtor()
    self.moveSkillBone = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/move_skill")
end

function ClientHero40022ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(38, function()
        self:CastImpactFromConfig()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero40022ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1, 1, 0.3)


    self:SetBoneOnTarget()
end

function ClientHero40022ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    self.clientHero:TriggerActionResult()
end

function ClientHero40022ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

function ClientHero40022ActiveSkill:SetBoneOnTarget()
    --- @type ClientHero
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    local targetPosition =  clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
    --- @type UnityEngine_Vector3
    local dir = targetPosition - self.clientHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
    targetPosition = targetPosition + dir.normalized * 2
    self.moveSkillBone.position = targetPosition
end