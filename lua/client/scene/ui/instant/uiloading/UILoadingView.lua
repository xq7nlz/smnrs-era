require "lua.client.scene.ui.common.UIBarPercentView"

--- @class UILoadingView : UIBaseView
UILoadingView = Class(UILoadingView, UIBaseView)

--- @return void
--- @param model UILoadingModel
--- @param ctrl UILoadingCtrl
function UILoadingView:Ctor(model, ctrl)
    --- @type LoadingConfig
    self.config = nil
    --- @type UILoadingCtrl
    self.ctrl = nil
    --- @type UILoadingModel
    self.model = nil

    UIBaseView.Ctor(self, model, ctrl)

    --- @type boolean
    self.isAutoPlayOpenSound = false
    --- @type boolean
    self.isAutoPlayCloseSound = false
    
    self:InitUpdateTime()
end

--- @return void
function UILoadingView:OnReadyCreate()
    ---@type LoadingConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.barPercent = UIBarPercentView(self.config.loadingBar)
    self:SetViewPercent(0)
    uiCanvas:SetBackgroundSize(self.config.loadingScreen)
end

--- @return void
function UILoadingView:OnReadyShow(result)
    self.uiTransform:SetAsLastSibling()
    self:SetViewPercent(0)
    self:StartUpdateTime()
    self.ctrl:Show()
    self:SetActive(true)
    self:ShowTrickAndTip()
end

--- @return void
function UILoadingView:ShowTrickAndTip()
    self.config.textGuide.text = LanguageUtils.LocalizeCommon(string.format("tip_%s", math.random(1, 7)))
end

function UILoadingView:InitUpdateTime()
    self.model.loadingSubject = Subject.Create()

    self.updateTime = function(value)
        self.model.loadingPercent = value
        local percent = value / self.model.totalUpdateTimes
        if percent >= 1 then
            self:RemoveUpdateTime()
            PopupMgr.HidePopup(self.model.uiName)
        else
            self:SetViewPercent(percent)
        end
    end
end

--- @return void
function UILoadingView:StartUpdateTime()
    self.subscriptionLoading = self.model.loadingSubject:Subscribe(self.updateTime)
end

--- @return void
function UILoadingView:RemoveUpdateTime()
    if self.subscriptionLoading ~= nil then
        self.subscriptionLoading:Unsubscribe()
        self.subscriptionLoading = nil
    end
end

function UILoadingView:SetViewPercent(percent)
    self.barPercent:SetPercent(percent)
end

--- @return void
function UILoadingView:Hide()
    self:RemoveUpdateTime()
    self.ctrl:Hide()

    RxMgr.hideLoading:Next()
    UIBaseView.Hide(self)
    self.model.isTriggerFinish = false
    self:SetPlayMusic()
    U_Resources.UnloadUnusedAssets()
end

--- @return void
function UILoadingView:OnReadyHide()
    -- do nothing
end

function UILoadingView:SetPlayMusic()
    if SceneMgr.IsHomeScene() then
        if zg.networkMgr.isConnected == true then
            zg.audioMgr:PlayMusic(MusicCtrl.mainMenuMusic)
            zg.audioMgr:StopMusic(MusicCtrl.splashMusic, function ()
                self:UnloadSplashMusic()
            end)
        end
    else
        local battleMusicPath = ClientConfigUtils.GetBattleMusicPath()
        zg.audioMgr:PlayMusic(battleMusicPath)
    end
end

function UILoadingView:UnloadSplashMusic()
    --local splashMusicAsset = SmartPool.Instance:GetPooledAudioFile(MusicCtrl.splashMusic)
    --if splashMusicAsset ~= nil then
    --    U_Resources.UnloadAsset(splashMusicAsset)
    --    SmartPool.Instance:RemoveAudio(MusicCtrl.splashMusic)
    --end
end