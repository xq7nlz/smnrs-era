require "lua.client.scene.ui.notification.NotificationArena"
require "lua.client.scene.ui.notification.NotificationArenaTeam"

--- @class UISelectArenaView : UIBaseView
UISelectArenaView = Class(UISelectArenaView, UIBaseView)

--- @return void
--- @param model UISelectArenaModel
function UISelectArenaView:Ctor(model)
    --- @type UISelectArenaConfig
    self.config = nil
    UIBaseView.Ctor(self, model)
    --- @type UISelectArenaModel
    self.model = model
end

function UISelectArenaView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    self:InitButtons()
end

function UISelectArenaView:InitLocalization()
    self.config.textArena.text = LanguageUtils.LocalizeFeature(FeatureType.ARENA)
    self.config.textArena3v3.text = LanguageUtils.LocalizeFeature(FeatureType.ARENA_TEAM)

    self.config.textArenaDesc.text = LanguageUtils.LocalizeCommon("arena_desc")
    self.config.textArena3v3Desc.text = LanguageUtils.LocalizeCommon("arena_3v3_desc")
end

function UISelectArenaView:InitButtons()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.arena.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickArena()
    end)
    self.config.arena3v3.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickArenaTeam()
    end)
end

function UISelectArenaView:InitUpdateTime()
    local timeOpen = FeatureItemInBound.GetTimeOpenIn(FeatureType.ARENA_TEAM)
    if (timeOpen > 0) then
        --XDebug.Log("time open in " .. tostring(timeOpen))
        self.timeRemaining = timeOpen
        self.config.timeText.text = string.format("%s %s",LanguageUtils.LocalizeCommon("will_open_in"),UIUtils.SetColorString(UIUtils.green_dark, TimeUtils.GetDeltaTime(self.timeRemaining, 4)))
        --self.config.timeText.text = string.format(LanguageUtils.LocalizeCommon("expire_in_s"),UIUtils.SetColorString(UIUtils.green_dark, TimeUtils.GetDeltaTime(self.timeRemaining, 4)))
        self.config.objTimeLock.gameObject:SetActive(true)
        self.updateTime = function(isSetTime)
            if isSetTime == true then
            else
                self.timeRemaining = self.timeRemaining - 1
            end
            if self.timeRemaining > 0 then
                self.config.timeText.text = string.format("%s %s",LanguageUtils.LocalizeCommon("will_open_in"),UIUtils.SetColorString(UIUtils.green_dark, TimeUtils.GetDeltaTime(self.timeRemaining, 4)))
                --self.config.timeText.text = string.format(LanguageUtils.LocalizeCommon("expire_in_s"),UIUtils.SetColorString(UIUtils.green_dark, TimeUtils.GetDeltaTime(self.timeRemaining, 4)))
            else
                self:OnTimeEnd()
                self.config.timeText.text = ""
                --XDebug.Log("end time")
                self.config.objTimeLock.gameObject:SetActive(false)
                self:StopTime()
            end
        end
        self:StartTime()
    else
        --XDebug.Log("time not req")
        self.config.objTimeLock.gameObject:SetActive(false)
        --self.config.timeOpenText.gameObject:SetActive(false)
        self.updateTime = nil
    end
end

function UISelectArenaView:StartTime()
    if self.updateTime ~= nil then
        zg.timeMgr:AddUpdateFunction(self.updateTime)
    end
end
function UISelectArenaView:StopTime()
    if self.updateTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
    end
end
function UISelectArenaView:OnTimeEnd()
    self:CheckLockArenaTeam()
end

function UISelectArenaView:CheckLockArenaTeam()
self.config.lockArenaTeam:SetActive(self.featureItemInBound.featureState ~= FeatureState.UNLOCK
        or ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.ARENA_TEAM, false) == false)
end

function UISelectArenaView:OnReadyShow()
    --- @type FeatureConfigInBound
    local featureConfigInBound = zg.playerData:GetMethod(PlayerDataMethod.FEATURE_CONFIG)
    --- @type FeatureItemInBound
    self.featureItemInBound = featureConfigInBound:GetFeatureConfigInBound(FeatureType.ARENA_TEAM)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    self.config.lockArena:SetActive(ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.ARENA, false) == false)
    self:CheckLockArenaTeam()

    self.config.notiArena:SetActive(NotificationArena.IsNotification())
    self.config.notiArenaTeam:SetActive(NotificationArenaTeam.IsNotification())
    self:InitUpdateTime()
end

function UISelectArenaView:OnClickArena()
    FeatureMapping.GoToFeature(FeatureType.ARENA, false, function ()
        PopupMgr.HidePopup(UIPopupName.UISelectArena)
    end)
end

function UISelectArenaView:OnClickArenaTeam()
    local featureState = self.featureItemInBound.featureState
    if featureState == FeatureState.UNLOCK then
        FeatureMapping.GoToFeature(FeatureType.ARENA_TEAM, false, function ()
            PopupMgr.HidePopup(UIPopupName.UISelectArena)
        end)
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowNotificationFeatureState(featureState)
    end
end

function UISelectArenaView:Hide()
    self:StopTime()
    UIBaseView.Hide(self)
end
----- @return void
function UISelectArenaView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end