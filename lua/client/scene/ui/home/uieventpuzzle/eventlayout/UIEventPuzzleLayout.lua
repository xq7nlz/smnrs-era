--- @class UIEventPuzzleLayout : UIEventLayout
UIEventPuzzleLayout = Class(UIEventPuzzleLayout, UIEventLayout)

--- @param view UIEventPuzzleView
--- @param tab EventPuzzleTab
--- @param anchor UnityEngine_RectTransform
function UIEventPuzzleLayout:Ctor(view, tab, anchor)
    --- @type UIEventPuzzleView
    self.view = view
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventPuzzleModel
    self.eventModel = nil
    --- @type EventPuzzleConfig
    self.eventConfig = nil
    self.opCode = nil
    self.eventTimeType = EventTimeType.EVENT_PUZZLE
    UIEventLayout.Ctor(self, view, self.eventTimeType)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIEventPuzzleLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
    self:GetModelConfig()
end

function UIEventPuzzleLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventPuzzleLayout:SetEventBanner()
end

function UIEventPuzzleLayout:SetEventTitle()
end

function UIEventPuzzleLayout:SetEventDesc()
end

function UIEventPuzzleLayout:UpdateNotification()
end



function UIEventPuzzleLayout:OnShow()
    self:GetModelConfig()
    UIEventLayout.OnShow(self)
end

function UIEventPuzzleLayout:OnHide()
    UIEventLayout.OnHide(self)
    self.anchor.gameObject:SetActive(false)
end

function UIEventPuzzleLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end