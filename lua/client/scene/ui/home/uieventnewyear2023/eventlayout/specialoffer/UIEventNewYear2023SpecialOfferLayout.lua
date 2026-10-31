require "lua.client.scene.ui.home.uiEventNewYear2023.EventLayout.specialOffer.UISpecialOfferNewYear2023ItemView"

--- @class UIEventNewYear2023SpecialOfferLayout : UIEventNewYear2023Layout
UIEventNewYear2023SpecialOfferLayout = Class(UIEventNewYear2023SpecialOfferLayout, UIEventNewYear2023Layout)

--- @param view UIEventView
function UIEventNewYear2023SpecialOfferLayout:Ctor(view, midAutumnTab, anchor)
    --- @type EventNewYear2023Model
    self.eventModel = nil
    --- @type EventNewYear2023Config
    self.eventConfig = nil
    --- @type UISpecialOfferNewYear2023Config
    self.layoutConfig = nil
    --- @type UISpecialOfferNewYear2023ItemView
    self.packList = nil

    UIEventNewYear2023Layout.Ctor(self, view, midAutumnTab, anchor)
end

function UIEventNewYear2023SpecialOfferLayout:OnShow()
    UIEventNewYear2023Layout.OnShow(self)
    for i = 1, self.packList:Count() do
        --- @type UISpecialOfferNewYear2023ItemView
        local packItem = self.packList:Get(i)
        packItem:OnShow(i, self.eventModel.timeData.dataId)
    end
end

function UIEventNewYear2023SpecialOfferLayout:OnHide()
    UIEventNewYear2023Layout.OnHide(self)
end

function UIEventNewYear2023SpecialOfferLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("new_year_2023_special_offer", self.anchor)
    UIEventNewYear2023Layout.InitLayoutConfig(self, inst)

    --self.itemsTableView = ItemsTableView(self.layoutConfig.rewardAnchor)
    self:InitButtons()
    self:InitLocalization()
    self:InitPacks()
end

function UIEventNewYear2023SpecialOfferLayout:InitPacks()
    self.packList = List()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_YEAR_2023)
    for i = 1, self.layoutConfig.rectTrans.childCount do
        local packView = UISpecialOfferNewYear2023ItemView(self.view, self.layoutConfig.rectTrans:GetChild(i - 1))
        self.packList:Add(packView)
    end
end


function UIEventNewYear2023SpecialOfferLayout:InitButtons()
end

function UIEventNewYear2023SpecialOfferLayout:InitLocalization()
end

