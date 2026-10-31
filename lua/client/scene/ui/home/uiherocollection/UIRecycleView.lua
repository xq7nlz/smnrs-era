require "lua.client.scene.ui.common.heroList.HeroListView4"
require "lua.client.core.network.hero.HeroRecycleOutBound"

local HERO_FOOD_ID_DELTA = 10000

--- @class UIRecycleView
UIRecycleView = Class(UIRecycleView)

local MAX_ITEM_SELECT = 16

--- @param view UIHeroCollectionView
function UIRecycleView:Ctor(uiTransform, view)
    ---@type UIHeroCollectionView
    self.view = view
    self.listMoney = List()
    ---@type HeroResource
    self.heroResource = nil
    ---@type HeroIconView
    self.heroIconView = nil
    ---@type MoneyIconView
    self.moneyView = nil
    --- @type List
    self.listOfSelectedItem = List()
    ---@type List  --<SlotHeroIconView>
    self.listSlotHero = List()
    --- @type List
    self.listHeroUnselected = List()
    --- @type List
    self.listHero = List()
    --- @type List
    self.heroInUseList = List()
    --- @type List
    self.listFoodInUseList = List()
    --- @type List
    self.listHeroInventoryId = List()
    --- @type Dictionary
    self.listHeroResource = Dictionary()
    --- @type List
    self.listFoodId = List()
    --- @type List
    self.listCheckStarHero = List()
    --- @type List
    self.listMoneyBar = List()
    --- @type List
    self.listHeroResourceSelected = List()
    --- @type Dictionary
    self.listNumberOrbInbound = Dictionary()
    ---@type UIRecycleConfig
    self.config = UIBaseConfig(uiTransform)

    self.config.buttonAsk.onClick:AddListener(function()
        self:OnClickHelp()
    end)
    self.config.buttonAutoSelect.onClick:AddListener(function()
        self:OnClickAutoSelect()
    end)
    self.config.buttonRecycle.onClick:AddListener(function()
        self:OnClickRecycle()
    end)
    self:InitScroll()
end

function UIRecycleView:InitLocalization()
    self.config.textAutoSelect.text = LanguageUtils.LocalizeCommon("auto_select")
    self.config.textRecycle.text = LanguageUtils.LocalizeCommon("recycle")
    self.config.textAcquiredItems.text = LanguageUtils.LocalizeCommon("acquired_items")
end

function UIRecycleView:Show()
    self.config.gameObject:SetActive(true)
    self.config.bgMoney.gameObject:SetActive(self.listNumberOrbInbound:Count() > 0)
    self:ResetData()
    self:UpdateView()
end

function UIRecycleView:UpdateView()
    if self.listSlotHero:Count() == 0 then
        for i = 1, MAX_ITEM_SELECT do
            ---@type SlotHeroIconView
            local slotHeroIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.SlotHeroIconView2, self.config.recycleSelectedItem)
            slotHeroIconView:AddListener(function()
                if slotHeroIconView.heroResource ~= nil then
                    local id
                    if slotHeroIconView.heroResource.inventoryId ~= nil then
                        id = slotHeroIconView.heroResource.inventoryId
                        self.listHeroInventoryId:RemoveOneByReference(id)
                        self.listCheckStarHero:RemoveOneByReference(slotHeroIconView.heroResource)
                    else
                        id = slotHeroIconView.heroResource.id
                        self.listFoodId:RemoveOneByReference(slotHeroIconView.heroResource.heroFoodType * HERO_FOOD_ID_DELTA + slotHeroIconView.heroResource.star)
                    end
                    self.listHeroResourceSelected:RemoveByReference(slotHeroIconView.heroResource)
                    self.listOfSelectedItem:RemoveOneByReference(slotHeroIconView.heroResource)
                    self.listHeroUnselected:Add(slotHeroIconView.heroResource)
                    self:UpdateSlot()
                    self:ShowAcquiredItems()
                    self.uiScroll:RefreshCells()
                end
            end)
            self.listSlotHero:Add(slotHeroIconView)
        end
    end

    self:UpdateSlot()
    self:ShowHeroList()
end

