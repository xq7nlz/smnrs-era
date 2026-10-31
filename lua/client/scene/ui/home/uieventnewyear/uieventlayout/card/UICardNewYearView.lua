require "lua.client.scene.ui.home.uiEventNewYear.uiEventLayout.card.CardConfigView"

--- @class UICardNewYearView
UICardNewYearView = Class(UICardNewYearView)

--- @param transform UnityEngine_Transform
--- @param view UIEventNewYearCardLayout
function UICardNewYearView:Ctor(transform, view)
    --- @type BlackFridayCardConfig
    self.config = UIBaseConfig(transform)
    --- @type number
    self.packId = nil
    --- @type number
    self.dataId = nil
    --- @type string
    self.packKey = nil
    --- @type OpCode
    self.opCode = nil
    --- @type ItemsTableView
    self.itemsTable = nil
    --- @type IapDataInBound
    self.iapDataInBound = nil
    --- @type EventNewYearModel
    self.eventModel = nil

    self.eventTimeType = view.eventTimeType

    self.eventActionType = view.actionType

    ---@type List
    self.cardConfigList = nil
    self.view = view
    self:InitButtonListener()
    self:InitItemTableView()
end

function UICardNewYearView:InitLocalization()
    self.config.contentText.text = LanguageUtils.LocalizeCommon("event_new_year_card_content")
end

function UICardNewYearView:InitButtonListener()
    self.config.buttonBuy.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBuy()
    end)
end

function UICardNewYearView:InitItemTableView()
    self.itemsTable = ItemsTableView(self.config.resAnchor)
    self.cardConfig = CardConfigView(self.view.layoutConfig.cardConfig)

    if self.config.vipPointView == nil then
        self.config.vipPointView = self.config.transform:Find("holder/buy_button/vip_point_view").gameObject
    end
end

function UICardNewYearView:UpdateData()
    ---@type EventNewYearCardStoreProduct
    self.data = ResourceMgr.GetPurchaseConfig():GetNewYearCard():GetPack(self.dataId):GetPackBase(self.packId)
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
end

function UICardNewYearView:OnShow(packId, dataId)
    self.dataId = dataId
    self.packId = packId
    self:UpdateData()
    self.opCode = self.data.opCode
    self.packKey = ClientConfigUtils.GetPurchaseKey(self.opCode, self.packId, dataId)
    --- @type IapDataInBound
    self.iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    --- @type EventNewYearConfig
    self.eventConfig = self.eventModel:GetConfig()
    self:ShowPack()
    self:SetPrice()
end

function UICardNewYearView:ShowPack()
    LanguageUtils.CheckInitLocalize(self, UICardNewYearView.InitLocalization)

    local numberBought = self.eventModel:GetNumberBuy(self.eventActionType, self.packId)
    local left = self.data.stock
    left = self.data.stock - numberBought

    if self.eventModel.subscriptionDurationDict ~= nil and self.eventModel.subscriptionDurationDict:IsContainKey(self.packId) then
        self.day = self.eventModel.subscriptionDurationDict:Get(self.packId)
    end

    local isBought = self.day ~= nil and self.day > 0

    local vip, rewardList = self.data:GetReward(self.data.rewardNotInstantList)

    self.config.contentText.text = LanguageUtils.LocalizeCommon("event_new_year_card_content")

    self:ShowTextBuy(left, self.data.stock)
    self:SetInstantReward(self.data.rewardNotInstantList, isBought)

    vip = self.data:GetVip()
    self:SetVipText(vip)
end

function UICardNewYearView:SetPrice()
    self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(self.packKey)
    --  XDebug.Log("pack key: "..tostring(self.packKey))
end

