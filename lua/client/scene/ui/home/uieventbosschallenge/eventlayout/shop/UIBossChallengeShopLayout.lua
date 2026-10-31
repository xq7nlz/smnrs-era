--- @class UIBossChallengeShopLayout : UIEventBossChallengeLayout
UIBossChallengeShopLayout = Class(UIBossChallengeShopLayout, UIEventBossChallengeLayout)

--- @param view UINewServerWeekView
--- @param anchor UnityEngine_RectTransform
function UIBossChallengeShopLayout:Ctor(view, tab, anchor)
    ---@type UIBossChallengeShopLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_BOSS_CHALLENGE
    --- @type PackViewType
    self.packViewType = PackViewType.EVENT_BOSS_CHALLENGE_BUNDLE
    UIEventBossChallengeLayout.Ctor(self, view, tab, anchor)
end

function UIBossChallengeShopLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_boss_challenge_shop_layout", self.anchor)
    UIEventBossChallengeLayout.InitLayoutConfig(self, inst)
    self:InitScrolls()
    self:InitLocalization()
end

function UIBossChallengeShopLayout:InitLocalization()
    UIEventBossChallengeLayout.InitLocalization(self)
end

function UIBossChallengeShopLayout:OnPurchaseSuccess()
    self.uiScroll:Resize(self.packOfProducts.groupPackDict:Count() - 1)
end

function UIBossChallengeShopLayout:InitPack()
    ---@type BossChallengeGroupPackOfProducts
    self.packOfProducts = ResourceMgr.GetPurchaseConfig():GetEventBossChallengeBundleStore():GetCurrentPack()
end

function UIBossChallengeShopLayout:InitScrolls()
    --- @param obj BossChallengeShopTitleView
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        local listPack = self.packOfProducts.groupPackDict:Get(dataIndex)
        obj:SetData(listPack, self.packViewType, function()
            self:OnPurchaseSuccess()
        end, dataIndex)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scroll, UIPoolType.UIEventBossChallengeShopTitle, onCreateItem)
end

function UIBossChallengeShopLayout:InitButtonListener()

end

function UIBossChallengeShopLayout:OnShow()
    UIEventBossChallengeLayout.OnShow(self)
    self:InitPack()
    self.uiScroll:Resize(self.packOfProducts.groupPackDict:Count() - 1)
    self.anchor.gameObject:SetActive(true)
end

function UIBossChallengeShopLayout:SetUpLayout()
    UIEventBossChallengeLayout.SetUpLayout(self)
end

function UIBossChallengeShopLayout:OnHide()
    UIEventBossChallengeLayout.OnHide(self)
    self.uiScroll:Hide()
end
