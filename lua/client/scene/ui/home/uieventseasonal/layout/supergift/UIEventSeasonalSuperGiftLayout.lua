require "lua.client.scene.ui.home.uiEventSeasonal.layout.superGift.SeasonalSummerGameSelectHero"
require "lua.client.data.Event.ExchangeEventConfig"
--- @class UIEventSeasonalSuperGiftLayout : UIEventSeasonalLayout
UIEventSeasonalSuperGiftLayout = Class(UIEventSeasonalSuperGiftLayout, UIEventSeasonalLayout)

local SINGLE_EXCHANGE = 1
local SINGLE_SELECTION = 1
local SINGLE_THROW = 1

--- @param view UIEventSeasonalView
--- @param anchor UnityEngine_RectTransform
function UIEventSeasonalSuperGiftLayout:Ctor(view, tab, anchor)
    self.tab = tab
    --- @type UIEventSeasonalView
    self.view = view
    ---@type UIEventSeasonalSummerGameLayoutConfig
    self.layoutConfig = nil
    ---@type Dictionary
    self.loginRewardDict = Dictionary()
    --- @type EventSeasonalConfig
    self.eventConfig = nil
    ---@type number
    self.idExchange = nil
    ---@type number
    self.exchangeId = nil
    ---@type RewardInBound
    self.exchangeReward = nil
    ---@type RewardInBound
    self.rewardExchange = nil
    ---@type List
    self.listHeroSelectItem = List()
    ---@type number
    self.numberQuestDone = nil
    ---@type boolean
    self.skipAnimation = nil
    ---@type List
    self.listMainReward = List()
    UIEventSeasonalLayout.Ctor(self, view, tab, anchor)
end

function UIEventSeasonalSuperGiftLayout:SetUpLayout()
    UIEventSeasonalLayout.SetUpLayout(self)
end

function UIEventSeasonalSuperGiftLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_seasonal_summer_game_layout", self.anchor)
    UIEventSeasonalLayout.InitLayoutConfig(self, inst)
end

function UIEventSeasonalSuperGiftLayout:InitLocalization()
    UIEventSeasonalLayout.InitLocalization(self)
    self.layoutConfig.textSubEvent.text = LanguageUtils.LocalizeCommon("seasonal_super_gift")
    self.layoutConfig.textTapToClose.text = LanguageUtils.LocalizeCommon("tap_to_close")
    self.layoutConfig.textExchange.text = LanguageUtils.LocalizeCommon("exchange")
    self.layoutConfig.textSelectToExchange.text = LanguageUtils.LocalizeCommon("select_ball_to_exchange")
    self.layoutConfig.textSelectExchangeTo.text = LanguageUtils.LocalizeCommon("select_ball_exchange_to")
    self.layoutConfig.textMainQuest.text = LanguageUtils.LocalizeCommon("seasonal_summer_game_main_quest")
    self.layoutConfig.textBallExchange.text = LanguageUtils.LocalizeCommon("exchange_ball")
    self.layoutConfig.textDetailTab.text = LanguageUtils.LocalizeCommon("seasonal_summer_game_title_detail")
end

function UIEventSeasonalSuperGiftLayout:InitButtonListener()
    self.layoutConfig.backButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
        self:CloseLayout()
    end)
    self.layoutConfig.buttonInfor.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_seasonal_info"))
    end)
    self.layoutConfig.buttonBallExchange.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self.layoutConfig.anchorBallExchange:SetActive(true)
    end)
    self.layoutConfig.buttonBallExchangeClose.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
        self.layoutConfig.anchorBallExchange:SetActive(false)
        self:ClearExchangeState()
    end)
    self.layoutConfig.buttonExchange.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:ExchangeBall()
    end)
    self.layoutConfig.buttonSelectToExchange.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:SelectBall(false)
    end)
    self.layoutConfig.imgSelectBallToExchange.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:SelectBall(false)
    end)
    self.layoutConfig.buttonSelectExchangeTo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:SelectBall(true)
    end)
    self.layoutConfig.imgSelectBallExchangeTo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:SelectBall(true)
    end)
    self.layoutConfig.buttonCloseAnchorThrowBall.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
        self:CloseThrowAnchor()
    end)
    self.layoutConfig.toggleSkipAnimation.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
        self:ToggleSkipAnimation()
    end)
    self.layoutConfig.buttonCollectMainQuest.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
        self:ClaimMainQuest()
    end)
    self.layoutConfig.buttonFinalReward.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
        self:ShowPreviewFinalReward()
    end)
    self.layoutConfig.buttonPreviewReward.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
        self:ShowPreviewReward()
    end)
