---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiHeroMenu.uiHeroReset.UIHeroResetConfig"
require "lua.client.core.network.altar.AltarDisassembleHeroOutBound"
require "lua.client.core.network.altar.AltarDisassembleHeroInBound"

--- @class UIHeroReset
UIHeroReset = Class(UIHeroReset)

--- @return void
--- @param transform UnityEngine_Transform
--- @param heroMenuView UIHeroMenuView
function UIHeroReset:Ctor(transform, model, heroMenuView)
    --- @type UIHeroMenuModel
    self.model = model
    --- @type UIHeroMenuView
    self.heroMenuView = heroMenuView
    ---@type UIHeroResetConfig
    ---@type UIHeroResetConfig
    self.config = UIBaseConfig(transform)
    --- @type List --<ItemIconData>
    self.resourceList = List()

    self.config.buttonReset.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickReset()
    end)

    ---@type HeroResetConfig
    self.heroResetConfig = ResourceMgr.GetHeroResetConfig()
    self.config.priceReset.text = self.heroResetConfig.moneyValue

    --- @param obj IconView
    --- @param index number
    local onCreateItem = function(obj, index)
        local data = self.resourceList:Get(index + 1)
        --XDebug.Log(LogUtils.ToDetail(data))
        obj:SetIconData(data)
        obj:RegisterShowInfo()
    end

    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.RootIconView, onCreateItem)

    self:InitLocalization()
end

--- @return void
function UIHeroReset:InitLocalization()
    self.config.localizeReset.text = LanguageUtils.LocalizeCommon("reset")
    self.config.localizeNotiReset.text = LanguageUtils.LocalizeCommon("notice_reset_hero")
end

--- @return void
function UIHeroReset:Show()
    self.resourceList = self.heroMenuView.model.heroResource:GetResourceReset()
    self.uiScroll.scroll.enabled = true
    self.uiScroll:Resize(self.resourceList:Count())
    Coroutine.start(function()
        coroutine.waitforendofframe()
        coroutine.waitforendofframe()
        if self.resourceList:Count() <= 10 then
            self.uiScroll.scroll.enabled = false
        end
    end)
end

--- @return void
function UIHeroReset:Hide()
    self.uiScroll:Hide()
end

--- @return void
function UIHeroReset:OnClickReset()
    if InventoryUtils.GetMoney(self.heroResetConfig.moneyType) >= self.heroResetConfig.moneyValue then
        local reset = function()
            local listHeroInventoryId = List()
            listHeroInventoryId:Add(self.heroMenuView.model.heroResource.inventoryId)

            ---@type AltarDisassembleHeroInBound
            local altarDisassembleHeroInBound

            --- @param buffer UnifiedNetwork_ByteBuf
            local onBufferReading = function(buffer)
                altarDisassembleHeroInBound = AltarDisassembleHeroInBound(buffer)
            end

            local callbackSuccess = function()
                InventoryUtils.Sub(ResourceType.Money, self.heroResetConfig.moneyType, self.heroResetConfig.moneyValue)
                ---@type List
                local listResource = self.heroMenuView.model.heroResource:GetResourceReset()
                ---@param v ItemIconData
                for _, v in pairs(listResource:GetItems()) do
                    v:AddToInventory()
                end
                self.heroMenuView.model.heroResource.heroLevel = 1
                self.heroMenuView.model.heroResource.heroItem:Clear()
                PopupUtils.ShowRewardList(listResource)
                self.heroMenuView:OnClickHeroInfo()
                self.heroMenuView:ChangeStatHero()
            end
            NetworkUtils.RequestAndCallback(OpCode.ALTAR_HERO_RESET, AltarDisassembleHeroOutBound(listHeroInventoryId),
                    callbackSuccess, SmartPoolUtils.LogicCodeNotification, onBufferReading)
        end
        PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("are_you_sure"),nil, reset)
    else
        SmartPoolUtils.NotiLackResource(self.heroResetConfig.moneyType)
    end
end