function UIRecycleView:InitScroll()
    --- @return boolean
    --- @param heroIndex number
    ---@param heroResource HeroResource
    self.filterConditionAnd = function(heroIndex, heroResource)
        return heroResource.heroStar <= 5
    end

    ---- Scroll Hero
    --- @param buttonHero HeroIconView
    local onUpdateIconHero = function(heroIndex, buttonHero, heroResource)
        if self.listOfSelectedItem:IsContainValue(heroResource) or self.listOfSelectedItem:IsContainValue(heroResource) then
            buttonHero:ActiveMaskSelect(true, UIUtils.sizeItem)
        else
            buttonHero:ActiveMaskSelect(false)
        end
        if ClientConfigUtils.CheckLockHero(heroResource) then
            buttonHero:ActiveMaskLock(true, UIUtils.sizeItem)
        else
            buttonHero:ActiveMaskLock(false)
        end
    end

    --- @param obj HeroIconView
    --- @param index number
    local onCreateItem = function(obj, index)
        --- @type number
        local data = self.listHero:Get(index + 1)
        ---@type HeroResource
        --local heroResource = self.listHero:Get(heroIndex)
        if data.heroFoodType ~= nil then
            obj:SetIconData(ItemIconData.CreateBuyHeroFood(data.heroFoodType, data.star))
            obj:SetSizeHeroView()
            obj:AddListener(function()
                self:ClickItem(data, obj)
                onUpdateIconHero(nil, obj, data)
            end)
            obj:SetSizeHeroView()
            onUpdateIconHero(nil, obj, data)
        else
            if data then
                obj:SetIconData(HeroIconData.CreateByHeroResource(data))
                if self.showClass then
                    obj:ShowClassHero()
                end
                obj:AddListener(function()
                    local noti = ClientConfigUtils.GetNotiLockHero(data)
                    if noti ~= nil then
                        SmartPoolUtils.ShowShortNotification(noti)
                    else
                        self:ClickItem(data, obj)
                        onUpdateIconHero(nil, obj, data)
                    end
                end)
                onUpdateIconHero(nil, obj, data)
            end
        end
    end

    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.HeroIconView, onCreateItem, onCreateItem)
    self.uiScroll:SetUpMotion(MotionConfig(nil, nil, nil, 0.02, 3))
end

--- @return void
function UIRecycleView:UpdateSlot()
    for i = 1, self.listSlotHero:Count() do
        ---@type SlotHeroIconView
        local slotHeroIconView = self.listSlotHero:Get(i)
        if slotHeroIconView.heroResource ~= nil then
            local id
            local isShowClass
            if slotHeroIconView.heroResource.inventoryId ~= nil then
                id = slotHeroIconView.heroResource.inventoryId
                isShowClass = true
            else
                id = slotHeroIconView.heroResource.id
                isShowClass = false
            end
            if self.listOfSelectedItem:IsContainValue(slotHeroIconView.heroResource) then
                slotHeroIconView:ShowHeroIconView(slotHeroIconView.heroResource, isShowClass)
            else
                slotHeroIconView:DeSpawnHeroIconView()
            end
        end
    end
end

function UIRecycleView:OnClickRecycle()
    ---@type HeroRecycleOutBound
    local heroRecycleOutBound = HeroRecycleOutBound()
    heroRecycleOutBound.listHeroInventory = self.listHeroInventoryId
    heroRecycleOutBound.listFoodId = self.listFoodId

    if heroRecycleOutBound.listHeroInventory:Count() == 0 and heroRecycleOutBound.listFoodId:Count() == 0 then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("nothing_to_recycle"))
        return
    end

    local callback = function(result)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            ---@type List
            self.rewardItems = NetworkUtils.GetRewardInBoundList(buffer)
        end
        local onSuccess = function()
            if self.rewardItems ~= nil then
                PopupUtils.ClaimAndShowRewardList(self.rewardItems)
                for i = 1, self.listHeroInventoryId:Count() do
                    local id = self.listHeroInventoryId:Get(i)
                    for k, v in pairs(self.listHeroResource:GetItems()) do
                        if id == k then
                            InventoryUtils.Sub(ResourceType.Hero, v)
                        end
                    end
                end

                for _, v in pairs(self.listFoodInUseList:GetItems()) do
                    ---@param v HeroFood
                    for _, v1 in pairs(self.listOfSelectedItem:GetItems()) do
                        if v == v1 then
                            zg.playerData:GetMethod(PlayerDataMethod.HERO_EVOLVE_FOOD):SubHeroFood(v.heroFoodType, v.star, v.number)
                        end
                    end
                end
            end
            self:ResetData()
            self:UpdateView()
            self:ShowAcquiredItems()
            self.view:UpdateNotiRecycle()
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    for i = 1, self.listCheckStarHero:Count() do
        local hero = self.listCheckStarHero:Get(i)
        local heroTier = ResourceMgr.GetHeroesConfig():GetHeroTier():GetHeroTier(hero.heroId)
        if hero.heroStar >= 5 and heroTier >= 6 then
            PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("recycle_four_star_hero"), nil, function()
                NetworkUtils.Request(OpCode.HERO_RECYCLE, heroRecycleOutBound, callback)
            end)
            return
        end
    end
    NetworkUtils.Request(OpCode.HERO_RECYCLE, heroRecycleOutBound, callback)
