--- @class UIEggHunLayout : UIEventEasterEggLayout
UIEggHunLayout = Class(UIEggHunLayout, UIEventEasterEggLayout)

--- @param view UIEventXmasView
--- @param tab XmasTab
--- @param anchor UnityEngine_RectTransform
function UIEggHunLayout:Ctor(view, tab, anchor)
    --- @type UIEggHunConfig
    self.layoutConfig = nil
    --- @type List
    self.listItem = nil
    ---@type List<DiceSlotView>
    UIEventEasterEggLayout.Ctor(self, view, tab, anchor)
end

function UIEggHunLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("egg_hun", self.anchor)
    UIEventEasterEggLayout.InitLayoutConfig(self, inst)
    self:InitButtonListener()
    self:InitLocalization()
end

function UIEggHunLayout:InitLocalization()
    UIEventEasterEggLayout.InitLocalization(self)
    self.layoutConfig.textEventName.text = LanguageUtils.LocalizeCommon("egg_hun_name")
    self.layoutConfig.textEventContent.text = LanguageUtils.LocalizeCommon("egg_hun_desc")
    self.localizeDrop1 = LanguageUtils.LocalizeCommon("egg_hun_drop_1")
    self.localizeDrop2 = LanguageUtils.LocalizeCommon("egg_hun_drop_2")
    self.localizeDrop3 = LanguageUtils.LocalizeCommon("egg_hun_drop_3")
    self.localizeDrop4 = LanguageUtils.LocalizeCommon("hammer_drop_1")
    self.localizeDrop5 = LanguageUtils.LocalizeCommon("hammer_drop_2")
end

function UIEggHunLayout:InitButtonListener()

end

function UIEggHunLayout:OnShow()
    UIEventEasterEggLayout.OnShow(self)
    self.layoutConfig.drop1.text = self.localizeDrop1
    self.layoutConfig.drop2.text = self.localizeDrop2
    self.layoutConfig.drop3.text = self.localizeDrop3
    self.layoutConfig.drop4.text = StringUtils.FormatLocalize(self.localizeDrop4, self.eventModel:GetNumberChallengeArena() )
    self.layoutConfig.drop5.text = self.localizeDrop5
    if self.listItem == nil then
        self.listItem = List()
        --- @type IconView
        local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.layoutConfig.drop1.transform:GetChild(0))
        iconView:SetIconData(ItemIconData.CreateInstance(ResourceType.Money, MoneyType.EVENT_EASTER_GOLD_EGG))
        iconView:RegisterShowInfo()
        self.listItem:Add(iconView)

        iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.layoutConfig.drop2.transform:GetChild(0))
        iconView:SetIconData(ItemIconData.CreateInstance(ResourceType.Money, MoneyType.EVENT_EASTER_YELLOW_EGG))
        iconView:RegisterShowInfo()
        self.listItem:Add(iconView)

        iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.layoutConfig.drop3.transform:GetChild(0))
        iconView:SetIconData(ItemIconData.CreateInstance(ResourceType.Money, MoneyType.EVENT_EASTER_RAINBOW_EGG))
        iconView:RegisterShowInfo()
        self.listItem:Add(iconView)

        iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.layoutConfig.drop4.transform:GetChild(0))
        iconView:SetIconData(ItemIconData.CreateInstance(ResourceType.Money, MoneyType.EVENT_EASTER_YELLOW_HAMMER))
        iconView:RegisterShowInfo()
        self.listItem:Add(iconView)

        iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.layoutConfig.drop5.transform:GetChild(0))
        iconView:SetIconData(ItemIconData.CreateInstance(ResourceType.Money, MoneyType.EVENT_EASTER_RAINBOW_HAMMER))
        iconView:RegisterShowInfo()
        self.listItem:Add(iconView)
    end
end

function UIEggHunLayout:OnHide()
    UIEventEasterEggLayout.OnHide(self)
    if self.listItem ~= nil then
        ---@param v IconView
        for i, v in ipairs(self.listItem:GetItems()) do
            v:ReturnPool()
        end
        self.listItem:Clear()
        self.listItem = nil
    end
end