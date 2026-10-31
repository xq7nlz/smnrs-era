require "lua.client.scene.ui.home.uiWheelOfFate.SpinWheel"
require "lua.client.core.network.casino.RefreshCasinoInBound"
require "lua.client.core.network.casino.SpinCasinoInBound"
require "lua.client.scene.ui.home.uiWheelOfFate.PreviewCasino"

--- @class UIWheelOfFateView : UIBaseView
UIWheelOfFateView = Class(UIWheelOfFateView, UIBaseView)

--- @return void
--- @param model UIWheelOfFateModel
--- @param ctrl UIWheelOfFateCtrl
function UIWheelOfFateView:Ctor(model, ctrl)
    ---@type UIWheelOfFateConfig
    self.config = nil
    ---@type SpinWheel
    self.spinWheel = nil
    ---@type List | RootIconView
    self.listIconView = List()
    ---@type function
    self.coroutineTimeRefresh = nil

    --- @type MoneyBarView
    self.casinoBarView = nil

    ---@type PreviewCasino
    self.previewCasino = nil

    ---@type function
    self.coroutineSpin = nil

    --PARTICLE
    ---@type UnityEngine_GameObject
    self.effectSpin = nil
    ---@type UnityEngine_GameObject
    self.effectActive = nil
    ---@type UnityEngine_GameObject
    self.effectRefresh = nil
    ---@type UnityEngine_GameObject
    self.effectActiveBasic = nil
    ---@type UnityEngine_GameObject
    self.effectRefreshBasic = nil
    ---@type UnityEngine_GameObject
    self.effectActivePremium = nil
    ---@type UnityEngine_GameObject
    self.effectRefreshPremium = nil
    ---@type UnityEngine_GameObject
    self.effectBg = nil
    ---@type UnityEngine_GameObject
    self.effectSpinBasic = nil
    ---@type UnityEngine_GameObject
    self.effectSpinPremium = nil

    -- init variables here
    UIBaseView.Ctor(self, model, ctrl)
    --- @type UIWheelOfFateModel
    self.model = model
    --- @type UIWheelOfFateCtrl
    self.ctrl = ctrl
    ---@type boolean
    self.skipAnimation = false
    ---@type number
    self.numberOfBought = nil
    ---@type number
    self.stock = nil
end

--- @return void
function UIWheelOfFateView:OnReadyCreate()
    ---@type UIWheelOfFateConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.spinWheel = SpinWheel(self.config.spin)
    self.previewCasino = PreviewCasino(self.config.previewCasino)

    local callbackRotate = function(angle)
        self:SynSpin(angle)
    end
    self.spinWheel.callbackRotate = callbackRotate

    self.config.buttonSpin1.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSpin1()
    end)
    self.config.buttonSpin10.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSpin10()
    end)
    self.config.spinWatchAds.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSpinWatchAds()
    end)
    self.config.buttonRefresh.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickReset()
    end)
    self.config.buttonRefresh2.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickReset()
    end)
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonTutorial.onClick:AddListener(function()
        self:OnClickHelpInfo()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.toggleSkipAnimation.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSkipAnimation()
    end)

    self.effectSpinBasic = ResourceLoadUtils.LoadUIEffect("fx_spin_basic", self.config.transform)
    self.effectSpinBasic:SetActive(false)
    self.effectSpinPremium = ResourceLoadUtils.LoadUIEffect("fx_spin_premium", self.config.transform)
    self.effectSpinPremium:SetActive(false)
    self.effectActiveBasic = ResourceLoadUtils.LoadUIEffect("fx_casino_basic_active", self.config.fxCasinoActive)
    self.effectActiveBasic:SetActive(false)
    self.effectRefreshBasic = ResourceLoadUtils.LoadUIEffect("fx_casino_basic_reset", self.config.fxCasinoReset)
    self.effectRefreshBasic:SetActive(false)
    self.effectActivePremium = ResourceLoadUtils.LoadUIEffect("fx_casino_premium_active", self.config.fxCasinoActive)
    self.effectActivePremium:SetActive(false)
    self.effectRefreshPremium = ResourceLoadUtils.LoadUIEffect("fx_casino_premium_reset", self.config.fxCasinoReset)
    self.effectRefreshPremium:SetActive(false)
    self.effectBg = ResourceLoadUtils.LoadUIEffect("fx_casino_bg_active", self.previewCasino:GetFxAnchor())
    self.effectBg:SetActive(false)

    self:InitUpdateTimeForceRefresh()
end

--- @return void
function UIWheelOfFateView:InitUpdateTimeForceRefresh()
    self:InitUpdateTimeNextDay(function(timeNextDay, isSetTime)
        self.config.textForceRefresh.text = string.format("%s <color=#bafe05>%s</color>", self.localizeNextRefresh, timeNextDay)
        if isSetTime == true then
            UIUtils.AlignText(self.config.textForceRefresh)
        end
    end)
