--- @class UIEventPieceAdventureShopLayout : UIEventPieceAdventureLayout
UIEventPieceAdventureShopLayout = Class(UIEventPieceAdventureShopLayout, UIEventPieceAdventureLayout)

--- @param view UIEventAiryuuView
--- @param anchor UnityEngine_RectTransform
function UIEventPieceAdventureShopLayout:Ctor(view, tab, anchor)
    ---@type UIEventPieceAdventureShopLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listMoneyBar = List()
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_PIECE_ADVENTURE
    --- @type PackViewType
    self.packViewType = PackViewType.EVENT_PIECE_ADVENTURE_BUNDLE
    UIEventPieceAdventureLayout.Ctor(self, view, tab, anchor)
end

function UIEventPieceAdventureShopLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_piece_adventure_bundle_layout", self.anchor)
    UIEventPieceAdventureLayout.InitLayoutConfig(self, inst)
    self:InitScrolls()
    self:InitLocalization()
    self:InitButtonListener()
end

function UIEventPieceAdventureShopLayout:InitLocalization()
    UIEventPieceAdventureLayout.InitLocalization(self)
end

function UIEventPieceAdventureShopLayout:ReturnPoolMoneyBar()
    ---@param v MoneyBarView
    for _, v in pairs(self.listMoneyBar:GetItems()) do
        v:ReturnPool()
    end
    self.listMoneyBar:Clear()
end

function UIEventPieceAdventureShopLayout:InitPack()
    self.packOfProducts = ResourceMgr.GetPurchaseConfig():GetEventPieceAdventureBundleStore():GetCurrentPack()
end

function UIEventPieceAdventureShopLayout:InitScrolls()
    --- @param obj BossChallengeShopTitleView
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        local listPack = self.packOfProducts.groupPackDict:Get(dataIndex)
        obj:SetData(listPack, self.packViewType, function()
            self:OnPurchaseSuccess()
        end, dataIndex)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scroll, UIPoolType.UIEventPieceAdventureShopTitle, onCreateItem)
end

function UIEventPieceAdventureShopLayout:OnPurchaseSuccess()
    self.uiScroll:Resize(self.packOfProducts.groupPackDict:Count())
end

function UIEventPieceAdventureShopLayout:InitButtonListener()

end

function UIEventPieceAdventureShopLayout:OnShow()
    UIEventPieceAdventureLayout.OnShow(self)
    self:InitPack()
    self.uiScroll:Resize(self.packOfProducts.groupPackDict:Count())
    self.anchor.gameObject:SetActive(true)
end

function UIEventPieceAdventureShopLayout:SetUpLayout()
    UIEventPieceAdventureLayout.SetUpLayout(self)
end

function UIEventPieceAdventureShopLayout:OnHide()
    UIEventPieceAdventureLayout.OnHide(self)
    self.uiScroll:Hide()
    self:ReturnPoolMoneyBar()
end