--- @class UIBattlePassExchangeView : UIBaseView
UIBattlePassExchangeView = Class(UIBattlePassExchangeView, UIBaseView)

--- @param model UIBattlePassModel
function UIBattlePassExchangeView:Ctor(model)
    --- @type UIBattlePassExchangeConfig
    self.config = nil
    ---@type MoneyBarView
    self.moneyBarView = nil
    ---@type UILoopScroll
    self.uiScroll = nil
    ---@type BattlePassExchangeConfig
    self.battlePassExchangeConfig = nil
    ---@type UISelectFactionFilter
    self.selectType = nil
    self.listItem = List()

    UIBaseView.Ctor(self, model)
    --- @type UIBattlePassExchangeModel
    self.model = model
end

function UIBattlePassExchangeView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    self.battlePassExchangeConfig = ResourceMgr.GetBattlePassExchangeConfig()
    self:InitButtons()
    self:InitUpdateTime()
    self:_InitLocalization()
    self:InitScrolls()
    self:SetFilterData()
end

function UIBattlePassExchangeView:_InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("battle_pass_store")
end

function UIBattlePassExchangeView:InitButtons()
    self.config.backButton.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonHelp.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHelpInfo()
    end)
end

function UIBattlePassExchangeView:_InitMoneyBar()
    if self.moneyBarView == nil then
        self.moneyBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.config.moneyAnchor)
        self.moneyBarView:SetIconData(MoneyType.BATTLE_PASS_TOKEN)
    end
end

--- @return void
function UIBattlePassExchangeView:SetSprite(spriteName, image)
    if self.atlas == nil or self.lastDataId ~= self.dataId then
        self.lastDataId = self.dataId
    end
    image.sprite = ResourceLoadUtils.LoadAssetBattlePass(self.dataId, spriteName)
end

--- @return void
function UIBattlePassExchangeView:SetBackground(spriteName, image)
    image.sprite = ResourceLoadUtils.LoadAssetBattlePass(self.dataId, spriteName)
end

function UIBattlePassExchangeView:StartTime()
    if self.updateTime ~= nil then
        zg.timeMgr:AddUpdateFunction(self.updateTime)
    end
end

function UIBattlePassExchangeView:StopTime()
    if self.updateTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
    end
end

function UIBattlePassExchangeView:_GetEventEndTime()
    return self.eventBattlePassModel.timeData.endTime
end

function UIBattlePassExchangeView:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            local timeServer = zg.timeMgr:GetServerTime()
            self.timeRemaining = self:_GetEventEndTime() - timeServer
        else
            self.timeRemaining = self.timeRemaining - 1
        end
        if self.timeRemaining > 0 then
            self.config.textRefreshIn.text = string.format(LanguageUtils.LocalizeCommon("refresh_in"),
                    UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRemaining, 4)))
        else
            self.config.textRefreshIn.text = string.format(LanguageUtils.LocalizeCommon("refresh_in"),
                    UIUtils.SetColorString(UIUtils.green_light, "0s"))
            self:StopTime()
            self:OnReadyHide()
        end
    end
end

function UIBattlePassExchangeView:InitScrolls()
    ---@param obj BattlePassExchangeItem
    local onCreateItem = function(obj, index)
        self.listItem:AddAll(self.battlePassExchangeConfig.listExchangeItem)
        ---@type BattlePassExchangeConfig
        local exchangeItem = self.listItem:Get(index + 1)
        self:SetItemData(obj, exchangeItem)

        obj.onClickBuy = function()
            local canExchange = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.BATTLE_PASS_TOKEN, obj.moneyValue))
            if canExchange then
                local yesCallback = function()
                    PopupMgr.HidePopup(UIPopupName.UIPopupNotificationReward)
                    local rewardList = List()
                    --- @param buffer UnifiedNetwork_ByteBuf
                    local onBufferReading = function(buffer)
                        rewardList = NetworkUtils.GetRewardInBoundList(buffer)
                    end

                    local onSuccess = function()
                        InventoryUtils.Sub(ResourceType.Money, MoneyType.BATTLE_PASS_TOKEN, obj.moneyValue)
                        if rewardList ~= nil or rewardList:Count() > 0 then
                            PopupUtils.ClaimAndShowRewardList(rewardList)
                        end
                    end

                    local onFailed = function()
                        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("failed"))
                    end

                    local outBound = UnknownOutBound.CreateInstance(PutMethod.Int, obj.id, PutMethod.Int, obj.resourceNumber)
                    NetworkUtils.RequestAndCallback(OpCode.EVENT_BATTLE_PASS_EXCHANGE_SKIN, outBound, onSuccess, onFailed, onBufferReading)
                end
                local rewardList = List()
                local rewardItem = RewardInBound.CreateBySingleParam(obj.resourceType, obj.resourceId, obj.resourceNumber, obj.resourceData)
                rewardList:Add(rewardItem)
                local resourceList = RewardInBound.GetItemIconDataList(rewardList)

                local data = {}
                data.rewardList = rewardList
                data.resourceList = resourceList
                data.textButton = true
                data.titleText = string.format("%s\n%s", LanguageUtils.LocalizeCommon("confirm_exchange"),
                        UIUtils.SetColorString(UIUtils.red_light, LanguageUtils.LocalizeSkinName(obj.resourceId)))
                data.yesCallback = yesCallback
                PopupMgr.ShowPopup(UIPopupName.UIPopupNotificationReward, data)
            end
        end
        --obj.onCLickBuyAlready = function()
        --    SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("already_bought"))
        --end
    end
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.BattlePassExchangeItem, onCreateItem)
end