end

--- @return void
function UIWheelOfFateView:InitLocalization()
    local localizeRefresh = LanguageUtils.LocalizeCommon("refresh")
    self.config.localizeRefreshGem.text = localizeRefresh
    self.config.localizeRefreshFree.text = localizeRefresh
    local localizeSpin = LanguageUtils.LocalizeCommon("spin_x")
    self.config.localizeSpin1.text = string.format(localizeSpin, 1)
    self.config.localizeSpin10.text = string.format(localizeSpin, 10)
    self.localizeForceRefresh = LanguageUtils.LocalizeCommon("free_refresh")
    self.localizeNextRefresh = LanguageUtils.LocalizeCommon("next_refresh")
    self.config.localizeNextRefresh.text = self.localizeForceRefresh
    self.config.textSkipAnimation.text = LanguageUtils.LocalizeCommon("skip_animation")
end

--- @return void
--- @param result BattleResult
function UIWheelOfFateView:Init(result)
    if result ~= nil then
        self.model.casinoType = result.casinoType
    end
    --- @type PlayerCasinoInBound
    self.server = zg.playerData:GetMethod(PlayerDataMethod.CASINO)
    --- @type CasinoBaseConfig
    self.csv = ResourceMgr.GetCasinoConfig().casinoBaseConfig
    self:_InitCasino(self.model.casinoType)
    ---@type CasinoPriceConfig
    local casinoPriceConfig = ResourceMgr.GetCasinoConfig().casinoPriceDictionary:Get(self.model.casinoType):Get(2)
    --XDebug.Log(LogUtils.ToDetail(ResourceMgr.GetCasinoConfig().casinoPriceDictionary:Get(result.casinoType):GetItems()))
    self.model.numberChip10 = casinoPriceConfig.spinPrice
    self.config.textNumberRune10.text = tostring(self.model.numberChip10)
    self:_InitMoneyBar(self.model.chip)
    --XDebug.Log(self.model.casinoType)
    self.ctrl:InitItemIcon()
    self:UpdateItem()
    self:UpdateRefreshTime()
    self:UpdateWatchAdsButton()
end

--- @return void
function UIWheelOfFateView:UpdateWatchAdsButton()
    if self.model.casinoType == CasinoType.Basic then
        self.numberOfBought = self.server.numberWatchAdBasic
        self.stock = self.csv.numberAdBasic
    else
        self.numberOfBought = self.server.numberWatchAdPremium
        self.stock = self.csv.numberAdPremium
    end

    self.config.spinWatchAds.gameObject:SetActive(self.model.casinoType == CasinoType.Basic)

    self.config.textAdsSpin.text = string.format("%s %s",
            UIUtils.SetColorString(UIUtils.white, LanguageUtils.LocalizeCommon("free")),
            UIUtils.SetColorString(UIUtils.green_light, string.format("%s/%s", self.stock - self.numberOfBought, self.stock)))
    UIUtils.SetActiveColorByMaterial(self.config.spinWatchAds.gameObject, (self.stock - self.numberOfBought) > 0, "ui_gray_mat")
end

--- @return void
function UIWheelOfFateView:UpdateItem()
    for i = 1, self.model.itemConfigList:Count() do
        --- @type ItemIconData
        local iconData = self.model.itemConfigList:Get(i)
        ---@type IconView
        local iconView
        if self.listIconView:Count() < i then
            iconView = SmartPoolUtils.GetIconViewByIconData(iconData, self.config.spin:GetChild(i - 1))
            iconView.config.transform.localPosition = U_Vector3(0, 275, 0)
            iconView:RegisterShowInfo()
            self.listIconView:Add(iconView)
        else
            iconView = self.listIconView:Get(i)
            iconView:SetIconData(iconData)
        end
    end
    self:CheckClaimItem()
end

--- @return void
function UIWheelOfFateView:CheckClaimItem()
    for i = 1, self.listIconView:Count() do
        ---@type RootIconView
        local iconView = self.listIconView:Get(i)
        if self.model.listClaim:IsContainValue(i - 1) then
            iconView:ActiveMaskSelect(true, UIUtils.sizeItem)
        else
            iconView:ActiveMaskSelect(false)
        end
    end
end

