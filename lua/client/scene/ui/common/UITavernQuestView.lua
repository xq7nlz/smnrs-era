---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.UITavernQuestConfig"

--- @class UITavernQuestView : MotionIconView
UITavernQuestView = Class(UITavernQuestView, MotionIconView)

--- @return void
function UITavernQuestView:Ctor()
    MotionIconView.Ctor(self)
    ---@type TavernQuestInBound
    self.quest = nil
    ---@type RootIconView
    self.iconView = nil
    ---@type TavernQuestDataConfig
    self.tavernQuestDataConfig = nil
    ---@type function
    self.updateTime = nil
    ---@type function
    self.delayRequestLock = nil
    ---@type function
    self.callbackStartQuest = nil
    ---@type function
    self.callbackCancelQuest = nil
    ---@type function
    self.callbackSpeedUpQuest = nil
    ---@type function
    self.callbackCompleteQuest = nil
    ---@type function
    self.callbackLockQuest = nil
    ---@type function
    self.coroutineAnimAddQuest = nil

    self:InitUpdateTime()
end

--- @return void
function UITavernQuestView:InitLocalization()
    self.config.localizeStart.text = LanguageUtils.LocalizeCommon("start")
    self.config.localizeComplete.text = LanguageUtils.LocalizeCommon("complete")
    self.config.localizeFree.text = LanguageUtils.LocalizeCommon("free")
    self.config.localizeSpeedUp.text = LanguageUtils.LocalizeCommon("speed_up")
    self.config.textQuestComplete.text = LanguageUtils.LocalizeCommon("complete")
end

--- @return void
function UITavernQuestView:SetPrefabName()
    self.prefabName = 'tavern_quest'
    self.uiPoolType = UIPoolType.UITavernQuestView
end

--- @return void
--- @param transform UnityEngine_Transform
function UITavernQuestView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    --- @type UITavernQuestConfig
    ---@type UITavernQuestConfig
    self.config = UIBaseConfig(transform)

    self:InitButtonListener()
end

