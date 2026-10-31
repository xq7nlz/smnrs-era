--- @class TagBuilding
TagBuilding = Class(TagBuilding)

--- @param transform UnityEngine_RectTransform
function TagBuilding:Ctor(transform,view)
    --- @type TagBuildingConfig
    self.config = UIBaseConfig(transform)
   -- self.self.updateTime = nil
    self.mainAreaBuilding = view
end

--- @param isEnable boolean
function TagBuilding:EnableNotify(isEnable)
    self.config.notify:SetActive(isEnable)
end
function TagBuilding:OnShow(featureType)
        self.featureType = featureType
    self:InitUpdateTime()
end

function TagBuilding:OnHide(featureType)
    self:StopTime()
end

function TagBuilding:OnTimeEnd()
    self.mainAreaBuilding:CheckUnlockFeature(self.featureType)
end

function TagBuilding:InitUpdateTime()
    local timeOpenIn = FeatureItemInBound.GetTimeOpenIn(self.featureType)
    if (timeOpenIn > 0) then
        self.timeRemaining = timeOpenIn
        self.config.timeOpenText.text = string.format("%s %s",LanguageUtils.LocalizeCommon("will_open_in"),UIUtils.SetColorString(UIUtils.green_dark, TimeUtils.GetDeltaTime(self.timeRemaining, 4)))
        --string.format(LanguageUtils.LocalizeCommon("expire_in_s"),UIUtils.SetColorString(UIUtils.green_dark, TimeUtils.GetDeltaTime(self.timeRemaining, 4)))
        self.config.contextTimeBar.gameObject:SetActive(true)
        self.updateTime = function(isSetTime)
            if isSetTime == true then
            else
                self.timeRemaining = self.timeRemaining - 1
            end
            if self.timeRemaining > 0 then
                self.config.timeOpenText.text = string.format("%s %s",LanguageUtils.LocalizeCommon("will_open_in"),UIUtils.SetColorString(UIUtils.green_dark, TimeUtils.GetDeltaTime(self.timeRemaining, 4)))
                --elf.config.timeOpenText.text = string.format(LanguageUtils.LocalizeCommon("expire_in_s"),UIUtils.SetColorString(UIUtils.green_dark, TimeUtils.GetDeltaTime(self.timeRemaining, 4)))
            else
                self:OnTimeEnd()
                self.config.timeOpenText.text = ""
                self.config.contextTimeBar.gameObject:SetActive(false)
                self:StopTime()
            end
        end
        self:StartTime()
    else
        self.config.contextTimeBar.gameObject:SetActive(false)
        --self.config.timeOpenText.gameObject:SetActive(false)
        self.updateTime = nil
    end
end

function TagBuilding:StartTime()
    if self.updateTime ~= nil then
        zg.timeMgr:AddUpdateFunction(self.updateTime)
    end
end
function TagBuilding:StopTime()
    if self.updateTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
    end
end

--- @param featureType FeatureType
function TagBuilding:SetFeatureIcon(featureType)
    if featureType == nil then
        return
    end
    self.config.featureIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconFeature, featureType)
end

--- @param featureType FeatureType
function TagBuilding:InitLocalize(featureType)
    self.config.featureName.text = LanguageUtils.LocalizeFeature(featureType)
    --if featureType == FeatureType.DOMAINS then
    --    self.config.featureName.text = string.format("%s (%s)", self.config.featureName.text, LanguageUtils.LocalizeCommon("beta"))
    --end
end

--- @param tittle string
function TagBuilding:FixedTittle(tittle)
    self.config.featureName.text = tittle
end

--- @param isEnable boolean
function TagBuilding:Enable(isEnable)
    self.config.gameObject:SetActive(isEnable)
end