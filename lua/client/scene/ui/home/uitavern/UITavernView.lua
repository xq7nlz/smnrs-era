require "lua.client.core.network.tavern.TavernAddQuestInBound"
require "lua.client.core.network.tavern.TavernRerollQuestInBound"

--- @class UITavernView : UIBaseView
UITavernView = Class(UITavernView, UIBaseView)

--- @return void
--- @param model UITavernModel
--- @param ctrl UITavernCtrl
function UITavernView:Ctor(model, ctrl)
    ---@type UITavernConfig
    self.config = nil

    --- @type MoneyBarView
    self.questBasicScrollBarView = nil
    --- @type MoneyBarView
    self.questAdvanceScrollBarView = nil
    --- @type MoneyBarView
    self.gemBarView = nil
    --- @type boolean
    self.playEffectAdd = nil
    --- @type boolean
    self.playEffectRefresh = nil

    ---@type TavernConfig
    self.tavernConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    UIBaseView.Ctor(self, model, ctrl)
    --- @type UITavernModel
    self.model = model
    --- @type UITavernCtrl
    self.ctrl = ctrl
end

--- @return void
function UITavernView:OnReadyCreate()
    ---@type UITavernConfig
    self.config = UIBaseConfig(self.uiTransform)

    self:InitScrollView()
    self:InitButtonListener()
    self:InitUpdateTimeNextDay(function(timeNextDay, isSetTime)
        self.config.textTimeReset.text = StringUtils.FormatLocalizeStart1(self.localizeTimeRefresh,
                string.format("<color=#%s>%s/%s</color>", UIUtils.green_light, self.model.numberRefresh, self.numberQuestDaily),
                UIUtils.SetColorString(UIUtils.green_light, timeNextDay))
        if isSetTime == true then
            UIUtils.AlignText(self.config.textTimeReset)
        end
    end)
end

function UITavernView:InitScrollView()
    --- @param obj UITavernQuestView
    --- @param index number
    local onCreateItem = function(obj, index)
        local indexInList = index + 1
        ---@type TavernQuestInBound
        local quest = zg.playerData:GetMethod(PlayerDataMethod.TAVERN).listTavernQuest:Get(indexInList)
        local startQuest = function()
            self:ViewNumberRefresh()
        end
        local cancelQuest = function()
            self:ViewNumberRefresh()
        end
        local lockQuest = function()
            self:ViewNumberRefresh()
        end
        local completeQuest = function()
            ---@type List
            local listTavern = zg.playerData:GetMethod(PlayerDataMethod.TAVERN).listTavernQuest
            listTavern:RemoveByIndex(indexInList)
            self.uiScroll:RefreshCells(listTavern:Count())
            self.config.empty:SetActive(listTavern:Count() == 0)
        end
        obj:SetQuest(quest)
        obj.callbackStartQuest = startQuest
        obj.callbackCancelQuest = cancelQuest
        obj.callbackLockQuest = lockQuest
        obj.callbackCompleteQuest = completeQuest
        if self.playEffectAdd ~= nil and index == 0 then
            obj:PlayAnimAddQuest()
        end

        if self.playEffectRefresh ~= nil and quest.questState == TavernQuestState.WAITING and quest.isLock == false then
            obj:PlayEffectRefresh()
        end
    end

    ---@type UILoopScroll
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.UITavernQuestView, onCreateItem, onCreateItem)
    self.uiScroll:SetUpMotion(MotionConfig(0, 0, 0, 0.04))
end

