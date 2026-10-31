---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.EventServerOpenItemConfig"

--- @class EventServerOpenItemView : IconView
EventServerOpenItemView = Class(EventServerOpenItemView, IconView)

--- @return void
function EventServerOpenItemView:Ctor()
    --- @type ItemsTableView
    self.itemsTable = nil
    ---@type ServerOpenItemData
    self.serverOpenItemData = nil

    ---@type function
    self.callbackClickGo = nil
    ---@type function
    self.callbackClickClaim = nil
    ---@type function
    self.callbackClickBuy = nil

    IconView.Ctor(self)
end

--- @return void
function EventServerOpenItemView:SetPrefabName()
    self.prefabName = 'event_server_open_item'
    self.uiPoolType = UIPoolType.EventServerOpenItemView
end

function EventServerOpenItemView:InitLocalization()
    self.config.textBuy.text = LanguageUtils.LocalizeCommon("buy")
    self.config.localizeGo.text = LanguageUtils.LocalizeCommon("go")
    self.config.localizeCollect.text = LanguageUtils.LocalizeCommon("claim")
end

--- @return void
--- @param transform UnityEngine_Transform
function EventServerOpenItemView:SetConfig(transform)
    assert(transform)
    --- @type EventServerOpenItemConfig
    ---@type EventServerOpenItemConfig
    self.config = UIBaseConfig(transform)
    self.config.goButton.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickGo()
    end)
    self.config.buyButton.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBuy()
    end)
    self.config.collectButton.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickCollect()
    end)
end

--- @return void
--- @param data ServerOpenItemData
function EventServerOpenItemView:SetIconData(data, callbackClickGo, callbackClickClaim, callbackClickBuy)
    self.serverOpenItemData = data
    self.callbackClickGo = callbackClickGo
    self.callbackClickClaim = callbackClickClaim
    self.callbackClickBuy = callbackClickBuy
    self:InitReward()
    self:UpdateView()
end

function EventServerOpenItemView:InitReward()
    if self.itemsTable == nil then
        self.itemsTable = ItemsTableView(self.config.itemAnchor)
    end
    if self.serverOpenItemData.type == ServerOpenType.QUEST then
        self.itemsTable:SetData(RewardInBound.GetItemIconDataList(self.serverOpenItemData.questUnitInBound.config:GetListReward()))
    else
        self.itemsTable:SetData(RewardInBound.GetItemIconDataList(self.serverOpenItemData.eventServerOpenMarketItem.serverOpenMarket.listReward))
    end
end

function EventServerOpenItemView:UpdateView()
    self.config.buyButton.transform.parent.gameObject:SetActive(false)
    self.config.collectButton.gameObject:SetActive(false)
    self.config.goButton.gameObject:SetActive(false)
    if self.serverOpenItemData.type == ServerOpenType.QUEST then
        local questUnitInBound = self.serverOpenItemData.questUnitInBound
        if questUnitInBound ~= nil then
            local mainReq = questUnitInBound.config:GetMainRequirementTarget()
            local number = questUnitInBound.number or 0
            self.config.textProgress.text = string.format("%d/%d", number, mainReq)
            self.config.progress.fillAmount = number / mainReq
            self.config.progressFull.gameObject:SetActive(self.config.progress.fillAmount == 1)
            if self.serverOpenItemData.questUnitInBound.questState ~= QuestState.COMPLETED then
                if number >= mainReq then
                    self.config.collectButton.gameObject:SetActive(true)
                elseif self.serverOpenItemData.questUnitInBound.config._featureMapping ~= nil then
                    self.config.goButton.gameObject:SetActive(true)
                end
            end
            self.config.textQuestContent.text = LanguageUtils.LocalizeQuestDescription(questUnitInBound.questId, questUnitInBound.config)
            self.config.tick:SetActive(questUnitInBound.questState == QuestState.COMPLETED)
        end
    else
        local eventServerOpenMarketItem = self.serverOpenItemData.eventServerOpenMarketItem
        self.config.textQuestContent.text = LanguageUtils.LocalizeCommon("buy_item_quest_name")
        local current = eventServerOpenMarketItem.maxStock - eventServerOpenMarketItem.currentStock
        self.config.tick:SetActive(current == eventServerOpenMarketItem.maxStock)
        self.config.textProgress.text = string.format("%d/%d", current, eventServerOpenMarketItem.maxStock)
        self.config.progress.fillAmount = current / eventServerOpenMarketItem.maxStock
        self.config.progressFull.gameObject:SetActive(self.config.progress.fillAmount == 1)
        if current < eventServerOpenMarketItem.maxStock then
            self.config.buyButton.transform.parent.gameObject:SetActive(true)
        end
        self.config.iconMoney.sprite = ResourceLoadUtils.LoadMoneyIcon(eventServerOpenMarketItem.serverOpenMarket.moneyData.itemId)
        self.config.iconMoney:SetNativeSize()
        self.config.textPrice.text = ClientConfigUtils.FormatNumber(eventServerOpenMarketItem.serverOpenMarket.moneyData.quantity)
        local requireVip = eventServerOpenMarketItem.serverOpenMarket.vipRequire
        if requireVip ~= nil and requireVip > 0 then
            self.config.textVip.gameObject:SetActive(true)
            self.config.textVip.text = string.format(LanguageUtils.LocalizeCommon("require_vip"), requireVip)
        else
            self.config.textVip.gameObject:SetActive(false)
        end
    end
end

function EventServerOpenItemView:OnClickGo()
    if self.callbackClickGo ~= nil then
        self.callbackClickGo()
    end
end

function EventServerOpenItemView:OnClickCollect()
    if self.callbackClickClaim ~= nil then
        self.callbackClickClaim()
    end
end

function EventServerOpenItemView:OnClickBuy()
    if self.callbackClickBuy ~= nil then
        self.callbackClickBuy()
    end
end

function EventServerOpenItemView:ReturnPool()
    IconView.ReturnPool(self)

    if self.itemsTable ~= nil then
        self.itemsTable:Hide()
        self.itemsTable = nil
    end
end

return EventServerOpenItemView