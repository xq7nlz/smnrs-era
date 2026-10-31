require "lua.client.scene.ui.home.uiNewServerWeek.uiNewServerWeekLayout.UINewServerWeekLayout"
require "lua.client.scene.ui.home.uiNewServerWeek.uiNewServerWeekLayout.EventSpin.ServerWeekDiceSlotView"
--- @class UINewServerWeekSpinLayout : UINewServerWeekLayout
UINewServerWeekSpinLayout = Class(UINewServerWeekSpinLayout, UINewServerWeekLayout)

--- @param view UINewServerWeekView
--- @param newServerWeekTab NewServerWeekTab
--- @param anchor UnityEngine_RectTransform
function UINewServerWeekSpinLayout:Ctor(view, newServerWeekTab, anchor)
    ---@type number
    self.lastUserSpinTime = nil -- dont care about success or not
    ---@type number
    self.nextSpinTime = nil

    ---@type number
    self.eventEndTimeDuration = nil
    ---@type number
    self.eventEndTime = nil

    ---@type number
    self.nextSpinTimeDuration = nil

    ---@type EventNewServerWeekSpinModel
    self.eventModel = nil
    ---@type EventNewServerWeekSpinConfig
    self.evConfig = nil
    ---@type number
    self.numberOfSquares = 16
    ---@type List<EventServerWeekDiceSlotView>
    self.diceList = nil
    ---@type List<LapSlotView>
    self.lapList = nil
    ---@type number
    self.rollNum = 1
    ---@type number
    self.position = 1
    ---@type number
    self.prevPosition = 1
   --  ---@type number
    --self.lapCompleted = 1
    ---@type boolean
    self.isLimit = false

    self.arrowTransform_1 = nil

    self.arrowTransform_2 = nil

    self.anchor = anchor
    --- @type UINewServerSpinLayoutConfig
    self.layoutConfig = nil
    self:InitLayoutConfig()
    self:InitUpdateTime()
    self:InitUpdateEventEndTime()
    UINewServerWeekLayout.Ctor(self, view, newServerWeekTab,anchor)

end

function UINewServerWeekSpinLayout:UpdateLayoutOnSpinSuccess(spinTimeAvailable)
    self:SetTimeTextWhenStop(self.eventModel.numberSpined + 1)
    local availableDice = self.eventModel:AvailableToSpin(spinTimeAvailable)
    local textNumberDice = 1
    local colorStr = UIUtils.green_light

    if (availableDice) then
        --XDebug.Log("AVAILABLE DICE 1")
    else
        --XDebug.Log("AVAILABLE DICE 0")
        textNumberDice = 0
        colorStr = UIUtils.red_dark
    end
    self.layoutConfig.avaiableDiceText.text = string.format("%s %s", LanguageUtils.LocalizeCommon("week_spin_available_dice"),UIUtils.SetColorString(colorStr,textNumberDice))
end

function UINewServerWeekSpinLayout:StartTimeOnSpinSuccess()
    self:UpdateLayoutOnSpinSuccess()
    self:StopTime()
    self:StartTime()
end

function UINewServerWeekSpinLayout:SetUpLayout()
    UINewServerWeekLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UINewServerWeekSpinLayout:InitItemShow()

end

function UINewServerWeekSpinLayout:OnHide()
    UINewServerWeekLayout.OnHide(self)
    self:StopCalEventEndTime()
    self:StopTime()
    self:ResetDiceViews()
    --self:ResetLapViews()
    self:UpdateCurrentDiceView()

    --[[    if self.diceBarView ~= nil then
            self.diceBarView:ReturnPool()
            self.diceBarView = nil
        end]]
    --if self.eventDiceData ~= nil then
    --    self.eventDiceData = nil
    --    XDebug.Log("dice data onhide: " .. tostring(self.eventHalloweenModel:GetDiceData()))
    --end
end


local TIME_TO_ROLL = 0.03

---@return EventNewServerWeekSpinConfig
function UINewServerWeekSpinLayout:GetModel()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SERVER_OPEN_SPIN)
end

---@return EventNewServerWeekSpinConfig
function UINewServerWeekSpinLayout:GetModelConfig()
    self:GetModel()
    if self.eventModel ~= nil then
        self.evConfig = self.eventModel:GetConfig()
    else
        --XDebug.Log("NIL EVENT MODEL")
    end
end



function UINewServerWeekSpinLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("new_server_week_spin_layout", self.anchor)
    --local inst = PrefabLoadUtils.Instantiate("dice_layout", self.anchor)
    UINewServerWeekLayout.InitLayoutConfig(self, inst)
    self.arrowTransform_1 = self.layoutConfig.select1:GetChild(0) -- for corner square
    self.arrowTransform_2 = self.layoutConfig.select2:GetChild(0)
    --self.rollAnim = self.layoutConfig.rollAnim
    --self.bg = self.layoutConfig.rollBg
    --self.itemsTableView = ItemsTableView(self.layoutConfig.rewardAnchor)
    self:InitButtons()
    self:InitLocalization()
    --self:InitLapViews()

end

function UINewServerWeekSpinLayout:InitButtons()
    self.layoutConfig.rollButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickRoll()
    end)
    self.layoutConfig.buttonHelp.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHelpInfo()
    end)
end

--- @return void
function UINewServerWeekSpinLayout:OnClickHelpInfo()
    local info = LanguageUtils.LocalizeHelpInfo("event_server_week_spin_info")
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, info)
end

function UINewServerWeekSpinLayout:InitDiceViews()
    self.diceList = List()
--[[    local addDiceList = false
    if self.diceList == nil then
        addDiceList = true

    end]]
    local dicList = self.evConfig:GetDictSpinCooldownTime()
    local dicReward = self.evConfig:GetDictRewardPositionConfig()
    for i = 1, self.layoutConfig.diceRollContainer.childCount do
        if dicList:IsContainKey(i) then
            local reward = dicReward:Get(i)
            local diceView = EventServerWeekDiceSlotView(self.layoutConfig.diceRollContainer:GetChild(i - 1), i)
            diceView:SetReward(reward)
            --if (addDiceList) then
                self.diceList:Add(diceView)
            --end
            else
            --print("not contain key " , i)
        end
    end
end


function UINewServerWeekSpinLayout:UpdateDiceViews()
    for i = 1, self.diceList:Count() do
        ---@type EventServerWeekDiceSlotView
        local view = self.diceList:Get(i)
        for j = 1, self.posList:Count() do
            local temp = self.posList:Get(j)
            if i == temp then
                view:SetView(true)
                break
            end
        end
    end
end

function UINewServerWeekSpinLayout:ResetLapViews()
    for i = 1, self.lapList:Count() do
        local view = self.lapList:Get(i)
        view:SetView(0)
    end
end

function UINewServerWeekSpinLayout:ResetDiceViews(showEffect)
    for i = 1, self.diceList:Count() do
        local view = self.diceList:Get(i)
        view:SetView(false)
        if showEffect ~= nil then
            view:ShowEffect()
        end
    end
    self.first = nil
    --if self.posList ~= nil then
    --    self.posList:Clear()
    --end
end

function UINewServerWeekSpinLayout:InitLocalization()
    self.layoutConfig.rollText.text = LanguageUtils.LocalizeCommon("spin")
    self.layoutConfig.packageTitle.text = LanguageUtils.LocalizeCommon("new_server_week_spin")
--[[    self.layoutConfig.startTitle.text = LanguageUtils.LocalizeCommon("start")
    local diceGuide = StringUtils.FormatLocalize(LanguageUtils.LocalizeCommon("dice_guide"),nil,nil,LanguageUtils.LocalizeCommon("daily_packs"))
    self.layoutConfig.diceGuideTitle.text = diceGuide
    self.layoutConfig.diceTitle.text = LanguageUtils.LocalizeCommon("dice_title")
    self.layoutConfig.lapTitle.text = LanguageUtils.LocalizeCommon("lap_reward")
    self.layoutConfig.rollText.text = LanguageUtils.LocalizeCommon("roll")
    self.layoutConfig.localizeLapCompleted.text = LanguageUtils.LocalizeCommon("completed")]]
end

function UINewServerWeekSpinLayout:CalculateSpinInfo()
    self.eventModel:CalculateSpinInfo()
    self:UpdateNextSpinTime()
end

function UINewServerWeekSpinLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UINewServerWeekSpinLayout:GetFromConfig()

end

