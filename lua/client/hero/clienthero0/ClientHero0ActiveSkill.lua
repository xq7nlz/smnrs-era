--- @class ClientHero0ActiveSkill : SummonerSkillShow
ClientHero0ActiveSkill = Class(ClientHero0ActiveSkill, SummonerSkillShow)

function ClientHero0ActiveSkill:PreloadVideoClip()
    self.videoClipName = string.format("video_summoner_%s_skill_1", self.baseHero.id)
    zg.battleEffectMgr:PreloadVideoClip(self.videoClipName)
end

function ClientHero0ActiveSkill:DeliverSetFrameActionWithVideo()
    self:AddFrameActionWithVideo(13, function()
        self:ShowCutSceneVideo()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero0ActiveSkill:CastOnTarget(actionResults)
    SummonerSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero0ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    SummonerSkillShow.OnTriggerActionResult(self)
end

function ClientHero0ActiveSkill:DarkScreenWithoutVideo()
    self.clientBattleShowController:DoCoverBattle(1.3, 0.5, 0.4)
    SummonerSkillShow.DarkScreenWithoutVideo(self)
end