end

function UIRecycleView:ShowAcquiredItems()
    self:HideIconData()

    local numberWaterOrbInbound = 0
    local numberFireOrbInbound = 0
    local numberAbyssOrbInbound = 0
    local numberNatureOrbInbound = 0
    local numberDarkOrbInbound = 0
    local numberLightOrbInbound = 0
    local numberSunOrbInbound = 0
    local numberMoonOrbInbound = 0

    self.listNumberOrbInbound = Dictionary()
    for i = 1, self.listHeroResourceSelected:Count() do
        local hero = self.listHeroResourceSelected:Get(i)
        if hero.heroId ~= nil then
            local factionType = ClientConfigUtils.GetFactionIdByHeroId(hero.heroId)
            if factionType == HeroFactionType.WATER then
                numberWaterOrbInbound = numberWaterOrbInbound + ResourceMgr.GetHeroMenuConfig():GetOrbNumberByStarConfigByPath(hero.heroStar)
                self.listNumberOrbInbound:Add(MoneyType.WATER_ORB, numberWaterOrbInbound)
            elseif factionType == HeroFactionType.FIRE then
                numberFireOrbInbound = numberFireOrbInbound + ResourceMgr.GetHeroMenuConfig():GetOrbNumberByStarConfigByPath(hero.heroStar)
                self.listNumberOrbInbound:Add(MoneyType.FIRE_ORB, numberFireOrbInbound)
            elseif factionType == HeroFactionType.ABYSS then
                numberAbyssOrbInbound = numberAbyssOrbInbound + ResourceMgr.GetHeroMenuConfig():GetOrbNumberByStarConfigByPath(hero.heroStar)
                self.listNumberOrbInbound:Add(MoneyType.ABYSS_ORB, numberAbyssOrbInbound)
            elseif factionType == HeroFactionType.NATURE then
                numberNatureOrbInbound = numberNatureOrbInbound + ResourceMgr.GetHeroMenuConfig():GetOrbNumberByStarConfigByPath(hero.heroStar)
                self.listNumberOrbInbound:Add(MoneyType.NATURE_ORB, numberNatureOrbInbound)
            elseif factionType == HeroFactionType.LIGHT then
                numberLightOrbInbound = numberLightOrbInbound + ResourceMgr.GetHeroMenuConfig():GetOrbNumberByStarConfigByPath(hero.heroStar)
                self.listNumberOrbInbound:Add(MoneyType.LIGHT_ORB,numberLightOrbInbound)
            elseif factionType == HeroFactionType.DARK then
                numberDarkOrbInbound = numberDarkOrbInbound + ResourceMgr.GetHeroMenuConfig():GetOrbNumberByStarConfigByPath(hero.heroStar)
                self.listNumberOrbInbound:Add(MoneyType.DARK_ORB, numberDarkOrbInbound)
            end
        else
            local heroFoodType = hero.heroFoodType
            if heroFoodType == HeroFoodType.WATER then
                numberWaterOrbInbound = numberWaterOrbInbound + ResourceMgr.GetHeroMenuConfig():GetOrbNumberByStarConfigByPath(hero.star)
                self.listNumberOrbInbound:Add(MoneyType.WATER_ORB, numberWaterOrbInbound)
            elseif heroFoodType == HeroFoodType.FIRE then
                numberFireOrbInbound = numberFireOrbInbound + ResourceMgr.GetHeroMenuConfig():GetOrbNumberByStarConfigByPath(hero.star)
                self.listNumberOrbInbound:Add(MoneyType.FIRE_ORB, numberFireOrbInbound)
            elseif heroFoodType == HeroFoodType.ABYSS then
                numberAbyssOrbInbound = numberAbyssOrbInbound + ResourceMgr.GetHeroMenuConfig():GetOrbNumberByStarConfigByPath(hero.star)
                self.listNumberOrbInbound:Add(MoneyType.ABYSS_ORB, numberAbyssOrbInbound)
            elseif heroFoodType == HeroFoodType.NATURE then
                numberNatureOrbInbound = numberNatureOrbInbound + ResourceMgr.GetHeroMenuConfig():GetOrbNumberByStarConfigByPath(hero.star)
                self.listNumberOrbInbound:Add(MoneyType.NATURE_ORB, numberNatureOrbInbound)
            elseif heroFoodType == HeroFoodType.LIGHT then
                numberLightOrbInbound = numberLightOrbInbound + ResourceMgr.GetHeroMenuConfig():GetOrbNumberByStarConfigByPath(hero.star)
                self.listNumberOrbInbound:Add(MoneyType.LIGHT_ORB,numberLightOrbInbound)
            elseif heroFoodType == HeroFoodType.DARK then
                numberDarkOrbInbound = numberDarkOrbInbound + ResourceMgr.GetHeroMenuConfig():GetOrbNumberByStarConfigByPath(hero.star)
                self.listNumberOrbInbound:Add(MoneyType.DARK_ORB, numberDarkOrbInbound)
            elseif heroFoodType == HeroFoodType.SUN then
                numberSunOrbInbound = numberSunOrbInbound + ResourceMgr.GetHeroMenuConfig():GetOrbNumberByStarConfigByPath(hero.star)
                self.listNumberOrbInbound:Add(MoneyType.SUN_ORB, numberSunOrbInbound)
            elseif heroFoodType == HeroFoodType.MOON then
                numberMoonOrbInbound = numberMoonOrbInbound + ResourceMgr.GetHeroMenuConfig():GetOrbNumberByStarConfigByPath(hero.star)
                self.listNumberOrbInbound:Add(MoneyType.MOON_ORB, numberMoonOrbInbound)
            end
        end
    end

    for k, v in pairs(self.listNumberOrbInbound:GetItems()) do
        if v > 0 then
            self:SetIconData(k, v)
        end
    end

    self.config.bgMoney.gameObject:SetActive(self.listNumberOrbInbound:Count() > 0)