--- @return void
function UIWheelOfFateView:StartRefreshTime()
    -- TODO fixed next time
    if self.updateTimeRefresh == nil and self.model.timeRefresh ~= nil then
        --- @param isSetTime boolean
        self.updateTimeRefresh = function(isSetTime)
            if isSetTime == true then
                self:UpdateRefreshTime()
            end
            if self.model.timeRefresh ~= nil then
                self.config.textTimeRefresh.gameObject:SetActive(false)
                if self.model.timeRefresh > 0 then
                    self.model.timeRefresh = self.model.timeRefresh - 1
                    --XDebug.Log(string.format("time%s, %s", time, TimeUtils.GetTimeFromSecond(time)))
                    self.config.textTimeRefresh.text = TimeUtils.SecondsToClock(self.model.timeRefresh)
                else
                    if self.model.casinoType == CasinoType.Basic then
                        zg.playerData:GetMethod(PlayerDataMethod.CASINO).numberRefreshBase = zg.playerData:GetMethod(PlayerDataMethod.CASINO).numberRefreshBase + 1
                        zg.playerData:GetMethod(PlayerDataMethod.CASINO).lastTimeRefreshBase = zg.timeMgr:GetServerTime()
                    else
                        zg.playerData:GetMethod(PlayerDataMethod.CASINO).numberRefreshPremium = zg.playerData:GetMethod(PlayerDataMethod.CASINO).numberRefreshPremium + 1
                        zg.playerData:GetMethod(PlayerDataMethod.CASINO).lastTimeRefreshPremium = zg.timeMgr:GetServerTime()
                    end
                    self:UpdateRefreshTime()
                end
            else
                self:RemoveUpdateTimeRefresh()
            end
        end
        zg.timeMgr:AddUpdateFunction(self.updateTimeRefresh)
    end
end

--- @return void
function UIWheelOfFateView:RemoveUpdateTimeRefresh()
    self.config.textTimeRefresh.gameObject:SetActive(false)
    if self.updateTimeRefresh ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTimeRefresh)
        self.updateTimeRefresh = nil
    end
end

--- @return void
function UIWheelOfFateView:UpdateRefreshTime()
    --- @type PlayerCasinoInBound
    local server = zg.playerData:GetMethod(PlayerDataMethod.CASINO)
    --- @type CasinoBaseConfig
    local csv = ResourceMgr.GetCasinoConfig().casinoBaseConfig
    --XDebug.Log(LogUtils.ToDetail(PlayerData.playerCasinoInBound))
    self.model.timeRefresh = nil
    if self.model.casinoType == CasinoType.Basic then
        if server.numberRefreshBase < csv.basicCasinoMaxFreeRefresh then
            self.model.timeRefresh = zg.timeMgr:GetServerTime() - server.lastTimeRefreshBase
            local delta = csv.basicCasinoFreeRefreshInterval
            if self.model.timeRefresh > delta then
                server.numberRefreshBase = server.numberRefreshBase + math.floor(self.model.timeRefresh / delta)
                self.model.timeRefresh = self.model.timeRefresh % delta
            end
            if server.numberRefreshBase < csv.basicCasinoMaxFreeRefresh then
                self.model.timeRefresh = delta - self.model.timeRefresh
            else
                server.numberRefreshBase = csv.basicCasinoMaxFreeRefresh
                self.model.timeRefresh = nil
            end
        end
    else
        if server.numberRefreshPremium < csv.premiumCasinoMaxFreeRefresh then
            self.model.timeRefresh = zg.timeMgr:GetServerTime() - server.lastTimeRefreshPremium
            local delta = csv.premiumCasinoFreeRefreshInterval
            if self.model.timeRefresh > delta then
                server.numberRefreshPremium = server.numberRefreshPremium + math.floor(self.model.timeRefresh / delta)
                self.model.timeRefresh = self.model.timeRefresh % delta
            end
            if server.numberRefreshPremium < csv.premiumCasinoMaxFreeRefresh then
                self.model.timeRefresh = delta - self.model.timeRefresh
            else
                server.numberRefreshPremium = csv.premiumCasinoMaxFreeRefresh
                self.model.timeRefresh = nil
            end
        end
    end
    self:UpdateRefreshCount()
    if self.model.timeRefresh ~= nil then
        self.config.textTimeRefresh.gameObject:SetActive(false)
        self:StartRefreshTime()
    else
        self.config.textTimeRefresh.gameObject:SetActive(false)
    end
end

--- @return void
function UIWheelOfFateView:UpdateRefreshCount()
    local gem
    local freeCount
    if self.model.casinoType == CasinoType.Basic then
        freeCount = zg.playerData:GetMethod(PlayerDataMethod.CASINO).numberRefreshBase
        gem = ResourceMgr.GetCasinoConfig().casinoBaseConfig.basicCasinoRefreshGemPrice
    else
        freeCount = zg.playerData:GetMethod(PlayerDataMethod.CASINO).numberRefreshPremium
        gem = ResourceMgr.GetCasinoConfig().casinoBaseConfig.premiumCasinoRefreshGemPrice
    end
    if freeCount > 0 then
        self.config.gemRefresh:SetActive(false)
        --self.config.textFreeCount.gameObject:SetActive(true)
        --self.config.textFreeCount.text = tostring(freeCount)
        self.config.buttonRefresh.gameObject:SetActive(false)
        self.config.buttonRefresh2.gameObject:SetActive(false)
    else
        self.config.gemRefresh:SetActive(true)
        --self.config.textFreeCount.gameObject:SetActive(false)
        self.config.textGemPrice.text = tostring(gem)
        self.config.buttonRefresh.gameObject:SetActive(false)
        self.config.buttonRefresh2.gameObject:SetActive(false)
    end