function UITavernQuestView:InitButtonListener()
    self.config.buttonStart.onClick:AddListener(function()
        self:OnClickQuest()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.buttonLock.onClick:AddListener(function()
        self:OnClickLock()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.buttonSpeedUp.onClick:AddListener(function()
        self:OnClickSpeedUp()
        zg.audioMgr:PlaySfxUi(SfxUiType.BUY)
    end)
    self.config.buttonFree.onClick:AddListener(function()
        self:OnClickFreeQuest()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.buttonComplete.onClick:AddListener(function()
        self:OnClickComplete()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

--- @return void
function UITavernQuestView:ReturnPool()
    MotionIconView.ReturnPool(self)
    self:RemoveUpdateTime()
    self:ReturnPoolEffectAdd()
    self:ReturnPoolEffectRefresh()
    self:ReturnPoolEffectStart()
    self:ReturnPoolEffectSpeedUp()
    self:StopAnimAddQuest()
end

--- @return void
---@param quest TavernQuestInBound
function UITavernQuestView:SetQuest(quest)
    self.quest = quest
    if self.quest.questState == TavernQuestState.DONE then
        self.quest.inventoryHeroList:Clear()
    end
    --self.config.textQuest.text = LanguageUtils.LocalizeNameQuestTavern(self.quest.star)
    self.tavernQuestDataConfig = ResourceMgr.GetTavernQuestConfig():GetQuestDataByStar(self.quest.star)
    self:RemoveUpdateTime()
    if self.quest.questState == TavernQuestState.DOING then
        self:StartTimeQuest()
    end
    self:ViewLock()
    self:ViewQuest()
    self:ViewStage()
    self.config.transform.sizeDelta = U_Vector2(1480.2, 143)
    self.config.transform.localScale = U_Vector3.one
    --XDebug.Log(LogUtils.ToDetail(self.quest))
end

function UITavernQuestView:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeQuest()
        else
            self.timeQuest = self.timeQuest - 1
        end
        self.quest.questState = TavernQuestState.DOING
        self.config.textAutoTime.text = TimeUtils.SecondsToClock(self.timeQuest)
        self.config.bgTimeProcess.fillAmount = self.timeQuest / self.tavernQuestDataConfig.time
        if self.timeQuest <= 0 then
            self.quest.questState = TavernQuestState.DONE
            self.quest.inventoryHeroList:Clear()
            self:ViewStage()
            self:ViewLock()
            self:RemoveUpdateTime()
        end
    end
end

--- @return void
function UITavernQuestView:StartTimeQuest()
    self.config.bgTimeProcessFull:SetActive(false)
    self:RemoveUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

--- @return void
function UITavernQuestView:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

--- @return number
function UITavernQuestView:SetTimeQuest()
    self.timeQuest = self.tavernQuestDataConfig.time - (zg.timeMgr:GetServerTime() - self.quest.startTime)
end

--- @return void
function UITavernQuestView:OnClickQuest()
    local callbackStart = function()
        self:CallbackStartQuest()
    end
    PopupMgr.ShowPopup(UIPopupName.UIPopupTavernReward, { ["quest"] = self.quest, ["callbackStart"] = callbackStart })
end

--- @return void
function UITavernQuestView:OnClickLock()
    if self.quest.questState == TavernQuestState.DOING then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("in_progress"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    elseif self.quest.questState == TavernQuestState.DONE then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("completed"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    else
        local isLock = not self.quest.isLock
        self.quest.isLock = isLock
        self:ViewLock()
        if self.callbackLockQuest ~= nil then
            self.callbackLockQuest()
        end
        NetworkUtils.RequestAndCallback(OpCode.TAVERN_QUEST_LOCK, UnknownOutBound.CreateInstance(PutMethod.Long, self.quest.id, PutMethod.Bool, isLock))
    end
end

--- @return void
function UITavernQuestView:OnClickBackOrClose()
    local cancelQuest = function()
        NetworkUtils.RequestAndCallback(OpCode.TAVERN_QUEST_CANCEL, UnknownOutBound.CreateInstance(PutMethod.Long, self.quest.id))
        self.quest.questState = TavernQuestState.WAITING
        self:RemoveUpdateTime()
        self.quest.inventoryHeroList:Clear()
        self.quest.isLock = false
        self:ViewLock()
        self:ViewStage()
        if self.callbackCancelQuest ~= nil then
            self.callbackCancelQuest()
        end
    end

    local yesCallback = function()
        cancelQuest()
        zg.audioMgr:PlaySfxUi(SfxUiType.CONFIRM)
    end

    PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("want_to_cancel_quest"), nil, yesCallback)
end

--- @return void
function UITavernQuestView:SpeedUpQuest()
    local canSpeedUp
    if self.tavernQuestDataConfig.speedUpGem  <=  0 then
        canSpeedUp = true
    else
        canSpeedUp = InventoryUtils.IsEnoughSingleResourceRequirement(
                RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.GEM, self.tavernQuestDataConfig.speedUpGem))
    end
    if canSpeedUp then
        NetworkUtils.RequestAndCallback(OpCode.TAVERN_QUEST_SPEED_UP, UnknownOutBound.CreateInstance(PutMethod.Long, self.quest.id))
        InventoryUtils.Sub(ResourceType.Money, MoneyType.GEM, self.tavernQuestDataConfig.speedUpGem)
        self.quest.questState = TavernQuestState.DONE
        self.quest.inventoryHeroList:Clear()
        self:RemoveUpdateTime()
        self:ViewStage()
        if self.callbackSpeedUpQuest ~= nil then
            self.callbackSpeedUpQuest()
        end
        self:PlayEffectSpeedUp()
    end
end

--- @return void
function UITavernQuestView:OnClickSpeedUp()
    local yesCallback = function()
        self:SpeedUpQuest()
        zg.audioMgr:PlaySfxUi(SfxUiType.CONFIRM)
    end
    PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("want_to_speed_up"), nil, yesCallback)
end

--- @return void
function UITavernQuestView:OnClickFreeQuest()
    self:SpeedUpQuest()
end

--- @return void
function UITavernQuestView:OnClickComplete()
    local callback = function(result)
        ----- @param buffer UnifiedNetwork_ByteBuf
        --local onBufferReading = function(buffer)
        --    local questId = buffer:GetLong()
        --end
        local onSuccess = function()
            self.quest.reward:AddToInventory()
            if self.callbackCompleteQuest ~= nil then
                self.callbackCompleteQuest()
            end
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.TAVERN_QUEST_COMPLETE, UnknownOutBound.CreateInstance(PutMethod.Long, self.quest.id), callback)
    SmartPoolUtils.ShowReward1Item(ItemIconData.Clone(self.iconView.iconData))
end

--- @return void
function UITavernQuestView:ViewQuest()
    if self.iconView == nil then
        self.iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.item.transform)
        self.iconView:RegisterShowInfo()
    end
    self.iconView:SetIconData(self.quest.reward:GetIconData())

    self.quest.questName = LanguageUtils.LocalizeNameQuestTavern(self.quest.star, self.quest.id)
    self.config.textQuest.text = self.quest.questName

    -- STAR
    local sprite
    if self.quest.star < 6 then
        sprite = ResourceLoadUtils.LoadStarsIcon(StarsAtlas.starTavern1)
    elseif self.quest.star == 6 then
        sprite = ResourceLoadUtils.LoadStarsIcon(StarsAtlas.starTavern6)
    else
        sprite = ResourceLoadUtils.LoadStarsIcon(StarsAtlas.starTavern7)
    end
    self.config.star.sprite = sprite
    local sizeStar = sprite.border.x + sprite.border.z
    local sizeStarDelta = sprite.bounds.size.x * 100 - sizeStar
    self.config.star.rectTransform.sizeDelta = U_Vector2(sizeStar + sizeStarDelta * (self.quest.star - 1), sprite.bounds.size.y * 100)

    --self.config.bgStar.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.bgTavernQuests, self.quest.star)
