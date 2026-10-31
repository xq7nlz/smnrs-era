--- @class UIQuestLayout
UIQuestLayout = Class(UIQuestLayout)

--- @param view UIQuestView
function UIQuestLayout:Ctor(view, opCodeClaim)
    self.view = view
    --- @type OpCode
    self.opCodeClaim = opCodeClaim
    --- @type UILoopScroll
    self.uiScroll = self.view.uiScroll
    --- @type UIQuestConfig
    self.config = view.config

    self:_InitConfig()
    self:InitLocalization()
end

function UIQuestLayout:_InitConfig()

end

function UIQuestLayout:OnShow()
    --- @type QuestDataInBound
    self.questDataInBound = self.view.questDataInBound

    self:SetUpLayout()
end

function UIQuestLayout:SetUpLayout()

end

function UIQuestLayout:OnHide()

end

function UIQuestLayout:OnClaimSuccess()

end

function UIQuestLayout:InitLocalization()

end

--- @return RewardInBound
function UIQuestLayout:GetExtraReward(questId)
    return nil
end