end

--- @return void
---@param casinoType CasinoType
function UIWheelOfFateView:_InitCasino(casinoType)
    if casinoType == CasinoType.Basic then
        self.model.chip = MoneyType.CASINO_BASIC_CHIP
        self.config.arrowBasic:SetActive(true)
        self.config.arrowPremium:SetActive(false)
        self.effectActive = self.effectActiveBasic
        self.effectRefresh = self.effectRefreshBasic
        self.effectSpin = self.effectSpinBasic
    else
        self.model.chip = MoneyType.CASINO_PREMIUM_CHIP
        self.config.arrowBasic:SetActive(false)
        self.config.arrowPremium:SetActive(true)
        self.effectActive = self.effectActivePremium
        self.effectRefresh = self.effectRefreshPremium
        self.effectSpin = self.effectSpinPremium
    end
    self.previewCasino:Show(casinoType)
end

--- @return void
function UIWheelOfFateView:_InitMoneyBar(casinoType)
    self.casinoBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.config.casinoRoot)
    ---@type UnityEngine_Sprite
    local iconCasino = ResourceLoadUtils.LoadMoneyIcon(casinoType)
    self.config.iconLuckyRune1.sprite = iconCasino
    self.config.iconLuckyRune10.sprite = iconCasino
    self.casinoBarView:SetIconData(casinoType)
    if casinoType == MoneyType.CASINO_BASIC_CHIP then
        self.casinoBarView:AddListener(function()
            self:OnClickBuyCasinoCoin()
        end)
    end
end

--- @return void
function UIWheelOfFateView:OnClickBuyCasinoCoin()
    --- @type VipData
    local vip = ResourceMgr.GetVipConfig():GetCurrentBenefits()
    ---@type PlayerCasinoInBound
    local casinoInBound = zg.playerData:GetMethod(PlayerDataMethod.CASINO)
    ---@type CasinoBaseConfig
    local casinoConfig = ResourceMgr.GetCasinoConfig().casinoBaseConfig
    local turnCanBuy = casinoConfig.numberBuyBasicChip - casinoInBound.turnBuyChip + vip.casinoBonusTurnBuyBasicChip
    if turnCanBuy > 0 then
        local callback = function(numberReturn, priceTotal)
            local onReceived = function(result)
                local onSuccess = function()
                    InventoryUtils.Sub(ResourceType.Money, MoneyType.GEM, priceTotal)
                    InventoryUtils.Add(ResourceType.Money, MoneyType.CASINO_BASIC_CHIP, numberReturn)
                    casinoInBound.turnBuyChip = casinoInBound.turnBuyChip + numberReturn
                    SmartPoolUtils.ShowReward1Item(ItemIconData.CreateInstance(ResourceType.Money, MoneyType.CASINO_BASIC_CHIP, numberReturn))
                end
                NetworkUtils.ExecuteResult(result, nil, onSuccess, SmartPoolUtils.LogicCodeNotification)
            end
            NetworkUtils.Request(OpCode.CASINO_CHIP_BUY, UnknownOutBound.CreateInstance(PutMethod.Byte, CasinoType.Basic, PutMethod.Int, numberReturn), onReceived)
        end
        ---@type PopupBuyItemData
        local dataPurchase = PopupBuyItemData()
        dataPurchase:SetData(ResourceType.Money, MoneyType.CASINO_BASIC_CHIP, 1, 1, turnCanBuy,
                MoneyType.GEM, casinoConfig.basicCasinoBuyChipPrice, callback, LanguageUtils.LocalizeMoneyType(MoneyType.CASINO_BASIC_CHIP), LanguageUtils.LocalizeCommon("buy"), false)
        PopupMgr.ShowPopup(UIPopupName.UIPopupBuyItem, dataPurchase)
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("max_turn_bought"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end
end

--- @return void
function UIWheelOfFateView:OnReadyShow(result)
    self:Init(result)
    self:StartRefreshTime()
    self:SetStateToggleSkipAnimation()
end

--- @return void
function UIWheelOfFateView:Hide()
    UIBaseView.Hide(self)
    self:RemoveUpdateTimeRefresh()
    self.casinoBarView:ReturnPool()
    self.previewCasino:Hide()
    for i, v in pairs(self.listIconView:GetItems()) do
        v:ReturnPool()
    end
    self.listIconView:Clear()
    self.spinWheel:Hide()
    self.model.itemConfigList:Clear()
end

--- @return void
function UIWheelOfFateView:SynSpin(angle)
    self.previewCasino:SetRotateWheel(angle)
end

--- @return void
function UIWheelOfFateView:OnClickSpinWatchAds()
    if self.spinWheel.isSpinning == false then
        if self.numberOfBought < self.stock then
            VideoRewardedUtils.SetType(1)
            VideoRewardedUtils.SetAction(function()
                self:RequestSpinWatchAds()
            end)
            IapDataInBound.Validate(function()
                if VideoRewardedUtils.AllowSkipVideo() then
                    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.MAIN_FEATURES, "watch_video", 0)
                    VideoRewardedUtils.RequestToServer()
                else
                    VideoRewardedUtils.OpenRewarded(AdsPlacement.FORTUNE_WHEEL)
                end
            end)
        else
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("max_ads_turn_daily"))
        end
    end