function UINewServerWeekSpinLayout:OnShow()
    UINewServerWeekLayout.OnShow(self)
    self:GetModelConfig()
    self:CalculateSpinInfo()
    self:InitDiceViews()
    self:FillData()
    self:UpdateLayoutOnSpinSuccess()
    local availableDice = self.eventModel:AvailableToSpin()
    local nextSpinCount = nil
    if (availableDice) then
        nextSpinCount = self.eventModel.numberSpined + 1
        else
    end
    self:StartTime(nextSpinCount)
    self:StartCalEventEndTime()
    --self:UpdateRequireView()
   -- self:InitLapViews()
end

function UINewServerWeekSpinLayout:FillData()
    --elf.diceBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.diceBarAnchor)
    --self.diceBarView:SetIconData(MoneyType.EVENT_HALLOWEEN_DICE)
    --self.eventDiceData = self.eventHalloweenModel:GetDiceData()
    local numberOfRewardClaimed = self.eventModel.openedPositions:Count()
    if (numberOfRewardClaimed == 0) then
        self.position = 1
        else
        self.position = self.eventModel.openedPositions:Get(numberOfRewardClaimed)
    end
    --XDebug.Log("LAST pos " .. tostring(self.position))


    self.prevPosition = self.position
    --self.lapCompleted = self.eventDiceData.lapCompleted
    self.rollNum = numberOfRewardClaimed + 1 --need recheck
    self.posList = self.eventModel.openedPositions
--[[    if self.position ~= 1 then
        self.posList:Add(self.position - 1)
    end]]
    self:UpdateCurrentDiceView()
    --self:UpdateLapViews()
    self:UpdateDiceViews()
end

--- @return EventServerWeekDiceSlotView
function UINewServerWeekSpinLayout:UpdateCurrentDiceView() --enable frame at current position
    if self.position <= self.diceList:Count() then
        local view = self.diceList:Get(self.position)
        local check = self:IsBigDice(self.position)
        self:SetEnableArrow(check, true)
        self:SetEnableFrame(view.config.transform.position, check, true)
        return view
    end
    return nil
end



--[[function UINewServerWeekSpinLayout:StartAnimRollDice()
    self.bg.color = U_Color(0,0,0,0)
    self.bg.gameObject:SetActive(true)
    self.bg:DOColor(U_Color(0,0,0,0.75), 1)
    self.rollAnim.gameObject:SetActive(true)
    self.rollAnim.AnimationState:SetAnimation(0, "roll", true)
end]]

--[[function UINewServerWeekSpinLayout:OnEndRoll()
    self.rollAnim.gameObject:SetActive(false)
    zg.audioMgr:PlaySfxUi(SfxUiType.DICE_END)
end]]


function UINewServerWeekSpinLayout:OnClickRoll()
    local onReceived = function(result)
        --- @type DiceRewardResult
        local diceResult
        local slotId = nil
        local listReward = nil
        local onBufferReading = function(buffer)
            slotId = buffer:GetInt()
            --local size = buffer:GetByte()
            listReward = self.evConfig:GetDictRewardPositionConfig():Get(slotId)
            --diceResult = DiceRewardResult(buffer)
        end

        local onFailed = function()
           -- self:OnEndRoll()
            --SmartPoolUtils.LogicCodeNotification()
            --self.bg.gameObject:SetActive(false)
        end
        local onSuccess = function()
            self.eventModel:AddOpenedPosition(slotId)
            self.eventModel:SetLastSpintTime(self.lastUserSpinTime)

            if slotId ~= nil then
                --XDebug.Log("NEW POS " .. tostring(slotId))
                zg.audioMgr:PlaySfxUi(SfxUiType.DICE_ROLL)
                self.touch = TouchUtils.Spawn("DiceRollAnimation")
                self.prevPosition = self.position
                self.position = slotId
                self.diceValue = self.position - self.prevPosition -- so o can phai di qua
                if (self.diceValue < 0) then
                    self.diceValue = self.diceValue + self.numberOfSquares
                end
                --self.posList:Add(slotId) refernce , no need

                Coroutine.start(function()
                    --coroutine.waitforseconds(2)
                    ---@type UnityEngine_UI_Image
                    --local rollImage = self.layoutConfig.rollImage
                    --rollImage.sprite = ResourceLoadUtils.LoadIconRollDice(self.diceValue)
                   -- rollImage.color = U_Color(1,1,1,1)
                    --self:OnEndRoll()
                   -- rollImage.gameObject:SetActive(true)
                    --rollImage:DOColor(U_Color(1,1,1,1), 0.2)
                    --coroutine.waitforseconds(0.5)
                    --self.bg:DOColor(U_Color(0,0,0,0), 1)
                   -- coroutine.waitforseconds(0.5)
                    --rollImage:DOColor(U_Color(1,1,1,0), 0.5)
                    --coroutine.waitforseconds(0.5)
                    --rollImage.gameObject:SetActive(false)
                    --self.bg.gameObject:SetActive(false)
                    self:DiceRollAnimation()
                    self:CalculateSpinInfo()
                    self:StartTimeOnSpinSuccess()

                    --InventoryUtils.Sub(ResourceType.Money, MoneyType.EVENT_HALLOWEEN_DICE, 1)
                end)

            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    local canRoll = self.eventModel:AvailableToSpin()
    if canRoll then
        self.lastUserSpinTime = zg.timeMgr:GetServerTime()
        --self:StartAnimRollDice()
        NetworkUtils.Request(OpCode.EVENT_SERVER_OPEN_SPIN, nil, onReceived,true)
        else
        local text = UIUtils.SetColorString(UIUtils.red_light, LanguageUtils.LocalizeCommon("server_week_spin_not_available"))

        local reachMaxNumber =  self.eventModel:ReachMaxSpinNumber()
        if (reachMaxNumber) then

        else
            local timeRemaining =  self.nextSpinTimeDuration
            local textTimeRemaining = "00:00:00"
            if (timeRemaining > 0) then
                textTimeRemaining = TimeUtils.GetDeltaTime(timeRemaining)
            else

            end
            --XDebug.Log("timeRemaining " .. tostring(timeRemaining))
            text = string.format("%s %s %s",
                    UIUtils.SetColorString(UIUtils.red_light, LanguageUtils.LocalizeCommon("server_week_spin_not_available")),
                    LanguageUtils.LocalizeCommon("will_end_in"),
                    UIUtils.SetColorString(UIUtils.green_light, textTimeRemaining))
            --server_week_new_spint
        end

        SmartPoolUtils.ShowShortNotification(text)
        --SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("server_week_spin_not_available"))
    end
