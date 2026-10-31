--- @class ClientHero60012ActiveSkill : BaseSkillShow
ClientHero60012ActiveSkill = Class(ClientHero60012ActiveSkill, BaseSkillShow)

function ClientHero60012ActiveSkill:DeliverCtor()
    --- @type UnityEngine_Transform
    self.targetSkillBone = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/TargetSkill")
    --- @type string
    self.skillFxName = string.format("hero_%d_skill_fx", self.baseHero.id)
    --- @type ClientHero
    self.clientTargetHero = nil
end

--- @param actionResults List<BaseActionResult>
function ClientHero60012ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.8, 1, 0.3)


    self.clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self.targetSkillBone.position = self.clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)

    local targetPosition = self.clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR)
    self.clientHero.animation:UpdateLayer(targetPosition.y, 1)
end

function ClientHero60012ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero60012ActiveSkill:OnEndTurn()
    self.clientHero.animation:UpdateLayer(self.clientHero.originPosition.y)
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

function ClientHero60012ActiveSkill:OnCastEffect()
    local skillFx = self:GetClientEffect(AssetType.HeroBattleEffect, self.skillFxName)
    if skillFx ~= nil then
        skillFx:SetToHeroAnchor(self.clientTargetHero)
    end
end