end

function UIEventSeasonalSuperGiftLayout:InitMoneyBar()
    --- @type List
    self.listMoneyBar = List()
    ---@type MoneyBarView
    local moneyBarView1 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.moneyAnchor)
    moneyBarView1:SetIconData(MoneyType.EVENT_SEASONAL_MONEY)
    moneyBarView1.config.buttonInfo.interactable = true
    moneyBarView1.config.buttonInfo.onClick:RemoveAllListeners()
    moneyBarView1:SetSize(0, 0)
    moneyBarView1.config.buttonInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        moneyBarView1:ShowInfo()
    end)
    moneyBarView1:AddListener(function()
        self.view:SelectTab(EventSeasonalTab.FIREWORK_SHOP)
    end)
    ---@type MoneyBarView
    local moneyBarView2 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.moneyAnchor)
    moneyBarView2:SetIconData(MoneyType.EVENT_SEASONAL_GUN_POWER)
    moneyBarView2.config.buttonInfo.interactable = true
    moneyBarView2.config.buttonInfo.onClick:RemoveAllListeners()
    moneyBarView2:SetSize(0, 0)
    moneyBarView2.config.buttonInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        moneyBarView2:ShowInfo()
    end)
    moneyBarView2:AddListener(function()
        self.view:SelectTab(EventSeasonalTab.FIREWORK_SHOP)
    end)
    self.listMoneyBar:Add(moneyBarView1)
    self.listMoneyBar:Add(moneyBarView2)
end

function UIEventSeasonalSuperGiftLayout:ReturnPoolMoneyBar()
    ---@param v MoneyBarView
    for _, v in pairs(self.listMoneyBar:GetItems()) do
        v:ReturnPool()
    end
    self.listMoneyBar:Clear()
end

----------------------------------------Show------------------------------------------------

function UIEventSeasonalSuperGiftLayout:OnShow()
    UIEventSeasonalLayout.OnShow(self)
    self.layoutConfig.anchorThrowBall.gameObject:SetActive(false)
    self.layoutConfig.anchorBallExchange.gameObject:SetActive(false)
    self.anchor.gameObject:SetActive(true)
    self:InitHeroAnchor()
    self:InitMainQuestReward()
    self:SetStateMainQuest()
end

----------------------------------------HeroSelect------------------------------------------------