end

--- @return void
function UINewServerWeekSpinLayout:StartCalEventEndTime()
    if self.updateEventEndTime ~= nil then
        zg.timeMgr:AddUpdateFunction(self.updateEventEndTime)
    end
end

function UINewServerWeekSpinLayout:StopCalEventEndTime()
    if self.updateEventEndTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateEventEndTime)
    end
end

function UINewServerWeekSpinLayout:InitUpdateEventEndTime()
    --- @param isSetTime boolean
    self.updateEventEndTime = function(isSetTime)

        if isSetTime == true then
            self.eventEndTime = self.eventModel.timeData.endTime
            self.eventEndTimeDuration =  self.eventEndTime - zg.timeMgr:GetServerTime()
            if  self.eventEndTimeDuration > 0 then
            else
                --XDebug.Log("NO TIME GET")
            end
            --UIUtils.AlignText(self.layoutConfig.textEventNextDay)
        else
            if self.eventEndTimeDuration ~= nil then
                self.eventEndTimeDuration = self.eventEndTimeDuration - 1
            end
        end
        if self.eventEndTimeDuration > 0 then
            local time = TimeUtils.GetDeltaTime(self.eventEndTimeDuration)
            self.layoutConfig.endText.text = string.format("%s %s", LanguageUtils.LocalizeCommon("will_end_in"),
                    UIUtils.SetColorString(UIUtils.green_light, time))
            --self.layoutConfig.endText.text = UIUtils.SetColorString(UIUtils.white, time) --LanguageUtils.LocalizeCommon("next_spin_server_week") .. " " .. UIUtils.SetColorString(UIUtils.white, time)
        else
            self.layoutConfig.endText.text = ""
            self:StopCalEventEndTime()
        end
    end
end



function UINewServerWeekSpinLayout:SetTimeTextWhenStop(nextSpinCount)
    local _duration = self.eventModel:GetTimeCooldown()
    local nextDuration = 0
    local nextSpinCountInput = nextSpinCount
    if (nextSpinCount == nil) then
        nextSpinCountInput = self.eventModel.numberSpined
        else
    end
    local reachMax = self.eventModel:ReachMaxSpinNumber()
    if (reachMax) then
        if (nextSpinCount ~= nil) then
            nextDuration =  self.eventModel:GetTimeCooldownForSpinNumber(nextSpinCount)
        else
            nextDuration =  _duration
        end
    end
    local textTime = UIUtils.SetColorString(UIUtils.green_light,TimeUtils.GetDeltaTime(nextDuration))
    if (nextDuration == 0) then
        textTime = UIUtils.SetColorString(UIUtils.green_light,"00:00:00")
        else

    end
   -- XDebug.Log("NEXT DURATION " .. tostring(nextDuration) .. " nextSpinCount " .. tostring(nextSpinCount))
    self.layoutConfig.timeCountDown.text = textTime
