require "lua.client.scene.ui.home.uiEventMidAutumn.ItemShowWithNameAndType"
require "lua.client.scene.ui.home.uiEventNewHero.eventHeroNewLayout.treasure.ElunePet"

--- @class UIEventNewHeroTreasureLayout : UIEventNewHeroLayout
UIEventNewHeroTreasureLayout = Class(UIEventNewHeroTreasureLayout, UIEventNewHeroLayout)

--- @param view UIEventNewHeroView
--- @param eventTimeType EventTimeType
--- @param anchor UnityEngine_RectTransform
function UIEventNewHeroTreasureLayout:Ctor(view, eventTimeType, anchor)
    --- @type EventNewHeroTreasureModel
    self.eventModel = nil
    --- @type EventNewHeroTreasureConfig
    self.eventConfig = nil
    --- @type UIEventNewHeroTreasureLayoutConfig
    self.layoutConfig = nil
    --- @type List
    self.listPoolItemShow = List()
    --- @type number
    self.moneyType = nil
    --- @type number
    self.moneyValue = nil
    --- @type number
    self.selectId = -1
    --- @type ElunePet
    self.pet = nil
    ---@type List
    self.listRewardInfo = List()
    UIEventNewHeroLayout.Ctor(self, view, eventTimeType, anchor)
end

function UIEventNewHeroTreasureLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("new_hero_treasure", self.anchor)
    UIEventNewHeroLayout.InitLayoutConfig(self, inst)

    self.pet = ElunePet(self.layoutConfig.elunePet)
    self:InitButtonListener()
    self:InitLocalization()
end

function UIEventNewHeroTreasureLayout:InitLocalization()
    UIEventNewHeroLayout.InitLocalization(self)
    self.layoutConfig.textEventName.text = LanguageUtils.LocalizeCommon("elune_journey")
    self.layoutConfig.textStart.text = LanguageUtils.LocalizeCommon("start")
end

function UIEventNewHeroTreasureLayout:InitButtonListener()
    self.layoutConfig.buttonHelp.onClick:AddListener(function()
        self:ShowInfo()
    end)
    self.layoutConfig.complete.onClick:AddListener(function()
        self:OnClickFinalTreasure()
    end)
end

function UIEventNewHeroTreasureLayout:OnShow()
    UIEventNewHeroLayout.OnShow(self)
    self.selectId = -1
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    self.eventConfig = self.eventModel:GetConfig()

    ---@type MoneyBarView
    self.gemBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.money)
    self.gemBarView:SetIconData(self.eventConfig:GetRewardBuy().reward.id)
    self.gemBarView:AddListener(function()
        self:ShowBuyMoney()
    end)
    --self.gemBarView:Reverse(true)

    if self.listItem == nil then
        self.listItem = List()
    end
    for line = 1, self.eventConfig:GetTreasureLine() do
        ---@param v TreasureRewardConfig
        for i, v in ipairs(self.eventConfig:GetListTreasureRewardConfig(line):GetItems()) do
            ---@type UITreasureItemView
            local itemOwn = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.UITreasureItemView,
                    self.layoutConfig.map:GetChild(line - 1):GetChild(i - 1))
            itemOwn:SetData(v, function()
                self:OnClickSelect(itemOwn)
            end)
            self.listItem:Add(itemOwn)
        end
    end
    self:UpdateUI()

    self.pet:PlayIdle()
    self.pet:SetPosition(self:GetMilestonePosByPosId(self.eventModel.currentPosition), 1)
end

