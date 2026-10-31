require "lua.client.scene.ui.home.uiEventXmas.uiEventXmasLayout.exclusiveOffer.UIExclusiveOfferXmasItemView"

--- @class UIEventXmasExclusiveOfferLayout : UIEventXmasLayout
UIEventXmasExclusiveOfferLayout = Class(UIEventXmasExclusiveOfferLayout, UIEventXmasLayout)

--- @param view UIEventView
function UIEventXmasExclusiveOfferLayout:Ctor(view, midAutumnTab, anchor)
    --- @type EventXmasModel
    self.eventModel = nil
    --- @type EventXmasConfig
    self.eventConfig = nil
    --- @type UISpecialOfferMidAutumnConfig
    self.layoutConfig = nil
    --- @type UISpecialOfferHalloweenItemView
    self.packList = nil

    UIEventXmasLayout.Ctor(self, view, midAutumnTab, anchor)
end

function UIEventXmasExclusiveOfferLayout:OnShow()
    UIEventXmasLayout.OnShow(self)
    for i = 1, self.packList:Count() do
        --- @type UISpecialOfferHalloweenItemView
        local packItem = self.packList:Get(i)
        packItem:OnShow(i, self.eventModel.timeData.dataId)
    end
end

function UIEventXmasExclusiveOfferLayout:OnHide()
    UIEventXmasLayout.OnHide(self)
end

function UIEventXmasExclusiveOfferLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("xmas_special_offer", self.anchor)
    UIEventXmasLayout.InitLayoutConfig(self, inst)

    self:InitButtons()
    self:InitLocalization()
    self:InitPacks()
end

function UIEventXmasExclusiveOfferLayout:InitPacks()
    self.packList = List()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_XMAS)
    for i = 1, self.layoutConfig.rectTrans.childCount do
        local packView = UIExclusiveOfferXmasItemView(self.layoutConfig.rectTrans:GetChild(i - 1))
        self.packList:Add(packView)
    end
end


function UIEventXmasExclusiveOfferLayout:InitButtons()
end

function UIEventXmasExclusiveOfferLayout:InitLocalization()
end