end

---@param obj MoneyType
function UIRecycleView:SetIconData(moneyType, value)
    if moneyType == MoneyType.WATER_ORB then
        self.config.waterInfo.gameObject:SetActive(true)
        self.config.waterText.text = ClientConfigUtils.FormatNumber(value)
        self.config.waterButton.onClick:AddListener(function()
            self:ShowInfoIconData(moneyType)
        end)
    elseif moneyType == MoneyType.FIRE_ORB then
        self.config.fireInfo.gameObject:SetActive(true)
        self.config.fireText.text = ClientConfigUtils.FormatNumber(value)
        self.config.fireButton.onClick:AddListener(function()
            self:ShowInfoIconData(moneyType)
        end)
    elseif moneyType == MoneyType.ABYSS_ORB then
        self.config.abyssInfo.gameObject:SetActive(true)
        self.config.abyssText.text = ClientConfigUtils.FormatNumber(value)
        self.config.abyssButton.onClick:AddListener(function()
            self:ShowInfoIconData(moneyType)
        end)
    elseif moneyType == MoneyType.NATURE_ORB then
        self.config.natureInfo.gameObject:SetActive(true)
        self.config.natureText.text = ClientConfigUtils.FormatNumber(value)
        self.config.natureButton.onClick:AddListener(function()
            self:ShowInfoIconData(moneyType)
        end)
    elseif moneyType == MoneyType.LIGHT_ORB then
        self.config.lightInfo.gameObject:SetActive(true)
        self.config.lightText.text = ClientConfigUtils.FormatNumber(value)
        self.config.lightButton.onClick:AddListener(function()
            self:ShowInfoIconData(moneyType)
        end)
    elseif moneyType == MoneyType.DARK_ORB then
        self.config.darkInfo.gameObject:SetActive(true)
        self.config.darkText.text = ClientConfigUtils.FormatNumber(value)
        self.config.darkButton.onClick:AddListener(function()
            self:ShowInfoIconData(moneyType)
        end)
    elseif moneyType == MoneyType.SUN_ORB then
        self.config.sunInfo.gameObject:SetActive(true)
        self.config.sunText.text = ClientConfigUtils.FormatNumber(value)
        self.config.sunButton.onClick:AddListener(function()
            self:ShowInfoIconData(moneyType)
        end)
    elseif moneyType == MoneyType.MOON_ORB then
        self.config.moonInfo.gameObject:SetActive(true)
        self.config.moonText.text = ClientConfigUtils.FormatNumber(value)
        self.config.moonButton.onClick:AddListener(function()
            self:ShowInfoIconData(moneyType)
        end)
    end
