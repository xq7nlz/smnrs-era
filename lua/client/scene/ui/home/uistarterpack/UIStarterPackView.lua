require "lua.client.scene.ui.home.uiStarterPack.UIStarterPackItem"

--- @class UIStarterPackView : UIBaseView
UIStarterPackView = Class(UIStarterPackView, UIBaseView)

--- @param model UIStarterPackModel
function UIStarterPackView:Ctor(model)
    --- @type UIStarterPackConfig
    self.config = nil
    --- @type Dictionary
    self.packItemDict = Dictionary()
    --- @type IapDataInBound
    self.iapDataInBound = nil
    --- @type GroupProductConfig
    self.groupProductConfig = nil
    --- @type List
    self.listOfProducts = nil
    UIBaseView.Ctor(self, model)
    --- @type UIStarterPackModel
    self.model = model
end

function UIStarterPackView:OnReadyCreate()
    ---@type UIStarterPackConfig
    self.config = UIBaseConfig(self.uiTransform)
    self:InitButtonListener()
    self:InitUpdateTime()
end

function UIStarterPackView:InitButtonListener()
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

function UIStarterPackView:InitLocalization()
    self.config.textTapToClose.gameObject:SetActive(false)
    self.config.localizeTitle.text = LanguageUtils.LocalizeCommon("starter_pack")
end

function UIStarterPackView:InitUpdateTime()
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            local createdTime = self.progressPackCollection.activeProgressPackDict:Get(self.groupId)
            if createdTime ~= nil then
                self.timeRefresh = createdTime + self.groupProductConfig.duration - zg.timeMgr:GetServerTime()
            else
                self:OnTimeEnd()
                return
            end
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        self.config.packTimer.text = string.format("%s %s",
                LanguageUtils.LocalizeCommon("will_end_in"),
                UIUtils.SetColorString(UIUtils.color7, TimeUtils.GetDeltaTime(self.timeRefresh)))
        if self.timeRefresh < 0 then
            self:OnTimeEnd()
        end
    end
end

--- @return void
function UIStarterPackView:OnClickBackOrClose()
    UIBaseView.OnClickBackOrClose(self)

    --zg.playerData.remoteConfig.showedStarterPackCreatedTime = self.progressPackCollection.activeProgressPackDict:Get(self.groupId)
    zg.playerData.remoteConfig.showedStarterPackLoginTime = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).lastLoginTime
    zg.playerData:SaveRemoteConfig()
end

--- @param data {callbackClose : function}
function UIStarterPackView:OnReadyShow(data)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    UIBaseView.OnReadyShow(self, data)

    self:GetRefs()
    if self.groupProductConfig == nil then
        self:OnReadyHide()
        return
    end
    self:InitPackItemView()
    self:ShowStarterPacksInfo()

    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIStarterPackView:GetRefs()
    self.iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    --- @type ProgressPackCollection
    self.progressPackCollection = self.iapDataInBound.progressPackData
    local listActiveGroupProductConfig = self.progressPackCollection:GetListActiveGroupByViewType(PackViewType.STARTER_PACK)
    --- @type GroupProductConfig
    self.groupProductConfig = listActiveGroupProductConfig:Get(1)
    self.groupId = self.groupProductConfig.groupId

    --- @type List
    local listProductInGroup = self.groupProductConfig:GetListProductConfig()
    --- @type ProductConfig
    local firstPack = listProductInGroup:Get(1)
    ---@type ProgressProduct
    self.csv = ResourceMgr.GetPurchaseConfig():GetCashShop():GetPackById(OpCode.PURCHASE_PROGRESS_PACK, firstPack.id)
end

function UIStarterPackView:InitPackItemView()
    local listOfProducts = self.groupProductConfig:GetListProductConfig()
    for i = 1, listOfProducts:Count() do
        --- @type ProductConfig
        local starterPackProduct = listOfProducts:Get(i)
        local id = starterPackProduct.id
        --- @type UIStarterPackItem
        local uiStarterPackItem = self.packItemDict:Get(id)
        if uiStarterPackItem == nil then
            local trans = self.config.transform:Find("popup/starter_pack_" .. i)
            if trans ~= nil then
                uiStarterPackItem = UIStarterPackItem(trans)
                self.packItemDict:Add(id, uiStarterPackItem)
            else
                XDebug.Error("There is no ui for starter pack id " .. i)
                return
            end
        end
        uiStarterPackItem:InitConfig(starterPackProduct)
        uiStarterPackItem:AddOnClickBuyListener(function()
            self:OnClickBuyPack(id)
        end)
    end