function UIEventNewHeroTreasureLayout:ShowBuyMoney()
    local rewardBuy = self.eventConfig:GetRewardBuy()
    ---@type RewardInBound
    local reward = rewardBuy.reward
    local callback = function(numberReturn, priceTotal)
        local onReceived = function(result)
            local onSuccess = function()
                InventoryUtils.Sub(ResourceType.Money, rewardBuy.moneyType, priceTotal)
                InventoryUtils.Add(ResourceType.Money, reward.id, numberReturn)
                SmartPoolUtils.ShowReward1Item(ItemIconData.CreateInstance(ResourceType.Money, reward.id, numberReturn))
            end
            NetworkUtils.ExecuteResult(result, nil, onSuccess, SmartPoolUtils.LogicCodeNotification)
        end
        NetworkUtils.Request(OpCode.EVENT_NEW_HERO_TREASURE_REWARD_BUY, UnknownOutBound.CreateInstance(PutMethod.Int, numberReturn), onReceived)
    end
    ---@type PopupBuyItemData
    local dataPurchase = PopupBuyItemData()
    dataPurchase:SetData(ResourceType.Money, reward.id, 1, 1, math.floor(InventoryUtils.Get(ResourceType.Money, rewardBuy.moneyType) / rewardBuy.moneyValue),
            rewardBuy.moneyType, rewardBuy.moneyValue, callback, LanguageUtils.LocalizeMoneyType(reward.id), LanguageUtils.LocalizeCommon("buy"), false)
    PopupMgr.ShowPopup(UIPopupName.UIPopupBuyItem, dataPurchase)
end

---@param treasureItemView UITreasureItemView
function UIEventNewHeroTreasureLayout:OnClickSelect(treasureItemView)
    local treasureRewardConfig = treasureItemView.treasureRewardConfig
    local id = treasureRewardConfig.id
    local pos = treasureItemView.config.transform.position

    if self.eventModel:GetIndexUnlockLine(treasureRewardConfig.line) == treasureRewardConfig.index - 1 then
        self.selectId = id
        self.moneyType = treasureRewardConfig.moneyType
        self.moneyValue = treasureRewardConfig.moneyValue
        self.gemBarView:SetIconData(self.moneyType)

        self:HideReward()
        local data = {}
        data.rewardList = treasureItemView.treasureRewardConfig.listReward
        data.price = treasureRewardConfig.moneyValue
        data.callbackMove = function()
            PopupMgr.HidePopup(UIPopupName.UISelectTreasure)
            self:OnClickMove()
        end
        PopupMgr.ShowPopup(UIPopupName.UISelectTreasure, data)

    elseif self.eventModel:GetIndexUnlockLine(treasureRewardConfig.line) > treasureRewardConfig.index - 1 then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reward_claimed"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)

        self.selectId = -1
        self:UpdateUI()

        self:ShowReward(pos, id)
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("need_claim_previous_reward"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)

        self.selectId = -1
        self:UpdateUI()

        self:ShowReward(pos, id)
    end
end

function UIEventNewHeroTreasureLayout:UpdateUI()
    self:HideReward()
    ---@param v UITreasureItemView
    for i, v in ipairs(self.listItem:GetItems()) do
        v:UpdateState(self.eventModel:GetIndexUnlockLine(v.treasureRewardConfig.line))
        if v.treasureRewardConfig.id == self.eventModel.currentPosition then
            self.layoutConfig.elune.position = v.config.transform.position
        end
    end
    --if self.selectId < 0 then
    --    self:ActiveSelect(false)
    --else
    --    self:ActiveSelect(true)
    --end
    for i = 1, self.eventConfig:GetTreasureLine() do
        self.layoutConfig.finish:GetChild(i - 1).gameObject:SetActive(false)
    end
    if self.eventModel.numberCompletedLine == self.eventConfig:GetTreasureLine() then
        self.layoutConfig.textGoal.text = LanguageUtils.LocalizeCommon("finish")
    else
        self.layoutConfig.textGoal.text = string.format(LanguageUtils.LocalizeCommon("goal_x"), self.eventModel.numberCompletedLine + 1)
    end
    self.layoutConfig.finish:GetChild(math.min(self.layoutConfig.finish.childCount - 1, self.eventModel.numberCompletedLine)).gameObject:SetActive(true)
end

function UIEventNewHeroTreasureLayout:ActiveSelect(isActive)
    --self.layoutConfig.iconSelect.gameObject:SetActive(isActive)
    --self.layoutConfig.moveButton.gameObject:SetActive(isActive)
    --self.gemBarView.config.gameObject:SetActive(isActive)