end

function UIRecycleView:ShowInfoIconData(moneyType)
    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = {["type"] = ResourceType.Money, ["id"] = moneyType}})
end

function UIRecycleView:HideIconData()
    self.config.waterInfo.gameObject:SetActive(false)
    self.config.fireInfo.gameObject:SetActive(false)
    self.config.abyssInfo.gameObject:SetActive(false)
    self.config.natureInfo.gameObject:SetActive(false)
    self.config.lightInfo.gameObject:SetActive(false)
    self.config.darkInfo.gameObject:SetActive(false)
    self.config.sunInfo.gameObject:SetActive(false)
    self.config.moonInfo.gameObject:SetActive(false)
end


---@param obj HeroIconView
function UIRecycleView:ClickItem(data, obj)
    if self.listOfSelectedItem:IsContainValue(data) then
        -- Deselect
        self:SelectItem(data, false, obj)
    elseif self.listOfSelectedItem:Count() < MAX_ITEM_SELECT then
        -- Select
        self:SelectItem(data, true, obj)
    else
        -- Reach max
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("have_max_items_recycle"))
    end
end

---@param obj HeroIconView
function UIRecycleView:SelectItem(data, isSelect, obj)
    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)

    if isSelect then
        if data.inventoryId ~= nil then
            self.listHeroInventoryId:Add(data.inventoryId)
            self.listCheckStarHero:Add(data)
        else
            self.listFoodId:Add(data.heroFoodType * HERO_FOOD_ID_DELTA + data.star)
        end
        self.listHeroResourceSelected:Add(data)
        self.listOfSelectedItem:Add(data)
        self.listHeroUnselected:RemoveOneByReference(data)
        self:_AddHeroResource(data)
        obj:ActiveMaskSelect(true)
    else
        if data.inventoryId ~= nil then
            self.listHeroInventoryId:RemoveOneByReference(data.inventoryId)
            self.listCheckStarHero:RemoveOneByReference(data)
        else
            self.listFoodId:RemoveOneByReference(data.heroFoodType * HERO_FOOD_ID_DELTA + data.star)
        end
        self.listHeroResourceSelected:RemoveOneByReference(data)
        self.listOfSelectedItem:RemoveOneByReference(data)
        self.listHeroUnselected:Add(data)
        self:_RemoveHeroResource(data)
        obj:ActiveMaskSelect(false)
    end
    self:ShowAcquiredItems()
end

--- @return void
---@param heroResource HeroResource
function UIRecycleView:_AddHeroResource(heroResource)
    ---@param v SlotHeroIconView
    for _, v in pairs(self.listSlotHero:GetItems()) do
        if v.heroResource == nil then
            local isShowClass
            if heroResource.inventoryId ~= nil then
                isShowClass = true
            else
                isShowClass = false
            end
            v:ShowHeroIconView(heroResource, isShowClass)
            break
        end
    end
end