function UIBattlePassExchangeView:SetFilterData()
    --- @param obj UnityEngine_UI_Button
    --- @param isSelect boolean
    local onSelectFaction = function(obj, isSelect, indexTab)
        if obj ~= nil then
            UIUtils.SetInteractableButton(obj, not isSelect)
            if isSelect then
                self.config.iconSelect.gameObject:SetActive(true)
                self.config.iconSelect.transform.position = self.config.selectType:GetChild(indexTab - 1).position
            end
        end
    end
    local onChangeSelectFaction = function(indexTab, lastTab)

    end
    local onClickSelectFaction = function(indexTab)
        self:Sort()
    end
    self.selectType = UISelectFactionFilter(self.config.selectType, nil, onSelectFaction, onChangeSelectFaction, onClickSelectFaction)
    self.selectType:SetSprite()
end

--- @return void
function UIBattlePassExchangeView:Sort()
    local faction = self.selectType.indexTab - 1

    self.listItem:Clear()
    self.listItem:AddAll(self.battlePassExchangeConfig.listExchangeItem)
    if faction > 0 then
        local listExchangeItem = self.battlePassExchangeConfig.listExchangeItem
        for i = 1, listExchangeItem:Count() do

            --- @type BattlePassExchangeItem
            local skinData = listExchangeItem:Get(i)
            if skinData ~= nil then
                local skinFaction = ClientConfigUtils.GetFactionIdByHeroId(ClientConfigUtils.GetHeroIdBySkinId(skinData.resourceId))
                if faction ~= skinFaction then
                    self.listItem:RemoveByReference(skinData)
                end
            end
        end
    end
    self.uiScroll:Resize(self.listItem:Count())
end

---@param data BattlePassExchangeConfig
---@param obj BattlePassExchangeItem
function UIBattlePassExchangeView:SetItemData(obj, data)
    obj:SetItemData(data.id, data.moneyType, data.moneyValue, data.resourceType, data.resourceId, data.resourceNumber, data.resourceData, data.limit)
    obj:EnableTagHot(self.idSkinHot == data.resourceId)
end

function UIBattlePassExchangeView:OnReadyShow(skinId)
    UIBaseView.OnReadyShow(self)
    self.battlePassExchangeConfig = ResourceMgr.GetBattlePassExchangeConfig()
    self.idSkinHot = skinId
    self.eventBattlePassModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BATTLE_PASS)
    self:_InitLocalization()
    self:_InitMoneyBar()
    self:StartTime()
    self.dataId = self.eventBattlePassModel.timeData.dataId
    self.battlePassExchangeConfig = ResourceMgr.GetBattlePassExchangeConfig()
    self:SetSprite("background", self.config.bgDarkTheme)
    --self:SetSprite("backgound", self.config.bg)
    self.uiScroll:Resize(self.battlePassExchangeConfig.listExchangeItem:Count())
end

function UIBattlePassExchangeView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIBattlePass, nil, UIPopupName.UIBattlePassExchange)
end

function UIBattlePassExchangeView:Hide()
    UIBaseView.Hide(self)
    if self.moneyBarView ~= nil then
        self.moneyBarView:ReturnPool()
        self.moneyBarView = nil
    end
    self.listItem:Clear()
    self:StopTime()
    self.uiScroll:Hide()
end

function UIBattlePassExchangeView:OnClickHelpInfo()
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("battle_pass_exchange"))
end

