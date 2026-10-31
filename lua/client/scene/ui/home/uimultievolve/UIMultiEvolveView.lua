require "lua.client.core.network.hero.HeroMultiEvolveOutBound"
require "lua.client.core.network.hero.HeroMultiEvolveInBound"

--- @class UIMultiEvolveView : UIBaseView
UIMultiEvolveView = Class(UIMultiEvolveView, UIBaseView)

--- @return void
--- @param model UIMultiEvolveModel
function UIMultiEvolveView:Ctor(model)
    self.maxSelect = 10
    ---@type HeroListView
    self.heroList = nil
    ---@type List
    self.listHeroEvolveOutBound = List()

    ---@type boolean
    self.isSelectHeroEvolve = true
    --- @type HeroEvolveOutBound
    self.currentHeroEvolveOutBound = nil
    --- @type HeroEvolveOutBound
    self.currentHeroEvolveView = nil

    ---@type Dictionary --<star, count>
    self.dictMoonMaterial = Dictionary()
    ---@type Dictionary --<star, count>
    self.dictSumMaterial = Dictionary()

    self.cacheSortFaction = nil
    self.cacheSortStar = nil

    self.evolveSuccess = false

    -- init variables here
    UIBaseView.Ctor(self, model)
    --- @type UIMultiEvolveModel
    self.model = model
end

--- @return void
function UIMultiEvolveView:OnReadyCreate()
    ---@type UIMultiEvolveConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgNone.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)

    self.config.buttonDone.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickDone()
    end)
    self.config.buttonEvolve.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEvolve()
    end)
    self.config.buttonAuto.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickAutoFill()
    end)

    -- Scroll heroEvolve
    --- @param obj MultiEvolveItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        obj:ActiveSelection(obj.heroEvolveOutBound == self.currentHeroEvolveOutBound)
        obj:ActiveButtonRemove(self.isSelectHeroEvolve)
        obj:UpdateFillHero()
    end

    --- @param obj MultiEvolveItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        if self.isSelectHeroEvolve == false and obj.heroEvolveOutBound == self.currentHeroEvolveOutBound then
            self.currentHeroEvolveView = obj
        end
        obj:SetData(self.listHeroEvolveOutBound:Get(index + 1), function()
            self:RemoveHeroEvolve(obj.heroEvolveOutBound)
        end, function()
            self:AutoFill(obj.heroEvolveOutBound)
        end)
        obj:AddListener(function()
            self:OnSelectMultiEvolveItemView(obj)
        end)
        onUpdateItem(obj, index)
    end

    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.MultiEvolveItemView, onCreateItem, onCreateItem)


    -- Scroll Material
    --- @param obj HeroIconView
    --- @param index number
    local onUpdateItem = function(obj, index)
        if index < self.listHero:Count() then
            ---@type HeroResource
            local heroResource = self.listHero:Get(index + 1)
            --- @type HeroIconData
            local data = HeroIconData.CreateByHeroResource(heroResource)
            obj:SetIconData(data)
            obj:SetSizeHeroView()
            if self:IsContainMaterialEvolve(heroResource) then
                obj:ActiveMaskSelect(true, UIUtils.sizeItem)
            else
                obj:ActiveMaskSelect(false)
            end
            if ClientConfigUtils.CheckLockHero(heroResource) then
                obj:ActiveMaskLock(true, UIUtils.sizeItem)
            else
                obj:ActiveMaskLock(false, UIUtils.sizeItem)
            end
        else
            local indexFood = index + 1 - self.listHero:Count()
            --- @type HeroFood
            local data = self.listFood:Get(indexFood)
            obj:SetIconData(ItemIconData.CreateBuyHeroFood(data.heroFoodType, data.star))
            obj:SetSizeHeroView()
            if self:IsContainFoodIndex(indexFood) then
                obj:ActiveMaskSelect(true, UIUtils.sizeItem)
            else
                obj:ActiveMaskSelect(false)
            end
        end
    end
    --- @param obj HeroIconView
    --- @param index number
    local onCreateItem = function(obj, index)
        obj:AddListener(function()
            self:OnSelectMaterialEvolve(index + 1)
            onUpdateItem(obj, index)
        end)
        onUpdateItem(obj, index)
    end

    self.uiScrollMaterial = UILoopScroll(self.config.scrollMaterial, UIPoolType.HeroIconView, onCreateItem, onCreateItem)

    --HERO LIST
    self.heroList = HeroListView(self.config.heroList)

    --- @return void
    --- @param heroIndex number
    --- @param buttonHero HeroIconView
    --- @param heroResource HeroResource
    self.onUpdateIconHero = function(heroIndex, buttonHero, heroResource)
        if ClientConfigUtils.CheckHeroInTraining(heroResource.inventoryId) then
            buttonHero:ActiveMaskLock(true, UIUtils.sizeItem)
        else
            buttonHero:ActiveMaskLock(false)
            if self.isSelectHeroEvolve == true and self:IsContainHeroEvolve(heroResource) then
                buttonHero:ActiveMaskSelect(true, UIUtils.sizeItem)
            elseif self.isSelectHeroEvolve == false and self:IsContainMaterialEvolve(heroResource) then
                buttonHero:ActiveMaskSelect(true, UIUtils.sizeItem)
            else
                buttonHero:ActiveMaskSelect(false)
            end
        end
        buttonHero:EnableButton(true)
    end

    --- @return void
    --- @param heroIndex number
    --- @param buttonHero HeroIconView
    --- @param heroResource HeroResource
    self.buttonListener = function(heroIndex, buttonHero, heroResource)
        if ClientConfigUtils.CheckHeroInTraining(heroResource.inventoryId) then
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("hero_in_training"))
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        else
            if self.isSelectHeroEvolve then
                self:OnSelectHeroEvolve(heroResource)
            else
                self:OnSelectMaterialEvolve(heroResource)
            end
        end
        self.onUpdateIconHero(heroIndex, buttonHero, heroResource)
    end

    self.heroList:Init(self.buttonListener, nil, nil, nil, nil, self.onUpdateIconHero, self.onUpdateIconHero)