end

--- @return void
function UITavernQuestView:ViewLock()
    if self.quest.isLock == true or self.quest.questState == TavernQuestState.DOING or self.quest.questState == TavernQuestState.DONE then
        self.config.iconLock:SetActive(true)
        self.config.iconUnlock:SetActive(false)
    else
        self.config.iconLock:SetActive(false)
        self.config.iconUnlock:SetActive(true)
    end
end

--- @return void
function UITavernQuestView:ViewStage()
    if self.quest.questState == TavernQuestState.WAITING then
        self.config.buttonStart.gameObject:SetActive(true)
        self.config.buttonSpeedUp.gameObject:SetActive(false)
        self.config.buttonFree.gameObject:SetActive(false)
        self.config.buttonComplete.gameObject:SetActive(false)
        self.config.buttonClose.gameObject:SetActive(false)
        self.config.autoTime:SetActive(false)
        self.config.textQuestComplete.gameObject:SetActive(false)
        self.config.textQuestTime.gameObject:SetActive(true)
        local time = self.tavernQuestDataConfig.time / TimeUtils.SecondAHour
        if time < 1 then
            self.config.textQuestTime.text = string.format(LanguageUtils.LocalizeCommon("min_x"), math.floor(time * 60))
        else
            self.config.textQuestTime.text = string.format(LanguageUtils.LocalizeCommon("hour_x"), math.floor(time))
        end
    elseif self.quest.questState == TavernQuestState.DOING then
        self.config.buttonStart.gameObject:SetActive(false)
        if self.tavernQuestDataConfig.speedUpGem > 0 then
            self.config.buttonSpeedUp.gameObject:SetActive(true)
            self.config.buttonFree.gameObject:SetActive(false)
            self.config.textGemSpeedUp.text = tostring(self.tavernQuestDataConfig.speedUpGem)
        else
            self.config.buttonSpeedUp.gameObject:SetActive(false)
            self.config.buttonFree.gameObject:SetActive(true)
        end
        self.config.buttonComplete.gameObject:SetActive(false)
        self.config.buttonClose.gameObject:SetActive(true)
        self.config.autoTime:SetActive(true)
        self.config.textQuestTime.gameObject:SetActive(false)
        self.config.textQuestComplete.gameObject:SetActive(false)
        self.config.textAutoTime.gameObject:SetActive(true)
    elseif self.quest.questState == TavernQuestState.DONE then
        self.config.buttonStart.gameObject:SetActive(false)
        self.config.buttonSpeedUp.gameObject:SetActive(false)
        self.config.buttonFree.gameObject:SetActive(false)
        self.config.buttonComplete.gameObject:SetActive(true)
        self.config.buttonClose.gameObject:SetActive(false)
        self.config.autoTime:SetActive(false)
        self.config.textQuestTime.gameObject:SetActive(false)
        self.config.textQuestComplete.gameObject:SetActive(true)
        self.config.textAutoTime.gameObject:SetActive(false)
        self.config.bgTimeProcessFull:SetActive(true)
        --XDebug.Log("Full size" .. LogUtils.ToDetail(self))
    end
end

