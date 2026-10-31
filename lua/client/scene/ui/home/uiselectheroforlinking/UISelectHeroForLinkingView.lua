require "lua.client.core.network.heroLinking.HeroLinkingSaveOutBound"

--- @class UISelectHeroForLinkingView : UIBaseView
UISelectHeroForLinkingView = Class(UISelectHeroForLinkingView, UIBaseView)

--- @return void
--- @param model UISelectHeroForLinkingModel
function UISelectHeroForLinkingView:Ctor(model)
    --- @type ItemsTableView
    self.tableSelfHero = nil
    --- @type ItemsTableView
    self.tableFriendHero = nil
    --- @type function
    self.callbackSelectHero = nil

    --- @type List
    self.listOwnHero = nil
    --- @type List
    self.listFriendHero = nil
    --- @type HeroLinkingInBound
    self.heroLinkingInBound = nil
    --- @type BasicInfoInBound
    self.basicInfoInBound = nil
    --- @type PlayerFriendInBound
    self.playerFriendInBound = nil
    --- @type {isOwnHero : boolean, heroResource : HeroResource, playerName, friendId}
    self.selectData = nil
    --- @type boolean
    self.isSlotEmptyOnShow = nil

    UIBaseView.Ctor(self, model)
    --- @type UISelectHeroForLinkingModel
    self.model = model
end

function UISelectHeroForLinkingView:OnReadyCreate()
    --- @type UISelectHeroForLinkingConfig
    self.config = UIBaseConfig(self.uiTransform)

    self:InitButtonListener()
    self:InitTableSelfHero()
    self:InitTableFriendHero()
end

function UISelectHeroForLinkingView:InitTableSelfHero()
    --- @param playerHeroIconView PlayerHeroIconView
    local onInitItem = function(playerHeroIconView)
        if self:IsEqualSelectData(playerHeroIconView.itemData) then
            playerHeroIconView:ActiveMaskSelect(true)
        end
        playerHeroIconView:AddClickListener(function()
            if ClientConfigUtils.CheckHeroInAncientTree(playerHeroIconView.itemData.heroResource.inventoryId) then
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("hero_in_ancient_tree"))
                zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            else
                self:HandleOnClickItemView(playerHeroIconView, true)
            end
        end)
    end
    self.tableSelfHero = ItemsTableView(self.config.tableSelfHero, onInitItem, UIPoolType.PlayerHeroIconView)
end

function UISelectHeroForLinkingView:InitTableFriendHero()
    --- @param playerHeroIconView PlayerHeroIconView
    local onInitItem = function(playerHeroIconView)
        if self:IsEqualSelectData(playerHeroIconView.itemData) then
            playerHeroIconView:ActiveMaskSelect(true)
        end
        playerHeroIconView:AddClickListener(function()
            self:HandleOnClickItemView(playerHeroIconView, false)
        end)
    end
    self.tableFriendHero = ItemsTableView(self.config.tableFriendHero, onInitItem, UIPoolType.PlayerHeroIconView)
end

--- @param playerHeroIconView PlayerHeroIconView
function UISelectHeroForLinkingView:HandleOnClickItemView(playerHeroIconView, isOwnHero)
    local itemData = playerHeroIconView.itemData
    if self.selectData == nil then
        playerHeroIconView:ActiveMaskSelect(true)
        self.selectData = itemData
        self.selectData.isOwnHero = isOwnHero
    else
        if self:IsEqualSelectData(itemData) then
            self.selectData = nil
            playerHeroIconView:ActiveMaskSelect(false)
        else
            local selectedItemView = self:FindItemViewBySelectData()
            if selectedItemView ~= nil then
                selectedItemView:ActiveMaskSelect(false)
            else
                print(">>> WTF?? ")
            end

            self.selectData = itemData
            playerHeroIconView:ActiveMaskSelect(true)
        end
    end
    if isOwnHero == false then
        local linkingConfig = ResourceMgr.GetHeroLinkingTierConfig()
        --- @type ItemLinkingTierConfig
        local itemLinkingTierConfig = linkingConfig:GetItemLinkingByGroup(self.groupId)
        local friendHeroUse = self.heroLinkingInBound:GetCountListFriendHeroUseInGroup(self.groupId)
        if friendHeroUse == itemLinkingTierConfig.listHero:Count() - 1
                and self.selectData ~= nil
                and itemData.isOwnHero == false
                and self:IsEqualSelectData(self.selectedDataOnShow) == false then
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("require_at_least_one_your_hero_in_linking"))
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            self.selectData = nil
            playerHeroIconView:ActiveMaskSelect(false)
            return
        end
    end
