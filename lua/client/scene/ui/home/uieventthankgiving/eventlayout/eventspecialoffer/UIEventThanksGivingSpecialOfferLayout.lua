require "lua.client.scene.ui.home.uiEventThankGiving.EventLayout.EventSpecialOffer.UISpecialOfferThanksGivingItemView"

--- @class UIEventThanksGivingSpecialOfferLayout : UIEventThanksGivingLayout
UIEventThanksGivingSpecialOfferLayout = Class(UIEventThanksGivingSpecialOfferLayout, UIEventThanksGivingLayout)

--- @param view UIEventView
function UIEventThanksGivingSpecialOfferLayout:Ctor(view, midAutumnTab, anchor)
    --- @type EventThankGivingModel
    self.eventModel = nil
    --- @type EventThanksGivingConfig
    self.eventConfig = nil
    --- @type UISpecialOfferMidAutumnConfig
    self.layoutConfig = nil
    --- @type UISpecialOfferThanksGivingItemView
    self.packList = nil

    UIEventThanksGivingLayout.Ctor(self, view, midAutumnTab, anchor)
end

function UIEventThanksGivingSpecialOfferLayout:OnShow()
    UIEventThanksGivingLayout.OnShow(self)
    for i = 1, self.packList:Count() do
        --- @type UISpecialOfferThanksGivingItemView
        local packItem = self.packList:Get(i)
        packItem:OnShow(i, self.eventModel.timeData.dataId)
    end
end

function UIEventThanksGivingSpecialOfferLayout:OnHide()
    UIEventThanksGivingLayout.OnHide(self)
end

function UIEventThanksGivingSpecialOfferLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("thanks_giving_special_offer", self.anchor)
    UIEventThanksGivingLayout.InitLayoutConfig(self, inst)

    --self.itemsTableView = ItemsTableView(self.layoutConfig.rewardAnchor)
    self:InitButtons()
    self:InitLocalization()
    self:InitPacks()
end

function UIEventThanksGivingSpecialOfferLayout:InitPacks()
    self.packList = List()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_THANKS_GIVING)
    for i = 1, self.layoutConfig.rectTrans.childCount do
        local packView = UISpecialOfferThanksGivingItemView(self.layoutConfig.rectTrans:GetChild(i - 1))
        self.packList:Add(packView)
    end
end


function UIEventThanksGivingSpecialOfferLayout:InitButtons()
end

function UIEventThanksGivingSpecialOfferLayout:InitLocalization()
end