function UIEventSeasonalSuperGiftLayout:InitHeroAnchor()
    local dictHeroData = self.eventConfig:GetDictHeroSelect()
    for slotId = 1, dictHeroData:Count() do
        local slotDataModel = self.eventModel:GetSlotDataById(slotId)
        ---@type SeasonalSummerGameSelectHero
        local heroSelectItem = SeasonalSummerGameSelectHero(self.layoutConfig.heroAnchor:GetChild(slotId - 1))
        local selectedHeroId
        ---@type  {ballId, targetBall, listHeroId}
        local slotDataConfig = dictHeroData:Get(slotId)
        heroSelectItem:InitButtonLocalization(LanguageUtils.LocalizeCommon("join"))
        if slotDataModel.heroId < 0 then
            heroSelectItem:InitButtonLocalization(LanguageUtils.LocalizeCommon("select_hero"))
        end
        ---@type function
        local callbackSelect
        ---@type function
        local callbackJoin
        if slotDataModel.heroId < 0 then
            callbackSelect = function()
                ---@type PopupUseItemData
                local data = {}
                data.textItemPool = LanguageUtils.LocalizeCommon("select_hero_pool")
                data.listItem = List()
                data.listItem = slotDataConfig.listHeroId
                data.minSelect = 1
                data.maxSelect = 1
                ---@param listItemSelected List|HeroIconData
                data.callbackSelect = function(listItemSelected)
                    ---@type HeroIconData
                    local heroIconData = listItemSelected:Get(1)
                    if heroIconData then
                        selectedHeroId = heroIconData.heroId
                        heroSelectItem:ShowHero(selectedHeroId)
                        heroSelectItem:InitButtonLocalization(LanguageUtils.LocalizeCommon("join"))
                        self.eventModel:SetHeroToSlot(selectedHeroId)
                        slotDataModel.heroId = selectedHeroId
                        PopupMgr.HidePopup(UIPopupName.UISelectItemPool)
                        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("save_successful"))
                    else
                        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("need_to_select"))
                    end
                end
                PopupMgr.ShowPopup(UIPopupName.UISelectItemPool, data)
            end
        else
            heroSelectItem:ShowHero(slotDataModel.heroId)
        end
        local rewardState = slotDataModel.rewardState
        if rewardState == RewardState.NOT_AVAILABLE_TO_CLAIM then
            callbackJoin = function()
                if slotDataModel.heroId < 0 then
                    callbackSelect()
                else
                    if selectedHeroId then
                        local callbackYes = function()
                            local onSuccess = function()
                                self.eventModel:SetHeroToSlot(selectedHeroId)
                                slotDataModel.heroId = selectedHeroId
                                self:InitThrowAnchor(slotId, slotDataConfig.ballId, slotDataConfig.targetBall, slotDataModel.thrownBall)
                                selectedHeroId = false
                            end
                            local onFailed = function(logicCode)
                                SmartPoolUtils.LogicCodeNotification(logicCode)
                            end
                            NetworkUtils.RequestAndCallback(OpCode.EVENT_SEASONAL_QUIZ_HERO_SELECT,
                                    UnknownOutBound.CreateInstance(PutMethod.Byte, SINGLE_SELECTION, PutMethod.Int, slotId, PutMethod.Int, selectedHeroId),
                                    onSuccess, onFailed)
                        end
                        PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("can_not_reselect_hero"), nil, callbackYes)
                    else
                        self:InitThrowAnchor(slotId, slotDataConfig.ballId, slotDataConfig.targetBall, slotDataModel.thrownBall)
                    end
                end
            end
        elseif rewardState == RewardState.AVAILABLE_TO_CLAIM then
            callbackJoin = function()
                local rewardList = List()
                ---@param buffer UnifiedNetwork_ByteBuf
                local onBufferReading = function(buffer)
                    rewardList = NetworkUtils.GetRewardInBoundList(buffer)
                end
                local onSuccess = function()
                    if rewardList ~= nil or rewardList:Count() > 0 then
                        PopupUtils.ClaimAndShowRewardList(rewardList)
                    end
                    self.eventModel:SetRewardStateSlot(slotId, RewardState.CLAIMED)
                    self:SetStateMainQuest()
                    heroSelectItem:SetRewardState(RewardState.CLAIMED)
                end
                local onFailed = function(logicCode)
                    SmartPoolUtils.LogicCodeNotification(logicCode)
                end
                NetworkUtils.RequestAndCallback(OpCode.EVENT_SEASONAL_SLOT_REWARD_CLAIM,
                        UnknownOutBound.CreateInstance(PutMethod.Byte, slotId), onSuccess, onFailed, onBufferReading)
            end
        elseif rewardState == RewardState.CLAIMED then
            callbackJoin = function()
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("claimed"))
            end
        end
        heroSelectItem:SetData(rewardState, callbackSelect, callbackJoin)
        self.listHeroSelectItem:Add(heroSelectItem)
    end
end

function UIEventSeasonalSuperGiftLayout:ReturnPoolHeroSelectItem()
    ---@param v SeasonalSummerGameSelectHero
    for _, v in pairs(self.listHeroSelectItem:GetItems()) do
        v:ReturnPool()
    end
    self.listHeroSelectItem:Clear()
end

----------------------------------------BallExchange---------------------------------------------

function UIEventSeasonalSuperGiftLayout:ExchangeBall()
    if self.idExchange == nil or self.exchangeId == nil then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reselect_exchange_item"))
    else
        ---@type {moneyType, moneyValue}
        local exchangePrice = self.eventConfig:GetBallExchangePrice()
        local listReward = List()
        local rewardInBound = self.exchangeReward
        rewardInBound.number = SINGLE_EXCHANGE
        listReward:Add(rewardInBound:GetIconData())
        --- @type ExchangeEventConfig
        local exchangeData = ExchangeEventConfig()
        exchangeData.id = self.rewardExchange.id
        exchangeData.itemIconData = ItemIconData.CreateInstance(ResourceType.Money, self.rewardExchange.id, SINGLE_EXCHANGE)
        exchangeData.limit = InventoryUtils.GetMoney(self.rewardExchange.id)
        exchangeData.listRewardItem = listReward
        local data = {}
        data.exchangeData = exchangeData
        data.exchangePrice = exchangePrice
        data.callbackExchangePrice = function(numberExchange)
            self:CallOpCodeExchange(numberExchange)
        end
        PopupMgr.ShowPopup(UIPopupName.UIPopupExchangeMidAutumn, data)
    end
end