--- @return void
function UITavernQuestView:CallbackStartQuest()
    self:PlayEffectStart()
    self.quest.startTime = zg.timeMgr:GetServerTime()
    self.quest.questState = TavernQuestState.DOING
    self:StartTimeQuest()
    self:ViewLock()
    self:ViewQuest()
    self:ViewStage()
    if self.callbackStartQuest ~= nil then
        self.callbackStartQuest(self)
    end
end

--- @return void
function UITavernQuestView:PlayEffectAdd()
    if self.effectAdd == nil then
        ---@type UnityEngine_GameObject
        self.effectAdd = SmartPool.Instance:SpawnUIEffectPool(EffectPoolType.AddTavern, self.config.transform)
    end
    self.effectAdd.gameObject:SetActive(false)
    self.effectAdd.gameObject:SetActive(true)
end

--- @return void
function UITavernQuestView:ReturnPoolEffectAdd()
    if self.effectAdd ~= nil then
        SmartPool.Instance:DespawnUIEffectPool(EffectPoolType.AddTavern, self.effectAdd)
        self.effectAdd = nil
    end
end

--- @return void
function UITavernQuestView:PlayEffectRefresh()
    if self.effectRefresh == nil then
        ---@type UnityEngine_GameObject
        self.effectRefresh = SmartPool.Instance:SpawnUIEffectPool(EffectPoolType.RefreshTavern, self.config.transform)
    end
    self.effectRefresh.gameObject:SetActive(false)
    self.effectRefresh.gameObject:SetActive(true)
end

--- @return void
function UITavernQuestView:ReturnPoolEffectRefresh()
    if self.effectRefresh ~= nil then
        SmartPool.Instance:DespawnUIEffectPool(EffectPoolType.RefreshTavern, self.effectRefresh)
        self.effectRefresh = nil
    end
end

--- @return void
function UITavernQuestView:PlayEffectStart()
    if self.effectStart == nil then
        ---@type UnityEngine_GameObject
        self.effectStart = SmartPool.Instance:SpawnUIEffectPool(EffectPoolType.StartTavern, self.config.transform)
    end
    self.effectStart.gameObject:SetActive(false)
    self.effectStart.gameObject:SetActive(true)
end

--- @return void
function UITavernQuestView:ReturnPoolEffectStart()
    if self.effectStart ~= nil then
        SmartPool.Instance:DespawnUIEffectPool(EffectPoolType.StartTavern, self.effectStart)
        self.effectStart = nil
    end
end

--- @return void
function UITavernQuestView:PlayEffectSpeedUp()
    if self.effectSpeedUp == nil then
        ---@type UnityEngine_GameObject
        self.effectSpeedUp = SmartPool.Instance:SpawnUIEffectPool(EffectPoolType.SpeedUpTavern, self.config.transform)
    end
    self.effectSpeedUp.gameObject:SetActive(false)
    self.effectSpeedUp.gameObject:SetActive(true)
end

--- @return void
function UITavernQuestView:ReturnPoolEffectSpeedUp()
    if self.effectSpeedUp ~= nil then
        SmartPool.Instance:DespawnUIEffectPool(EffectPoolType.SpeedUpTavern, self.effectSpeedUp)
        self.effectSpeedUp = nil
    end
end

--- @return void
function UITavernQuestView:PlayAnimAddQuest()
    ---@type UnityEngine_UI_VerticalLayoutGroup
    local layout = self.config.transform.parent:GetComponent(ComponentName.UnityEngine_UI_VerticalLayoutGroup)
    self:StopAnimAddQuest()
    self.coroutineAnimAddQuest = Coroutine.start(function()
        local time = 0
        local maxTime = 0.2
        local scale = 0
        local loop = true
        while loop do
            time = time + U_Time.deltaTime
            scale = time / maxTime
            if scale >= 1 then
                scale = 1
                loop = false
            end
            self.config.transform.sizeDelta = U_Vector2(1480.2 * scale, 143 * scale)
            self.config.transform.localScale = U_Vector3(scale, scale, scale)
            layout.enabled = false
            layout.enabled = true
            coroutine.waitforendofframe()
        end
        self:PlayEffectAdd()
    end)
end

--- @return void
function UITavernQuestView:StopAnimAddQuest()
    if self.coroutineAnimAddQuest ~= nil then
        Coroutine.stop(self.coroutineAnimAddQuest)
        self.coroutineAnimAddQuest = nil
    end
end

return UITavernQuestView