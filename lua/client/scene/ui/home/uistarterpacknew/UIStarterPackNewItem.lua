--- @class UIStarterPackNewItem
UIStarterPackNewItem = Class(UIStarterPackNewItem)

--- @param transform UnityEngine_Transform
function UIStarterPackNewItem:Ctor(transform, view)
    --- @type UIStarterPackNewView
    self.parentView = view
    --- @type  ProgressProduct
    self.starterPackProduct = nil
    self.updateTime = nil
    ---@type UIStarterPackNewItemConfig
    self.config = UIBaseConfig(transform)
    ---@type number
    self.limitLine = 4
    ---@type List
    self.listIconData1 = List()
    ---@type List
    self.listIconData2 = List()
    self:InitTableView()
    ---@type boolean
    self.isSelectHeroPack = nil
    ---@type boolean
    self.isSoldOut = false
    --- @type Dictionary
    self.selectItems = Dictionary()

    ---@type List()
    self.effectRewardNotSelected = List()
end

---@return number
---@param pos number
function UIStarterPackNewItem:GetSelectID(pos)
    if (self.starterPackProduct == nil) then
        return nil
    end
    return UIStarterPackNewView.GetItemSelect(self.starterPackProduct.id, pos)
end

function UIStarterPackNewItem:OnSelectHeroSuccess(listId)
    self.selectItems = listId
    self.parentView:SetItemSelect(self.starterPackProduct.id, listId)
end

--- @param v RootIconView
function UIStarterPackNewItem:OnClickItem(listNumber, indexInList, v)
    ---@type boolean
    local isSelectedBtn =  (not self.isSoldOut) and self.isSelectHeroPack and listNumber == 1
    local selectType = indexInList
    if (isSelectedBtn and selectType == 1) then
        local data = {}
        data.packId = self.starterPackProduct.id
        data.callbackClosed = function()
            self.parentView:SetFx(true)
        end
        data.selectedIndex = self:GetSelectID(1)
        data.rewardSelectionList = self.starterPackProduct.rewardSelectionHeroList
        data.selectItems = self.selectItems
        data.onSelectHeroSuccess = function(listId)
            self:OnSelectHeroSuccess(listId)
        end
        self.parentView:SetFx(false)
        PopupMgr.ShowPopup(UIPopupName.UIPreviewStarterPack, data)
    elseif (isSelectedBtn and selectType == 2) then
        self.parentView:SetFx(false)
        local data = {}
        data.packId = self.starterPackProduct.id
        data.selectedIndex = self:GetSelectID(2)
        data.rewardSelectionList = self.starterPackProduct.rewardSelectionItemList
        data.selectItems = self.selectItems
        data.onSelectHeroSuccess = function(listId)
            self:OnSelectHeroSuccess(listId)
        end
        data.callbackClose = function()
            PopupMgr.HidePopup(UIPopupName.UIPreviewStarterPackFragment)
        end
        PopupMgr.ShowPopup(UIPopupName.UIPreviewStarterPackFragment, data)
    else
        v:ShowInfo()
    end
end

function UIStarterPackNewItem:InitTableView()
    --- @param obj RootIconView
    local onInitItem1 = function(obj, index)
        local showPlusNoti = false
        local selectId = self:GetSelectID(index)
        local isSelectHeroItem = self.isSelectHeroPack and (index == 1 or index == 2)
        local notSelect = self.isSelectHeroPack and (selectId == nil or selectId <= 0)
        showPlusNoti = isSelectHeroItem and notSelect
        obj:ActiveUIPool(UIPoolType.Plus, showPlusNoti)
        obj:ActiveUIPool(UIPoolType.Noti, showPlusNoti)
        obj:ActiveUIPool(UIPoolType.Change,
                not self.isSoldOut and isSelectHeroItem and not notSelect, U_Vector2(130, 130))
        local effect = obj:ActiveUIPool(UIPoolType.FXReward, showPlusNoti)
        if (showPlusNoti) then
            self.effectRewardNotSelected:Add(effect)
        end

        -- set icon info
        obj:RemoveAllListeners()
        obj:AddListener(function()
            self:OnClickItem(1, index, obj)
        end)
    end
    local onInitItem2 = function(obj, index)
        obj:RemoveAllListeners()
        -- set icon info
        obj:AddListener(function()
            self:OnClickItem(2, index, obj)
        end)
    end
    ---@type ItemsTableView
    self.itemsTableView1 = ItemsTableView(self.config.rewardAnchor1, onInitItem1, UIPoolType.RootIconView)
    self.itemsTableView2 = ItemsTableView(self.config.rewardAnchor2, onInitItem2, UIPoolType.RootIconView)
end