function UIEventSeasonalSuperGiftLayout:CallOpCodeExchange(numberExchange)
    local rewardList = List()
    --- @param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        rewardList = NetworkUtils.GetRewardInBoundList(buffer)
    end
    local onSuccess = function()
        InventoryUtils.Sub(ResourceType.Money, self.idExchange, numberExchange)
        if rewardList ~= nil or rewardList:Count() > 0 then
            PopupUtils.ClaimAndShowRewardList(rewardList)
        end
    end
    local onFailed = function()
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("failed"))
    end
    NetworkUtils.RequestAndCallback(OpCode.EVENT_SEASONAL_WATER_BALL_EXCHANGE,
            UnknownOutBound.CreateInstance(PutMethod.Int, numberExchange, PutMethod.Int, self.idExchange, PutMethod.Int, self.exchangeId),
            onSuccess, onFailed, onBufferReading)
end

function UIEventSeasonalSuperGiftLayout:SelectBall(isTarget)
    ---@type {titleText, itemDict| Dictionary, callBackClose| function, isTarget, idExchange, exchangeId}
    local data = {}
    data.titleText = LanguageUtils.LocalizeCommon("select_ball_to_exchange")
    if isTarget then
        data.titleText = LanguageUtils.LocalizeCommon("select_ball_exchange_to")
    end
    data.isTarget = isTarget
    data.itemDict = self.eventConfig:GetBallExchange()
    data.idExchange = self.idExchange
    data.exchangeId = self.exchangeId
    data.callbackSelect = function(result)
        if result then
            ---@type RewardInBound
            local rewardInBound = result
            local sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.seasonalBall, rewardInBound.id)
            if isTarget then
                self.exchangeId = rewardInBound.id
                self.exchangeReward = rewardInBound
                self.layoutConfig.imgBallExchangeTo.sprite = sprite
                self.layoutConfig.imgBallExchangeTo.gameObject:SetActive(true)
            else
                self.idExchange = rewardInBound.id
                self.rewardExchange = rewardInBound
                self.layoutConfig.imgBallToExchange.sprite = sprite
                self.layoutConfig.imgBallToExchange.gameObject:SetActive(true)
            end
            self:SetExchangeState(isTarget, false)
        else
            if isTarget then
                self.exchangeId = nil
                self.layoutConfig.imgBallExchangeTo.gameObject:SetActive(false)
            else
                self.idExchange = nil
                self.layoutConfig.imgBallToExchange.gameObject:SetActive(false)
            end
            self:SetExchangeState(isTarget, true)
        end
    end
    PopupMgr.ShowPopup(UIPopupName.UIPopupFourItem, data)
end

function UIEventSeasonalSuperGiftLayout:SetExchangeState(isTarget, isActive)
    if isTarget then
        self.layoutConfig.bgTextRight:SetActive(isActive)
        self.layoutConfig.buttonSelectExchangeTo.gameObject:SetActive(isActive)
    else
        self.layoutConfig.bgTextLeft:SetActive(isActive)
        self.layoutConfig.buttonSelectToExchange.gameObject:SetActive(isActive)
    end
end

function UIEventSeasonalSuperGiftLayout:SetExchangeState(isTarget, isActive)
    if isTarget then
        self.layoutConfig.bgTextRight:SetActive(isActive)
        self.layoutConfig.buttonSelectExchangeTo.gameObject:SetActive(isActive)
    else
        self.layoutConfig.bgTextLeft:SetActive(isActive)
        self.layoutConfig.buttonSelectToExchange.gameObject:SetActive(isActive)
    end
end

function UIEventSeasonalSuperGiftLayout:ClearExchangeState()
    self.idExchange = nil
    self.exchangeId = nil
    self.layoutConfig.bgTextRight:SetActive(true)
    self.layoutConfig.buttonSelectExchangeTo.gameObject:SetActive(true)
    self.layoutConfig.bgTextLeft:SetActive(true)
    self.layoutConfig.buttonSelectToExchange.gameObject:SetActive(true)
    self.layoutConfig.imgBallExchangeTo.gameObject:SetActive(false)
    self.layoutConfig.imgBallToExchange.gameObject:SetActive(false)
end

----------------------------------------BallThrow---------------------------------------------

function UIEventSeasonalSuperGiftLayout:ShowPreviewReward()
    local data = {}
    data.uiPoolType = UIPoolType.RateView
    data.listRewardIconData = self.eventConfig:GetBallThrowReward()
    PopupMgr.ShowPopup(UIPopupName.UIShowItemInRandomPool, data)
end

function UIEventSeasonalSuperGiftLayout:SetButtonThrowState(moneyId)
    local number = InventoryUtils.GetMoney(moneyId)
    UIUtils.SetActiveColorByMaterial(self.layoutConfig.buttonThrowSingle.gameObject, number > 0, "ui_gray_mat")
    UIUtils.SetActiveColorByMaterial(self.layoutConfig.buttonThrowAll.gameObject, number > 0, "ui_gray_mat")