end

function UIEventNewHeroTreasureLayout:OnHide()
    UIEventNewHeroLayout.OnHide(self)
    if self.listItem ~= nil then
        ---@param v IconView
        for i, v in ipairs(self.listItem:GetItems()) do
            v:ReturnPool()
        end
        self.listItem = nil
    end
    if self.gemBarView then
        self.gemBarView:ReturnPool()
        self.gemBarView = nil
    end
    self:HideReward()
end

function UIEventNewHeroTreasureLayout:OnClickFinalTreasure()
    self:HideReward()
    local treasureFinal = self.eventModel:GetTreasureFinalCanOpen()
    if treasureFinal ~= nil then
        self.selectId = treasureFinal
        self.layoutConfig.iconSelect.anchoredPosition3D = self.layoutConfig.finish.anchoredPosition3D
        ---@type FinalTreasureRewardConfig
        local finalTreasureRewardConfig = self.eventConfig:GetFinalTreasureRewardConfig(treasureFinal)
        self.moneyType = finalTreasureRewardConfig.moneyType
        self.moneyValue = finalTreasureRewardConfig.moneyValue
        self.gemBarView:SetIconData(self.moneyType)
        self:ActiveSelect(true)

        local data = {}
        data.rewardList = finalTreasureRewardConfig.listReward
        data.price = finalTreasureRewardConfig.moneyValue
        data.callbackMove = function()
            PopupMgr.HidePopup(UIPopupName.UISelectTreasure)
            self:OnClickMove()
        end
        PopupMgr.ShowPopup(UIPopupName.UISelectTreasure, data)
    elseif self.eventModel.numberCompletedLine == self.eventConfig:GetTreasureLine() then
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("treasure_completed"))
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("need_complete_one_more_journey"))
    end
end

function UIEventNewHeroTreasureLayout:OnClickMove()
    if InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(
            ResourceType.Money, self.moneyType, self.moneyValue)) then
        if self.selectId > 1000 then
            local rewardInBoundList = List()
            local onReceived = function(result)
                local onBuffering = function(buffer)
                    rewardInBoundList = NetworkUtils.GetRewardInBoundList(buffer)
                end
                local onSuccess = function()
                    InventoryUtils.Sub(ResourceType.Money, self.moneyType, self.moneyValue)
                    self:DoJumpPet(self.eventModel.currentPosition, self.selectId, function()
                        self.eventModel:SetIndexUnlockLand(self.selectId)
                        PopupUtils.ClaimAndShowRewardList(rewardInBoundList)
                        self.eventModel.currentPosition = self.selectId
                        self.selectId = -1
                        self:UpdateUI()
                        self.view:UpdateNotificationByTab(self.eventBirthdayTab)
                    end)
                end
                local onFail = function(logicCode)
                    SmartPoolUtils.LogicCodeNotification(logicCode)
                end
                NetworkUtils.ExecuteResult(result, onBuffering, onSuccess, onFail)
            end
            NetworkUtils.Request(OpCode.EVENT_BIRTHDAY_ISLAND_UNLOCK, UnknownOutBound.CreateInstance(PutMethod.Int, self.selectId), onReceived)
        elseif self.selectId > 0 then
            local rewardInBoundList = List()
            local onReceived = function(result)
                local onBuffering = function(buffer)
                    rewardInBoundList = NetworkUtils.GetRewardInBoundList(buffer)
                end
                local onSuccess = function()
                    InventoryUtils.Sub(ResourceType.Money, self.moneyType, self.moneyValue)
                    local finishIndex = self.selectId
                    self:DoJumpPet(self.eventModel.currentPosition, self.selectId, function()
                        self.eventModel.currentPosition = -1
                        self.selectId = -1
                        self.eventModel.numberCompletedLine = self.eventModel.numberCompletedLine + 1
                        self:UpdateUI()
                        self.view:UpdateNotificationByTab(self.eventBirthdayTab)
                        PopupUtils.ClaimAndShowRewardList(rewardInBoundList, function ()
                            if self.eventModel.numberCompletedLine == self.eventConfig:GetTreasureLine() then

                            else
                                self:DoJumpPet(finishIndex, -1, function()

                                end)
                            end
                        end)
                    end)
                end
                local onFail = function(logicCode)
                    SmartPoolUtils.LogicCodeNotification(logicCode)
                end
                NetworkUtils.ExecuteResult(result, onBuffering, onSuccess, onFail)
            end
            NetworkUtils.Request(OpCode.EVENT_BIRTHDAY_LINE_COMPLETE_REWARD, nil, onReceived)
        end
    end
