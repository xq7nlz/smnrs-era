
--- @class UIEventSkinChallengeModel : UIBaseModel
UIEventSkinChallengeModel = Class(UIEventSkinChallengeModel, UIBaseModel)

--- @return void
function UIEventSkinChallengeModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventSkinChallenge, "ui_event_skin_challenge")
end

function UIEventSkinChallengeModel:InitListSubEvent()
	self.listSubEvent = List()
	self.listSubEvent:Add(EventSkinChallengeTab.QUEST)
	self.listSubEvent:Add(EventSkinChallengeTab.SELECT)
end