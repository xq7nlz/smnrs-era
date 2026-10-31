--- @class UIEventNewYearLayout : UIEventLayout
UIEventNewYearLayout = Class(UIEventNewYearLayout, UIEventLayout)

--- @param view UIEventNewYearView
--- @param newYearTab NewYearTab
--- @param anchor UnityEngine_RectTransform
function UIEventNewYearLayout:Ctor(view, newYearTab, anchor)
    --- @type UIEventNewYearView
    self.view = view
    --- @type NewYearTab
    self.newYearTab = newYearTab
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventNewYearModel
    self.eventModel = nil
    --- @type EventNewYearConfig
    self.eventConfig = nil

    self.opCode = OpCode.EVENT_CHRISTMAS_EXCHANGE_RESOURCE

    self.moneyTypeShow = MoneyType.EVENT_CHRISTMAS_CANDY_BAR

    self.eventTimeType = EventTimeType.EVENT_NEW_YEAR
    UIEventLayout.Ctor(self, view, self.eventTimeType)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIEventNewYearLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
end

function UIEventNewYearLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventNewYearLayout:SetEventBanner()
end

function UIEventNewYearLayout:SetEventTitle()
end

function UIEventNewYearLayout:SetEventDesc()
end

function UIEventNewYearLayout:OnShow()
    self:GetModelConfig()
    UIEventLayout.OnShow(self)
end

function UIEventNewYearLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end




