require "lua.client.scene.ui.home.uiMainArea.mainAreaBuilding.tagBuilding.TagBuilding"

--- @class MainAreaBuilding
MainAreaBuilding = Class(MainAreaBuilding)

--- @param transform UnityEngine_Transform
function MainAreaBuilding:Ctor(transform)
    --- @type MainAreaBuildingConfig
    self.config = nil
    --- @type TagBuilding
    self.tagBuilding = nil

    self:_InitConfig(transform)

    self.isSelectable = true
end

--- @param transform UnityEngine_Transform
function MainAreaBuilding:_InitConfig(transform)
    if self.config.tagBuilding then
        self.tagBuilding = TagBuilding(self.config.tagBuilding, self)
    end
end

function MainAreaBuilding:OnPointerDown()
    self.isSelectable = true
end

function MainAreaBuilding:OnPointerUp()

end

function MainAreaBuilding:OnBeginDrag()
    self.isSelectable = false
    self:OnPointerUp()
end

--- @return UnityEngine_UI_Button
function MainAreaBuilding:GetButton()
    self.isSelectable = true
    return self.config.clickArea
end

--- @param isEnable boolean
function MainAreaBuilding:EnableNotify(isEnable)
    if self.tagBuilding then
        self.tagBuilding:EnableNotify(isEnable)
    else
        self.config.notify:SetActive(isEnable)
    end
end

--- @param featureType FeatureType
function MainAreaBuilding:CheckUnlockFeature(featureType)
    self.featureType = featureType
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(featureType, false) == true then
        self:SetTagBuildingFeatureIcon(FeatureState.UNLOCK, featureType)
    else
        self:SetTagBuildingFeatureIcon(FeatureState.LOCK, 0)
    end
end

function MainAreaBuilding:GetFeatureItemInBound()
    --- @type FeatureConfigInBound
    local featureConfigInBound = zg.playerData:GetMethod(PlayerDataMethod.FEATURE_CONFIG)
    self.featureItemInBound = featureConfigInBound:GetFeatureConfigInBound(self.featureType)
end


function MainAreaBuilding:CheckFeatureState()
    self:GetFeatureItemInBound()
    ---@type FeatureItemInBound
    local featureState = self.featureItemInBound.featureState
    if featureState == FeatureState.LOCK then
        self:Enable(false)
        self:EnableTagBuilding(false)
    elseif featureState == FeatureState.COMING_SOON then
        self:Enable(true)

        self:EnableTagBuilding(true)

        self:SetTagBuildingFeatureIcon(featureState, 0)
    elseif featureState == FeatureState.MAINTAIN then
        self:Enable(true)

        self:EnableTagBuilding(true)

        self:SetTagBuildingFeatureIcon(featureState, 0)
    else
        self:Enable(true)

        self:EnableTagBuilding(true)

        self:SetTagBuildingFeatureIcon(featureState, self.featureType)
    end
end

function MainAreaBuilding:OnShow(featureType)
    self.featureType = featureType
    self.tagBuilding:OnShow(featureType)
end

function MainAreaBuilding:OnHide()
    self.tagBuilding:OnHide(self.featureType)
end

function MainAreaBuilding:SetTagBuildingFeatureIcon(featureState, featureType)
    if self.tagBuilding then
        if featureState == FeatureState.MAINTAIN
                or featureState == FeatureState.COMING_SOON then
            self.tagBuilding:SetFeatureIcon(0)
        else
            if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(featureType, false) == true then
                self.tagBuilding:SetFeatureIcon(featureType)
            else
                self.tagBuilding:SetFeatureIcon(0)
            end
        end
    end
end

function MainAreaBuilding:EnableTagBuilding(isEnable)
    if self.tagBuilding then
        self.tagBuilding:Enable(isEnable)
    end
end

--- @param featureType FeatureType
function MainAreaBuilding:InitLocalize(featureType)
    if self.tagBuilding then
        self.tagBuilding:InitLocalize(featureType)
    else
        self.config.featureName.text = LanguageUtils.LocalizeFeature(featureType)
    end
end

--- @param tittle string
function MainAreaBuilding:FixedTittle(tittle)
    if self.tagBuilding then
        self.tagBuilding:FixedTittle(tittle)
    else
        self.config.featureName.text = tittle
    end
end

function MainAreaBuilding.GetHighlightColorBuilding()
    return U_Color(0.28, 0.21, 0.21, 0)
end

--- @param listener function
function MainAreaBuilding:AddListener(listener)
    self.config.clickArea.onClick:RemoveAllListeners()
    self.config.clickArea.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if self.isSelectable then
            if self.featureType == nil then
                if listener then
                    listener()
                end
            else
                self:GetFeatureItemInBound()
                local featureState = self.featureItemInBound.featureState
                if featureState == FeatureState.MAINTAIN then
                    SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("feature_maintain"))
                    zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
                    return
                elseif featureState == FeatureState.LOCK then
                    self:Enable(false)
                    return
                elseif featureState == FeatureState.COMING_SOON then
                    SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("coming_soon"))
                    zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
                    return
                else
                    if listener then
                        listener()
                    end
                end
            end
        end
    end)
end

--- @param isEnable boolean
function MainAreaBuilding:Enable(isEnable)
    self.config.clickArea.gameObject:SetActive(isEnable)
    self.tagBuilding:Enable(false)
end