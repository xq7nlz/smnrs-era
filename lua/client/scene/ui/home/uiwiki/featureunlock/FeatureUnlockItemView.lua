--- @class FeatureUnlockItemView : UIPrefabView
FeatureUnlockItemView = Class(FeatureUnlockItemView, UIPrefabView)

function FeatureUnlockItemView:Ctor()
    UIPrefabView.Ctor(self)
    self.id=0
end

function FeatureUnlockItemView:SetPrefabName()
    self.prefabName = 'feature_unlock_item'
    self.uiPoolType = UIPoolType.FeatureUnlockItemView
end


--- @return void
--- @param transform UnityEngine_Transform
function FeatureUnlockItemView:SetConfig(transform)
    --- @type FeatureUnlockItemConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param feature FeatureLockData
---@param isUnlock  boolean
function FeatureUnlockItemView:SetData(feature,isUnlock)
    self.featureUnlockData = feature
    if self.featureUnlockData.stage > 0 then
        local difficult, map, stage = ClientConfigUtils.GetIdFromStageId( self.featureUnlockData.stage)
        --- KazuD#7046(Longnn-GD) chốt là về sau sẽ không require level
        self.config.decs.text =StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("require_stage_x"),
                LanguageUtils.LocalizeDifficult(difficult), map, stage)
    else
        self.config.decs.gameObject:SetActive(false)
    end
    self.isUnlock = isUnlock
    if self.isUnlock then
        self.config.decs.gameObject:SetActive(false)
        self.config.goButton.gameObject:SetActive(true)
    else
        --- @type FeatureConfigInBound
        local featureConfigInBound = zg.playerData:GetMethod(PlayerDataMethod.FEATURE_CONFIG)
        local featureItemInBound = featureConfigInBound:GetFeatureConfigInBound(feature.feature)
        if featureItemInBound.featureState == FeatureState.MAINTAIN then
            self.config.decs.text =LanguageUtils.LocalizeCommon("feature_maintain")
        end
        self.config.decs.gameObject:SetActive(true)
        self.config.goButton.gameObject:SetActive(false)
    end
    self.config.featureBackground.sprite = ResourceLoadUtils.LoadBackgroundFeature(feature.feature)
    self.config.featureName.text = LanguageUtils.LocalizeFeature(feature.feature)
    self.config.textGo.text = LanguageUtils.LocalizeCommon("go")
    self:InitUpdateTime()
end

--- @param callback function
function FeatureUnlockItemView:AddListener(callback)
    self.config.goButton.onClick:RemoveAllListeners()
    self.config.goButton.onClick:AddListener(callback)
end

function FeatureUnlockItemView:InitUpdateTime()
    local timeOpen = FeatureItemInBound.GetTimeOpenIn(self.featureUnlockData.feature)
    if (timeOpen > 0) then
        self.timeRemaining = timeOpen
        self.config.timeCountDown.text = string.format("%s %s",LanguageUtils.LocalizeCommon("will_open_in"),UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRemaining, 4)))
        self.config.timeCountDownWithIcon.gameObject:SetActive(true)
        self.updateTime = function(isSetTime)
            if isSetTime == true then
            else
                self.timeRemaining = self.timeRemaining - 1
            end
            if self.timeRemaining > 0 then
                self.config.timeCountDown.text = string.format("%s %s",LanguageUtils.LocalizeCommon("will_open_in"),UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRemaining, 4)))
            else
                self:OnTimeEnd()
                self.config.timeCountDown.text = ""
                self.config.timeCountDownWithIcon.gameObject:SetActive(false)
                self:StopTime()
            end
        end
        self:StartTime()
    else
        self.config.timeCountDownWithIcon.gameObject:SetActive(false)
        self.updateTime = nil
    end
end

function FeatureUnlockItemView:StartTime()
    if self.updateTime ~= nil then
        zg.timeMgr:AddUpdateFunction(self.updateTime)
    end
end

function FeatureUnlockItemView:StopTime()
    if self.updateTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
    end
end

function FeatureUnlockItemView:ReturnPool()
    UIPrefabView.ReturnPool(self)
    self:StopTime()
end

return FeatureUnlockItemView