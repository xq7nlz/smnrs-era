require "lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventSpecialOffer.UISpecialOfferHalloweenItemView"

--- @class UIEventHalloweenSpecialOfferLayout : UIEventHalloweenLayout
UIEventHalloweenSpecialOfferLayout = Class(UIEventHalloweenSpecialOfferLayout, UIEventHalloweenLayout)

--- @param view UIEventView
function UIEventHalloweenSpecialOfferLayout:Ctor(view, midAutumnTab, anchor)
    --- @type EventHalloweenModel
    self.eventHalloweenModel = nil
    --- @type EventHalloweenConfig
    self.eventConfig = nil
    --- @type UISpecialOfferMidAutumnConfig
    self.layoutConfig = nil
    --- @type UISpecialOfferHalloweenItemView
    self.packList = nil

    UIEventHalloweenLayout.Ctor(self, view, midAutumnTab, anchor)
end

function UIEventHalloweenSpecialOfferLayout:OnShow()
    UIEventHalloweenLayout.OnShow(self)
    for i = 1, self.packList:Count() do
        --- @type UISpecialOfferHalloweenItemView
        local packItem = self.packList:Get(i)
        packItem:OnShow(i, self.eventHalloweenModel.timeData.dataId)
    end
end

function UIEventHalloweenSpecialOfferLayout:OnHide()
    UIEventHalloweenLayout.OnHide(self)
end

function UIEventHalloweenSpecialOfferLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("halloween_special_offer", self.anchor)
    UIEventHalloweenLayout.InitLayoutConfig(self, inst)

    --self.itemsTableView = ItemsTableView(self.layoutConfig.rewardAnchor)
    self:InitButtons()
    self:InitLocalization()
    self:InitPacks()
end

function UIEventHalloweenSpecialOfferLayout:InitPacks()
    self.packList = List()
    self.eventHalloweenModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_HALLOWEEN)
    for i = 1, self.layoutConfig.rectTrans.childCount do
        local packView = UISpecialOfferHalloweenItemView(self.layoutConfig.rectTrans:GetChild(i - 1))
        self.packList:Add(packView)
    end
end


function UIEventHalloweenSpecialOfferLayout:InitButtons()
end

function UIEventHalloweenSpecialOfferLayout:InitLocalization()
end

