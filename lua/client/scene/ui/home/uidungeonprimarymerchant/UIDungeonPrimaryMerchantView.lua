---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiDungeonPrimaryMerchant.UIDungeonPrimaryMerchantConfig"

--- @class UIDungeonPrimaryMerchantView : UIBaseView
UIDungeonPrimaryMerchantView = Class(UIDungeonPrimaryMerchantView, UIBaseView)

--- @return void
--- @param model UIDungeonPrimaryMerchantModel
function UIDungeonPrimaryMerchantView:Ctor(model, ctrl)
    --- @type UIDungeonPrimaryMerchantConfig
    self.config = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type MoneyBarView
    self.goldBarView = nil
    --- @type MoneyBarView
    self.gemBarView = nil

    UIBaseView.Ctor(self, model, ctrl)
    --- @type UIDungeonPrimaryMerchantModel
    self.model = model
end

--- @return void
function UIDungeonPrimaryMerchantView:OnReadyCreate()
    ---@type UIDungeonPrimaryMerchantConfig
    self.config = UIBaseConfig(self.uiTransform)

    self:_InitButtonListener()
    self:_InitScroll()
    self:_InitLocalize()
end

function UIDungeonPrimaryMerchantView:_InitLocalize()
    self.config.textEmpty.text = LanguageUtils.LocalizeCommon("empty")
end
--- @return void
function UIDungeonPrimaryMerchantView:_InitScroll()
    --- @param obj DungeonShopItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        local objectId = index + 1
        --- @type MarketItemInBound
        local data = self.model.itemList:Get(objectId)
        if data == nil then
            XDebug.Error(string.format("data is nil: %d", index))
        end
        obj:SetIconData(data)
    end
    --- @param obj DungeonShopItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        onUpdateItem(obj, index)

        --- @param item MarketItemInBound
        obj.onFinish = function(item)
            self.model.itemList:RemoveByReference(item)
            self.uiScroll:RefreshCells(self.model.itemList:Count())
            self.config.empty:SetActive(self.model.itemList:Count() <= 0)
        end
        obj:AddListener(function()
            PopupUtils.ShowBuyItem(LanguageUtils.LocalizeCommon("want_to_buy"), obj.iconData.cost, function()
                DungeonRequest.BuySmashShop(self.model.sellerId, obj.iconData.id)
            end)
        end)
    end
    self.uiScroll = UILoopScroll(self.config.verticalScrollGrid, UIPoolType.DungeonShopItemView, onCreateItem, onUpdateItem)
    self.uiScroll:SetUpMotion(MotionConfig())
end

--- @return void
function UIDungeonPrimaryMerchantView:_InitMoneyBar()
    self.goldBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.config.goldAnchor)
    self.goldBarView:SetIconData(MoneyType.GOLD)

    self.gemBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.config.gemAnchor)
    self.gemBarView:SetIconData(MoneyType.GEM)
end

--- @return void
function UIDungeonPrimaryMerchantView:_InitButtonListener()
    self.config.bgFog.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)

    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

--- @return void
function UIDungeonPrimaryMerchantView:OnReadyShow(result)
    self.model.sellerId = result.seller
    self.model.itemList = zg.playerData:GetMethod(PlayerDataMethod.DUNGEON).shopDict:Get(self.model.sellerId)
    if self.model.itemList ~= nil then
        self.uiScroll:Resize(self.model.itemList:Count())
        self.uiScroll:PlayMotion()
        self.config.empty:SetActive(self.model.itemList:Count() <= 0)
    else
        self.config.empty:SetActive(true)
    end

    self:_InitMoneyBar()

    self.config.localizeTitle.text = result.tittle
end

--- @return void
function UIDungeonPrimaryMerchantView:OnClickBackOrClose()
    self:OnReadyHide()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
end

--- @return void
function UIDungeonPrimaryMerchantView:Hide()
    UIBaseView.Hide(self)

    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end

    if self.gemBarView ~= nil then
        self.gemBarView:ReturnPool()
        self.gemBarView = nil
    end

    if self.goldBarView ~= nil then
        self.goldBarView:ReturnPool()
        self.goldBarView = nil
    end
end