--- @return void
---@param heroResource HeroResource
function UIRecycleView:_RemoveHeroResource(heroResource)
    ---@param v SlotHeroIconView
    for _, v in pairs(self.listSlotHero:GetItems()) do
        if v.heroResource == heroResource then
            v:DeSpawnHeroIconView()
            break
        end
    end
end

--- @return void
function UIRecycleView:OnClickAutoSelect()
    if self.listHeroUnselected:Count() == 0 then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("all_hero_recycle_selected"))
        return
    end
    if self.listOfSelectedItem:Count() >= MAX_ITEM_SELECT then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("have_max_items_recycle"))
        return
    end

    self:SortListHero(self.listHeroUnselected, false)

    ---@param heroResource HeroResource
    local sortFourStar = function(heroResource)
        local star
        if heroResource.inventoryId ~= nil then
            star = heroResource.heroStar
        else
            star= heroResource.star
        end
        if star <= 4 then
            return true
        else
            return false
        end
    end

    ---@param heroResource HeroResource
    local sortFiveStar = function(heroResource)
        local star
        local heroTier = nil
        if heroResource.inventoryId ~= nil then
            star = heroResource.heroStar
            heroTier = ResourceMgr.GetHeroesConfig():GetHeroTier():GetHeroTier(heroResource.heroId)
        else
            star = heroResource.star
        end
        if star == 5 then
            if heroTier ~= nil then
                if heroTier < 6 then
                    return true
                else
                    return false
                end
            end
            return true
        else
            return false
        end
    end

    ---@param heroResource HeroResource
    local sortFiveStarSS = function(heroResource)
        local star
        local heroTier = nil
        if heroResource.inventoryId ~= nil then
            star = heroResource.heroStar
            heroTier = ResourceMgr.GetHeroesConfig():GetHeroTier():GetHeroTier(heroResource.heroId)
        else
            star= heroResource.star
        end
        if star == 5 then
            if heroTier ~= nil then
                if heroTier == 6 then
                    return true
                else
                    return false
                end
            end
            return false
        else
            return false
        end
    end

    ---@type List
    local listFourStar = List()
    ---@type List
    local listFiveStar = List()
    ---@type List
    local listFiveStarSS = List()
    local dataResource
    ---@type boolean
    local fourStar = false
    ---@type boolean
    local fiveStar = false
    ---@type boolean
    local fiveStarSS = false
    for _, v1 in ipairs(self.listHero:GetItems()) do
        for _, v in ipairs(self.listHeroUnselected:GetItems()) do
            if v1 == v then
                dataResource = v
                local id
                if dataResource.inventoryId ~= nil then
                    id = dataResource.inventoryId
                else
                    id = dataResource.id
                end

                if not self.listOfSelectedItem:IsContainValue(dataResource) and ClientConfigUtils.GetNotiLockHero(dataResource) == nil then
                    fourStar = sortFourStar(dataResource)
                    fiveStar = sortFiveStar(dataResource)
                    fiveStarSS = sortFiveStarSS(dataResource)

                    if fourStar then
                        listFourStar:Add(dataResource)
                    end
                    if fiveStar and listFourStar:Count() == 0 then
                        listFiveStar:Add(dataResource)
                    end
                    if fiveStarSS and listFourStar:Count() == 0 and listFiveStar:Count() == 0 then
                        listFiveStarSS:Add(dataResource)
                    end
                end
            end
        end
    end
    local listHeroSort = List()

    if listFourStar:Count() > 0 then
        listHeroSort = listFourStar
    elseif listFiveStar:Count() > 0 then
        listHeroSort = listFiveStar
    else
        listHeroSort = listFiveStarSS
    end

    for i = 1, listHeroSort:Count() do
        if self.listOfSelectedItem:Count() < MAX_ITEM_SELECT then
            local heroResource = listHeroSort:Get(i)
            local id
            if heroResource.inventoryId ~= nil then
                id = heroResource.inventoryId
                self.listHeroInventoryId:Add(heroResource.inventoryId)
                self.listCheckStarHero:Add(heroResource)
            else
                id = heroResource.id
                self.listFoodId:Add(heroResource.heroFoodType * HERO_FOOD_ID_DELTA + heroResource.star)
            end
            self.listHeroResourceSelected:Add(heroResource)
            self.listOfSelectedItem:Add(heroResource)
            self.listHeroUnselected:RemoveOneByReference(heroResource)
            self:_AddHeroResource(heroResource)
        end
    end
    self:ShowAcquiredItems()
    self.uiScroll:RefreshCells()
