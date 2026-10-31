--- @class UIEventNewHeroSpinLayout : UIEventNewHeroLayout
UIEventNewHeroSpinLayout = Class(UIEventNewHeroSpinLayout, UIEventNewHeroLayout)

function UIEventNewHeroSpinLayout:Ctor(view, xmasTab, anchor)
    --- @type EventNewHeroSpinModel
    self.eventModel = nil
    --- @type EventNewHeroSpinConfig
    self.eventConfig = nil
    --- @type UINewHeroSpinConfig
    self.layoutConfig = nil

    ---@type Dictionary
    self.dictItemView = nil
    ---@type MoneyBarView
    self.moneyBar = nil
    --- @type MoneyType
    self.moneyType = nil

    UIEventNewHeroLayout.Ctor(self, view, xmasTab, anchor)
end


function UIEventNewHeroSpinLayout:OnShow()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_HERO_SPIN)
    self.dataId = self.eventModel.timeData.dataId
    self.eventConfig = self.eventModel:GetConfig()
    UIEventNewHeroLayout.OnShow(self)

    local bg = ResourceLoadUtils.LoadTexture("BgNewHeroSpin", tostring(self.eventModel.timeData.dataId), ComponentName.UnityEngine_Sprite)
    self.layoutConfig.bgBannerSpin.sprite = bg

    self:UpdateView()

    self.layoutConfig.textTitle.text = LanguageUtils.LocalizeCommon("rose_spin_" .. self.dataId)
end

function UIEventNewHeroSpinLayout:OnHide()
    UIEventNewHeroLayout.OnHide(self)
    self:ReturnPoolListItem()
    if self.moneyBar ~= nil then
        self.moneyBar:ReturnPool()
        self.moneyBar = nil
    end
end

function UIEventNewHeroSpinLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("new_hero_spin", self.anchor)
    UIEventNewHeroLayout.InitLayoutConfig(self, inst)
    self:InitButtons()
    self:InitLocalization()
end

function UIEventNewHeroSpinLayout:InitButtons()
    self.layoutConfig.rollButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickRoll()
    end)
    self.layoutConfig.skinReview.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSkinPreview()
    end)
end

function UIEventNewHeroSpinLayout:ShowBuyMoney()
    local gemPrice = self.eventConfig:GetRoseCost()
    local turnCanBuy = 1000
    if turnCanBuy > 0 then
        local callback = function(numberReturn, priceTotal)
            local onReceived = function(result)
                local onSuccess = function()
                    InventoryUtils.Sub(ResourceType.Money, MoneyType.GEM, priceTotal)
                    InventoryUtils.Add(ResourceType.Money, self.moneyType, numberReturn)
                    SmartPoolUtils.ShowReward1Item(ItemIconData.CreateInstance(ResourceType.Money, self.moneyType, numberReturn))
                end
                NetworkUtils.ExecuteResult(result, nil, onSuccess, SmartPoolUtils.LogicCodeNotification)
            end
            NetworkUtils.Request(OpCode.EVENT_NEW_HERO_ROSE_BUY, UnknownOutBound.CreateInstance(PutMethod.Int, numberReturn), onReceived)
        end
        ---@type PopupBuyItemData
        local dataPurchase = PopupBuyItemData()
        dataPurchase:SetData(ResourceType.Money, self.moneyType, 1, 1, turnCanBuy,
                MoneyType.GEM, gemPrice, callback, LanguageUtils.LocalizeMoneyType(self.moneyType), LanguageUtils.LocalizeCommon("buy"), false)
        PopupMgr.ShowPopup(UIPopupName.UIPopupBuyItem, dataPurchase)
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("max_turn_bought"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end
end

function UIEventNewHeroSpinLayout:InitLocalization()
    self.layoutConfig.textButtonContent.text = LanguageUtils.LocalizeCommon("roll")
    self.layoutConfig.textFree.text = LanguageUtils.LocalizeCommon("free")
    self.layoutConfig.textReviewSkin.text = LanguageUtils.LocalizeCommon("review_skin")
end

---@param require RewardInBound
function UIEventNewHeroSpinLayout:OnClickSkinPreview()
    ---@type BattleTeamInfo
    local attackerTeam = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfo(self.eventConfig:GetAttackerTeam():GetPredefineTeamData(), BattleConstants.ATTACKER_TEAM_ID)
    ---@type BattleTeamInfo
    local defenderTeam = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfoByDefenderTeamData(self.eventConfig:GetDefenderTeam())
    ClientBattleData.skipForReplay = true
    zg.playerData.rewardList = nil
    zg.battleMgr:RunCalculatedBattleScene(attackerTeam, defenderTeam, GameMode.EVENT_NEW_HERO)
end

---@param require RewardInBound
function UIEventNewHeroSpinLayout:OnClickRoll()
    if self.cost.isFree == true or InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, self.moneyType, self.cost.moneyValue)) then
        local slotId = nil
        local rewardInBoundList = nil
        local onReceived = function(result)
            --- @param buffer UnifiedNetwork_ByteBuf
            local onBuffering = function(buffer)
                slotId = buffer:GetInt()
                rewardInBoundList = NetworkUtils.GetRewardInBoundList(buffer)
            end
            local onSuccess = function()
                if self.cost.isFree ~= true then
                    InventoryUtils.Sub(ResourceType.Money, self.moneyType, self.cost.moneyValue)
                end

                local listItem = List()
                ---@param eventNewHeroSpinReward EventNewHeroSpinReward
                ---@param item ItemIconView
                for eventNewHeroSpinReward, item in pairs(self.dictItemView:GetItems()) do
                    if eventNewHeroSpinReward:GetLayer() == EventNewHeroSpinReward.GetLayerBySlot(slotId)
                            and self.eventModel.openedSlots:IsContainValue(eventNewHeroSpinReward.id) == false then
                        listItem:Add(eventNewHeroSpinReward)
                    end
                end
                listItem:SortWithMethod(EventNewHeroSpinReward.SortId)
                local touchObject = TouchUtils.Spawn("UIEventNewHeroSpinLayout:OnClickRoll")
                local showReward = function()
                    self.eventModel.openedSlots:Add(slotId)
                    PopupUtils.ClaimAndShowRewardList(rewardInBoundList)
                    self:UpdateView()
                    self.view:UpdateNotificationByTab(self.eventTimeType)
                    touchObject:Enable()
                end

                if listItem:Count() > 1 then
                    Coroutine.start(function()
                        local index = 1
                        local deltaTime = 0.1
                        local time = 0
                        ---@type EventNewHeroSpinReward
                        local eventNewHeroSpinReward = nil
                        ---@type ItemIconView
                        local item = nil
                        while time >=0 do
                            time = time + deltaTime
                            eventNewHeroSpinReward = listItem:Get(index)
                            item = self.dictItemView:Get(eventNewHeroSpinReward)
                            if time < 1 then
                                item:ActiveEffectSpin(false)
                                item:ActiveEffectSpin(true)
                            else
                                if eventNewHeroSpinReward.id ~= slotId then
                                    item:ActiveEffectSpin(false)
                                    item:ActiveEffectSpin(true)
                                else
                                    item:ActiveEffectRose(false)
                                    item:ActiveEffectRose(true)
                                    time = -1
                                end
                            end
                            if index < listItem:Count() then
                                index = index + 1
                            else
                                index = 1
                            end
                            zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
                            coroutine.yield(coroutine.waitforseconds(deltaTime))
                        end
                        showReward()
                    end)
                else
                    Coroutine.start(function()
                        ---@type ItemIconView
                        local item = self.dictItemView:Get(listItem:Get(1))
                        item:ActiveEffectRose(true)
                        coroutine.yield(coroutine.waitforseconds(0.1))
                        showReward()
                    end)
                end

            end
            local onFail = function(logicCode)
                SmartPoolUtils.LogicCodeNotification(logicCode)
            end
            NetworkUtils.ExecuteResult(result, onBuffering, onSuccess, onFail)
        end
        NetworkUtils.Request(OpCode.EVENT_NEW_HERO_SPIN, UnknownOutBound.CreateInstance(PutMethod.Bool, self.cost.isFree), onReceived)
    end

