require "lua.client.scene.ui.home.uiEventMidAutumn.uiEventMidAutumnLayout.specialOffer.UISpecialOfferMidAutumnItemView"

--- @class UIEventSpecialOfferMidAutumnLayout : UIEventMidAutumnLayout
UIEventSpecialOfferMidAutumnLayout = Class(UIEventSpecialOfferMidAutumnLayout, UIEventMidAutumnLayout)

--- @param view UIEventView
function UIEventSpecialOfferMidAutumnLayout:Ctor(view, midAutumnTab, anchor)
    --- @type EventMidAutumnModel
    self.eventMidAutumnModel = nil
    --- @type EventMidAutumnConfig
    self.eventConfig = nil
    --- @type UISpecialOfferMidAutumnConfig
    self.layoutConfig = nil
    --- @type UISpecialOfferMidAutumnItemView
    self.packList = nil

    UIEventMidAutumnLayout.Ctor(self, view, midAutumnTab, anchor)
end

function UIEventSpecialOfferMidAutumnLayout:OnShow()
    UIEventMidAutumnLayout.OnShow(self)
    for i = 1, self.packList:Count() do
        --- @type UISpecialOfferMidAutumnItemView
        local packItem = self.packList:Get(i)
        packItem:OnShow(i, self.eventMidAutumnModel.timeData.dataId)
    end

    self:StartUpdateTime()
end

function UIEventSpecialOfferMidAutumnLayout:OnHide()
    self:RemoveUpdateTime()
    UIEventMidAutumnLayout.OnHide(self)
end

function UIEventSpecialOfferMidAutumnLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("mid_autumn_special_offer", self.anchor)
    UIEventMidAutumnLayout.InitLayoutConfig(self, inst)

    --self.itemsTableView = ItemsTableView(self.layoutConfig.rewardAnchor)
    self:InitButtons()
    self:InitLocalization()
    self:InitPacks()
    self:InitUpdateTime()
end

function UIEventSpecialOfferMidAutumnLayout:InitPacks()
    self.packList = List()
    self.eventMidAutumnModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_MID_AUTUMN)
    for i = 1, self.layoutConfig.holder.childCount do
        local packView = UISpecialOfferMidAutumnItemView(self.view, self.layoutConfig.holder:GetChild(i - 1))
        self.packList:Add(packView)
    end
end


function UIEventSpecialOfferMidAutumnLayout:InitButtons()
end

function UIEventSpecialOfferMidAutumnLayout:InitLocalization()
    self.layoutConfig.textTitle.text = LanguageUtils.LocalizeCommon("event_mid_autumn_special_offer_title")
end

function UIEventSpecialOfferMidAutumnLayout:InitUpdateTime()
    self.layoutConfig.time.gameObject:SetActive(true)
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        self.layoutConfig.time.text = string.format(LanguageUtils.LocalizeCommon("refresh_in"),
                UIUtils.SetColorString(UIUtils.white, TimeUtils.GetDeltaTime(self.timeRefresh)))
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
            if self.onEventTimeEnded then
                self.onEventTimeEnded()
            end
        end
    end
end

function UIEventSpecialOfferMidAutumnLayout:OnEventTimeEnded(eventTimeType)
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = eventTimeType, ["isAdded"] = false })
end

function UIEventSpecialOfferMidAutumnLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventSpecialOfferMidAutumnLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventSpecialOfferMidAutumnLayout:SetTimeRefresh()
    self.timeRefresh = zg.timeMgr:GetRemainingTime()
end