end

--- @return PlayerHeroIconView
function UISelectHeroForLinkingView:FindItemViewBySelectData()
    local listItemsView
    if self.selectData.isOwnHero == true then
        listItemsView = self.tableSelfHero:GetItems()
    else
        listItemsView = self.tableFriendHero:GetItems()
    end
    for i = 1, listItemsView:Count() do
        --- @type PlayerHeroIconView
        local itemView = listItemsView:Get(i)
        if self:IsEqualSelectData(itemView.itemData) then
            return itemView
        end
    end
    return nil
end

--- @param data {heroResource : HeroResource, playerName, isOwnHero : boolean, friendId}
function UISelectHeroForLinkingView:IsEqualSelectData(data)
    if self.selectData == nil or data == nil then
        return false
    end
    return (self.selectData.heroResource.inventoryId == data.heroResource.inventoryId
            and self.selectData.heroResource.heroId == data.heroResource.heroId
            and self.selectData.heroResource.heroStar == data.heroResource.heroStar)
            and self.selectData.isOwnHero == data.isOwnHero
            and self.selectData.friendId == data.friendId
end

function UISelectHeroForLinkingView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("select_hero_for_linking")
    self.config.textEmpty.text = LanguageUtils.LocalizeCommon("empty")
    self.config.textSelect.text = LanguageUtils.LocalizeCommon("select")
    self.config.textFriendSupport.text = LanguageUtils.LocalizeCommon("friend_hero_support")
end

function UISelectHeroForLinkingView:InitButtonListener()
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.selectButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSelect()
    end)
end

--- @param data {groupId, slot, callback}
function UISelectHeroForLinkingView:OnReadyShow(data)
    local closeByNoData = function()
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("no_data"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        self:OnClickBackOrClose()
    end
    self.groupId = data.groupId
    self.slot = data.slot

    local linkingConfig = ResourceMgr.GetHeroLinkingTierConfig()
    self.requireStar, self.requireId = linkingConfig:GetStarIdByGroupSlot(self.groupId, self.slot)
    if self.requireStar == nil or self.requireId == nil then
        closeByNoData()
        XDebug.Error("nil data linking ")
        print(self.requireStar, self.requireId)
        return
    end

    self.heroLinkingInBound = zg.playerData:GetMethod(PlayerDataMethod.HERO_LINKING)
    self.playerFriendInBound = zg.playerData:GetMethod(PlayerDataMethod.FRIEND)

    self.basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    self.playerName = self.basicInfoInBound.name

    self:FindSelectedDataOnShow()

    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    self.callbackSelectHero = data.callback

    self:GetListOwnHero()
    self.tableSelfHero:SetData(self.listOwnHero)

    self:GetListFriendHero()
    self.tableFriendHero:SetData(self.listFriendHero)

    local hasOwnHeroData = self.listOwnHero:Count() > 0
    local hasFriendHeroData = self.listFriendHero:Count() > 0
    self.config.empty:SetActive(not hasOwnHeroData and not hasFriendHeroData)
    self.config.friendSupport:SetActive(hasFriendHeroData)

    Coroutine.start(function()
        self.config.contentSize.enabled = false
        coroutine.yield(nil)
        self.config.contentSize.enabled = true
    end)

    self:InitListener()
end

function UISelectHeroForLinkingView:InitListener()
    self.requestListSupportHeroListener = RxMgr.notificationRequestListSupportHero:Subscribe(RxMgr.CreateFunction(self.ListSupportHeroUpdated))
end

function UISelectHeroForLinkingView:RemoveListener()
    if self.requestListSupportHeroListener ~= nil then
        self.requestListSupportHeroListener:Unsubscribe()
        self.requestListSupportHeroListener = nil
    end
end

function UISelectHeroForLinkingView:ListSupportHeroUpdated()
    self:OnClickBackOrClose()
    SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("data_updated"))
end

