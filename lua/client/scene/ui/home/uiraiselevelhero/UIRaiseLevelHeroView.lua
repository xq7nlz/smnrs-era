require "lua.client.scene.ui.home.uiRaiseLevelHero.RaiseLevelWorldFormation"
require "lua.client.scene.ui.home.uiRaiseLevelHero.UIHeroListRaiseLevelLayout"
require "lua.client.scene.ui.home.uiRaiseLevelHero.BattleViewRaiseLevel"

--- @class UIRaiseLevelHeroView : UIBaseView
UIRaiseLevelHeroView = Class(UIRaiseLevelHeroView, UIBaseView)

--- @return void
--- @param model UIRaiseLevelHeroModel
function UIRaiseLevelHeroView:Ctor(model)
    ---@type UIRaiseLevelConfig
    self.config = nil
    ---@type HeroListView
    self.heroList = nil
    ---@type UIHeroListRaiseLevelLayout
    self.layout = nil
    --- @type MoneyBarView
    self.moneyBarView = nil
    --- @type MoneyBarView
    self.gemBarView = nil
    UIBaseView.Ctor(self, model)
    --- @type UIRaiseLevelHeroModel
    self.model = model
end

function UIRaiseLevelHeroView:OnReadyCreate()
    ---@type UIQuestConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.layout = UIHeroListRaiseLevelLayout(self.config.scroll, self)
    self.raiseWorldFormation = RaiseLevelWorldFormation(self.config.raiseLevelFormation)
    self.raiseWorldFormation:OnCreate()
    self:InitButtonListener()
end

function UIRaiseLevelHeroView:OnReadyShow(result)
    if result.show == nil or result.show == true then
        self.raiseWorldFormation:OnShow()
    end
    self.layout:OnShow()
    self.raiseInbound = zg.playerData:GetRaiseLevelHero()
    self:UpdateHeroCount()
    self:InitMoneyBar()
end

function UIRaiseLevelHeroView:InitMoneyBar()
    if self.moneyBarView == nil then
        self.moneyBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.config.moneyBarAnchor)
        self.moneyBarView:SetIconData(MoneyType.RAISED_HERO_UNLOCK_SLOT_CURRENCY)
    end
    if self.gemBarView == nil then
        self.gemBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.config.moneyBarAnchor)
        self.gemBarView:SetIconData(MoneyType.GEM)
    end
end

function UIRaiseLevelHeroView:Hide()
    self.layout:OnHide()
    self.raiseWorldFormation:OnHide()
    if self.moneyBarView ~= nil then
        self.moneyBarView:ReturnPool()
        self.moneyBarView = nil
    end
    if self.gemBarView ~= nil then
        self.gemBarView:ReturnPool()
        self.gemBarView = nil
    end
    UIBaseView.Hide(self)
end

function UIRaiseLevelHeroView:InitButtonListener()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonAsk.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHelpInfo()
    end)
end

function UIRaiseLevelHeroView:OnClickHelpInfo()
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("raise_level_hero"))
end

function UIRaiseLevelHeroView:OnClickBackOrClose()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIRaiseLevelHero)
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
end

--- @return void
function UIRaiseLevelHeroView:InitLocalization()
    self.config.localizeRaisedList.text = LanguageUtils.LocalizeCommon("raised_list")
    self.config.localizeRaiseLevel.text = LanguageUtils.LocalizeCommon("raise_hero_describe")
end

--- @return void
function UIRaiseLevelHeroView:UpdateHeroCount()
    self.config.heroCountText.text = string.format("%s/%s", UIUtils.SetColorString(UIUtils.red_dark, self.raiseInbound:GetRaisedSlotCount()), self.raiseInbound.raisedSlots:Count())
end