---@param rewardList List
function UICardNewYearView:SetInstantReward(rewardList, isBought)
    ---@type List
    local listIconData = List()
    ---@param v RewardInBound
    for i, v in ipairs(rewardList:GetItems()) do
        local iconData = v:GetIconData()
        if isBought == false then
            iconData.quantity = v:GetNumberBase()
        end
        listIconData:Add(iconData)
    end
    self.itemsTable:SetData(listIconData, UIPoolType.RootIconView)

    if self.cardConfigList == nil then
        self.cardConfigList = List()
        self.cardConfigList:Add(self.cardConfig)
        for i = 1, rewardList:Count() - 1 do
            local cardView = CardConfigView(U_GameObject.Instantiate(self.view.layoutConfig.cardConfig.gameObject, self.view.layoutConfig.transform))
            self.cardConfigList:Add(cardView)
        end
        Coroutine.start(function()
            coroutine.waitforendofframe()
            for i = 1, rewardList:Count() do
                ---@type RewardInBound
                local reward = rewardList:Get(i)
                ---@type CardConfigView
                local card = self.cardConfigList:Get(i)
                local pos = self.itemsTable:Get(i).config.transform.position
                pos.y = pos.y + 1
                local factorType = nil
                if isBought == false then
                    factorType = reward:GetFACTOR_TYPE()
                end
                local calculationType = nil
                if isBought == false then
                    calculationType = reward:GetCALCULATOR_TYPE()
                end
                card:ShowCard(pos, factorType, calculationType)
            end
        end)
    end

    for i = 1, rewardList:Count() do
        local reward = rewardList:Get(i)
        ---@type CardConfigView
        local card = self.cardConfigList:Get(i)
        if (reward:GetFACTOR_TYPE() ~= nil or reward:GetCALCULATOR_TYPE() ~= nil) and not isBought then
            card.config.gameObject:SetActive(true)
        else
            card.config.gameObject:SetActive(false)
        end
    end
end

function UICardNewYearView:SetVipText(vipText)
    if self.config.vipPointView then
        self.config.vipPointView:SetActive(vipText ~= nil)
    end
    if vipText ~= nil then
        self.config.vipText.text = "+" .. tostring(vipText)
    end
end

function UICardNewYearView:OnHide()
    self.itemsTable:Hide()
    self.day = nil
    self.config.remainText.gameObject:SetActive(false)
end

function UICardNewYearView:OnClickBuy()
    if self:CanBuy() then
        local packKey = self.packKey
        if self.data ~= nil then
            packKey = ClientConfigUtils.GetPurchaseKey(self.data.opCode, self.data.id, self.data.dataId)
        end
        BuyUtils.InitListener(function()
            PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.IAP }, function()
                self.eventModel:AddNumberBuy(self.eventActionType, self.packId, 1)
                self.day = tonumber(self.eventConfig:GetCardDurationMaxDictionaryConfig():Get(self.packId))
                if self.eventModel.subscriptionDurationDict ~= nil then
                    local number
                    if self.eventModel.subscriptionDurationDict:IsContainKey(self.packId) then
                        number = tonumber(self.eventModel.subscriptionDurationDict:Get(self.packId) + self.eventConfig:GetCardDurationMaxDictionaryConfig():Get(self.packId))
                    else
                        number = tonumber(self.eventConfig:GetCardDurationMaxDictionaryConfig():Get(self.packId))
                    end
                    self.eventModel.subscriptionDurationDict:Add(self.packId, number)
                end
                self:ShowPack()
            end)
        end)
        RxMgr.purchaseProduct:Next(packKey)
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

--- @param left number
--- @param max number
function UICardNewYearView:ShowTextBuy(left, max)
    local day = 0
    if self.eventModel.subscriptionDurationDict ~= nil and self.eventModel.subscriptionDurationDict:IsContainKey(self.packId) then
        day = self.eventModel.subscriptionDurationDict:Get(self.packId)
    else
        day = self.eventConfig:GetCardDurationMaxDictionaryConfig():Get(self.packId)
    end
    local dayString = string.format("%s", day)
    if self.eventModel:IsOpening() then
        if left == nil or max == nil then
            self.config.localizeBuy.text = LanguageUtils.LocalizeCommon("buy")
        else
            local color = UIUtils.green_light
            if left == 0 then
                color = UIUtils.red_dark
                -- black friday just have 1 pack
                self.config.remainText.text = string.format(LanguageUtils.LocalizeCommon("new_year_remain_x"), UIUtils.SetColorString(UIUtils.green_light, dayString))
                self.config.remainText.gameObject:SetActive(true)
                self.config.buttonBuy.gameObject:SetActive(false)
            else
                self.config.remainText.gameObject:SetActive(false)
                self.config.buttonBuy.gameObject:SetActive(true)
            end
            self.config.localizeBuy.text = string.format("%s %s",
                    LanguageUtils.LocalizeCommon("buy"),
                    UIUtils.SetColorString(color, string.format("(%s/%s)", left, max)))
        end
    else
        self.config.remainText.text = string.format(LanguageUtils.LocalizeCommon("new_year_remain_x"), UIUtils.SetColorString(UIUtils.green_light, dayString))
        self.config.remainText.gameObject:SetActive(true)
        self.config.buttonBuy.gameObject:SetActive(false)
    end
end

function UICardNewYearView:CanBuy()
    local numberBought = self.eventModel:GetNumberBuy(self.eventActionType, self.packId)
    return (self.data.stock - numberBought) > 0
end

return UICardNewYearView
