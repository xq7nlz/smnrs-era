require "lua.client.scene.ui.home.uiInventory.equipment.UIInventoryEquipmentView"
require "lua.client.scene.ui.home.uiInventory.artifact.UIInventoryArtifactView"
require "lua.client.scene.ui.home.uiInventory.fragment.UIInventoryFragmentView"
require "lua.client.scene.ui.home.uiInventory.money.UIInventoryMoneyView"
require "lua.client.scene.ui.home.uiInventory.skin.UIInventorySkinView"
require "lua.client.scene.ui.home.uiInventory.idleEffect.UIInventoryIdleEffectView"
require "lua.client.core.network.item.sellItem.SellItemOutBound"

--- @class UIInventoryView : UIBaseView
UIInventoryView = Class(UIInventoryView, UIBaseView)

--- @return void
--- @param model UIInventoryModel
function UIInventoryView:Ctor(model)
    ---@type UIInventoryConfig
    self.config = nil
    --- @type UISelect
    self.tab = nil
    ---@type UITabInventoryConfig[]
    self.tabInventoryConfig = {}
    ---@type UIInventoryEquipmentView
    self.equipment = nil
    ---@type UIInventoryArtifactView
    self.artifact = nil
    ---@type UIInventoryFragmentView
    self.fragment = nil
    ---@type UIInventoryMoneyView
    self.money = nil
    ---@type UIInventorySkinView
    self.skin = nil
    ---@type UIInventoryIdleEffectView
    self.idleEffect = nil

    self.onClickFragment = nil
    --- @type boolean
    self.canPlayMotion = true
    -- init variables here
    UIBaseView.Ctor(self, model)
    --- @type UIInventoryModel
    self.model = self.model
end

--- @return void
function UIInventoryView:OnReadyCreate()
    --- @type UIInventoryConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.equipment = UIInventoryEquipmentView(self, self.config.content:GetChild(UIInventoryTab.Equipment - 1), self.model)
    self.money = UIInventoryMoneyView(self, self.config.content:GetChild(UIInventoryTab.Money - 1), self.model)
    self.fragment = UIInventoryFragmentView(self, self.config.content:GetChild(UIInventoryTab.Fragment - 1), self.model)
    self.artifact = UIInventoryArtifactView(self, self.config.content:GetChild(UIInventoryTab.Artifact - 1), self.model)
    self.skin = UIInventorySkinView(self, self.config.content:GetChild(UIInventoryTab.Skin - 1), self.model)
    self.config.tabEffect.gameObject:SetActive(ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.IDLE_EFFECT))
    self.config.content:GetChild(UIInventoryTab.IdleEffect - 1).gameObject:SetActive(
            ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.IDLE_EFFECT))
    if (ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.IDLE_EFFECT)) then
        self.idleEffect = UIInventoryIdleEffectView(self, self.config.content:GetChild(UIInventoryTab.IdleEffect - 1), self.model)
    else
    end
    -- Tab
    --- @param obj UITabInventoryConfig
    --- @param isSelect boolean
    local onSelect = function(obj, isSelect, indexTab)
        if obj ~= nil then
            obj.button.interactable = not isSelect
            obj.bgOn.gameObject:SetActive(isSelect)
        end
        self.config.content:GetChild(indexTab - 1).gameObject:SetActive(isSelect)
    end
    local funSelectTab = { self.ShowEquipment, self.ShowMoney, self.ShowFragment, self.ShowArtifact,
                           self.ShowSkin, self.ShowIdleEffect }

    local funHideTab = { self.HideEquipment, self.HideMoney, self.HideFragment, self.HideArtifact,
                         self.HideSKin, self.HideIdleEffect  }
    local onChangeSelect = function(indexTab, lastTab)
        if lastTab ~= nil then
            funHideTab[lastTab](self)
        end
        if indexTab ~= nil then
            funSelectTab[indexTab](self)
            self.config.softTutFrgament:SetActive(indexTab ~= UIInventoryTab.Fragment and NotificationFragment.IsCanShowSoftTutFragment())
        end
    end
    self.tab = UISelect(self.config.tabParent, UIBaseConfig, onSelect, onChangeSelect)

    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

--- @return void
function UIInventoryView:InitLocalization()
    self.config.localizeEquip.text = LanguageUtils.LocalizeCommon("equip")
    self.config.localizeStorage.text = LanguageUtils.LocalizeCommon("storage")
    self.config.localizeFragment.text = LanguageUtils.LocalizeCommon("fragment")
    self.config.localizeArtifact.text = LanguageUtils.LocalizeCommon("artifact")
    self.config.localizeSkin.text = LanguageUtils.LocalizeCommon("skin")
    self.config.localizeIdleEffect.text = LanguageUtils.LocalizeCommon("idle_effect")
    local gallery = LanguageUtils.LocalizeCommon("gallery")
    self.config.localizeGallery.text = gallery
    self.config.localizeGallerySkin.text = gallery
    self.config.localizeGalleryIdleEffect.text = gallery
    self.config.textEmpty.text = LanguageUtils.LocalizeCommon("empty")
end

function UIInventoryView:OnReadyShow()
    local content = self.config.scrollTab.content
    content.anchoredPosition = U_Vector2(content.anchoredPosition.x,0)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    self.canPlayMotion = true
    self.tab:Select(1)
    self.model.sellItemDict:Clear()
    self:CheckNotificationFragment()
    self:CheckNotificationStorage()
end