end

function UIWheelOfFateView:RequestSpinWatchAds()
    local touchObject
    zg.audioMgr:PlaySfxUi(SfxUiType.BUY)
    self.previewCasino:PlayAnim()
    ---@type SpinCasinoInBound
    local spinCasinoInBound
    local index = ClientMathUtils.randomHelper:RandomMinMax(1, 9)
    local callbackSpin = function()
        local rewardList = List()
        ---@param v SpinCasinoItemRewardInBound
        for _, v in pairs(spinCasinoInBound.rewardItems:GetItems()) do
            rewardList:Add(v.reward:GetIconData())
        end
        PopupUtils.ShowRewardList(rewardList)
        Coroutine.start(function()
            coroutine.waitforseconds(0.5)
            touchObject:Enable()
        end)
        self.effectActive:SetActive(false)
        self.effectBg:SetActive(false)
        self.effectSpin:SetActive(false)
        self.previewCasino:PlayEffect(false)
    end

    if not self.skipAnimation then
        self.spinWheel.indexTarget = index - 1
        self.spinWheel.isValidate = false
        self.spinWheel.timeDefault = 5
        self.spinWheel:Rotate(callbackSpin)
        self.effectActive:SetActive(true)
        self.effectBg:SetActive(true)
        self.effectSpin:SetActive(true)
    end

    local callback = function(result)
        touchObject = TouchUtils.Spawn("UIWheelOfFateView:OnClickSpin1")
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            spinCasinoInBound = SpinCasinoInBound(buffer)
        end

        local onSuccess = function()
            if self.model.casinoType == CasinoType.Basic then
                self.server.numberWatchAdBasic = self.server.numberWatchAdBasic + 1
            else
                self.server.numberWatchAdPremium = self.server.numberWatchAdPremium + 1
            end

            ---@type SpinCasinoItemRewardInBound
            local spinCasinoItemRewardInBound = spinCasinoInBound.rewardItems:Get(1)
            if self.model.listSingleClaim:IsContainValue(spinCasinoItemRewardInBound.id) == true
                    and self.model.listClaim:IsContainValue(spinCasinoItemRewardInBound.id) == false then
                self.model.listClaim:Add(spinCasinoItemRewardInBound.id)
                self:SetClaimItem(spinCasinoItemRewardInBound.id + 1)
            end
            self.spinWheel.indexTarget = spinCasinoItemRewardInBound.id
            spinCasinoItemRewardInBound.reward:AddToInventory()
            self.ctrl:AddCasinoPoint1()
            if self.skipAnimation then
                callbackSpin()
            else
                self.spinWheel.isValidate = true
            end

            zg.audioMgr:PlaySfxUi(SfxUiType.CASINO_SPIN)
            zg.audioMgr:PlaySfxUi(SfxUiType.BUY)
            self:UpdateWatchAdsButton()
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            self:OnRequestFailed()
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.CASINO_SPIN, UnknownOutBound.CreateInstance(PutMethod.Byte, self.model.casinoType, PutMethod.Bool, true, PutMethod.Bool, true), callback)
end