end

--- @return void
function UINewServerWeekSpinLayout:StartTime(nextSpinCount)
    self:SetTimeTextWhenStop(nextSpinCount)
    if self.updateTime ~= nil then
        --print("start time spin")
        zg.timeMgr:AddUpdateFunction(self.updateTime)
    end
end

function UINewServerWeekSpinLayout:StopTime()
    if self.updateTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
    end
end


function UINewServerWeekSpinLayout:OnReachTimeNextSpin()
    --XDebug.Log("reach time next spin")
    self:UpdateLayoutOnSpinSuccess(true)
end

function UINewServerWeekSpinLayout:UpdateNextSpinTime()
    self.nextSpinTime =  self.eventModel.nextSpinTime
    self.nextSpinTimeDuration = self.nextSpinTime - zg.timeMgr:GetServerTime()
end

function UINewServerWeekSpinLayout:InitUpdateTime()

    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self.nextSpinTime = self.eventModel:GetNextSpinTime()
            self.nextSpinTimeDuration =  self.nextSpinTime - zg.timeMgr:GetServerTime()
            if  self.nextSpinTimeDuration > 0 then

            else
                --XDebug.Log("NO TIME GET")
            end
            --UIUtils.AlignText(self.layoutConfig.textEventNextDay)
        else
            if self.nextSpinTimeDuration ~= nil then
                self.nextSpinTimeDuration = self.nextSpinTimeDuration - 1
            end
        end
        if self.nextSpinTimeDuration > 0 then
                local time = TimeUtils.GetDeltaTime(self.nextSpinTimeDuration)
            self.layoutConfig.timeCountDown.text = UIUtils.SetColorString(UIUtils.green_light,time)
                    --self.layoutConfig.timeCountDown.text = LanguageUtils.LocalizeCommon("next_force_refresh") .. " " .. UIUtils.SetColorString(UIUtils.white, time)
        else
            self:StopTime()
            self:OnReachTimeNextSpin()
            --self:SetTimeTextWhenStop()
        end
    end
end




