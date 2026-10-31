--- @class UIEventBundleLayout : UIEventLayout
UIEventBundleLayout = Class(UIEventBundleLayout, UIEventLayout)

local cellSize = U_Vector2(494, 389)
local spacing = U_Vector2(0, 10)

--- @param view UIEventView
--- @param eventTimeType EventTimeType
function UIEventBundleLayout:Ctor(view, eventTimeType)
    UIEventLayout.Ctor(self, view, eventTimeType)
end

--- @param eventPopupModel EventPopupQuestModel
function UIEventBundleLayout:OnShow(eventPopupModel)
    --- @type EventPopupQuestModel
    self.eventPopupPurchaseModel = eventPopupModel
    --- @type List -- BonusTagItemView
    self.listIconBonusView = List()
    UIEventLayout.OnShow(self, eventPopupModel)
end

function UIEventBundleLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.view:SetGridContentSize(cellSize, spacing, 3)
    self:InitScrollContentBundle()
    local count = self.eventPopupPurchaseModel:GetAllData():Count()
    self:ResizeLoopScrollContent(count)
    self.view.scrollLoopContent:ScrollToCell(count - 1)
end

function UIEventBundleLayout:InitScrollContentBundle()
    --- @param obj IapTilePackItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type PurchasedPackInBound
        local purchasedPack = self.eventPopupPurchaseModel:GetDataByIndexOfList(dataIndex)
        self:CheckListExtraReward(obj, purchasedPack)
        self:CheckEventCondition(purchasedPack)

        obj:SetViewIconData(PackViewType.EVENT_BUNDLE, purchasedPack, function()
            RxMgr.notificationEventPopup:Next(self.eventTimeType)
        end)
    end
    self.view.scrollLoopContent = UILoopScroll(self.config.VerticalScrollContent, UIPoolType.IapTilePackItem, onCreateItem)
end

function UIEventBundleLayout:CheckEventCondition(purchasedPack)
    local eventBirthdayModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BIRTHDAY)
    if eventBirthdayModel and eventBirthdayModel:IsOpening() then
        purchasedPack.config.enableVipPointTag = true
    end
end

--- @return void
function UIEventBundleLayout:CheckListExtraReward(obj, purchasedPack)
    local bundleId = string.sub(purchasedPack.config.androidPackageName, string.len(purchasedPack.config.androidPackageName) - 25, string.len(purchasedPack.config.androidPackageName))
    purchasedPack.config.bonusRewardList = self:GetListExtraReward(bundleId)
    if purchasedPack.config.bonusRewardList:Count() > 0 then
        for i, v in ipairs(purchasedPack.config.bonusRewardList:GetItems()) do
            local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.BonusTagItemView, obj.config.transform)
            self.listIconBonusView:Add(iconView)
            iconView:SetData(v)
            iconView:SetLocalLocationOffset(U_Vector3(123, 180 - i * 60, 0))
        end
    end
end

--- @return List --- List<RewardInBound>()
function UIEventBundleLayout:GetListExtraReward(bundleId)
    --- @type EventEasterEggModel
    local eventEasterEggModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_EASTER_EGG)
    if eventEasterEggModel and eventEasterEggModel:IsOpening() then
        local dataId = eventEasterEggModel.timeData.dataId
        --- @type EventEasterEggConfig
        local eventEasterEggConfig = ResourceMgr.GetEventConfig():GetData(EventTimeType.EVENT_EASTER_EGG, dataId)
        return eventEasterEggConfig:GetBundleBonusReward(dataId, bundleId)
    end
    return List()
end

function UIEventBundleLayout:OnHide()
    UIEventLayout.OnHide(self)
    for i, v in ipairs(self.listIconBonusView:GetItems()) do
        v:ReturnPool()
    end
    self.listIconBonusView:Clear()
    UIEventLayout.EnableLoopScrollContent(self, false)
end