end

--- @return void
function UIMultiEvolveView:InitLocalization()
    self.localizeSelectHero = LanguageUtils.LocalizeCommon("select_hero_evolve")
    self.localizeSelectMaterial = LanguageUtils.LocalizeCommon("select_material_hero")
    self.config.textAuto.text = LanguageUtils.LocalizeCommon("auto_fill")
    self.config.textDone.text = LanguageUtils.LocalizeCommon("done")
    self.config.textEvolve.text = LanguageUtils.LocalizeCommon("evolve")
    self.config.textEmpty.text = LanguageUtils.LocalizeCommon("empty_hero_evolve")
end

--- @return void
function UIMultiEvolveView:OnReadyShow(result)
    if result ~= nil then
        self.callbackCloseAfterEvolve = result.callbackCloseAfterEvolve
    else
        self.callbackCloseAfterEvolve = nil
    end
    self.evolveSuccess = false
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    self.heroList.config.gameObject:SetActive(true)
    self.uiScrollMaterial.scroll.gameObject:SetActive(false)
    self:ShowSelectHero()
end

--- @return void
function UIMultiEvolveView:ShowSelectHero()
    self.isSelectHeroEvolve = true
    self.uiScroll:Hide()
    self.uiScrollMaterial:Hide()
    self.heroList.config.gameObject:SetActive(true)
    self.uiScrollMaterial.scroll.gameObject:SetActive(false)
    self:UpdateView()
    self:SetDataSelectHeroEvolve()
    self:ReSizeSelectHero()
end

--- @return void
function UIMultiEvolveView:ReSizeSelectHero()
    self.uiScroll:Resize(self.listHeroEvolveOutBound:Count())
    self:UpdateTitle()
    self.config.empty:SetActive(self.listHeroEvolveOutBound:Count() == 0)
end

--- @return void
function UIMultiEvolveView:ShowSelectMaterial()
    self.cacheSortFaction = self.heroList.factionSort.indexTab
    self.cacheSortStar = self.heroList.starSort.indexTab
    self.isSelectHeroEvolve = false
    self.heroList:ReturnPool()
    self.heroList.config.gameObject:SetActive(false)
    self.uiScrollMaterial.scroll.gameObject:SetActive(true)
    self:UpdateView()
    self.currentHeroEvolveOutBound = self.listHeroEvolveOutBound:Get(1)
    self:ReSizeSelectHero()
    self:SetDataSelectMaterialEvolve()
end

--- @return void
--- @param heroResource HeroResource
function UIMultiEvolveView:GetIndexHeroEvolve(heroResource)
    local index = nil
    ---@param v HeroEvolveOutBound
    for i, v in ipairs(self.listHeroEvolveOutBound:GetItems()) do
        if v.heroInventoryId == heroResource.inventoryId then
            index = i
            break
        end
    end
    return index
end

--- @return void
--- @param heroResource HeroResource
function UIMultiEvolveView:AddHeroEvolve(heroResource)
    local indexHero = self:GetIndexHeroEvolve(heroResource)
    local heroEvolve = nil
    if indexHero == nil then
        heroEvolve = HeroEvolveOutBound(heroResource.inventoryId)
        self.listHeroEvolveOutBound:Add(heroEvolve)
    end
    return indexHero, heroEvolve
end

--- @return void
--- @param heroResource HeroResource
function UIMultiEvolveView:OnSelectHeroEvolve(heroResource)
    local indexHero = self:GetIndexHeroEvolve(heroResource)
    if indexHero ~= nil then
        self.listHeroEvolveOutBound:RemoveByIndex(indexHero)
    elseif self.listHeroEvolveOutBound:Count() < self.maxSelect then
        local heroEvolve = HeroEvolveOutBound(heroResource.inventoryId)
        self.listHeroEvolveOutBound:Add(heroEvolve)
    else
        SmartPoolUtils.ShowShortNotification(string.format(LanguageUtils.LocalizeCommon("limit_x"), self.maxSelect))
    end
    self:ReSizeSelectHero()
end