end

function UIEventSeasonalSuperGiftLayout:SubAnchorInitListener(slotId, moneyType, targetBall)
    self.layoutConfig.buttonThrowSingle.onClick:RemoveAllListeners()
    self.layoutConfig.buttonThrowSingle.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
        self:ThrowBall(slotId, moneyType, targetBall, true)
    end)
    self.layoutConfig.buttonThrowAll.onClick:RemoveAllListeners()
    self.layoutConfig.buttonThrowAll.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
        self:ThrowBall(slotId, moneyType, targetBall, false)
    end)
    self.layoutConfig.buttonTest.gameObject:SetActive(false)
    self.layoutConfig.buttonTest.onClick:RemoveAllListeners()
    self.layoutConfig.buttonTest.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
        self:TestAnim(moneyType)
    end)
end

function UIEventSeasonalSuperGiftLayout:TestAnim(moneyId)
    if not self.skipAnimation then
        self:MoveProjectileTransformRandom(moneyId)
    else
        self:PlayParticleByType(moneyId)
    end
end

---@return UnityEngine_GameObject
function UIEventSeasonalSuperGiftLayout:GetProjectileByType(moneyId)
    if moneyId == MoneyType.EVENT_SEASONAL_BLUE_BALL then
        return self.layoutConfig.projectileWater
    elseif moneyId == MoneyType.EVENT_SEASONAL_GREEN_BALL then
        return self.layoutConfig.projectileNature
    elseif moneyId == MoneyType.EVENT_SEASONAL_GREY_BALL then
        return self.layoutConfig.projectileAbyss
    elseif moneyId == MoneyType.EVENT_SEASONAL_RED_BALL then
        return self.layoutConfig.projectileFire
    end
end

function UIEventSeasonalSuperGiftLayout:MoveProjectileTransformRandom(moneyId)
    ---@type UnityEngine_GameObject
    local gameObject = self:GetProjectileByType(moneyId)
    self:CheckParent(gameObject.transform)
    self:SpawnProjectileInThrowPos(gameObject)
    self:MoveProjectileToTarget(gameObject, moneyId)
end

--- @param gameObject UnityEngine_GameObject
function UIEventSeasonalSuperGiftLayout:Set(gameObject)
    gameObject:SetActive(false)
    local x = math.random(500, 892)
    local y = math.random(-580, 230)
    local parameter = self:RandomSign()
    local sign = parameter / math.abs(parameter)
    x = x * sign
    gameObject.transform.localPosition = U_Vector3(x, y, 0)
    gameObject:SetActive(true)
end

--- @param gameObject UnityEngine_GameObject
function UIEventSeasonalSuperGiftLayout:SpawnProjectileRandom(gameObject)
    gameObject:SetActive(false)
    local x = math.random(500, 892)
    local y = math.random(-580, 230)
    local parameter = self:RandomSign()
    local sign = parameter / math.abs(parameter)
    x = x * sign
    gameObject.transform.localPosition = U_Vector3(x, y, 0)
    gameObject:SetActive(true)
end

--- @param gameObject UnityEngine_GameObject
function UIEventSeasonalSuperGiftLayout:SpawnProjectileInThrowPos(gameObject)
    gameObject:SetActive(false)
    local throwPosX = self.layoutConfig.targetDynamic.gameObject.transform.localPosition.x
    local throwPos = U_Vector3(-throwPosX, -727, 0)
    gameObject.transform.localPosition = throwPos
    gameObject:SetActive(true)
end

--- @param gameObject UnityEngine_GameObject
function UIEventSeasonalSuperGiftLayout:MoveProjectileToTarget(gameObject, moneyId)
    DOTweenUtils.DOLocalMove(gameObject.transform, U_Vector3(0, 0, 0), 0.5, nil,
            function()
                gameObject:SetActive(false)
                self:PlayParticleByType(moneyId)
            end)
end

function UIEventSeasonalSuperGiftLayout:RandomSign()
    local result = math.random(-10, 10)
    if result == 0 then
        result = self:RandomSign()
    end
    return result
end

function UIEventSeasonalSuperGiftLayout:HideAllBallProjectile()
    self.layoutConfig.projectileFire:SetActive(false)
    self.layoutConfig.projectileAbyss:SetActive(false)
    self.layoutConfig.projectileNature:SetActive(false)
    self.layoutConfig.projectileWater:SetActive(false)
end