function UITavernView:InitButtonListener()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonBasicScroll.onClick:AddListener(function()
        self:OnClickBasicScroll()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.buttonPremiumScroll.onClick:AddListener(function()
        self:OnClickPremiumScroll()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.buttonRefesh.onClick:AddListener(function()
        self:OnClickRefresh()
        zg.audioMgr:PlaySfxUi(SfxUiType.BUY)
    end)
    self.config.buttonTutorial.onClick:AddListener(function()
        self:OnClickHelpInfo()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

--- @return void
function UITavernView:InitLocalization()
    self.config.localizeRefresh.text = LanguageUtils.LocalizeCommon("refresh")
    self.config.localizeBasicUse.text = LanguageUtils.LocalizeMoneyType(MoneyType.QUEST_BASIC_SCROLL)
    self.config.localizePremiumUse.text = LanguageUtils.LocalizeMoneyType(MoneyType.QUEST_PREMIUM_SCROLL)
    self.config.textEmpty.text = LanguageUtils.LocalizeCommon("no_tavern_quest")
    self.localizeTimeRefresh = LanguageUtils.LocalizeCommon("quest_refresh_in")
end

function UITavernView:SetNumberQuestDaily()
    --- @type VipData
    local vip = ResourceMgr.GetVipConfig():GetCurrentBenefits()
    self.numberQuestDaily = self.tavernConfig.numberQuestDaily + vip.tavernBonusQuest
end

--- @return void
function UITavernView:OnReadyShow()
    self.tavernConfig = ResourceMgr.GetTavernConfig()
    self:_InitMoneyBar()
    self.ctrl:InitQuestDoing()
    self.ctrl:SortQuest()
    self.config.gameObject:SetActive(true)
    self:RefreshQuest()
    self:ShowAnimationNpc()
    self:SetNumberQuestDaily()
    self.uiScroll:PlayMotion()
end

--- @return void
function UITavernView:Hide()
    UIBaseView.Hide(self)
    self.uiScroll:Hide()
    self.questBasicScrollBarView:ReturnPool()
    self.questAdvanceScrollBarView:ReturnPool()
    self.gemBarView:ReturnPool()
end

--- @return void
function UITavernView:ShowAnimationNpc()
    if self.config.anim.AnimationState ~= nil then
        self.config.anim.AnimationState:ClearTracks()
    end
    self.config.anim.AnimationState:SetAnimation(0, "start", false)
    self.config.anim.AnimationState:AddAnimation(0, "idle", true, 0)
end

--- @return void
function UITavernView:RefreshQuest(scrollToHead)
    --- @type List
    local listTavernQuest = zg.playerData:GetMethod(PlayerDataMethod.TAVERN).listTavernQuest
    self.uiScroll:Resize(listTavernQuest:Count())
    if listTavernQuest:Count() > 0 and scrollToHead == true then
        self.uiScroll:ScrollToCell(0)
    end
    self:ViewNumberRefresh()
    self.config.empty:SetActive(listTavernQuest:Count() == 0)
end

--- @return void
function UITavernView:_InitMoneyBar()
    self.questBasicScrollBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.config.rootQuest1)
    self.questBasicScrollBarView:SetIconData(MoneyType.QUEST_BASIC_SCROLL)

    self.questAdvanceScrollBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.config.rootQuest2)
    self.questAdvanceScrollBarView:SetIconData(MoneyType.QUEST_PREMIUM_SCROLL)

    self.gemBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.config.rootGem)
    self.gemBarView:SetIconData(MoneyType.GEM)
end

--- @return void
function UITavernView:AddQuest(questScroll)
    local canAddQuest = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, questScroll, 1))
    if canAddQuest then
        local callback = function(result)
            --- @param buffer UnifiedNetwork_ByteBuf
            local onBufferReading = function(buffer)
                local tavernAddQuestInBound = TavernAddQuestInBound(buffer)
                for _, v in pairs(tavernAddQuestInBound.listTavernQuest:GetItems()) do
                    zg.playerData:GetMethod(PlayerDataMethod.TAVERN).listTavernQuest:Insert(v, 1)
                end
            end
            local onSuccess = function()
                InventoryUtils.Sub(ResourceType.Money, questScroll, 1)
                self.playEffectAdd = true
                self:RefreshQuest(true)
                self.playEffectAdd = nil
            end
            NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
        end
        NetworkUtils.Request(OpCode.TAVERN_QUEST_ADD, UnknownOutBound.CreateInstance(PutMethod.Byte, questScroll), callback)
    end