end

function UIEventNewHeroSpinLayout:CreateItemView()
    self.dictItemView = Dictionary()
    local dict, list = self.eventConfig:GetRewardConfig()
    ---@param v EventNewHeroSpinReward
    for i, v in ipairs(list:GetItems()) do
        ---@type RootIconView
        local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.layoutConfig.reward:GetChild(v:GetLayer() - 1))
        item:SetIconData(v.reward:GetIconData())
        item:RegisterShowInfo()
        self.dictItemView:Add(v, item)
    end
end

function UIEventNewHeroSpinLayout:UpdateView()
    if self.dictItemView == nil then
        self:CreateItemView()
    end

    ---@param eventNewHeroSpinReward EventNewHeroSpinReward
    ---@param item ItemIconView
    for eventNewHeroSpinReward, item in pairs(self.dictItemView:GetItems()) do
        if self.eventModel.openedSlots:IsContainValue(eventNewHeroSpinReward.id) then
            item:ActiveMaskSelect(true)
        end
    end

    local dict = self.eventConfig:GetCostConfig()
    ---@type EventNewHeroSpinCost
    self.cost = dict:Get(math.min(self.eventModel.openedSlots:Count() + 1, dict:Count()))
    self.moneyType = self.cost.moneyType

    if self.moneyBar == nil then
        self.moneyBar = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.money)
        self.moneyBar:AddListener(function ()
            self:ShowBuyMoney()
        end)
    end
    self.moneyBar:SetIconData(self.moneyType)
    if self.cost.isFree == true then
        self.layoutConfig.textButtonContent.transform.parent.gameObject:SetActive(false)
        self.layoutConfig.textFree.transform.parent.gameObject:SetActive(true)
    else
        self.layoutConfig.textButtonContent.transform.parent.gameObject:SetActive(true)
        self.layoutConfig.textFree.transform.parent.gameObject:SetActive(false)
        self.layoutConfig.textValuePrice.text = tostring((self.cost.isFree ~= true and self.cost.moneyValue) or 0)
    end
    self.layoutConfig.iconCurrency.sprite = ResourceLoadUtils.LoadMoneyIcon(self.moneyType)
    self.layoutConfig.iconCurrency:SetNativeSize()
end

function UIEventNewHeroSpinLayout:ReturnPoolListItem()
    if self.dictItemView ~= nil then
        ---@param v ItemIconView
        for i, v in pairs(self.dictItemView:GetItems()) do
            v:ReturnPool()
        end
        self.dictItemView = nil
    end
end