--- @class UIEventBossChallengeModel : UIBaseModel
UIEventBossChallengeModel = Class(UIEventBossChallengeModel, UIBaseModel)

--- @return void
function UIEventBossChallengeModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventBossChallenge, "ui_event_boss_challenge")
end

function UIEventBossChallengeModel:InitListSubEvent()
	self.listSubEvent = List()
	self.listSubEvent:Add(EventBossChallengeTab.PREMIUM_PASS)
	self.listSubEvent:Add(EventBossChallengeTab.CHALLENGE_TOWER)
	self.listSubEvent:Add(EventBossChallengeTab.BOSS_QUEST)
	self.listSubEvent:Add(EventBossChallengeTab.BOSS_PACK)
	--self.listSubEvent:Add(EventBossChallengeTab.BOSS_LEADER_BOARD)
end