require "lua.client.scene.ui.home.uiEventQixiFestival.EventLayout.specialOffer.UISpecialOfferQixiFestivalItemView"

--- @class UIEventQixiFestivalSpecialOfferLayout : UIEventQixiFestivalLayout
UIEventQixiFestivalSpecialOfferLayout = Class(UIEventQixiFestivalSpecialOfferLayout, UIEventQixiFestivalLayout)

--- @param view UIEventView
function UIEventQixiFestivalSpecialOfferLayout:Ctor(view, midAutumnTab, anchor)
    --- @type EventQixiFestivalModel
    self.eventModel = nil
    --- @type EventQixiFestivalConfig
    self.eventConfig = nil
    --- @type UISpecialOfferQixiFestivalConfig
    self.layoutConfig = nil
    --- @type UISpecialOfferQixiFestivalItemView
    self.packList = nil

    UIEventQixiFestivalLayout.Ctor(self, view, midAutumnTab, anchor)
end

function UIEventQixiFestivalSpecialOfferLayout:OnShow()
    UIEventQixiFestivalLayout.OnShow(self)
    for i = 1, self.packList:Count() do
        --- @type UISpecialOfferQixiFestivalItemView
        local packItem = self.packList:Get(i)
        packItem:OnShow(i, self.eventModel.timeData.dataId)
    end
end

function UIEventQixiFestivalSpecialOfferLayout:OnHide()
    UIEventQixiFestivalLayout.OnHide(self)
end

function UIEventQixiFestivalSpecialOfferLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("qixi_festival_special_offer", self.anchor)
    UIEventQixiFestivalLayout.InitLayoutConfig(self, inst)

    --self.itemsTableView = ItemsTableView(self.layoutConfig.rewardAnchor)
    self:InitButtons()
    self:InitLocalization()
    self:InitPacks()
end

function UIEventQixiFestivalSpecialOfferLayout:InitPacks()
    self.packList = List()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_QIXI)
    for i = 1, self.layoutConfig.rectTrans.childCount do
        local packView = UISpecialOfferQixiFestivalItemView(self.view, self.layoutConfig.rectTrans:GetChild(i - 1))
        self.packList:Add(packView)
    end
end


function UIEventQixiFestivalSpecialOfferLayout:InitButtons()
end

function UIEventQixiFestivalSpecialOfferLayout:InitLocalization()
end