--- @return void
function UIWheelOfFateView:OnClickSpin1()
    local touchObject
    if self.spinWheel.isSpinning == false then
        local canSpin1 = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, self.model.chip, 1))
        if canSpin1 then
            InventoryUtils.Sub(ResourceType.Money, self.model.chip, 1)
            zg.audioMgr:PlaySfxUi(SfxUiType.BUY)
            self.previewCasino:PlayAnim()
            ---@type SpinCasinoInBound
            local spinCasinoInBound
            local index = ClientMathUtils.randomHelper:RandomMinMax(1, 9)
            --local resetItems = false
            local callbackSpin = function()
                --if resetItems == true then
                --    self:CheckClaimItem()
                --end
                local rewardList = List()
                ---@param v SpinCasinoItemRewardInBound
                for _, v in pairs(spinCasinoInBound.rewardItems:GetItems()) do
                    rewardList:Add(v.reward:GetIconData())
                end
                PopupUtils.ShowRewardList(rewardList)
                Coroutine.start(function()
                    coroutine.waitforseconds(0.5)
                    touchObject:Enable()
                end)
                self.effectActive:SetActive(false)
                self.effectBg:SetActive(false)
                self.effectSpin:SetActive(false)
                self.previewCasino:PlayEffect(false)
            end

            if not self.skipAnimation then
                self.spinWheel.indexTarget = index - 1
                self.spinWheel.isValidate = false
                self.spinWheel.timeDefault = 5
                self.spinWheel:Rotate(callbackSpin)
                self.effectActive:SetActive(true)
                self.effectBg:SetActive(true)
                self.effectSpin:SetActive(true)
            end

            local callback = function(result)
                touchObject = TouchUtils.Spawn("UIWheelOfFateView:OnClickSpin1")
                --- @param buffer UnifiedNetwork_ByteBuf
                local onBufferReading = function(buffer)
                    spinCasinoInBound = SpinCasinoInBound(buffer)
                end

                local onSuccess = function()
                    ---@type SpinCasinoItemRewardInBound
                    local spinCasinoItemRewardInBound = spinCasinoInBound.rewardItems:Get(1)
                    if self.model.listSingleClaim:IsContainValue(spinCasinoItemRewardInBound.id) == true
                            and self.model.listClaim:IsContainValue(spinCasinoItemRewardInBound.id) == false then
                        self.model.listClaim:Add(spinCasinoItemRewardInBound.id)
                        self:SetClaimItem(spinCasinoItemRewardInBound.id + 1)
                        --resetItems = true
                    end
                    self.spinWheel.indexTarget = spinCasinoItemRewardInBound.id
                    spinCasinoItemRewardInBound.reward:AddToInventory()
                    self.ctrl:AddCasinoPoint1()
                    if self.skipAnimation then
                        callbackSpin()
                    else
                        self.spinWheel.isValidate = true
                    end

                    zg.audioMgr:PlaySfxUi(SfxUiType.CASINO_SPIN)
                    zg.audioMgr:PlaySfxUi(SfxUiType.BUY)
                end
                local onFailed = function(logicCode)
                    SmartPoolUtils.LogicCodeNotification(logicCode)
                    self:OnRequestFailed()
                end
                NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
            end
            NetworkUtils.Request(OpCode.CASINO_SPIN, UnknownOutBound.CreateInstance(PutMethod.Byte, self.model.casinoType, PutMethod.Bool, true, PutMethod.Bool, false), callback)
        end
    end
end

--- @return void
function UIWheelOfFateView:OnClickSpin10()
    local touchObject
    --- @type VipData
    local vip = ResourceMgr.GetVipConfig():GetCurrentBenefits()
    local levelRequire, stageRequire = ClientConfigUtils.GetLevelStageRequire(MinorFeatureType.CASINO_MULTIPLE_SPIN)
    if vip.casinoUnlockMultipleSpin == true or
            (levelRequire == nil and stageRequire == nil) then
        if self.spinWheel.isSpinning == false then
            local canSpin10 = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, self.model.chip, self.model.numberChip10))
            if canSpin10 then
                InventoryUtils.Sub(ResourceType.Money, self.model.chip, self.model.numberChip10)
                self.previewCasino:PlayAnim()
                ---@type SpinCasinoInBound
                local spinCasinoInBound
                --local resetItems = false
                local callbackSpin = function()
                    --if resetItems == true then
                    --    self:CheckClaimItem()
                    --end
                    local rewardList = List()
                    ---@type List
                    local dict = List()
                    --- @param casinoReward SpinCasinoItemRewardInBound
                    for _, casinoReward in ipairs(spinCasinoInBound.rewardItems:GetItems()) do
                        local iconData = casinoReward.reward:GetIconData()
                        rewardList:Add(iconData)
                        if dict:IsContainValue(tostring(iconData)) then
                            XDebug.Error("BUG    " .. tostring(iconData))
                        else
                            dict:Add(tostring(iconData))
                        end
                    end

                    PopupUtils.ShowRewardList(rewardList)
                    Coroutine.start(function()
                        coroutine.waitforseconds(0.5)
                        touchObject:Enable()
                    end)
                    self.effectActive:SetActive(false)
                    self.effectBg:SetActive(false)
                    self.effectSpin:SetActive(false)
                    self.previewCasino:PlayEffect(false)
                end
                if not self.skipAnimation then
                    self.spinWheel.isValidate = false
                    self.spinWheel.timeDefault = 5
                    self.spinWheel:Rotate(callbackSpin, nil, self.skipAnimation)
                    self.effectActive:SetActive(true)
                    self.effectBg:SetActive(true)
                    self.effectSpin:SetActive(true)
                end
                local callback = function(result)
                    touchObject = TouchUtils.Spawn("UIWheelOfFateView:OnClickSpin10")
                    --- @param buffer UnifiedNetwork_ByteBuf
                    local onBufferReading = function(buffer)
                        spinCasinoInBound = SpinCasinoInBound(buffer)
                    end

                    local onSuccess = function()
                        --- @param casinoReward SpinCasinoItemRewardInBound
                        for _, casinoReward in ipairs(spinCasinoInBound.rewardItems:GetItems()) do
                            casinoReward.reward:AddToInventory()
                            if self.model.listSingleClaim:IsContainValue(casinoReward.id) == true
                                    and self.model.listClaim:IsContainValue(casinoReward.id) == false then
                                self.model.listClaim:Add(casinoReward.id)
                                self:SetClaimItem(casinoReward.id + 1)
                                --resetItems = true
                            end
                        end
                        ---@type SpinCasinoItemRewardInBound
                        local spinCasinoItemRewardLast = spinCasinoInBound.rewardItems:Get(spinCasinoInBound.rewardItems:Count())
                        self.ctrl:AddCasinoPoint10()
                        self.spinWheel.indexTarget = spinCasinoItemRewardLast.id
                        if self.skipAnimation then
                            callbackSpin()
                        else
                            self.spinWheel.isValidate = true
                        end
                        zg.audioMgr:PlaySfxUi(SfxUiType.CASINO_SPIN)
                        zg.audioMgr:PlaySfxUi(SfxUiType.BUY)
                    end
                    local onFailed = function(logicCode)
                        SmartPoolUtils.LogicCodeNotification(logicCode)
                        self:OnRequestFailed()
                    end
                    NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
                end
                NetworkUtils.Request(OpCode.CASINO_SPIN, UnknownOutBound.CreateInstance(PutMethod.Byte, self.model.casinoType, PutMethod.Bool, false, PutMethod.Bool, false), callback)
            end
        end
    else
        local vipUnlock = ResourceMgr.GetVipConfig():RequireLevelUnlockMultipleSpin()
        SmartPoolUtils.NotificationRequireVipOrLevelAndStage(vipUnlock, levelRequire, stageRequire)
    end