--- @return void
--- @param index number
function UIMultiEvolveView:OnSelectMaterialEvolve(index)
    ---@type HeroResource
    local heroResourceSelect = nil
    ---@type number
    local indexFood = nil
    if index > self.listHero:Count() then
        indexFood = index - self.listHero:Count()
    else
        heroResourceSelect = self.listHero:Get(index)
    end

    if heroResourceSelect ~= nil then
        local noti = ClientConfigUtils.GetNotiLockHero(heroResourceSelect)
        if noti ~= nil then
            SmartPoolUtils.ShowShortNotification(noti)
            return
        end
    end

    local remove = false
    ---@param v HeroEvolveMaterialOutBound
    for i, v in ipairs(self.currentHeroEvolveOutBound.heroMaterials:GetItems()) do
        if (heroResourceSelect ~= nil and v.heroInventoryId == heroResourceSelect.inventoryId)
                or (indexFood ~= nil and v.indexFood == indexFood) then
            self.currentHeroEvolveOutBound.heroMaterials:RemoveByIndex(i)
            remove = true
            break
        end
    end
    if remove == false then
        ---@type HeroResource
        local heroResource = InventoryUtils.GetHeroResourceByInventoryId(self.currentHeroEvolveOutBound.heroInventoryId)
        ---@type HeroEvolvePriceConfig
        local heroEvolvePrice = ResourceMgr.GetHeroMenuConfig():GetHeroEvolvePriceConfig(heroResource.heroId, heroResource.heroStar + 1)
        ---@type Dictionary
        local dictSlot = self.currentHeroEvolveOutBound:GetDictSlot()
        local index = 0
        ---@param heroMaterialEvolveData HeroMaterialEvolveData
        for i, heroMaterialEvolveData in ipairs(heroEvolvePrice.heroMaterialEvolveData:GetItems()) do
            local slot = i - 1
            local count = dictSlot:Get(slot)
            if count == nil then
                count = 0
            end
            if count < heroMaterialEvolveData.number then
                local iconData = heroMaterialEvolveData:GetHeroIconDataByHeroResource(heroResource)
                ---@type HeroEvolveMaterialOutBound
                local heroEvolveMaterialOutBound = nil
                if heroResourceSelect ~= nil then
                    if (iconData.heroId == nil or iconData.heroId == heroResourceSelect.heroId)
                            and (iconData.star == nil or iconData.star == heroResourceSelect.heroStar)
                            and (iconData.faction == nil or iconData.faction == ClientConfigUtils.GetFactionIdByHeroId(heroResourceSelect.heroId)) then
                        heroEvolveMaterialOutBound = HeroEvolveMaterialOutBound(i - 1, heroResourceSelect.inventoryId)
                    end
                else
                    ---@type HeroFood
                    local heroFood = self.listFood:Get(indexFood)
                    if iconData.faction == nil
                            or ClientConfigUtils.GetFoodFactionByFaction(iconData.faction) == heroFood.heroFoodType
                            or ClientConfigUtils.GetFoodMoonSunByFaction(iconData.faction) == heroFood.heroFoodType then
                        heroEvolveMaterialOutBound = HeroEvolveMaterialOutBound(i - 1, nil, heroFood.heroFoodType, heroFood.star)
                        heroEvolveMaterialOutBound.indexFood = indexFood
                    end
                end
                if heroEvolveMaterialOutBound ~= nil then
                    local listIndex = List()
                    ---@param v HeroEvolveMaterialOutBound
                    for i, v in ipairs(self.currentHeroEvolveOutBound.heroMaterials:GetItems()) do
                        if v.slotId == slot then
                            listIndex:Add(v.index)
                        end
                    end
                    for i = index, index + heroMaterialEvolveData.number do
                        if listIndex:IsContainValue(i) == false then
                            heroEvolveMaterialOutBound.index = i
                            break
                        end
                    end
                    self.currentHeroEvolveOutBound.heroMaterials:Add(heroEvolveMaterialOutBound)
                    break
                end
            end
            index = index + heroMaterialEvolveData.number
        end
    end

    if self.currentHeroEvolveView ~= nil and self.currentHeroEvolveView.heroEvolveOutBound == self.currentHeroEvolveOutBound then
        self.currentHeroEvolveView:UpdateFillHero()
    end
end

--- @return void
--- @param multiEvolveItemView MultiEvolveItemView
function UIMultiEvolveView:OnSelectMultiEvolveItemView(multiEvolveItemView)
    if self.isSelectHeroEvolve == false and self.currentHeroEvolveOutBound ~= multiEvolveItemView.heroEvolveOutBound then
        self.currentHeroEvolveOutBound = multiEvolveItemView.heroEvolveOutBound
        self.currentHeroEvolveView = multiEvolveItemView
        self.uiScroll:RefreshCells()
        self:SetDataSelectMaterialEvolve()
    end
end

--- @return void
--- @param heroResource HeroResource
function UIMultiEvolveView:IsContainHeroEvolve(heroResource)
    return self:GetIndexHeroEvolve(heroResource) ~= nil
end

--- @return void
--- @param heroResource HeroResource
function UIMultiEvolveView:IsContainMaterialEvolve(heroResource)
    local contain = false
    if self.currentHeroEvolveOutBound ~= nil then
        ---@param v HeroEvolveMaterialOutBound
        for i, v in ipairs(self.currentHeroEvolveOutBound.heroMaterials:GetItems()) do
            if v.heroInventoryId == heroResource.inventoryId then
                contain = true
                break
            end
        end
    end
    return contain
end

--- @return void
--- @param index number
function UIMultiEvolveView:IsContainFoodIndex(index)
    local contain = false
    if self.currentHeroEvolveOutBound ~= nil then
        ---@param v HeroEvolveMaterialOutBound
        for i, v in ipairs(self.currentHeroEvolveOutBound.heroMaterials:GetItems()) do
            if v.indexFood == index then
                contain = true
                break
            end
        end
    end
    return contain