end

function UIRecycleView:ShowHeroList()
    self.listHeroFromInventory = InventoryUtils.Get(ResourceType.Hero)

    ---@param v HeroFood
    for _, v in pairs(zg.playerData:GetMethod(PlayerDataMethod.HERO_EVOLVE_FOOD).listHeroFood:GetItems()) do
        if v.number > 0 then
            for i = 1, v.number do
                local heroFood = HeroFood(v.heroFoodType, v.star, 1)
                self.listFoodInUseList:Add(heroFood)
            end
        end
    end

    for i = 1, self.listFoodInUseList:Count() do
        local food = self.listFoodInUseList:Get(i)
        food.id = i
        self.listHero:Add(food)
    end

    --- @param heroResource HeroResource
    for heroIndex, heroResource in ipairs(self.listHeroFromInventory:GetItems()) do
        if (self.filterConditionAnd == nil or self.filterConditionAnd(heroIndex, heroResource)) then
            self.heroInUseList:Add(heroResource)
            self.listHeroResource:Add(heroResource.inventoryId, heroResource)
        end
    end

    self.heroInUseList:Reverse()
    for i = 1, self.heroInUseList:Count() do
        local hero = self.heroInUseList:Get(i)
        self.listHero:Add(hero)
    end

    self:SortListHero(self.listHero, true)

    for i = 1,self.listHero:Count() do
        local data = self.listHero:Get(i)
        self.listHeroUnselected:Add(data)
    end
    self.uiScroll:Resize(self.listHero:Count())
end

