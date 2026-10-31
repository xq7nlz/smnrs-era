require "lua.client.scene.ui.home.uiEventBlossomDay.EventLayout.specialOffer.UISpecialOfferBlossomDayItemView"

--- @class UIEventBlossomDaySpecialOfferLayout : UIEventBlossomDayLayout
UIEventBlossomDaySpecialOfferLayout = Class(UIEventBlossomDaySpecialOfferLayout, UIEventBlossomDayLayout)

--- @param view UIEventView
function UIEventBlossomDaySpecialOfferLayout:Ctor(view, midAutumnTab, anchor)
    --- @type EventBlossomDayModel
    self.eventModel = nil
    --- @type EventBlossomDayConfig
    self.eventConfig = nil
    --- @type UISpecialOfferBlossomDayConfig
    self.layoutConfig = nil
    --- @type UISpecialOfferBlossomDayItemView
    self.packList = nil

    UIEventBlossomDayLayout.Ctor(self, view, midAutumnTab, anchor)
end

function UIEventBlossomDaySpecialOfferLayout:OnShow()
    UIEventBlossomDayLayout.OnShow(self)
    for i = 1, self.packList:Count() do
        --- @type UISpecialOfferBlossomDayItemView
        local packItem = self.packList:Get(i)
        packItem:OnShow(i, self.eventModel.timeData.dataId)
    end
end

function UIEventBlossomDaySpecialOfferLayout:OnHide()
    UIEventBlossomDayLayout.OnHide(self)
end

function UIEventBlossomDaySpecialOfferLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("blossom_day_special_offer", self.anchor)
    UIEventBlossomDayLayout.InitLayoutConfig(self, inst)

    --self.itemsTableView = ItemsTableView(self.layoutConfig.rewardAnchor)
    self:InitButtons()
    self:InitLocalization()
    self:InitPacks()
end

function UIEventBlossomDaySpecialOfferLayout:InitPacks()
    self.packList = List()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BLOSSOM)
    for i = 1, self.layoutConfig.rectTrans.childCount do
        local packView = UISpecialOfferBlossomDayItemView(self.view, self.layoutConfig.rectTrans:GetChild(i - 1))
        self.packList:Add(packView)
    end
end


function UIEventBlossomDaySpecialOfferLayout:InitButtons()
end

function UIEventBlossomDaySpecialOfferLayout:InitLocalization()
end