function UIEventSeasonalSuperGiftLayout:GetParticleSystemByType(moneyId)
    if moneyId == MoneyType.EVENT_SEASONAL_BLUE_BALL then
        return self.layoutConfig.fxUiImpactWater
    elseif moneyId == MoneyType.EVENT_SEASONAL_GREEN_BALL then
        return self.layoutConfig.fxUiImpactNature
    elseif moneyId == MoneyType.EVENT_SEASONAL_GREY_BALL then
        return self.layoutConfig.fxUiImpactAbyss
    elseif moneyId == MoneyType.EVENT_SEASONAL_RED_BALL then
        return self.layoutConfig.fxUiImpactFire
    end
end

---@param transform UnityEngine_Transform
function UIEventSeasonalSuperGiftLayout:CheckParent(transform)
    if self.skipAnimation then
        transform:SetParent(self.layoutConfig.fxAnchorStatic)
    else
        transform:SetParent(self.layoutConfig.fxAnchorDynamic)
    end
    transform.localPosition = U_Vector3(0, 0, 0)
end

function UIEventSeasonalSuperGiftLayout:PlayParticleByType(moneyId)
    local particleSystem = self:GetParticleSystemByType(moneyId)
    self:CheckParent(particleSystem.transform)
    self:PlayParticle(particleSystem)
end

function UIEventSeasonalSuperGiftLayout:StopAllParticle()
    self:StopParticle(self.layoutConfig.fxUiImpactWater)
    self:StopParticle(self.layoutConfig.fxUiImpactNature)
    self:StopParticle(self.layoutConfig.fxUiImpactAbyss)
    self:StopParticle(self.layoutConfig.fxUiImpactFire)
end

--- @param particle UnityEngine_ParticleSystem
function UIEventSeasonalSuperGiftLayout:PlayParticle(particle)
    particle.gameObject:SetActive(true)
    if particle.isPlaying == true then
        particle:Stop()
    end
    particle:Play()
end

--- @param particle UnityEngine_ParticleSystem
function UIEventSeasonalSuperGiftLayout:StopParticle(particle)
    particle:Stop()
    particle.gameObject:SetActive(false)
end

function UIEventSeasonalSuperGiftLayout:ToggleSkipAnimation()
    self.skipAnimation = not self.skipAnimation
    self:SetStateSkipAnimationTick()
end

function UIEventSeasonalSuperGiftLayout:SetStateSkipAnimationTick()
    self.layoutConfig.iconTick.gameObject:SetActive(self.skipAnimation)
    self.layoutConfig.targetStatic.gameObject:SetActive(self.skipAnimation)
    self.layoutConfig.targetDynamic.gameObject:SetActive(not self.skipAnimation)
    self:StopAllParticle()
end

function UIEventSeasonalSuperGiftLayout:ThrowBall(slotId, moneyType, targetBall, isSingle)
    local number = SINGLE_THROW
    if not isSingle then
        number = InventoryUtils.GetMoney(moneyType)
        if number <= 0 then
            number = 1
        end
        local thrownBall = self.eventModel:GetSlotDataById(slotId).thrownBall
        local limit = targetBall - thrownBall
        if number > limit then
            number = limit
        end
    end
    if number > 0 then
        local canExchange = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, moneyType, number))
        if canExchange then
            self:PlayAnimBeforeCallOpCode(slotId, moneyType, targetBall, number)
        end
    end
end

--- @return void
function UIEventSeasonalSuperGiftLayout:PlayAnimBeforeCallOpCode(slotId, moneyType, targetBall, number)
    if not self.skipAnimation then
        self.coroutine = Coroutine.start(function()
            self:SetButtonInteractable(false)
            self:MoveProjectileTransformRandom(moneyType)
            coroutine.waitforseconds(1)
            self:CallOpCodeThrowBall(slotId, moneyType, targetBall, number)
            coroutine.waitforseconds(0.5)
            self:SetButtonInteractable(true)
        end)
    else
        self:PlayParticleByType(moneyType)
        self:CallOpCodeThrowBall(slotId, moneyType, targetBall, number)
    end
end

--- @return void
function UIEventSeasonalSuperGiftLayout:StopCoroutine()
    if self.coroutine ~= nil then
        Coroutine.stop(self.coroutine)
        self.coroutine = nil
    end
end

