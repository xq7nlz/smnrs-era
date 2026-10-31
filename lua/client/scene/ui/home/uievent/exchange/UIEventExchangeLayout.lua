--- @class UIEventExchangeLayout : UIEventLayout
UIEventExchangeLayout = Class(UIEventExchangeLayout, UIEventLayout)

--- @param view UIEventView
function UIEventExchangeLayout:Ctor(view)
    --- @type EventExchangePanel
    self.eventExchangePanel = nil
    UIEventLayout.Ctor(self, view)
end

--- @param eventPopupModel EventExchangeModel
function UIEventExchangeLayout:OnShow(eventPopupModel)
    self:EnableEventExchange(true)
    local isHeroExchange = self.eventExchangePanel:SetData(eventPopupModel)
    local _, type = ResourceMgr.GetEventExchangeConfig():GetDataFromId(eventPopupModel.timeData.dataId)
    self.config.eventTittle.text = EventTimeType.GetLocalize(EventTimeType.EVENT_EXCHANGE_QUEST, type)
    self.config.eventDesc.text = EventTimeType.GetInfoLocalize(EventTimeType.EVENT_EXCHANGE_QUEST, type)

    if not isHeroExchange then
        local bannerId = string.format("banner_event_%s_%s", EventTimeType.EVENT_EXCHANGE_QUEST, type)
        local sprite = ResourceLoadUtils.LoadTexture(ResourceLoadUtils.bannerEventTime, bannerId, ComponentName.UnityEngine_Sprite)
        if sprite ~= nil then
            self.config.eventBanner.sprite = sprite
            self.config.eventBanner:SetNativeSize()
        end
        self.config.eventBanner.gameObject:SetActive(sprite ~= nil)
    end
end

function UIEventExchangeLayout:OnHide()
    self:EnableEventExchange(false)
end

--- @param isEnable boolean
function UIEventExchangeLayout:EnableEventExchange(isEnable)
    if isEnable then
        self.eventExchangePanel = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.EventExchangePanel, self.config.exchangeEventAnchor)
    elseif self.eventExchangePanel ~= nil then
        self.eventExchangePanel:ReturnPool()
        self.eventExchangePanel = nil
    end
end