end

function UIEventNewHeroTreasureLayout:DoJumpPet(currentId, toId, onComplete)

    local fromPos = self:GetMilestonePosByPosId(currentId)
    local toPos = self:GetMilestonePosByPosId(toId)

    local touchObject = TouchUtils.Spawn("Jump")
    self.pet:SetDirection(toPos.x - fromPos.x)
    self.pet:DoJump(fromPos, toPos, function()
        self.pet:SetDirection(1)
        zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
        if onComplete then
            onComplete()
        end
        touchObject:Enable()
    end)
end

function UIEventNewHeroTreasureLayout:SetPetAtPos(posId)
    local pos = self:GetMilestonePosByPosId(posId)
    self.pet.anchoredPosition3D = pos
    self.pet:SetDirection(1)
end

function UIEventNewHeroTreasureLayout:ShowInfo()
    local data = {}
    data.callbackClose = function()
        PopupMgr.HidePopup(UIPopupName.UITreasureInfo)
    end
    PopupMgr.ShowPopup(UIPopupName.UITreasureInfo, data)
end

--- @return UnityEngine_Vector3
function UIEventNewHeroTreasureLayout:GetMilestoneByPos(line, pos)
    local lineAnchor = self.layoutConfig.map:GetChild(line - 1)
    local milestone = lineAnchor:GetChild(pos - 1)
    return lineAnchor.anchoredPosition3D + milestone.anchoredPosition3D
end

function UIEventNewHeroTreasureLayout:GetLineAndPosByPositionId(posId)
    return math.floor(posId / 1000), posId % 10
end

--- @return UnityEngine_Vector3
function UIEventNewHeroTreasureLayout:GetMilestonePosByPosId(posId)
    if posId > 1000 then
        local line, pos = self:GetLineAndPosByPositionId(posId)
        return self:GetMilestoneByPos(line, pos)
    elseif posId > 0 then
        return self.layoutConfig.finish.anchoredPosition3D
    elseif self.eventModel.numberCompletedLine < self.eventConfig:GetTreasureLine() then
        return self.layoutConfig.bgHolderStart.anchoredPosition3D
    end
    return self.layoutConfig.finish.anchoredPosition3D
end

function UIEventNewHeroTreasureLayout:ShowReward(position, posId)
    if posId > 1000 then
        local line, pos = self:GetLineAndPosByPositionId(posId)
        --- @type TreasureRewardConfig
        local listReward = self.eventConfig:GetTreasureRewardConfig(line, pos).listReward
        ---@param v RewardInBound
        for _, v in ipairs(listReward:GetItems()) do
            --- @type RootIconView
            local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.layoutConfig.bgListReward)
            item:SetIconData(v:GetIconData())
            item:RegisterShowInfo()
            self.listRewardInfo:Add(item)
        end

        self.layoutConfig.iconSelect.position = position
        self.layoutConfig.iconSelect.gameObject:SetActive(true)
    else
        self:HideReward()
    end
end

function UIEventNewHeroTreasureLayout:HideReward()
    ---@param v IconView
    for _, v in pairs(self.listRewardInfo:GetItems()) do
        v:ReturnPool()
    end
    self.listRewardInfo:Clear()
    self.layoutConfig.iconSelect.gameObject:SetActive(false)
end