function UIRecycleView:SortListHero(heroList, isListHero)
    ---@param heroResource HeroResource
    local sortOneStar = function(heroResource)
        local star
        if heroResource.id ~= nil then
            star = heroResource.star
        else
            star= heroResource.heroStar
        end
        if star == 1 then
            return true
        else
            return false
        end
    end

    ---@param heroResource HeroResource
    local sortTwoStar = function(heroResource)
        local star
        if heroResource.id ~= nil then
            star = heroResource.star
        else
            star= heroResource.heroStar
        end
        if star == 2 then
            return true
        else
            return false
        end
    end

    ---@param heroResource HeroResource
    local sortThreeStar = function(heroResource)
        local star
        if heroResource.id ~= nil then
            star = heroResource.star
        else
            star= heroResource.heroStar
        end
        if star == 3 then
            return true
        else
            return false
        end
    end

    ---@param heroResource HeroResource
    local sortFourStar = function(heroResource)
        local star
        if heroResource.id ~= nil then
            star = heroResource.star
        else
            star= heroResource.heroStar
        end
        if star == 4 then
            return true
        else
            return false
        end
    end

    ---@param heroResource HeroResource
    local sortFiveStar = function(heroResource)
        local star
        local heroTier = nil
        if heroResource.id ~= nil then
            star = heroResource.star
        else
            star= heroResource.heroStar
            heroTier = ResourceMgr.GetHeroesConfig():GetHeroTier():GetHeroTier(heroResource.heroId)
        end
        if star == 5 then
            if heroTier ~= nil then
                if heroTier < 6 then
                    return true
                else
                    return false
                end
            else
                return true
            end
        else
            return false
        end
    end

    ---@param heroResource HeroResource
    local sortFiveStarSS = function(heroResource)
        local star
        local heroTier = nil
        if heroResource.id ~= nil then
            star = heroResource.star
        else
            star= heroResource.heroStar
            heroTier = ResourceMgr.GetHeroesConfig():GetHeroTier():GetHeroTier(heroResource.heroId)
        end
        if star == 5 then
            if heroTier ~= nil then
                if heroTier == 6 then
                    return true
                else
                    return false
                end
            else
                return false
            end
        else
            return false
        end
    end

    ---@type List
    local listOneStar = List()
    ---@type List
    local listTwoStar = List()
    ---@type List
    local listThreeStar = List()
    ---@type List
    local listFourStar = List()
    ---@type List
    local listFiveStar = List()
    ---@type List
    local listFiveStarSS = List()
    ---@type HeroResource
    local dataResource
    ---@type boolean
    local oneStar = false
    ---@type boolean
    local twoStar = false
    ---@type boolean
    local threeStar = false
    ---@type boolean
    local fourStar = false
    ---@type boolean
    local fiveStar = false
    ---@type boolean
    local fiveStarSS = false
    for _, v in ipairs(heroList:GetItems()) do
        dataResource = v

        oneStar = sortOneStar(dataResource)
        twoStar = sortTwoStar(dataResource)
        threeStar = sortThreeStar(dataResource)
        fourStar = sortFourStar(dataResource)
        fiveStar = sortFiveStar(dataResource)
        fiveStarSS = sortFiveStarSS(dataResource)

        if oneStar then
            listOneStar:Add(dataResource)
        elseif twoStar then
            listTwoStar:Add(dataResource)
        elseif threeStar then
            listThreeStar:Add(dataResource)
        elseif fourStar then
            listFourStar:Add(dataResource)
        elseif fiveStar then
            listFiveStar:Add(dataResource)
        elseif fiveStarSS then
            listFiveStarSS:Add(dataResource)
        end
    end

    if isListHero then
        self.listHero:Clear()
        for _, v in ipairs(listOneStar:GetItems()) do
            self.listHero:Add(v)
        end
        for _, v in ipairs(listTwoStar:GetItems()) do
            self.listHero:Add(v)
        end
        for _, v in ipairs(listThreeStar:GetItems()) do
            self.listHero:Add(v)
        end
        for _, v in ipairs(listFourStar:GetItems()) do
            self.listHero:Add(v)
        end
        for _, v in ipairs(listFiveStar:GetItems()) do
            self.listHero:Add(v)
        end
        for _, v in ipairs(listFiveStarSS:GetItems()) do
            self.listHero:Add(v)
        end

        if self.listHero:Count() ~= heroList:Count() then
            print("Sort Hero Wrong" .. self.listHero:Count() .. heroList:Count())
        end
    else
        self.listHeroUnselected:Clear()
        for _, v in ipairs(listOneStar:GetItems()) do
            self.listHeroUnselected:Add(v)
        end
        for _, v in ipairs(listTwoStar:GetItems()) do
            self.listHeroUnselected:Add(v)
        end
        for _, v in ipairs(listThreeStar:GetItems()) do
            self.listHeroUnselected:Add(v)
        end
        for _, v in ipairs(listFourStar:GetItems()) do
            self.listHeroUnselected:Add(v)
        end
        for _, v in ipairs(listFiveStar:GetItems()) do
            self.listHeroUnselected:Add(v)
        end
        for _, v in ipairs(listFiveStarSS:GetItems()) do
            self.listHeroUnselected:Add(v)
        end
        if self.listHeroUnselected:Count() ~= heroList:Count() then
            print("Sort Hero Unselected Wrong" .. self.listHeroUnselected:Count() .. heroList:Count())
        end
    end
end

function UIRecycleView:ResetData()
    ---@param v SlotHeroIconView
    for _, v in pairs(self.listSlotHero:GetItems()) do
        v:ReturnPool()
    end
    self:HideIconData()
    self.uiScroll:Hide()
    self.listHeroResource:Clear()
    self.listFoodInUseList:Clear()
    self.heroInUseList:Clear()
    self.listHero:Clear()
    self.listHeroUnselected:Clear()
    self.listSlotHero:Clear()
    self.listOfSelectedItem:Clear()
    self.listHeroInventoryId:Clear()
    self.listFoodId:Clear()
    self.listCheckStarHero:Clear()
    self.listHeroResourceSelected:Clear()
    self.listNumberOrbInbound:Clear()
end

function UIRecycleView:Hide()
    if self.config.gameObject.activeInHierarchy then
        self.uiScroll:Hide()
        self:ResetData()
        self.config.gameObject:SetActive(false)
    end
end

function UIRecycleView:OnClickHelp()
    local info = LanguageUtils.LocalizeHelpInfo("recycle_info")
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, info)
end