function UISelectHeroForLinkingView:FindSelectedDataOnShow()
    ---@type LinkingHeroDataInBound
    local linkingHeroDataInBound = self.heroLinkingInBound:GetLinkingHeroDataByIdAndSlot(self.groupId, self.slot)
    if linkingHeroDataInBound == nil then
        self.selectData = nil
    else
        --- @type {isOwnHero : boolean, heroResource : HeroResource, playerName, friendId}
        self.selectData = {}
        self.selectData.isOwnHero = linkingHeroDataInBound.isOwnHero
        local inventoryId = linkingHeroDataInBound.inventoryId
        local heroId
        local heroStar
        local friendId = linkingHeroDataInBound.friendId
        local playerName = self.playerName
        if self.selectData.isOwnHero == false then
            self.selectData.friendId = friendId
            --- @type FriendData
            local friendData = self.playerFriendInBound:GetFriendDataByFriendId(friendId)
            if friendData ~= nil then
                playerName = friendData.friendName
            else
                playerName = ""
            end

            --- @type List
            local listHeroFriendSupport = self.heroLinkingInBound:GetListHeroFriendSupportByFriendId(friendId)
            for i = 1, listHeroFriendSupport:Count() do
                --- @type SupportHeroData
                local supportHeroData = listHeroFriendSupport:Get(i)
                if supportHeroData.inventoryId == inventoryId then
                    heroId = supportHeroData.heroId
                    heroStar = supportHeroData.star
                    self.selectData.heroResource = HeroResource.CreateInstance(inventoryId, heroId, heroStar)
                    break
                end
            end
        else
            self.selectData.heroResource = InventoryUtils.GetHeroResourceByInventoryId(inventoryId)
        end
    end
    self.selectedDataOnShow = self.selectData
    self.isSlotEmptyOnShow = self.selectData == nil
end

function UISelectHeroForLinkingView:OnClickSelect()
    if self.selectData == nil and self.selectedDataOnShow == nil then
        self:OnClickBackOrClose()
        return
    end

    local outBound = HeroLinkingSaveOutBound(self.groupId)

    local linkingGroupDataInBound = self.heroLinkingInBound:GetLinkingGroupDataInBound(self.groupId)
    --- @param v LinkingHeroDataInBound
    for k, v in pairs(linkingGroupDataInBound.linkingHeroDataDict:GetItems()) do
        local bindingInBound = BindingHeroInBound()
        bindingInBound.inventory = v.inventoryId
        bindingInBound.isOwnHero = v.isOwnHero
        bindingInBound.friendId = v.friendId
        outBound:SetSlot(k, bindingInBound)
    end

    if self.selectData ~= nil then
        local bindingInBound = BindingHeroInBound()
        bindingInBound.inventory = self.selectData.heroResource.inventoryId
        bindingInBound.isOwnHero = self.selectData.isOwnHero
        bindingInBound.friendId = self.selectData.friendId
        outBound:SetSlot(self.slot, bindingInBound)
    else
        outBound:RemoveSlot(self.slot)
    end

    local onReceived = function(result)
        local onSuccess = function()
            linkingGroupDataInBound:OnSaveSuccess(outBound)
            self:OnClickBackOrClose()
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("save_successful"))
            if self.callbackSelectHero ~= nil then
                self.callbackSelectHero()
            end
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.HERO_LINKING_HERO_SAVE, outBound, onReceived)
end

function UISelectHeroForLinkingView:Hide()
    UIBaseView.Hide(self)
    self.tableSelfHero:Hide()
    self.tableFriendHero:Hide()
    self.selectData = nil
    self:RemoveListener()
end

function UISelectHeroForLinkingView:GetListOwnHero()
    self.listOwnHero = List()
    local listAvailableHero = self.heroLinkingInBound:GetListAvailableSelfHeroAtLinkingSlot(self.groupId, self.slot)
    for i = 1, listAvailableHero:Count() do
        --- @type HeroResource
        local heroResource = listAvailableHero:Get(i)
        --- @type {heroResource : HeroResource, playerName, isOwnHero}
        local dataItem = {}
        dataItem.heroResource = heroResource
        dataItem.playerName = self.playerName
        dataItem.isOwnHero = true
        self.listOwnHero:Add(dataItem)
    end
end

function UISelectHeroForLinkingView:GetListFriendHero()
    self.listFriendHero = self.heroLinkingInBound:GetListAvailableFriendHeroSupport(self.groupId, self.slot)
end