end

function UIStarterPackView:ShowStarterPacksInfo()
    --- @param v UIStarterPackItem
    for k, v in pairs(self.packItemDict:GetItems()) do
        local packName, packDesc, iconFaction, price = self:GetPackLayoutInfo(k)
        v:ShowLayout(packName, packDesc, iconFaction, price, self.progressPackCollection:GetBoughtCount(k))
    end
end

function UIStarterPackView:GetPackLayoutInfo(packId)
    local packName
    local packDesc
    local iconFaction
    local price = zg.iapMgr:GetLocalPrizeString(ClientConfigUtils.GetPurchaseKey(OpCode.PURCHASE_PROGRESS_PACK, packId))
    --- @type ProductConfig
    local starterPackProduct = self.groupProductConfig:FindProductConfigByPackId(packId)
    if packId == 1 then
        packName = LanguageUtils.LocalizeCommon("starter_pack_name_1")
    else
        packDesc = LanguageUtils.LocalizeCommon("starter_pack_desc_" .. packId)
        local listItemReward = starterPackProduct:GetRewardList()
        --- @type RewardInBound
        local heroReward = listItemReward:Get(1)
        local heroId = ClientConfigUtils.GetHeroIdByFragmentHeroId(heroReward.id)
        packName = LanguageUtils.LocalizeNameHero(heroId)
        local factionId = ClientConfigUtils.GetFactionIdByHeroId(heroId)
        iconFaction = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconFactions, factionId)
    end
    return packName, packDesc, iconFaction, price
end

function UIStarterPackView:Hide()
    UIBaseView.Hide(self)
    --- @param v UIStarterPackItem
    for _, v in pairs(self.packItemDict:GetItems()) do
        v:Hide()
    end
    self:RemoveUpdateTime()
end

function UIStarterPackView:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

--- @param packId number
function UIStarterPackView:OnClickBuyPack(packId)
    local buyCount = self.progressPackCollection:GetBoughtCount(packId)
    --- @type ProductConfig
    local productConfig = self.groupProductConfig:FindProductConfigByPackId(packId)
    if productConfig == nil then
        XDebug.Error("StarterPack product config not found " .. packId)
        return
    end
    if buyCount >= productConfig.stock then
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.LogicCodeNotification(LogicCode.PURCHASE_PACK_SOLD_OUT)
    else
        BuyUtils.InitListener(function()
            --- @type UIStarterPackItem
            local itemView = self.packItemDict:Get(packId)
            itemView:ShowBuyState(buyCount + 1)
            self:CheckGroupStillActive()
            RxMgr.notificationPurchasePacks:Next()
        end, function(logicCode)
            XDebug.Error("Error logic code " .. logicCode)
        end)
        RxMgr.purchaseProduct:Next(ClientConfigUtils.GetPurchaseKey(OpCode.PURCHASE_PROGRESS_PACK, packId))
    end
end

function UIStarterPackView:OnTimeEnd()
    self:RemoveUpdateTime()
    self.iapDataInBound.progressPackData.activeProgressPackDict:RemoveByKey(self.groupId)
    RxMgr.notificationPurchasePacks:Next()
    self:OnReadyHide()
    SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
end

function UIStarterPackView:CheckGroupStillActive()
    local listProductConfig = self.groupProductConfig.listProductConfig
    local availablePack = listProductConfig:Count()
    for i = availablePack, 1, -1 do
        --- @type ProductConfig
        local productConfig = listProductConfig:Get(i)
        local boughtCount = self.progressPackCollection:GetBoughtCount(productConfig.id)
        if boughtCount >= productConfig.stock then
            availablePack = availablePack - 1
        end
    end
    if availablePack == 0 then
        self.iapDataInBound.progressPackData.activeProgressPackDict:RemoveByKey(self.groupId)
    end
end