end

--- @return void
--- @param heroEvolveOutBound HeroEvolveOutBound
function UIMultiEvolveView:RemoveHeroEvolve(heroEvolveOutBound)
    self.listHeroEvolveOutBound:RemoveOneByReference(heroEvolveOutBound)
    self.uiScroll:RefreshCells(self.listHeroEvolveOutBound:Count())
    self.heroList.uiScroll.scroll:RefreshCells()
    self:UpdateTitle()
end

--- @return void
--- @param heroEvolveOutBound HeroEvolveOutBound
function UIMultiEvolveView:AutoFill(heroEvolveOutBound)

end

--- @return void
function UIMultiEvolveView:OnClickAutoFill()
    if self.isSelectHeroEvolve == true then
        self:AutoFillSelect1()
        if self.listHeroEvolveOutBound:Count() > 0 then
            self:ShowSelectMaterial()
        else
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("evolve_invalid"))
        end
    else
        self:AutoFillMaterialAll()
    end
end

--- @return void
function UIMultiEvolveView:AutoFillSelect()
    local change = false
    ---@param heroIndex number
    for i, heroIndex in ipairs(self.heroList.heroInUseList:GetItems()) do
        ---@type HeroResource
        local heroResource = self.heroList.heroResourceList:Get(heroIndex)
        if self.listHeroEvolveOutBound:Count() < self.maxSelect then
            if ClientConfigUtils.CheckHeroInTraining(heroResource.inventoryId) == false then
                local index = self:AddHeroEvolve(heroResource)
                if index == nil then
                    change = true
                end
            end
        else
            break
        end
    end
    if change == true then
        self:ReSizeSelectHero()
        self.heroList.uiScroll.scroll:RefreshCells()
    end
end

--- @return void
function UIMultiEvolveView:AutoFillSelect1()
    local change = false
    local listInventoryId = List()
    ---@param heroIndex number
    for i, heroIndex in ipairs(self.heroList.heroInUseList:GetItems()) do
        ---@type HeroResource
        local heroResource = self.heroList.heroResourceList:Get(heroIndex)
        if self.listHeroEvolveOutBound:Count() < self.maxSelect then
            if ClientConfigUtils.CheckHeroInTraining(heroResource.inventoryId) == false and listInventoryId:IsContainValue(heroResource.inventoryId) == false then
                local index, heroEvolve = self:AddHeroEvolve(heroResource)

                if heroEvolve ~= nil then
                    local listId, canEvolve = self:AutoFillMaterialSlot(heroEvolve, listInventoryId)
                    if canEvolve == true then
                        for i, v in ipairs(listId:GetItems()) do
                            listInventoryId:Add(v)
                        end
                        if index == nil then
                            change = true
                        end
                    else
                        self.listHeroEvolveOutBound:RemoveOneByReference(heroEvolve)
                    end
                end
            end
        else
            break
        end
    end
    if change == true then
        self:ReSizeSelectHero()
        self.heroList.uiScroll.scroll:RefreshCells()
    end
end

--- @return void
function UIMultiEvolveView:AutoFillSelect2()
    local change = false
    local listHero = List()
    local listHeroCanFood = List()
    local foodCount = 0
    ---@param v HeroFood
    for _, v in ipairs(zg.playerData:GetMethod(PlayerDataMethod.HERO_EVOLVE_FOOD).listHeroFood:GetItems()) do
        if v.star == self.heroList.starSort.indexTab then
            foodCount = v.number
            break
        end
    end
    ---@param heroIndex number
    for i, heroIndex in ipairs(self.heroList.heroInUseList:GetItems()) do
        ---@type HeroResource
        local heroResource = self.heroList.heroResourceList:Get(heroIndex)
        if ClientConfigUtils.CheckHeroInTraining(heroResource.inventoryId) == false then
            listHero:Add(heroResource)
        end
        if ClientConfigUtils.CheckLockHero(heroResource) == false then
            listHeroCanFood:Add(heroResource)
        end
    end

    ---@param heroIndex number
    for i, heroIndex in ipairs(self.heroList.heroInUseList:GetItems()) do
        ---@type HeroResource
        local heroResource = self.heroList.heroResourceList:Get(heroIndex)
        if self.listHeroEvolveOutBound:Count() < self.maxSelect then
            if ClientConfigUtils.CheckHeroInTraining(heroResource.inventoryId) == false then
                local index = self:AddHeroEvolve(heroResource)
                if index == nil then
                    change = true
                end
            end
        else
            break
        end
    end

    if change == true then
        self:ReSizeSelectHero()
        self.heroList.uiScroll.scroll:RefreshCells()
    end
end

--- @return void
function UIMultiEvolveView:AutoFillMaterialAll()
    self:AutoFillMaterialSlot(self.currentHeroEvolveOutBound)
    for i, v in ipairs(self.listHeroEvolveOutBound:GetItems()) do
        if v ~= self.currentHeroEvolveOutBound then
            self:AutoFillMaterialSlot(v)
        end
    end
    self:SetDataSelectMaterialEvolve()
    self.uiScroll:RefreshCells()
end