function UINewServerWeekSpinLayout:DiceRollAnimation()
    Coroutine.start(function()
        ---@type EventServerWeekDiceSlotView
        local diceView = nil
        if self.position > self.numberOfSquares then
            self.position = self.numberOfSquares
        end
        local overlap = self.position < self.prevPosition
        local minSquareNumber = self.prevPosition
        local maxSquareNumber = self.position
        if (overlap) then
            maxSquareNumber = self.numberOfSquares
        end
        --local temp = self.prevPosition + self.diceValue -- next value
        local check = false

        local minPos = self.prevPosition
        local maxPos = self.position + self.numberOfSquares
        if (self.position < self.prevPosition) then
            maxPos = maxPos + self.numberOfSquares
        end
       --XDebug.Log("minPos " .. tostring(minPos) .. " MAX " .. tostring(maxPos))
        for i =  minPos, maxPos do
            local tempPos = math.fmod(i, self.numberOfSquares)
            if (tempPos == 0) then
                tempPos =  self.numberOfSquares
            end
            --XDebug.Log("temp pos " .. tostring(tempPos))
            check = self:IsBigDice(tempPos)
            diceView = self.diceList:Get(tempPos)
            self:SetEnableArrow(check, false)
            zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
            self:SetEnableFrame(diceView.config.transform.position, check, true)
            coroutine.waitforseconds(TIME_TO_ROLL)
            self:SetEnableFrame(diceView.config.transform.position, check, false)
        end


        if diceView ~= nil then
            zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
            self:SetEnableArrow(check, true)
            self:SetEnableFrame(diceView.config.transform.position, check, true)
            self.prevPosition = self.position
            diceView:ShowRewardInbound()
            diceView:SetView(true)
        end


        --[[        if temp > self.diceList:Count() then
                    print("Overlap")
                    self.lapCompleted = self.lapCompleted + 1
                    self.eventDiceData.lapCompleted = self.eventDiceData.lapCompleted + 1
                    for i = self.prevPosition + 1, self.diceList:Count() do
                        diceView = self.diceList:Get(i)
                        local check = self:IsBigDice(i) -- square is corner square
                        self:SetEnableArrow(check, false)
                        zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
                        self:SetEnableFrame(diceView.config.transform.position, check, true)
                        coroutine.waitforseconds(TIME_TO_ROLL)
                        self:SetEnableFrame(diceView.config.transform.position, check, false)
                    end
                    local check_2 = self:IsBigDice(1)
                    diceView = self.diceList:Get(1)
                    self:SetEnableArrow(check_2, false)
                    zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
                    self:SetEnableFrame(diceView.config.transform.position, check_2, true)
                    coroutine.waitforseconds(TIME_TO_ROLL)
                    if diceView ~= nil then
                        self:SetEnableArrow(check_2, true)
                        self.prevPosition = self.position
                        if  self.position ~= 1 then
                            diceView:ShowRewardInbound()
                        end
                    end
                    self:UpdateLapViews()
                    coroutine.waitforseconds(TIME_TO_ROLL + 0.5)
                    self:ResetSelect(false)
                    --diceView:SetView(true)
                    coroutine.waitforseconds(0.25)
                    local count = 2
                    local _diceView = nil
                    for j = 1, count do
                        for i = 1, self.diceList:Count() do
                            --- @type DiceSlotView
                            _diceView = self.diceList:Get(i)
                            zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
                            _diceView:SetEnableFrame(true)
                            coroutine.waitforseconds(0.035)
                            _diceView:SetEnableFrame(false)
                        end
                    end
                    count = 3
                    for j = 1, count do
                        zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
                        for i = 1, self.diceList:Count() do
                            --- @type DiceSlotView
                            _diceView = self.diceList:Get(i)
                            _diceView:SetEnableFrame(true)
                        end
                        coroutine.waitforseconds(0.6)
                    end

                    coroutine.waitforseconds(0.2)
                    zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
                    self:ResetDiceViews(true)
                    coroutine.waitforseconds(0.2)
                    local view = self:UpdateCurrentDiceView()
                    view:SetView(true)
                    view:ShowRewardInbound()

                    self.posList:Clear()
                else
                    print("Not overlap")
                    ---@type DiceSlotView
                    local check = false
                    for i = self.prevPosition + 1, self.position do
                        check = self:IsBigDice(i)
                        diceView = self.diceList:Get(i)
                        self:SetEnableArrow(check, false)
                        zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
                        self:SetEnableFrame(diceView.config.transform.position, check, true)
                        coroutine.waitforseconds(TIME_TO_ROLL)
                        self:SetEnableFrame(diceView.config.transform.position, check, false)
                    end
                    if diceView ~= nil then
                        zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
                        self:SetEnableArrow(check, true)
                        self:SetEnableFrame(diceView.config.transform.position, check, true)
                        self.prevPosition = self.position
                        diceView:ShowRewardInbound()
                        diceView:SetView(true)
                    end
                end]]
        self.touch:Enable()
    end)
end

function UINewServerWeekSpinLayout:IsBigDice(index)
    local indexList = { 1, 10, 14, 23 }
    for i, v in ipairs(indexList) do
        if v == index then
            return true
        end
    end
    return false
end
function UINewServerWeekSpinLayout:SetEnableArrow(check, isEnable)
    if check then -- square corner
        self.arrowTransform_1.gameObject:SetActive(isEnable)
        self.arrowTransform_2.gameObject:SetActive(not isEnable)
    else
        self.arrowTransform_1.gameObject:SetActive(not isEnable)
        self.arrowTransform_2.gameObject:SetActive(isEnable)
    end
end
function UINewServerWeekSpinLayout:SetEnableFrame(position, check, isEnable)
    if check then
        self.layoutConfig.select1.gameObject:SetActive(isEnable)
        self.layoutConfig.select2.gameObject:SetActive(not isEnable)
        self.layoutConfig.select1.position = position
    else
        self.layoutConfig.select1.gameObject:SetActive(not isEnable)
        self.layoutConfig.select2.gameObject:SetActive(isEnable)
        self.layoutConfig.select2.position = position
    end
end
function UINewServerWeekSpinLayout:ResetSelect(isEnable)
    self.layoutConfig.select1.gameObject:SetActive(isEnable)
    self.layoutConfig.select2.gameObject:SetActive(isEnable)
end




