require "lua.client.scene.ui.home.uiEventValentine2024.EventLayout.specialOffer.UISpecialOfferValentine2024ItemView"

--- @class UIEventValentine2024SpecialOfferLayout : UIEventValentine2024Layout
UIEventValentine2024SpecialOfferLayout = Class(UIEventValentine2024SpecialOfferLayout, UIEventValentine2024Layout)

--- @param view UIEventView
function UIEventValentine2024SpecialOfferLayout:Ctor(view, midAutumnTab, anchor)
    --- @type EventValentine2024Model
    self.eventModel = nil
    --- @type EventValentine2024Config
    self.eventConfig = nil
    --- @type UISpecialOfferValentine2024Config
    self.layoutConfig = nil
    --- @type UISpecialOfferValentine2024ItemView
    self.packList = nil

    UIEventValentine2024Layout.Ctor(self, view, midAutumnTab, anchor)
end

function UIEventValentine2024SpecialOfferLayout:OnShow()
    UIEventValentine2024Layout.OnShow(self)
    for i = 1, self.packList:Count() do
        --- @type UISpecialOfferValentine2024ItemView
        local packItem = self.packList:Get(i)
        packItem:OnShow(i, self.eventModel.timeData.dataId)
    end
end

function UIEventValentine2024SpecialOfferLayout:OnHide()
    UIEventValentine2024Layout.OnHide(self)
end

function UIEventValentine2024SpecialOfferLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("valentine_2024_special_offer", self.anchor)
    UIEventValentine2024Layout.InitLayoutConfig(self, inst)

    --self.itemsTableView = ItemsTableView(self.layoutConfig.rewardAnchor)
    self:InitButtons()
    self:InitLocalization()
    self:InitPacks()
end

function UIEventValentine2024SpecialOfferLayout:InitPacks()
    self.packList = List()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_VALENTINE_2024)
    for i = 1, self.layoutConfig.rectTrans.childCount do
        local packView = UISpecialOfferValentine2024ItemView(self.view, self.layoutConfig.rectTrans:GetChild(i - 1))
        self.packList:Add(packView)
    end
end


function UIEventValentine2024SpecialOfferLayout:InitButtons()
end

function UIEventValentine2024SpecialOfferLayout:InitLocalization()
end