--- @return void
--- @param heroEvolveOutBound HeroEvolveOutBound
function UIMultiEvolveView:AutoFillMaterialSlot(heroEvolveOutBound)
    local listInventoryId = List()
    ---@type List
    local listHero, listFood = self:GetListHeroAndFoodCanSelect(heroEvolveOutBound)
    ---@type HeroResource
    local heroResource = InventoryUtils.GetHeroResourceByInventoryId(heroEvolveOutBound.heroInventoryId)
    ---@type HeroEvolvePriceConfig
    local heroEvolvePrice = ResourceMgr.GetHeroMenuConfig():GetHeroEvolvePriceConfig(heroResource.heroId, heroResource.heroStar + 1)
    ---@type Dictionary
    local dictIndex = heroEvolveOutBound:GetDictIndex()
    ---@type Dictionary
    local dictSlot = heroEvolveOutBound:GetDictSlot()
    ---@type List
    local listHeroInventoryId = heroEvolveOutBound:GetListHeroMaterial()
    ---@type List
    local listIndexFood = heroEvolveOutBound:GetListIndexFood()
    local index = 0
    local canEvolve = true
    ---@param heroMaterialEvolveData HeroMaterialEvolveData
    for i, heroMaterialEvolveData in ipairs(heroEvolvePrice.heroMaterialEvolveData:GetItems()) do
        local slot = i - 1
        local count = dictSlot:Get(slot)
        if count == nil then
            count = 0
        end
        ---@param heroEvolveMaterialOutBound HeroEvolveMaterialOutBound
        local add = function(heroEvolveMaterialOutBound)
            count = count + 1
            for i = index, index + heroMaterialEvolveData.number do
                if dictIndex:IsContainKey(i) == false then
                    heroEvolveMaterialOutBound.index = i
                    dictIndex:Add(i, heroEvolveMaterialOutBound)
                    break
                end
            end
            heroEvolveOutBound.heroMaterials:Add(heroEvolveMaterialOutBound)
        end
        if count < heroMaterialEvolveData.number then
            ---@param v HeroResource
            for _, v in ipairs(listHero:GetItems()) do
                if ClientConfigUtils.CheckLockHero(v) == false and listHeroInventoryId:IsContainValue(v.inventoryId) == false and heroMaterialEvolveData:IsMatchHeroResource(heroResource, v) then
                    add(HeroEvolveMaterialOutBound(slot, v.inventoryId))
                    listHeroInventoryId:Add(v.inventoryId)
                    listInventoryId:Add(v.inventoryId)
                    if count == heroMaterialEvolveData.number then
                        break
                    end
                end
            end
        end
        if count < heroMaterialEvolveData.number then
            ---@param v HeroFood
            for i, v in ipairs(listFood:GetItems()) do
                if listIndexFood:IsContainValue(i) == false and heroMaterialEvolveData:IsMatchHeroFood(heroResource, v) then
                    ---@type HeroEvolveMaterialOutBound
                    local heroEvolveMaterialOutBound = HeroEvolveMaterialOutBound(slot, nil, v.heroFoodType, v.star)
                    heroEvolveMaterialOutBound.indexFood = i
                    add(heroEvolveMaterialOutBound)
                    if count == heroMaterialEvolveData.number then
                        break
                    end
                end
            end
        end
        index = index + heroMaterialEvolveData.number
        if count < heroMaterialEvolveData.number then
            canEvolve = false
        end
    end
    return listInventoryId, canEvolve
end

--- @return void
function UIMultiEvolveView:OnClickDone()
    if self.listHeroEvolveOutBound:Count() > 0 then
        self:ShowSelectMaterial()
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("you_need_select_hero"))
    end
end

--- @return void
function UIMultiEvolveView:UpdateTitle()
    if self.isSelectHeroEvolve == true then
        local color = UIUtils.color7
        if self.listHeroEvolveOutBound:Count() < self.maxSelect then
            color = UIUtils.color2
        end
        self.config.textTitle.text = string.format(self.localizeSelectHero,
                string.format("<color=#%s>%s/%s</color>", color, self.listHeroEvolveOutBound:Count(), self.maxSelect))
    else
        self.config.textTitle.text = self.localizeSelectMaterial
    end
end

--- @return void
function UIMultiEvolveView:UpdateView()
    if self.isSelectHeroEvolve == true then
        self.config.buttonEvolve.gameObject:SetActive(false)
        self.config.buttonDone.gameObject:SetActive(true)
    else
        self.config.buttonEvolve.gameObject:SetActive(true)
        self.config.buttonDone.gameObject:SetActive(false)
    end
end

