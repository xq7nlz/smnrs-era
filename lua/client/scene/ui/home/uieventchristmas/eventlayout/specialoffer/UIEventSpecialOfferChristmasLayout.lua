require "lua.client.scene.ui.home.uiEventChristmas.eventLayout.specialOffer.UISpecialOfferChristmasItemView"

--- @class UIEventSpecialOfferChristmasLayout : UIEventChristmasLayout
UIEventSpecialOfferChristmasLayout = Class(UIEventSpecialOfferChristmasLayout, UIEventChristmasLayout)

--- @param view UIEventView
function UIEventSpecialOfferChristmasLayout:Ctor(view, midAutumnTab, anchor)
    --- @type EventChristmasModel
    self.eventModel = nil
    --- @type EventChristmasConfig
    self.eventConfig = nil
    --- @type UISpecialOfferChristmasConfig
    self.layoutConfig = nil
    --- @type UISpecialOfferMidAutumnItemView
    self.packList = nil

    UIEventChristmasLayout.Ctor(self, view, midAutumnTab, anchor)
end

function UIEventSpecialOfferChristmasLayout:OnShow()
    UIEventChristmasLayout.OnShow(self)
    for i = 1, self.packList:Count() do
        --- @type UISpecialOfferMidAutumnItemView
        local packItem = self.packList:Get(i)
        packItem:OnShow(i, self.eventModel.timeData.dataId)
    end
end

function UIEventSpecialOfferChristmasLayout:OnHide()
    UIEventChristmasLayout.OnHide(self)
end

function UIEventSpecialOfferChristmasLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("christmas_special_offer", self.anchor)
    UIEventChristmasLayout.InitLayoutConfig(self, inst)

    --self.itemsTableView = ItemsTableView(self.layoutConfig.rewardAnchor)
    self:InitButtons()
    self:InitLocalization()
    self:InitPacks()
end

function UIEventSpecialOfferChristmasLayout:InitPacks()
    self.packList = List()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_CHRISTMAS)
    for i = 1, self.layoutConfig.holder.childCount do
        local packView = UISpecialOfferChristmasItemView(self.view, self.layoutConfig.holder:GetChild(i - 1))
        self.packList:Add(packView)
    end
end


function UIEventSpecialOfferChristmasLayout:InitButtons()
end

function UIEventSpecialOfferChristmasLayout:InitLocalization()
end

