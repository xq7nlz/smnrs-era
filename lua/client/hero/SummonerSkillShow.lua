--- @class SummonerSkillShow : BaseSkillShow
SummonerSkillShow = Class(SummonerSkillShow, BaseSkillShow)

function SummonerSkillShow:DeliverCtor()
    self:PreloadVideoClip()
    --- @type List<table{number, function}>
    self.listFrameActionWithVideo = List()
    self.animVideo = "v_" .. AnimationConstants.SKILL_ANIM
end

function SummonerSkillShow:PreloadVideoClip()
    self.videoClipName = string.format("video_summoner_%s_skill_1_%s", self.baseHero.id, self.clientHero.skinName)
    zg.battleEffectMgr:PreloadVideoClip(self.videoClipName)
end

function SummonerSkillShow:DeliverSetFrameAction()
    self:AddFrameAction(0, function()
        self:DarkScreenWithoutVideo()
    end)
end

--- @param frameAnimLength number
--- @param frameEndTurn number
--- @param frameActionResult number
--- @param frameEffect number
function SummonerSkillShow:SetFrameActionEventWithVideo(frameAnimLength, frameEndTurn, frameActionResult, frameEffect)
    self:AddFrameActionWithVideo(frameAnimLength, function()
        self:OnEndAnimation()
    end)
    if self.clientHero.heroModelType ~= HeroModelType.Full then
        return
    end
    self:AddFrameActionWithVideo(frameEndTurn, function()
        self:OnCompleteActionTurn()
    end)
    self:AddFrameActionWithVideo(frameActionResult, function()
        self:OnTriggerActionResult()
    end)
    self:AddFrameActionWithVideo(frameEffect, function()
        self:OnCastEffect()
    end)
    self:DeliverSetFrameActionWithVideo()
end

function SummonerSkillShow:DeliverSetFrameActionWithVideo()

end

--- @param frame number
--- @param action function
function SummonerSkillShow:AddFrameActionWithVideo(frame, action)
    if frame < 0 then
        return
    end
    self.listFrameActionWithVideo = self:CreateSerializeListActionByFrame(frame, action, self.listFrameActionWithVideo)
end

function SummonerSkillShow:PlayFrameAction()
    ClientConfigUtils.KillCoroutine(self.actionCoroutine)
    if self.canShowVideo == true then
        BaseSkillShow.PlayFrameAction(self, self.listFrameActionWithVideo)
    else
        BaseSkillShow.PlayFrameAction(self, self.listFrameAction)
    end
end

function SummonerSkillShow:ShowCutSceneVideo()
    self.clientBattleShowController:ShowVideoCutScene(self.videoClipName,
            self.baseHero.teamId == BattleConstants.DEFENDER_TEAM_ID)
end

function SummonerSkillShow:GetAnimName()
    if self.canShowVideo == true then
        return self.animVideo
    end
    return AnimationConstants.SKILL_ANIM
end

function SummonerSkillShow:DoAnimation()
    self.canShowVideo = not PlayerSettingData.isSkipVideoBattle
    self.animName = self:GetAnimName()
    BaseSkillShow.DoAnimation(self)
end

function SummonerSkillShow:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

function SummonerSkillShow:DarkScreenWithoutVideo()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.FRONT_BATTLE_LAYER_ID)
end