require "lua.client.scene.ui.home.uiWorldMap.WorldMapButtonMode"

--- @class UIWorldMapView : UIBaseView
UIWorldMapView = Class(UIWorldMapView, UIBaseView)

--- @return void
--- @param model UIWorldMapModel
function UIWorldMapView:Ctor(model)
    --- @type UIWorldMapConfig
    self.config = nil
    --- @type UILoopScroll
    self.scrollGate = nil
    --- @type Coroutine
    self.switchCoroutine = nil
    --- @type boolean
    self.playLoopFxOnDefaul = true
    --- @type CampaignData
    self.campaignData = nil
    --- @type Dictionary
    self.buttonModeDict = Dictionary()
    UIBaseView.Ctor(self, model)
    --- @type UIWorldMapModel
    self.model = model
end

function UIWorldMapView:OnReadyCreate()
    ---@type UIWorldMapConfig
    self.config = UIBaseConfig(self.uiTransform)
    self:_InitButtonListener()
    self:_InitScroll()
end

function UIWorldMapView:InitLocalization()
    --- @param k CampaignDifficultLevel
    --- @param v WorldMapButtonMode
    for k, v in ipairs(self.buttonModeDict:GetItems()) do
        v:SetButtonTitle(LanguageUtils.LocalizeDifficult(k))
    end
end

function UIWorldMapView:_InitButtonListener()
    self.config.back.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    for i = CampaignDifficultLevel.Normal, CampaignDifficultLevel.Universe do
        local button = self.config.level:GetChild(i - 1)
        local worldMapButtonMode = WorldMapButtonMode(button)
        worldMapButtonMode:AddOnSelectListener(function()
            zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
            self:SelectCampaignDifficultLevel(i)
        end)
        self.buttonModeDict:Add(i, worldMapButtonMode)
    end
end

function UIWorldMapView:_InitScroll()
    --- @param obj UIWorldMapGateItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        local bgGate
        local isComplete = false
        local isOpen = true
        if self.model.clientData.diff == self.model.playerData.diff then
            isComplete = self.model.clientData.mapId > dataIndex
            isOpen = self.model.clientData.mapId >= dataIndex
        elseif self.model.clientData.diff > self.model.playerData.diff then
            isOpen = false
        else
            isComplete = true
        end
        local isEnableArrow = dataIndex < self.model.currentMapCount
        local bgGateId = math.min(dataIndex, 9)
        bgGate = ResourceLoadUtils.LoadTexture(ResourceLoadUtils.bgWorldMap, string.format("bg_gate_%d", bgGateId), ComponentName.UnityEngine_Sprite)
        obj:SetBg(bgGate)
        obj:SetData(dataIndex, isComplete, isOpen, isEnableArrow, self.playLoopFxOnDefault)
        obj:AddOnClickListener(function()
            self:OnClickMap(dataIndex)
        end)
    end
    self.scrollGate = UILoopScroll(self.config.scrollGate, UIPoolType.WorldMapGateItem, onCreateItem)
end

--- @param result {isPlaySwitchNextMap : boolean, callbackClose}
function UIWorldMapView:OnReadyShow(result)
    self.campaignData = zg.playerData:GetCampaignData()
    self.playLoopFxOnDefault = true
    self.isPlaySwitchNextMap = result.isPlaySwitchNextMap
    if result.isPlaySwitchNextMap == true then
        self.config.cover:SetActive(true)
        self.listenToHideLoading = RxMgr.hideLoading:Subscribe(RxMgr.CreateFunction(self, self.OnLoadingHide))
    else
        self.config.cover:SetActive(false)
        local difficultLevel, mapId, stage = ClientConfigUtils.GetIdFromStageId(zg.playerData:GetCampaignData().stageNext)
        self.model:SetPlayerData(difficultLevel, mapId, stage)
        self:ShowUiByInfo(difficultLevel, mapId)
        self.scrollGate:RefillCells(mapId - 3)
    end
end

--- @return void
function UIWorldMapView:OnFinishAnimation()
    UIBaseView.OnFinishAnimation(self)
    if self.isPlaySwitchNextMap ~= true then
        self:CheckAndInitTutorial()
    end
end

function UIWorldMapView:Hide()
    ClientConfigUtils.KillCoroutine(self.switchCoroutine)
    self:RemoveListener()
    self.scrollGate:Hide()
    self:RemoveListenerTutorial()
    UIBaseView.Hide(self)
end

--- @param selectedMapId number
function UIWorldMapView:OnClickMap(selectedMapId)
    if self.model.clientData.diff > self.model.playerData.diff then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("need_clear_previous_stage"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    elseif self.model.clientData.diff == self.model.playerData.diff then
        if selectedMapId > self.model.playerData.mapId then
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("need_clear_previous_stage"))
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        elseif selectedMapId == self.model.playerData.mapId then
            self.campaignData.currentMapId = selectedMapId
            PopupMgr.ShowAndHidePopup(UIPopupName.UISelectMapPVE, nil, UIPopupName.UIWorldMap)
        else
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("completed"))
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        end
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("completed"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end
end

--- @param difficultLevel CampaignDifficultLevel
function UIWorldMapView:SelectCampaignDifficultLevel(difficultLevel)
    if self.model.clientData.diff == difficultLevel then
        return
    end
    local mapId = 1
    if self.model.playerData.diff == difficultLevel then
        mapId = self.model.playerData.mapId
    else
        mapId = ResourceMgr.GetCampaignDataConfig():GetCampaignStageConfig():GetNumberOfMapOfDifficultLevel(difficultLevel)
    end
    if self.model.playerData.diff < difficultLevel then
        if mapId < 0 then
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("coming_soon"))
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            return
        else
            mapId = 1
        end
    end

    self.model:SetClientData(difficultLevel, mapId)
    self.scrollGate:Hide()
    self:ShowUiByInfo(difficultLevel, mapId)
    self.scrollGate:RefillCells(mapId - 3)
