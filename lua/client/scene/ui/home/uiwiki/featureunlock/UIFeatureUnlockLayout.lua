--- @class UIFeatureUnlockLayout
UIFeatureUnlockLayout = Class(UIFeatureUnlockLayout)

--- @return void
--- @param transform UnityEngine_Transform
--- @param view UIWikiView
function UIFeatureUnlockLayout:Ctor(view, transform)
    --- @type UICommunityTotalView
    self.view = view
    ---@type UIFeatureUnlockConfig
    self.config = UIBaseConfig(transform)
    self:InitScroll()
    --- @type Dictionary<FeatureLockData>
    self:GetFeatureList()
end

function UIFeatureUnlockLayout:GetFeatureList()
    local featureDict = ResourceMgr.GetMajorFeatureLock().dict
    --- @type List
    self.featureList = List()
    for _, v in pairs(featureDict:GetItems()) do
        if v.isShow == true then
            self.featureList:Add(v)
        end
    end
    local listFeatureNotShow = ClientConfigUtils.GetListFeatureNotShow()
    for _, v in pairs(listFeatureNotShow:GetItems()) do
        ---@param j FeatureLockData
        for __,j in pairs(self.featureList:GetItems()) do
            if j.feature == v then
                self.featureList:RemoveByReference(j)
            end
        end
    end
end

function UIFeatureUnlockLayout:InitScroll()
    --- @param obj FeatureUnlockItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        --- @type FeatureLockData
        local featureLockData = self.featureList:Get(index + 1)
        obj:SetData(featureLockData, ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(featureLockData.feature,
                false))
        obj:AddListener(
                function()
                    local onSuccess = function()
                        --self.view:Hide()
                        PopupMgr.HidePopup(UIPopupName.UICommunityTotal)
                    end
                    FeatureMapping.GoToFeature(featureLockData.feature, true, onSuccess)
                end
        )
    end
    self.uiScroll = UILoopScroll(self.config.scroll,
            UIPoolType.FeatureUnlockItemView, onCreateItem)
    self.uiScroll:SetUpMotion(MotionConfig(0, 0, 0, 0.02, 3))
end

--- @return void
function UIFeatureUnlockLayout:Show()
    local itemCount = self.featureList:Count()
    self.uiScroll:Resize(itemCount)
    self.view:EnableEmpty(itemCount == 0)
end

--- @return void
function UIFeatureUnlockLayout:Hide()
    self.uiScroll:Hide()
end