--- @return void
function UIMultiEvolveView:OnClickEvolve()
    ---@type List
    local listHeroCanEvolve = List()
    ---@type HeroMultiEvolveOutBound
    local heroMultiEvolveOutBound = HeroMultiEvolveOutBound()
    heroMultiEvolveOutBound.listHeroEvolveOutBound = List()
    local goldTotal = 0
    local magicPotionTotal = 0
    local awakenBookTotal = 0
    local goldEvolve = 0
    local magicPotionEvolve = 0
    local awakenBookEvolve = 0
    local isConverting = false
    ---@param heroEvolveOutBound HeroEvolveOutBound
    for _, heroEvolveOutBound in ipairs(self.listHeroEvolveOutBound:GetItems()) do
        ---@type HeroResource
        local heroResourceEvolve = InventoryUtils.GetHeroResourceByInventoryId(heroEvolveOutBound.heroInventoryId)
        ---@type HeroEvolvePriceConfig
        local heroEvolvePrice = ResourceMgr.GetHeroMenuConfig():GetHeroEvolvePriceConfig(heroResourceEvolve.heroId, heroResourceEvolve.heroStar + 1)
        ---@type Dictionary
        local dict = heroEvolveOutBound:GetDictSlot()
        local fullSlot = true
        ---@param v HeroMaterialEvolveData
        for i, v in ipairs(heroEvolvePrice.heroMaterialEvolveData:GetItems()) do
            local countSlot = dict:Get(i - 1)
            if countSlot == nil or countSlot < v.number then
                fullSlot = false
            end
        end
        if fullSlot then
            if isConverting == false and heroResourceEvolve:IsConverting() then
                isConverting = true
            end
            listHeroCanEvolve:Add(heroEvolveOutBound)
            goldTotal = goldTotal + heroEvolvePrice.gold
            magicPotionTotal = magicPotionTotal + heroEvolvePrice.magicPotion
            awakenBookTotal = awakenBookTotal + heroEvolvePrice.awakenBook
            if InventoryUtils.IsValid(ResourceType.Money, MoneyType.GOLD, goldTotal)
                    and InventoryUtils.IsValid(ResourceType.Money, MoneyType.MAGIC_POTION, magicPotionTotal)
                    and InventoryUtils.IsValid(ResourceType.Money, MoneyType.AWAKEN_BOOK, awakenBookTotal) then
                heroMultiEvolveOutBound.listHeroEvolveOutBound:Add(heroEvolveOutBound)
                goldEvolve = goldTotal
                magicPotionEvolve = magicPotionTotal
                awakenBookEvolve = awakenBookTotal
            end
        end
    end

    if listHeroCanEvolve:Count() > 0 then
        local confirmEvolve = function()
            if heroMultiEvolveOutBound.listHeroEvolveOutBound:Count() > 0 then
                local callback = function(result)
                    ---@type HeroMultiEvolveInBound
                    local heroMultiEvolveInBound
                    --- @param buffer UnifiedNetwork_ByteBuf
                    local onBufferReading = function(buffer)
                        heroMultiEvolveInBound = HeroMultiEvolveInBound(buffer)
                    end
                    local onSuccess = function()
                        if isConverting then
                            ---@type ProphetTreeInBound
                            local prophetTreeInBound = zg.playerData:GetMethod(PlayerDataMethod.PROPHET_TREE)
                            if prophetTreeInBound ~= nil then
                                prophetTreeInBound.isConverting = false
                            end
                        end
                        ---@type List
                        local rewardList = List()

                        ---@param reward RewardInBound
                        for _, reward in pairs(heroMultiEvolveInBound.rewardItems:GetItems()) do
                            ClientConfigUtils.AddIconDataToList(rewardList, reward:GetIconData())
                        end

                        ---@param heroEvolveOutBound HeroEvolveOutBound
                        for _, heroEvolveOutBound in ipairs(heroMultiEvolveOutBound.listHeroEvolveOutBound:GetItems()) do
                            ---@param heroEvolveMaterialOutBound HeroEvolveMaterialOutBound
                            for _, heroEvolveMaterialOutBound in ipairs(heroEvolveOutBound.heroMaterials:GetItems()) do
                                if heroEvolveMaterialOutBound.heroInventoryId ~= nil then
                                    ---@type HeroResource
                                    local heroResource = InventoryUtils.GetHeroResourceByInventoryId(heroEvolveMaterialOutBound.heroInventoryId)
                                    for i, vv in pairs(heroResource.heroItem:GetItems()) do
                                        if i <= 4 then
                                            InventoryUtils.Add(ResourceType.ItemEquip, vv, 1)
                                            ClientConfigUtils.AddIconDataToList(rewardList, ItemIconData.CreateInstance(ResourceType.ItemEquip, vv, 1))
                                        elseif i == HeroItemSlot.ARTIFACT then
                                            InventoryUtils.Add(ResourceType.ItemArtifact, vv, 1)
                                            ClientConfigUtils.AddIconDataToList(rewardList, ItemIconData.CreateInstance(ResourceType.ItemArtifact, vv, 1))
                                        elseif i == HeroItemSlot.SKIN then
                                            InventoryUtils.Add(ResourceType.Skin, vv, 1)
                                            ClientConfigUtils.AddIconDataToList(rewardList, ItemIconData.CreateInstance(ResourceType.Skin, vv, 1))
                                        end
                                    end
                                    InventoryUtils.Sub(ResourceType.Hero, heroResource)
                                else
                                    zg.playerData:GetMethod(PlayerDataMethod.HERO_EVOLVE_FOOD):SubHeroFood(heroEvolveMaterialOutBound.heroFoodType, heroEvolveMaterialOutBound.heroFoodStar, 1)
                                end
                            end
                            ---@type HeroResource
                            local heroResourceEvolve = InventoryUtils.GetHeroResourceByInventoryId(heroEvolveOutBound.heroInventoryId)
                            heroResourceEvolve.heroStar = heroResourceEvolve.heroStar + 1
                        end

                        InventoryUtils.Sub(ResourceType.Money, MoneyType.GOLD, goldEvolve)
                        InventoryUtils.Sub(ResourceType.Money, MoneyType.MAGIC_POTION, magicPotionEvolve)

                        if rewardList:Count() > 0 then
                            PopupUtils.ShowRewardList(rewardList)

                            ---@param reward RewardInBound
                            for _, reward in pairs(heroMultiEvolveInBound.rewardItems:GetItems()) do
                                reward:AddToInventory()
                            end
                            heroMultiEvolveInBound.rewardItems:Clear()
                        else
                            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("change_success"))
							SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("selected_hero"))
                        end

                        self.evolveSuccess = true

                        self.listHeroEvolveOutBound:Clear()
                        self:ShowSelectHero()
                    end
                    NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
                end
                NetworkUtils.Request(OpCode.HERO_MULTI_EVOLVE, heroMultiEvolveOutBound, callback)
            elseif goldTotal > 0 or magicPotionTotal > 0 or awakenBookTotal > 0 then
                local listReward = List()
                listReward:Add(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.GOLD, goldTotal))
                listReward:Add(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.MAGIC_POTION, magicPotionTotal))
                listReward:Add(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.AWAKEN_BOOK, awakenBookTotal))
                InventoryUtils.IsEnoughMultiResourceRequirement(listReward, true)
            end
        end
        if goldTotal > 0 or magicPotionTotal > 0 or awakenBookTotal > 0 then
            local data = {}
            data.notification = LanguageUtils.LocalizeCommon("noti_confirm_resource")
            data.alignment = U_TextAnchor.MiddleCenter
            data.canCloseByBackButton = true
            data.listItem = List()
            if goldTotal > 0 then
                data.listItem:Add(ItemIconData.CreateInstance(ResourceType.Money, MoneyType.GOLD, goldTotal))
            end
            if magicPotionTotal > 0 then
                data.listItem:Add(ItemIconData.CreateInstance(ResourceType.Money, MoneyType.MAGIC_POTION, magicPotionTotal))
            end
            if awakenBookTotal > 0 then
                data.listItem:Add(ItemIconData.CreateInstance(ResourceType.Money, MoneyType.AWAKEN_BOOK, awakenBookTotal))
            end

            local buttonNo = {}
            buttonNo.text = LanguageUtils.LocalizeCommon("cancel")
            buttonNo.callback = function()
                PopupMgr.HidePopup(UIPopupName.UIPopupNotification)
            end
            data.button1 = buttonNo

            local buttonYes = {}
            buttonYes.text = LanguageUtils.LocalizeCommon("confirm")
            buttonYes.callback = function()
                PopupMgr.HidePopup(UIPopupName.UIPopupNotification)
                confirmEvolve()
            end
            data.button2 = buttonYes
            PopupMgr.ShowPopup(UIPopupName.UIPopupNotification, data)
        else
            confirmEvolve()
        end
    else
        SmartPoolUtils.NotiLackResource()
    end