function UIEventSeasonalSuperGiftLayout:CallOpCodeThrowBall(slotId, moneyType, targetBall, number)
    local rewardList = List()
    ---@param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        rewardList = NetworkUtils.GetRewardInBoundList(buffer)
    end
    local onSuccess = function()
        self.eventModel:AddBallThrownToSlot(slotId, number)
        InventoryUtils.Sub(ResourceType.Money, moneyType, number)
        self:SubAnchorSetTextDetail(targetBall, self.eventModel:GetSlotDataById(slotId).thrownBall)
        if rewardList ~= nil or rewardList:Count() > 0 then
            PopupUtils.ClaimAndShowRewardList(rewardList)
        end
        if self.eventModel:GetSlotDataById(slotId).thrownBall >= targetBall then
            self.eventModel:SetRewardStateSlot(slotId, RewardState.AVAILABLE_TO_CLAIM)
            self:CloseThrowAnchor()
            self:ReturnPoolHeroSelectItem()
            self:InitHeroAnchor()
            self:SetStateMainQuest()
        end
    end
    local onFailed = function(logicCode)
        SmartPoolUtils.LogicCodeNotification(logicCode)
    end
    NetworkUtils.RequestAndCallback(OpCode.EVENT_SEASONAL_WATER_BALL_USE,
            UnknownOutBound.CreateInstance(PutMethod.Byte, slotId, PutMethod.Byte, number),
            onSuccess, onFailed, onBufferReading)
end

function UIEventSeasonalSuperGiftLayout:SetButtonInteractable(isInteractable)
    self.layoutConfig.buttonThrowSingle.interactable = isInteractable
    self.layoutConfig.buttonThrowAll.interactable = isInteractable
    self.layoutConfig.toggleSkipAnimation.interactable = isInteractable
    self.layoutConfig.buttonPreviewReward.interactable = isInteractable
    self.layoutConfig.buttonCloseAnchorThrowBall.interactable = isInteractable
end

function UIEventSeasonalSuperGiftLayout:SubAnchorInitMoneyBar(ballId)
    ---@type MoneyBarView
    self.moneyBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.ballMoneyAnchor)
    self.moneyBarView:SetIconData(ballId)
    self.moneyBarView.config.buttonInfo.interactable = true
    self.moneyBarView.config.buttonInfo.onClick:RemoveAllListeners()
    self.moneyBarView:SetSize(0, 0)
    self.moneyBarView.config.buttonInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self.moneyBarView:ShowInfo()
    end)
end

function UIEventSeasonalSuperGiftLayout:SubAnchorReturnPoolMoneyBar()
    if self.moneyBarView then
        self.moneyBarView:ReturnPool()
        self.moneyBarView = nil
    end
end

function UIEventSeasonalSuperGiftLayout:SubAnchorInitLocalize()
    self.layoutConfig.textThrowTab.text = LanguageUtils.LocalizeCommon("seasonal_throw_ball")
    self.layoutConfig.textThrowSingle.text = LanguageUtils.LocalizeCommon("throw_single")
    self.layoutConfig.textThrowAll.text = LanguageUtils.LocalizeCommon("throw_all")
    self.layoutConfig.textSkipAnimation.text = LanguageUtils.LocalizeCommon("skip_animation")
end

function UIEventSeasonalSuperGiftLayout:SubAnchorSetTextDetail(targetBall, currentBall)
    self.layoutConfig.textThrowDetail.text = string.format(LanguageUtils.LocalizeCommon("throw_%s_time_execute_target") .. ": %s/%s", targetBall, currentBall, targetBall)
end

function UIEventSeasonalSuperGiftLayout:InitThrowAnchor(slotId, ballId, targetBall, currentBall)
    self.layoutConfig.anchorThrowBall.gameObject:SetActive(true)
    self.skipAnimation = false
    self:SetStateSkipAnimationTick()
    self:SubAnchorInitLocalize()
    self:SubAnchorSetTextDetail(targetBall, currentBall)
    self:SubAnchorInitMoneyBar(ballId)
    self:SetButtonThrowState(ballId)
    self:SubAnchorInitListener(slotId, ballId, targetBall)
    self:SetButtonInteractable(true)
    self:HideAllBallProjectile()
    self:StopAllParticle()
end

function UIEventSeasonalSuperGiftLayout:CloseThrowAnchor()
    self.layoutConfig.anchorThrowBall.gameObject:SetActive(false)
    self:SubAnchorReturnPoolMoneyBar()
    self:StopAllParticle()
    self:SetButtonInteractable(true)
    self:StopCoroutine()
end

----------------------------------------MainQuest---------------------------------------------

function UIEventSeasonalSuperGiftLayout:InitMainQuestReward()
    self.listMainReward = List()
    ---@type RootIconView
    local rootIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.layoutConfig.finalRewardAnchor)
    rootIconView:SetIconData(self.eventConfig:GetSummerGameFinalReward():GetIconData())
    rootIconView:RegisterShowInfo()
    self.listMainReward:Add(rootIconView)