end

--- @return void
--- @param index number
function UIWheelOfFateView:SetClaimItem(index)
    ---@type CasinoItemInBound
    local casinoItemInBound
    if self.model.casinoType == CasinoType.Basic then
        casinoItemInBound = zg.playerData:GetMethod(PlayerDataMethod.CASINO).baseCasinoItems:Get(index)
    else
        casinoItemInBound = zg.playerData:GetMethod(PlayerDataMethod.CASINO).premiumCasinoItems:Get(index)
    end
    casinoItemInBound.isClaim = true
end

--- @return void
function UIWheelOfFateView:OnRequestFailed()
    local callbackSuccess = function()

    end
    local callbackFailed = function()

    end
    PlayerDataRequest.RequestAndCallback(PlayerDataMethod.BASIC_INFO, callbackSuccess, callbackFailed)
end

--- @return void
function UIWheelOfFateView:OnClickReset()
    local touchObject
    if self.spinWheel.isSpinning == false then
        ---@type boolean
        local isRefreshFree = true
        local gem
        local refresh = function()
            ---@type RefreshCasinoInBound
            local refreshCasinoInBound
            local callbackValidate = function()
                if refreshCasinoInBound ~= nil then
                    if self.model.casinoType == refreshCasinoInBound.casinoType then
                        if self.model.casinoType == CasinoType.Basic then
                            zg.playerData:GetMethod(PlayerDataMethod.CASINO).baseCasinoItems = refreshCasinoInBound.casinoItems
                        else
                            zg.playerData:GetMethod(PlayerDataMethod.CASINO).premiumCasinoItems = refreshCasinoInBound.casinoItems
                        end
                        self.ctrl:InitItemIcon()
                        self:UpdateItem()
                    else
                        XDebug.Error("Check casino type return" .. refreshCasinoInBound.casinoType)
                    end
                end
            end
            local callbackFinishSpin = function()
                Coroutine.start(function()
                    coroutine.waitforseconds(0.5)
                    touchObject:Enable()
                end)
                self.effectRefresh:SetActive(false)
                self.previewCasino:PlayEffect(false)
            end
            self.spinWheel.isValidate = false
            self.spinWheel.timeDefault = 3
            self.spinWheel:Rotate(callbackFinishSpin, callbackValidate)
            self.effectRefresh:SetActive(true)
            self.previewCasino:PlayAnim()
            local callback = function(result)
                touchObject = TouchUtils.Spawn("UIWheelOfFateView:OnClickReset")
                --- @param buffer UnifiedNetwork_ByteBuf
                local onBufferReading = function(buffer)
                    refreshCasinoInBound = RefreshCasinoInBound(buffer)
                    if refreshCasinoInBound.isFree == true and isRefreshFree == false then
                        InventoryUtils.Add(ResourceType.Money, MoneyType.GEM, gem)
                        if refreshCasinoInBound.casinoType == CasinoType.Basic then
                            zg.playerData:GetMethod(PlayerDataMethod.CASINO).numberRefreshBase = zg.playerData:GetMethod(PlayerDataMethod.CASINO).numberRefreshBase - 1
                        else
                            zg.playerData:GetMethod(PlayerDataMethod.CASINO).numberRefreshPremium = zg.playerData:GetMethod(PlayerDataMethod.CASINO).numberRefreshPremium - 1
                        end
                    end
                end

                local onSuccess = function()
                    self.spinWheel.isValidate = true
                    zg.audioMgr:PlaySfxUi(SfxUiType.CASINO_REFRESH)
                    zg.audioMgr:PlaySfxUi(SfxUiType.BUY)
                end

                local onFailed = function(logicCode)
                    SmartPoolUtils.LogicCodeNotification(logicCode)
                    self.spinWheel.isValidate = true
                    refreshCasinoInBound = nil
                    XDebug.Error("Refresh Casino Fail")
                end
                NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
            end
            NetworkUtils.Request(OpCode.CASINO_REFRESH, UnknownOutBound.CreateInstance(PutMethod.Byte, self.model.casinoType), callback)
        end

        local checkRefresh = function(gem)
            local canRefresh = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.GEM, gem))
            if canRefresh then
                PopupUtils.ShowPopupNotificationUseResource(MoneyType.GEM, gem, function()
                    isRefreshFree = false
                    InventoryUtils.Sub(ResourceType.Money, MoneyType.GEM, gem)
                    refresh()
                end)
            end
        end

        if self.model.casinoType == CasinoType.Basic then
            if zg.playerData:GetMethod(PlayerDataMethod.CASINO).numberRefreshBase > 0 then
                zg.playerData:GetMethod(PlayerDataMethod.CASINO).numberRefreshBase = zg.playerData:GetMethod(PlayerDataMethod.CASINO).numberRefreshBase - 1
                refresh()
                if zg.playerData:GetMethod(PlayerDataMethod.CASINO).numberRefreshBase == ResourceMgr.GetCasinoConfig().casinoBaseConfig.basicCasinoMaxFreeRefresh - 1 then
                    zg.playerData:GetMethod(PlayerDataMethod.CASINO).lastTimeRefreshBase = zg.timeMgr:GetServerTime()
                    self:UpdateRefreshTime()
                else
                    self:UpdateRefreshCount()
                end
            else
                gem = ResourceMgr.GetCasinoConfig().casinoBaseConfig.basicCasinoRefreshGemPrice
                checkRefresh(gem)
            end
        else
            if zg.playerData:GetMethod(PlayerDataMethod.CASINO).numberRefreshPremium > 0 then
                zg.playerData:GetMethod(PlayerDataMethod.CASINO).numberRefreshPremium = zg.playerData:GetMethod(PlayerDataMethod.CASINO).numberRefreshPremium - 1
                refresh()
                if zg.playerData:GetMethod(PlayerDataMethod.CASINO).numberRefreshPremium == ResourceMgr.GetCasinoConfig().casinoBaseConfig.premiumCasinoMaxFreeRefresh - 1 then
                    zg.playerData:GetMethod(PlayerDataMethod.CASINO).lastTimeRefreshPremium = zg.timeMgr:GetServerTime()
                    self:UpdateRefreshTime()
                else
                    self:UpdateRefreshCount()
                end
            else
                gem = ResourceMgr.GetCasinoConfig().casinoBaseConfig.premiumCasinoRefreshGemPrice
                checkRefresh(gem)
            end
        end
    end