--- @return void
function UIInventoryView:OnFinishAnimation()
    UIBaseView.OnFinishAnimation(self)
    self:CheckAndInitTutorial()
end

--- @return void
function UIInventoryView:CheckNotificationFragment()
    NotificationFragment.CheckNotificationFragment(self.config.notiFragment)
end

--- @return void
function UIInventoryView:CheckNotificationStorage()
    NotificationCheckUtils.BoxNotificationCheck(self.config.notiStorage)
    self.subscriptionXmasBox = RxMgr.changeResource:Subscribe(function (data)
        if data.resourceType == ResourceType.Money and data.resourceId == MoneyType.EVENT_CHRISTMAS_BOX then
            NotificationCheckUtils.BoxNotificationCheck(self.config.notiStorage)
        end
    end)
end

--- @return void
function UIInventoryView:Hide()
    UIBaseView.Hide(self)
    self:RemoveListenerTutorial()
    self.tab:Select(nil)

    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Sell Item Success")
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            XDebug.Log("Sell Item Failed")
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    ---@type SellItemOutBound
    local sellItemOutBound = SellItemOutBound()
    for i, v in pairs(self.model.sellItemDict:GetItems()) do
        sellItemOutBound.listData:Add(SellItemRecordOutBound(i, v))
    end
    if sellItemOutBound.listData:Count() > 0 then
        --XDebug.Log("sellItemDict" .. LogUtils.ToDetail(self.model.sellItemDict:GetItems()))
        NetworkUtils.Request(OpCode.ITEM_SELL, sellItemOutBound, callback)
    end
    self:EnableEmpty(false)
    if self.subscriptionXmasBox ~= nil then
        self.subscriptionXmasBox:Unsubscribe()
        self.subscriptionXmasBox = nil
    end
    self.config.softTutFrgament:SetActive(false)
end

--- @return void
function UIInventoryView:ShowEquipment()
    self.config.textTitle.text = self.config.localizeEquip.text
    self.equipment:Show(self.canPlayMotion)
    if self.canPlayMotion == true then
        self.canPlayMotion = false
    end
end

--- @return void
function UIInventoryView:HideEquipment()
    self.equipment:Hide()
end

--- @return void
function UIInventoryView:ShowMoney()
    self.config.textTitle.text = self.config.localizeStorage.text
    self.money:Show()
end

--- @return void
function UIInventoryView:HideMoney()
    self.money:Hide()
end

--- @return void
function UIInventoryView:ShowFragment()
    self.config.textTitle.text = self.config.localizeFragment.text
    self.fragment:Show()
    if self.config.notiFragment.activeInHierarchy then
        NotificationFragment.SaveToServer()
    end
    self.config.notiFragment:SetActive(false)

    RxMgr.showFragment:Next()
end

--- @return void
function UIInventoryView:HideFragment()
    self.fragment:Hide()
end

--- @return void
function UIInventoryView:ShowArtifact()
    self.config.textTitle.text = self.config.localizeArtifact.text
    self.artifact:Show()
end

--- @return void
function UIInventoryView:HideArtifact()
    self.artifact:Hide()
end

--- @return void
function UIInventoryView:ShowSkin()
    self.config.textTitle.text = self.config.localizeSkin.text
    self.skin:Show()
end

--- @return void
function UIInventoryView:ShowIdleEffect()
    if ClientConfigUtils.USE_HERO_MENU_IDLE_EFFECT then
        self.config.textTitle.text = self.config.localizeIdleEffect.text
        self.idleEffect:Show()
    end

end

--- @return void
function UIInventoryView:HideSKin()
    self.skin:Hide()
end

--- @return void
function UIInventoryView:HideIdleEffect()
    if ClientConfigUtils.USE_HERO_MENU_IDLE_EFFECT then
        self.idleEffect:Hide()
    end
end

--- @return void
---@param tutorial UITutorialView
---@param step number
function UIInventoryView:ShowTutorial(tutorial, step)
    if step == TutorialStep.CLICK_TAB_FRAGMENT then
        if self.tab.indexTab == 3 then
            self.tab:Select(1)
        end
        tutorial:ViewFocusCurrentTutorial(self.tab.uiTransform:GetChild(2):
        GetComponent(ComponentName.UnityEngine_UI_Button), 0.6, nil, nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.CLICK_HERO_FRAGMENT then
        ---@type UnityEngine_UI_Button
        local button
        ---@param v FragmentIconView
        for _, v in ipairs(self.fragment.listFragmentItemView:GetItems()) do
            if v.iconData.type == ResourceType.HeroFragment then
                local star = ClientConfigUtils.GetHeroFragmentStar(v.iconData.itemId)
                if ResourceMgr.GetFragmentConfig().heroFragmentNumberDictionary:Get(star).number <= v.iconData.quantity then
                    button = v.iconView.iconView.config.button
                    break
                end
            end
        end
        if button ~= nil then
            tutorial:ViewFocusCurrentTutorial(button, U_Vector2(300, 400), nil, nil, TutorialHandType.CLICK)
        else
            XDebug.Error("MISSING HeroFragment")
        end
    end
end

--- @param isEnable boolean
function UIInventoryView:EnableEmpty(isEnable)
    self.config.empty:SetActive(isEnable)
end

UIInventoryTab = {
    Equipment = 1,
    Money = 2,
    Fragment = 3,
    Artifact = 4,
    Skin = 5,
    IdleEffect = 6,
}