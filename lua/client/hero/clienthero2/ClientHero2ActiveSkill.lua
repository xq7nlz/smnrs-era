--- @class ClientHero2ActiveSkill : SummonerSkillShow
ClientHero2ActiveSkill = Class(ClientHero2ActiveSkill, SummonerSkillShow)

function ClientHero2ActiveSkill:DeliverSetFrameActionWithVideo()
    self:AddFrameActionWithVideo(20, function()
        self:ShowCutSceneVideo()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero2ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero2ActiveSkill:OnCastEffect()

end

function ClientHero2ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero2ActiveSkill:DarkScreenWithoutVideo()
    self.clientBattleShowController:DoCoverBattle(1.6, 0.5, 0.4)
    SummonerSkillShow.DarkScreenWithoutVideo(self)
end