end

--- @param difficultLevel CampaignDifficultLevel
function UIWorldMapView:ShowUiByInfo(difficultLevel)
    difficultLevel = MathUtils.Clamp(difficultLevel, CampaignDifficultLevel.Normal, CampaignDifficultLevel.Universe)
    local mapCount = ResourceMgr.GetCampaignDataConfig():GetCampaignStageConfig():GetNumberOfMapOfDifficultLevel(difficultLevel)
    local bgWorldMapId = math.min(difficultLevel, CampaignDifficultLevel.Crazy)
    local bg = ResourceLoadUtils.LoadTexture(ResourceLoadUtils.bgWorldMap, string.format("bg_world_map_%d", bgWorldMapId), ComponentName.UnityEngine_Sprite)
    self.config.backGround.sprite = bg
    uiCanvas:SetBackgroundSize(self.config.backGround)

    --- @type WorldMapButtonMode
    local button = self.buttonModeDict:Get(difficultLevel)
    self.config.bgChosen.anchoredPosition3D = button:GetPosition()

    self.scrollGate:Hide()
    self.scrollGate:Resize(mapCount)
end

--- @return void
---@param tutorial UITutorialView
---@param step number
function UIWorldMapView:ShowTutorial(tutorial, step)
    if step == TutorialStep.CLICK_BACK_MAP then
        tutorial:ViewFocusCurrentTutorial(self.config.back, 0.5, function()
            return self.config.back.transform:GetChild(0).position
        end, nil, TutorialHandType.MOVE_CLICK)
    end
end

function UIWorldMapView:OnLoadingHide()
    local currDiff, currMapId, currStage = ClientConfigUtils.GetIdFromStageId(self.campaignData.stageCurrent)

    self.model:SetPlayerData(currDiff, currMapId, currStage)
    self:ShowUiByInfo(currDiff, currMapId)
    self.scrollGate:RefillCells(currMapId - 3)

    self:DoPlaySwitchToGate()
end

function UIWorldMapView:DoPlaySwitchToGate()
    local currDiff, currMapId, currStage = ClientConfigUtils.GetIdFromStageId(self.campaignData.stageCurrent)
    local nextDiff, nextMapId, nextStage = ClientConfigUtils.GetIdFromStageId(self.campaignData.stageNext)

    self.switchCoroutine = Coroutine.start(function()
        local currGate = self:GetGateById(currMapId)
        while currGate == nil do
            coroutine.yield(nil)
            currGate = self:GetGateById(currMapId)
        end
        currGate.config.fxUiGateLoop:Play()
        currGate.config.fxUiGateClose:Play()
        coroutine.waitforseconds(0.7)
        currGate.config.fxUiGateLoop:Stop()
        currGate.config.cover:SetActive(true)

        coroutine.waitforseconds(1)
        currGate:UpdateState(true, true)

        coroutine.waitforseconds(0.2)
        currGate.config.openMark:SetActive(false)

        self.model:SetPlayerData(nextDiff, nextMapId, nextStage)
        self.playLoopFxOnDefault = false
        self:ShowUiByInfo(nextDiff, nextMapId)
        local nextDiffMapCount = ResourceMgr.GetCampaignDataConfig():GetCampaignStageConfig():GetNumberOfMapOfDifficultLevel(nextDiff)
        if nextDiffMapCount > 1 then
            self.scrollGate:RefillCells(currMapId - 3)
            self.scrollGate:ScrollToCell(nextMapId - 1, 1000)
        elseif nextDiffMapCount == 1 then
            self.scrollGate:Resize(nextDiffMapCount)
        end
        local nextGate = self:GetGateById(nextMapId)
        while nextGate == nil do
            coroutine.yield(nil)
            nextGate = self:GetGateById(nextMapId)
        end
        nextGate.config.fxUiGateLoop:Stop()
        coroutine.waitforseconds(0.6)
        nextGate:UpdateState(false, true)
        nextGate.config.fxUiGateOpen:Play()
        coroutine.waitforseconds(0.2)
        nextGate.config.fxUiGateLoop:Play()
        self:CompleteSwitchGate()
    end)
end

--- @return UIWorldMapGateItem
--- @param mapId number
function UIWorldMapView:GetGateById(mapId)
    --- @param v UIWorldMapGateItem
    for _, v in pairs(self.scrollGate.dict:GetItems()) do
        if v.index == mapId then
            return v
        end
    end
    return nil
end

function UIWorldMapView:OnClickBackOrClose()
    if self.listenToHideLoading == nil then
        UIBaseView.OnClickBackOrClose(self)
    end
end

function UIWorldMapView:RemoveListener()
    if self.listenToHideLoading then
        self.listenToHideLoading:Unsubscribe()
        self.listenToHideLoading = nil
    end
end

function UIWorldMapView:CompleteSwitchGate()
    self.config.cover:SetActive(false)
    ClientConfigUtils.KillCoroutine(self.switchCoroutine)
    self:RemoveListener()
    self:CheckAndInitTutorial()
end