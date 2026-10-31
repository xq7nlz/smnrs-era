--- @class ClientHero3ActiveSkill : SummonerSkillShow
ClientHero3ActiveSkill = Class(ClientHero3ActiveSkill, SummonerSkillShow)

function ClientHero3ActiveSkill:DeliverSetFrameActionWithVideo()
    self:AddFrameActionWithVideo(20, function()
        self:ShowCutSceneVideo()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero3ActiveSkill:CastOnTarget(actionResults)
    SummonerSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero3ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    SummonerSkillShow.OnTriggerActionResult(self)
end

function ClientHero3ActiveSkill:DarkScreenWithoutVideo()
    self.clientBattleShowController:DoCoverBattle(1.6, 0.5, 0.4)
    SummonerSkillShow.DarkScreenWithoutVideo(self)
end