end

--- @return void
function UIMultiEvolveView:SetDataSelectHeroEvolve()
    ---@type List
    self.listHero = List()

    ---@param heroResource HeroResource
    for i, heroResource in ipairs(InventoryUtils.Get(ResourceType.Hero):GetItems()) do
        if heroResource.heroStar <= 4 then
            self.listHero:Add(heroResource)
        end
    end

    self.heroList:SetData(self.listHero, false, self.cacheSortFaction, self.cacheSortStar)
    self.heroList.uiScroll:RefreshCells()
end

--- @return void
--- @param heroEvolveOutBound HeroEvolveOutBound
function UIMultiEvolveView:GetListHeroMaterialCanSelect(heroEvolveOutBound)
    ---@type List
    local listHero = List()
    ---@type HeroResource
    local heroResource = InventoryUtils.GetHeroResourceByInventoryId(heroEvolveOutBound.heroInventoryId)
    local heroEvolvePrice = ResourceMgr.GetHeroMenuConfig():GetHeroEvolvePriceConfig(heroResource.heroId, heroResource.heroStar + 1)
    ---@type List
    local listHeroIconData = List()
    ---@param heroMaterialEvolveData HeroMaterialEvolveData
    for i, heroMaterialEvolveData in ipairs(heroEvolvePrice.heroMaterialEvolveData:GetItems()) do
        listHeroIconData:Add(heroMaterialEvolveData:GetHeroIconDataByHeroResource(heroResource))
    end
    ---@type List
    local listHeroEvolve = self:GetListHeroEvolve()
    self:GetListHeroMaterial(listHeroEvolve, heroEvolveOutBound)
    ---@param v HeroResource
    for i, v in ipairs(InventoryUtils.Get(ResourceType.Hero):GetItems()) do
        if listHeroEvolve:IsContainValue(v.inventoryId) == false then
            ---@param iconData HeroIconData
            for i, iconData in ipairs(listHeroIconData:GetItems()) do
                if (iconData.heroId == nil or iconData.heroId == v.heroId)
                        and (iconData.star == nil or iconData.star == v.heroStar)
                        and (iconData.faction == nil or iconData.faction == ClientConfigUtils.GetFactionIdByHeroId(v.heroId)) then
                    listHero:Add(v)
                    break
                end
            end
        end
    end
    return listHero
end

--- @return List
function UIMultiEvolveView:GetListHeroEvolve()
    ---@type List
    local listHeroEvolve = List()
    ---@param heroEvolveOutBound HeroEvolveOutBound
    for i, heroEvolveOutBound in ipairs(self.listHeroEvolveOutBound:GetItems()) do
        listHeroEvolve:Add(heroEvolveOutBound.heroInventoryId)
    end
    return listHeroEvolve