end

function UIEventSeasonalSuperGiftLayout:ReturnPoolMainQuestReward()
    ---@prarm v RootIconView
    for _, v in pairs(self.listMainReward:GetItems()) do
        v:ReturnPool()
    end
    self.listMainReward:Clear()
end

function UIEventSeasonalSuperGiftLayout:SetStateMainQuest()
    local target = self.eventConfig:GetDictHeroSelect():Count()
    self.numberQuestDone = 0
    ---@param v {heroId, thrownBall, rewardState}
    for _, v in pairs(self.eventModel:GetDictHeroSelect():GetItems()) do
        if v.rewardState == RewardState.CLAIMED or v.rewardState == RewardState.AVAILABLE_TO_CLAIM then
            self.numberQuestDone = self.numberQuestDone + 1
        end
    end
    self.layoutConfig.textProgress.text = string.format("%s/%s", self.numberQuestDone, target)
    self.layoutConfig.progressBarValue.fillAmount = self.numberQuestDone / target
    local state = self.eventModel:GetSummerGameFinalRewardState()
    if self.numberQuestDone >= target and state == RewardState.NOT_AVAILABLE_TO_CLAIM then
        self.eventModel:SetSummerGameFinalRewardStats(RewardState.AVAILABLE_TO_CLAIM)
    end
    self:SetButtonCollectMainQuest(state)
    self.layoutConfig.mainQuestNoti:SetActive(state == RewardState.AVAILABLE_TO_CLAIM)
    UIUtils.SetActiveColorByMaterial(self.layoutConfig.buttonCollectMainQuest, state ~= RewardState.CLAIMED, "ui_gray_mat")
end

---@param rewardState RewardState
function UIEventSeasonalSuperGiftLayout:SetButtonCollectMainQuest(rewardState)
    if rewardState == RewardState.NOT_AVAILABLE_TO_CLAIM then
        self.layoutConfig.textCollectMainQuest.text = LanguageUtils.LocalizeCommon("claim")
    elseif rewardState == RewardState.AVAILABLE_TO_CLAIM then
        self.layoutConfig.textCollectMainQuest.text = LanguageUtils.LocalizeCommon("claim")
    elseif rewardState == RewardState.CLAIMED then
        self.layoutConfig.textCollectMainQuest.text = LanguageUtils.LocalizeCommon("claimed")
    end
end

function UIEventSeasonalSuperGiftLayout:ClaimMainQuest()
    local target = self.eventConfig:GetDictHeroSelect():Count()
    if self.numberQuestDone < target then
        SmartPoolUtils.ShowShortNotification(string.format(LanguageUtils.LocalizeCommon("complete_%s_more_to_reward"), target - self.numberQuestDone))
    else
        if self.eventModel:GetSummerGameFinalRewardState() == RewardState.AVAILABLE_TO_CLAIM then
            local rewardList = List()
            ---@param buffer UnifiedNetwork_ByteBuf
            local onBufferReading = function(buffer)
                rewardList = NetworkUtils.GetRewardInBoundList(buffer)
            end
            local onSuccess = function()
                if rewardList ~= nil or rewardList:Count() > 0 then
                    PopupUtils.ClaimAndShowRewardList(rewardList)
                end
                self.eventModel:SetSummerGameFinalRewardStats(RewardState.CLAIMED)
                self:SetButtonCollectMainQuest(RewardState.CLAIMED)
            end
            local onFailed = function(logicCode)
                SmartPoolUtils.LogicCodeNotification(logicCode)
            end
            NetworkUtils.RequestAndCallback(OpCode.EVENT_SEASONAL_QUIZ_FINAL_REWARD_CLAIM, nil, onSuccess, onFailed, onBufferReading)
        end
    end
end

function UIEventSeasonalSuperGiftLayout:ShowPreviewFinalReward()
    local rewardInBound = self.eventConfig:GetSummerGameFinalReward()
    local data = {}
    data.type = rewardInBound.type
    data.id = rewardInBound.id
    PopupMgr.ShowPopup(UIPopupName.UISkinPreview, data)
end

----------------------------------------Hide---------------------------------------------

function UIEventSeasonalSuperGiftLayout:OnHide()
    UIEventSeasonalLayout.OnHide(self)
    self:ReturnPoolHeroSelectItem()
    self:ReturnPoolMainQuestReward()
    self:ClearExchangeState()
    self:CloseThrowAnchor()
    self:SetButtonInteractable(true)
    self:StopCoroutine()
end