end

--- @return void
function UIWheelOfFateView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIWheelOfFateView:OnClickBackOrClose()
    self:OnReadyHide()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
end

--- @return void
function UIWheelOfFateView:OnClickHelpInfo()
    local info = ""
    if self.model.casinoType == CasinoType.Basic then
        info = LanguageUtils.LocalizeHelpInfo("fortune_wheel_info")
    else
        info = LanguageUtils.LocalizeHelpInfo("destiny_wheel_info")
    end
    ---@type CasinoBaseConfig
    local config = ResourceMgr.GetCasinoConfig().casinoBaseConfig
    info = string.gsub(info, "{1}", tostring(MathUtils.Round(config.basicCasinoFreeRefreshInterval / TimeUtils.SecondAHour)))
    info = string.gsub(info, "{2}", tostring(MathUtils.Round(config.basicCasinoMaxFreeRefresh)))
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, info)
end

function UIWheelOfFateView:Destroy()
    self.previewCasino:OnDestroy()
end

--- @return void
function UIWheelOfFateView:OnClickSkipAnimation()
    self.skipAnimation = not self.skipAnimation
    self:SetStateToggleSkipAnimation()
end

--- @return void
function UIWheelOfFateView:SetStateToggleSkipAnimation()
    self.config.iconTick:SetActive(self.skipAnimation)
end