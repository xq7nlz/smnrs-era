require "lua.client.scene.ui.home.uiEventLunarNewYear2024.EventLayout.specialOffer.UISpecialOfferLunarNewYear2024ItemView"

--- @class UIEventLunarNewYear2024SpecialOfferLayout : UIEventLunarNewYear2024Layout
UIEventLunarNewYear2024SpecialOfferLayout = Class(UIEventLunarNewYear2024SpecialOfferLayout, UIEventLunarNewYear2024Layout)

--- @param view UIEventView
function UIEventLunarNewYear2024SpecialOfferLayout:Ctor(view, midAutumnTab, anchor)
    --- @type UISpecialOfferLunarNewYear2024Config
    self.layoutConfig = nil
    --- @type UISpecialOfferNewYear2023ItemView
    self.packList = nil

    UIEventLunarNewYear2024Layout.Ctor(self, view, midAutumnTab, anchor)
end

function UIEventLunarNewYear2024SpecialOfferLayout:OnShow()
    UIEventLunarNewYear2024Layout.OnShow(self)
    for i = 1, self.packList:Count() do
        --- @type UISpecialOfferLunarNewYear2024ItemView
        local packItem = self.packList:Get(i)
        packItem:OnShow(i, self.eventModel.timeData.dataId)
    end
end

function UIEventLunarNewYear2024SpecialOfferLayout:OnHide()
    UIEventLunarNewYear2024Layout.OnHide(self)
end

function UIEventLunarNewYear2024SpecialOfferLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("lunar_new_year_2024_special_offer", self.anchor)
    UIEventLunarNewYear2024Layout.InitLayoutConfig(self, inst)

    --self.itemsTableView = ItemsTableView(self.layoutConfig.rewardAnchor)
    self:InitButtons()
    self:InitLocalization()
    self:InitPacks()
end

function UIEventLunarNewYear2024SpecialOfferLayout:InitPacks()
    self.packList = List()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_LUNAR_NEW_YEAR_2024)
    for i = 1, self.layoutConfig.rectTrans.childCount do
        local packView = UISpecialOfferLunarNewYear2024ItemView(self.view, self.layoutConfig.rectTrans:GetChild(i - 1))
        self.packList:Add(packView)
    end
end


function UIEventLunarNewYear2024SpecialOfferLayout:InitButtons()
end

function UIEventLunarNewYear2024SpecialOfferLayout:InitLocalization()
end