--- @param starterPackProduct ProgressProduct
function UIStarterPackNewItem:InitConfig(starterPackProduct)
    self.starterPackProduct = starterPackProduct
    self.isSelectHeroPack = self.starterPackProduct.is_selection_pack
    self.selectItems = Dictionary()

    if (self.isSelectHeroPack) then
        for i = 1, 2 do
            local value = self:GetSelectID(i)
            if value == nil or value <= 0 then
                value = -1
            end
            self.selectItems:Add(i, value)
        end
    end

    ---@type RewardInBound
    local rewardInBound
    ---@type number
    local count = 0
    --- @type ItemIconData
    local iconDataSelect
    self.listIconData1 = List()
    self.listIconData2 = List()

    if (self.isSelectHeroPack) then
        for i = 1, 2 do
            if (i == 1 and self.selectItems:Get(i) > 0) then
                rewardInBound = self.starterPackProduct.rewardSelectionHeroDict:Get(
                        self.selectItems:Get(i)
                ).rewardInBound
                ---@type ItemIconData
                iconDataSelect = rewardInBound:GetIconData()
            elseif (i == 2 and self.selectItems:Get(i) > 0) then
                rewardInBound = self.starterPackProduct.rewardSelectionItemDict:Get(
                        self.selectItems:Get(i)
                ).rewardInBound
                ---@type ItemIconData
                iconDataSelect = rewardInBound:GetIconData()
            else
                iconDataSelect = ItemIconData()
                iconDataSelect:SetData(ResourceType.Money, MoneyType.STARTER_PACK_NONE)
            end
            self.listIconData1:Add(iconDataSelect)
            count = count + 1
        end
    end
    local listIconData = RewardInBound.GetItemIconDataList(self.starterPackProduct:GetRewardList())
    self.config.rewardAnchor2.gameObject:SetActive(true)
    for i = 1, listIconData:Count() do
        --- @type ItemIconData
        local iconDataTemp = listIconData:Get(i)
        count = count + 1
        if (count <= self.limitLine) then
            self.listIconData1:Add(iconDataTemp)
        else
            self.listIconData2:Add(iconDataTemp)
        end
    end
    self.itemsTableView1:SetData(self.listIconData1)
    if (self.listIconData2:Count() > 0) then
        self.itemsTableView2:SetData(self.listIconData2)
    else
        self.config.rewardAnchor2.gameObject:SetActive(false)
    end

    if (self.config.highlight ~= nil) then
        local chooseHero = not self:NotChooseHero()
        self.config.highlight.gameObject:SetActive(chooseHero)
    end
end

function UIStarterPackNewItem:ShowLayout(packName, packDesc, price, buyCount)
    self.config.packName.text = packName or ""
    self.price = price
    self:ShowBuyState(buyCount)
end

function UIStarterPackNewItem:ShowBuyState(buyCount)
    self.config.coverBuy.gameObject:SetActive(buyCount >= self.starterPackProduct.stock)
    local color = UIUtils.green_light
    if buyCount >= self.starterPackProduct.stock then
        color = UIUtils.red_light
        self.isSoldOut = true
        self.config.textPrice.text = LanguageUtils.LocalizeCommon("sold_out")
    else
        self.config.textPrice.text = self.price
        self.isSoldOut = false
    end
    self.config.textBuyState.text =
    string.format(LanguageUtils.LocalizeCommon("limit_x"),
            UIUtils.SetColorString(color, string.format("(%s/%s)",  self.starterPackProduct.stock - buyCount, self.starterPackProduct.stock)))
end

function UIStarterPackNewItem:Hide()
    if self.itemsTableView1 ~= nil then
        self.itemsTableView1:Hide()
    end
    if self.itemsTableView2 ~= nil then
        self.itemsTableView1:Hide()
    end
end

function UIStarterPackNewItem:NotChooseHero()
    local val = self:GetSelectID(1)
    return self.isSelectHeroPack and (val == nil or val <= 0)
end
function UIStarterPackNewItem:NotChooseItem()
    local val = self:GetSelectID(2)
    return self.isSelectHeroPack and (val == nil or val <= 0)
end

--- @param listener function
function UIStarterPackNewItem:AddOnClickBuyListener(listener)
    self.config.buttonBuy.onClick:RemoveAllListeners()
    self.config.buttonBuy.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if (self.isSelectHeroPack) then
            if (self.effectRewardNotSelected ~= nil) and self:NotChooseItem() and self:NotChooseHero() then
                for i = 1, self.effectRewardNotSelected:Count() do
                    local fx = self.effectRewardNotSelected:Get(i)
                    fx:GetComponentInChildren(ComponentName.UnityEngine_ParticleSystem):Play()
                end
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("starter_pack_choose_hero_noti"))
                return
            end
        end
        if (self.isSoldOut) then
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("starter_pack_sold_out"))
            return
        end
        if listener ~= nil then
            listener()
        end
    end)
end