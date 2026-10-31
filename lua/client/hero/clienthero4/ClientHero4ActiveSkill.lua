--- @class ClientHero4ActiveSkill : SummonerSkillShow
ClientHero4ActiveSkill = Class(ClientHero4ActiveSkill, SummonerSkillShow)

function ClientHero4ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(60, function()
        self:CastImpactFromConfig()
    end)
end

function ClientHero4ActiveSkill:DeliverSetFrameActionWithVideo()
    self:AddFrameActionWithVideo(20, function()
        self:ShowCutSceneVideo()
    end)
    self:AddFrameActionWithVideo(125, function()
        self:CastImpactFromConfig()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero4ActiveSkill:CastOnTarget(actionResults)
    SummonerSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero4ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    self:CastSfxImpactFromConfig()
    self.clientHero:TriggerActionResult()
end

function ClientHero4ActiveSkill:DarkScreenWithoutVideo()
    self.clientBattleShowController:DoCoverBattle(3, 1, 0.4)
    SummonerSkillShow.DarkScreenWithoutVideo(self)
end