end

--- @return void
function UITavernView:OnClickBasicScroll()
    self:AddQuest(MoneyType.QUEST_BASIC_SCROLL)
end

--- @return void
function UITavernView:OnClickPremiumScroll()
    self:AddQuest(MoneyType.QUEST_PREMIUM_SCROLL)
end

--- @return void
function UITavernView:OnClickRefresh()
    local refresh = function()
        local countQuestCanRefresh = 0
        ---@param v TavernQuestInBound
        for i, v in pairs(zg.playerData:GetMethod(PlayerDataMethod.TAVERN).listTavernQuest:GetItems()) do
            if v.isLock == false then
                countQuestCanRefresh = countQuestCanRefresh + 1
            end
        end

        if countQuestCanRefresh > 0 then
            local canRefresh = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.GEM, self.model.gemRefresh), true)
            if canRefresh then
                local callback = function(result)
                    --- @param buffer UnifiedNetwork_ByteBuf
                    local onBufferReading = function(buffer)
                        ---@type TavernRerollQuestInBound
                        local tavernRerollQuestInBound = TavernRerollQuestInBound(buffer)
                        tavernRerollQuestInBound.listTavernQuest:SortWithMethod(SortUtils.SortTavernQuest)
                        local count = 1
                        ---@param v TavernQuestInBound
                        for i, v in ipairs(zg.playerData:GetMethod(PlayerDataMethod.TAVERN).listTavernQuest:GetItems()) do
                            if v.questState == TavernQuestState.WAITING and v.isLock == false then
                                ---@type TavernQuestInBound
                                local tavernReplace = tavernRerollQuestInBound.listTavernQuest:Get(count)
                                zg.playerData:GetMethod(PlayerDataMethod.TAVERN).listTavernQuest:SetItemAtIndex(tavernReplace, i)
                                count = count + 1
                            end
                        end
                    end
                    local onSuccess = function()
                        InventoryUtils.Sub(ResourceType.Money, MoneyType.GEM, self.model.gemRefresh)
                        self.playEffectRefresh = true
                        self.ctrl:SortQuest()
                        self:RefreshQuest(true)
                        self.playEffectRefresh = nil
                        self:ViewNumberRefresh()
                    end
                    NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
                end
                NetworkUtils.Request(OpCode.TAVERN_QUEST_REROLL, nil, callback)
            end
        else
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("not_enough_quest_refresh"))
        end
    end

    local yesCallback = function()
        zg.audioMgr:PlaySfxUi(SfxUiType.CONFIRM)
        refresh()
    end

    PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("want_refresh_tavern"), nil, yesCallback)
end

--- @return void
function UITavernView:ViewNumberRefresh()
    self.model.numberRefresh = 0
    self.model.gemRefresh = 0
    ---@param v TavernQuestInBound
    for _, v in pairs(zg.playerData:GetMethod(PlayerDataMethod.TAVERN).listTavernQuest:GetItems()) do
        if v.questState == TavernQuestState.WAITING and v.isLock == false then
            self.model.numberRefresh = self.model.numberRefresh + 1
            ---@type TavernQuestDataConfig
            local tavernQuestDataConfig = ResourceMgr.GetTavernQuestConfig():GetQuestDataByStar(v.star)
            self.model.gemRefresh = self.model.gemRefresh + tavernQuestDataConfig.refreshGem
        end
    end
    self.config.textGemRefesh.text = tostring(self.model.gemRefresh)
end

function UITavernView:OnClickHelpInfo()
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("tavern_info"))
end

--- @return void
function UITavernView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UITavernView:OnClickBackOrClose()
    self:OnReadyHide()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
end