end

--- @return List
function UIMultiEvolveView:GetListHeroMaterial(list, currentHeroEvolveOutBound)
    ---@type List
    local listHero = list
    if listHero == nil then
        listHero = List()
    end
    ---@param heroEvolveOutBound HeroEvolveOutBound
    for i, heroEvolveOutBound in ipairs(self.listHeroEvolveOutBound:GetItems()) do
        if heroEvolveOutBound ~= currentHeroEvolveOutBound then
            heroEvolveOutBound:GetListHeroMaterial(listHero)
        end
    end
    return listHero
end

--- @return List  --<HeroFood>
function UIMultiEvolveView:GetListHeroFood(list, currentHeroEvolveOutBound)
    ---@type List
    local listHero = list
    if listHero == nil then
        listHero = List()
    end
    ---@param heroEvolveOutBound HeroEvolveOutBound
    for i, heroEvolveOutBound in ipairs(self.listHeroEvolveOutBound:GetItems()) do
        if heroEvolveOutBound ~= currentHeroEvolveOutBound then
            heroEvolveOutBound:GetListHeroFood(listHero)
        end
    end
    return listHero
end

--- @return void
--- @param heroEvolveOutBound HeroEvolveOutBound
function UIMultiEvolveView:GetListHeroAndFoodCanSelect(heroEvolveOutBound)
    ---@type List
    local listHero = self:GetListHeroMaterialCanSelect(heroEvolveOutBound)
    ---@type List --<HeroFood>
    local listFoodSelected = self:GetListHeroFood(nil, heroEvolveOutBound)
    ---@type PlayerHeroFoodInBound
    local playerHeroFoodInBoundClone = PlayerHeroFoodInBound()
    playerHeroFoodInBoundClone.listHeroFood = List()
    ---@param v HeroFood
    for _, v in ipairs(zg.playerData:GetMethod(PlayerDataMethod.HERO_EVOLVE_FOOD).listHeroFood:GetItems()) do
        playerHeroFoodInBoundClone.listHeroFood:Add(HeroFood(v.heroFoodType, v.star, v.number))
    end
    ---@param v HeroFood
    for _, v in ipairs(listFoodSelected:GetItems()) do
        playerHeroFoodInBoundClone:SubHeroFood(v.heroFoodType, v.star, v.number)
    end

    ---@type HeroResource
    local heroResource = InventoryUtils.GetHeroResourceByInventoryId(heroEvolveOutBound.heroInventoryId)
    ---@type HeroEvolvePriceConfig
    local heroEvolvePrice = ResourceMgr.GetHeroMenuConfig():GetHeroEvolvePriceConfig(heroResource.heroId, heroResource.heroStar + 1)
    ---@type List --<HeroFood>
    local listFoodCanSelect = heroEvolvePrice:GetListFood(heroResource)
    -----@type List
    local listFood = List()

    ---@param v HeroFood
    for _, v in ipairs(playerHeroFoodInBoundClone.listHeroFood:GetItems()) do
        ---@param itemIconData HeroFood
        for i, itemIconData in ipairs(listFoodCanSelect:GetItems()) do
            if v.heroFoodType == itemIconData.heroFoodType and v.star == itemIconData.star then
                for i = 1, v.number do
                    listFood:Add(HeroFood(v.heroFoodType, v.star))
                end
                break
            end
        end
    end

    ---@param v HeroEvolveMaterialOutBound
    for i, v in ipairs(heroEvolveOutBound.heroMaterials:GetItems()) do
        if v.heroInventoryId == nil then
            v.indexFood = nil
        end
    end

    ---@param itemIconData HeroFood
    for i, itemIconData in ipairs(listFood:GetItems()) do
        local stop = true
        ---@param v HeroEvolveMaterialOutBound
        for _, v in ipairs(heroEvolveOutBound.heroMaterials:GetItems()) do
            if v.heroInventoryId == nil then
                if v.indexFood == nil then
                    stop = false
                    if v.heroFoodType == itemIconData.heroFoodType and v.heroFoodStar == itemIconData.star then
                        v.indexFood = i
                        break
                    end
                end
            end
        end
        if stop == true then
            break
        end
    end
    return listHero, listFood
end

--- @return void
function UIMultiEvolveView:SetDataSelectMaterialEvolve()
    self.listHero, self.listFood = self:GetListHeroAndFoodCanSelect(self.currentHeroEvolveOutBound)
    self.uiScrollMaterial:Resize(self.listHero:Count() + self.listFood:Count())
end

--- @return void
function UIMultiEvolveView:Hide()
    UIBaseView.Hide(self)
    self.uiScroll:Hide()
    self.uiScrollMaterial:Hide()
    self.heroList:ReturnPool()
    self.listHeroEvolveOutBound:Clear()
    self.cacheSortFaction = nil
    self.cacheSortStar = nil
end

--- @return void
function UIMultiEvolveView:OnClickBackOrClose()
    local close = function()
        UIBaseView.OnClickBackOrClose(self)
        if self.evolveSuccess == true and self.callbackCloseAfterEvolve ~= nil then
            self.callbackCloseAfterEvolve()
        end
    end
    if self.listHeroEvolveOutBound:Count() > 0 then
        PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("noti_close_multi_evolve"), function()
            zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
        end, close)
    else
        close()
    end
end