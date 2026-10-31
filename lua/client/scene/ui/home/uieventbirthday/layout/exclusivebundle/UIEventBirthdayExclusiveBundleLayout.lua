--- @class UIEventBirthdayExclusiveBundleLayout : UIEventBirthdayLayout
UIEventBirthdayExclusiveBundleLayout = Class(UIEventBirthdayExclusiveBundleLayout, UIEventBirthdayLayout)

--- @param view UIEventNewYearView
--- @param newYearTab LunarNewYearTab
--- @param anchor UnityEngine_RectTransform
function UIEventBirthdayExclusiveBundleLayout:Ctor(view, tab, anchor)
    --- thay type bằng type config của từng layout
    --- @type BirthdayExclusiveBundleLayoutConfig
    self.layoutConfig = nil
    UIEventBirthdayLayout.Ctor(self ,view, tab, anchor)
    --- thay op code neu co
    self.opCode = OpCode.EVENT_BIRTHDAY_EXCLUSIVE_BUNDLE_PURCHASE

    --- @type List PreviewHeroSimpleView
    self.listPoolPreviewHeroSimple = List()

    --- @type List ExclusiveBundleButtonView
    self.listPoolExclusiveBundle = List()

    --- @type EventActionType
    self.eventActionType = EventActionType.BIRTHDAY_EXCLUSIVE_BUNDLE_PURCHASE

    --- @type number
    self.skinIdFirst = 50007001
    --- @type number
    self.skinIdSecond = 60005001
end

function UIEventBirthdayExclusiveBundleLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("birthday_exclusive_bundle", self.anchor)
    UIEventBirthdayLayout.InitLayoutConfig(self, inst)
    self:InitLocalization()
    self:SetUpLayout()
    self:SetEventTitle()
end

function UIEventBirthdayExclusiveBundleLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventBirthdayExclusiveBundleLayout:SetEventBanner()
end

function UIEventBirthdayExclusiveBundleLayout:SetEventTitle()
    self.layoutConfig.title.text = LanguageUtils.LocalizeCommon("birthday_exclusive_bundle")
end

function ExclusiveBundleButtonView:CheckStock()
    local numberBuyData = self.eventModel:GetNumberBuy(self.eventActionType, self.packId)
    local stockLeft = self.productConfig.stock - numberBuyData
    self.isSoldOut = stockLeft == 0
end

function UIEventBirthdayExclusiveBundleLayout:OnShow()
    self:GetModelConfig()
    UIEventLayout.OnShow(self)
    --- @type EventBirthdayModel
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BIRTHDAY)
    self.packBaseDict = ResourceMgr.GetPurchaseConfig():GetBirthdayExclusiveBundleStore():GetCurrentPack():GetAllPackBase()

    self:ShowExclusiveBundle()
    self:ShowHeroPreview(self.skinIdFirst, self.layoutConfig.firstHeroAnchor)
    self:ShowHeroPreview(self.skinIdSecond, self.layoutConfig.secondHeroAnchor)
end

function UIEventBirthdayExclusiveBundleLayout:ShowExclusiveBundle()
    --- @type ProductConfig
    for index, productConfig in ipairs(self.packBaseDict:GetItems()) do
        --- @type ExclusiveBundleButtonView
        local exclusiveBundleButton = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.ExclusiveBundleButtonView, self.layoutConfig.horizontalLayout)
        self.listPoolExclusiveBundle:Add(exclusiveBundleButton)
        local data = {}
        data.opCode = self.opCode
        data.productConfig = productConfig
        data.callbackAfterBuy = function()
            self.view:CheckAllNotificationTab()
            exclusiveBundleButton:SyncBuyState(self.eventModel:GetNumberBuy(self.eventActionType, productConfig.id))
        end
        exclusiveBundleButton:SetData(data)
        exclusiveBundleButton:SyncBuyState(self.eventModel:GetNumberBuy(self.eventActionType, productConfig.id))
    end
end


--- @return PreviewHeroSimpleView
--- @param rewardInBound RewardInBound
--- @param parent UnityEngine_RectTransform
function UIEventBirthdayExclusiveBundleLayout:ShowHeroPreview(skinId, parent)
    --- @type PreviewHeroSimpleView
    local previewHeroSimple = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.PreviewHeroSimpleView, parent)
    self.listPoolPreviewHeroSimple:Add(previewHeroSimple)
    previewHeroSimple:SetHeroData(skinId, true)
    return previewHeroSimple
end


function UIEventBirthdayExclusiveBundleLayout:OnHide()
    UIEventBirthdayLayout.OnHide(self)
    self.anchor.gameObject:SetActive(false)
    for i, v in ipairs(self.listPoolExclusiveBundle:GetItems()) do
        v:ReturnPool()
    end
    self.listPoolExclusiveBundle:Clear()
    for i, v in ipairs(self.listPoolPreviewHeroSimple:GetItems()) do
        v:ReturnPool()
    end
    self.listPoolPreviewHeroSimple:Clear()
    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView:OnHide()
        self.worldSpaceHeroView = nil
    end
end

function UIEventBirthdayExclusiveBundleLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end