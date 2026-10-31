---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiHeroMenu.UIHeroEvolve2.UIHeroEvolve2Config"
require "lua.client.core.network.hero.HeroEvolveOutBound"
require "lua.client.core.network.hero.HeroEvolveInBound"
require "lua.client.core.network.hero.HeroEvolveOrbOutBound"

--- @class UIHeroEvolve2
UIHeroEvolve2 = Class(UIHeroEvolve2)

--- @return void
--- @param transform UnityEngine_Transform
function UIHeroEvolve2:Ctor(transform, model, heroMenuView)
    --- @type UIHeroMenu2Model
    self.model = model
    --- @type UIHeroMenu2View
    self.heroMenuView = heroMenuView
    ---@type UIHeroEvolveConfig
    self.config = UIBaseConfig(transform)
    ---@type StatHeroEvolveChangeConfig
    self.levelCap = UIBaseConfig(self.config.levelCap)
    ---@type StatHeroEvolveChangeConfig
    self.hp = UIBaseConfig(self.config.hp)
    ---@type StatHeroEvolveChangeConfig
    self.attack = UIBaseConfig(self.config.attack)
    ---@type StatHeroEvolveChangeConfig
    self.speed = UIBaseConfig(self.config.speed)
    ---@type ListSkillView
    self.listSkillView = ListSkillView(self.config.skillParent, U_Vector2(-0.1, 0.5), nil)
    ---@type SkillHeroView[]
    self.listSkill = {}
    ---@type List -- HeroMaterialIconView[]
    self.materialConfig = List()
    ---@type List --<List<heroInventoryId>>
    self.dataMaterials = List()
    ---@type List --<List<heroInventoryId>>
    self.dataHeroFood = List()
    ---@type HeroEvolvePriceConfig
    self.heroEvolvePrice = nil
    ---@type HeroLevelCapConfig
    self.heroLevelCap = nil
    ---@type List
    self.dataOrbsSelect = List()
    ---@type List
    self.dataIdsSelect = List()
    self:InitUI()
end

--- @return void
function UIHeroEvolve2:InitLocalization()
    self.config.localizeEvolve.text = LanguageUtils.LocalizeCommon("evolve")
    self.config.localizeAwaken.text = LanguageUtils.LocalizeCommon("awaken")
    self.config.localizeLevelCap.text = LanguageUtils.LocalizeCommon("level_cap")
    self.config.textMaterialRequireValue.text = LanguageUtils.LocalizeCommon("material")
end

--- @return void
function UIHeroEvolve2:InitUI()
    self.config.buttonEvolve.onClick:AddListener(function()
        self:OnClickEvolve()
    end)
    self.config.buttonAwaken.onClick:AddListener(function()
        self:OnClickEvolve(true)
    end)
end

--- @return void
function UIHeroEvolve2:Show()
    self.heroMenuView:SetButtonNextHero(self.config.buttonEvolve.transform.position)
    self:UpdateUI()
end

--- @return void
function UIHeroEvolve2:Hide()
    ---@param v HeroMaterialIconView
    for _, v in ipairs(self.materialConfig:GetItems()) do
        v:ReturnPool()
    end
    self.listSkillView:ReturnPool()
    self.materialConfig:Clear()
    self.dataMaterials:Clear()
    self.dataHeroFood:Clear()
    self.dataOrbsSelect:Clear()
    self.dataIdsSelect:Clear()
end

--- @return void
function UIHeroEvolve2:RequestEvolveHero(isAwaken)
    ---@type HeroEvolveOutBound
    local heroEvolveOutBound = HeroEvolveOutBound(self.model.heroResource.inventoryId)
    for slotId, material in pairs(self.dataMaterials:GetItems()) do
        for i, heroResource in pairs(material:GetItems()) do
            --XDebug.Log("heroResource.inventoryId" .. heroResource.inventoryId)
            heroEvolveOutBound.heroMaterials:Add(HeroEvolveMaterialOutBound(slotId - 1, heroResource.inventoryId))
        end
    end
    ---@param list List
    for slotId, list in pairs(self.dataHeroFood:GetItems()) do
        ---@param heroFood HeroFood
        for _, heroFood in pairs(list:GetItems()) do
            for i = 1, heroFood.number do
                heroEvolveOutBound.heroMaterials:Add(HeroEvolveMaterialOutBound(slotId - 1, nil, heroFood.heroFoodType, heroFood.star))
            end
        end
    end
    ---@param dict Dictionary
    for slotId, dict in pairs(self.dataOrbsSelect:GetItems()) do
        for i,v in pairs(dict:GetItems()) do
            heroEvolveOutBound.heroOrbs:Add(HeroEvolveOrbOutBound(slotId - 1, i, v))
        end
    end

    local callback = function(result)
        ---@type HeroEvolveInBound
        local heroEvolveInBound
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            heroEvolveInBound = HeroEvolveInBound(buffer)
        end
        local onSuccess = function()
            local touchObject = TouchUtils.Spawn("UIHeroEvolve2:RequestEvolveHero")
            local isInPentagram = heroEvolveOutBound:IsInPentagram()
            if self.model.heroResource:IsConverting() then
                ---@type ProphetTreeInBound
                local prophetTreeInBound = zg.playerData:GetMethod(PlayerDataMethod.PROPHET_TREE)
                prophetTreeInBound.isConverting = false
            end
            ---@type List
            local rewardList = List()

            ---@param reward RewardInBound
            for _, reward in pairs(heroEvolveInBound.rewardItems:GetItems()) do
                ClientConfigUtils.AddIconDataToList(rewardList, reward:GetIconData())
            end

            for _, material in pairs(self.dataMaterials:GetItems()) do
                ---@param heroResource HeroResource
                for _, heroResource in pairs(material:GetItems()) do
                    InventoryUtils.Sub(ResourceType.Hero, heroResource)
                    ---@param v HeroResource
                    for _, v in pairs(self.model.heroSort:GetItems()) do
                        if v.inventoryId == heroResource.inventoryId then
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
                            self.model.heroSort:RemoveByReference(v)
                        end
                    end
                end
            end

            InventoryUtils.Sub(ResourceType.Money, MoneyType.GOLD, self.heroEvolvePrice.gold)
            InventoryUtils.Sub(ResourceType.Money, MoneyType.MAGIC_POTION, self.heroEvolvePrice.magicPotion)
            InventoryUtils.Sub(ResourceType.Money, MoneyType.AWAKEN_BOOK, self.heroEvolvePrice.awakenBook)

            ---@param list List
            for _, list in pairs(self.dataHeroFood:GetItems()) do
                ---@param heroFood HeroFood
                for _, heroFood in pairs(list:GetItems()) do
                    zg.playerData:GetMethod(PlayerDataMethod.HERO_EVOLVE_FOOD):SubHeroFood(heroFood.heroFoodType, heroFood.star, heroFood.number)
                end
            end

            ---@param dict Dictionary
            for _, dict in pairs(self.dataOrbsSelect:GetItems()) do
                for i,v in pairs(dict:GetItems()) do
                    InventoryUtils.Sub(ResourceType.Money, i, v)
                end
            end

            self.heroMenuView:UpdateListHeroSort()

            self.model.heroResource.heroStar = self.model.heroResource.heroStar + 1

            local updateUI = function()
                self.heroMenuView.previewHeroMenu:PreviewHero(self.model.heroResource, HeroModelType.Basic)
                self.model.canSortHero = true

                if self.heroMenuView:CheckCanOpenEvolve(false) then
                    self:Hide()
                    self:Show()
                else
                    self.heroMenuView.tab:Select(1)
                end
            end

            if isAwaken == true then
                self.heroMenuView.previewHeroMenu:Awaken()
                zg.audioMgr:PlaySfxUi(SfxUiType.HERO_AWAKEN)
            else
                self.heroMenuView.previewHeroMenu:Evolve()
                zg.audioMgr:PlaySfxUi(SfxUiType.HERO_EVOLVE)
            end
            local data = {}
            data.awaken = isAwaken
            data.heroResource = self.model.heroResource
            data.isSummoner = false
            data.callbackClose = function()
                PopupMgr.HidePopup(UIPopupName.UIPopupEnhance)
                if rewardList:Count() > 0 then
                    PopupUtils.ShowRewardList(rewardList)

                    ---@param reward RewardInBound
                    for _, reward in pairs(heroEvolveInBound.rewardItems:GetItems()) do
                        reward:AddToInventory()
                    end
                    heroEvolveInBound.rewardItems:Clear()
                end
            end
            local callbackDelay = function()
                updateUI()
                touchObject:Enable()
            end
            PopupMgr.ShowPopupDelay(2, UIPopupName.UIPopupEnhance, data, nil, callbackDelay)
            heroEvolveOutBound.heroMaterials:Clear()
            self.dataMaterials:Clear()
            self.dataHeroFood:Clear()
            self.dataOrbsSelect:Clear()
            self.dataIdsSelect:Clear()
            self.heroMenuView:ChangeStatHero()
            if isInPentagram then
                zg.playerData:GetRaiseLevelHero():UpdateInEvolve()
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(OpCode.HERO_EVOLVE, heroEvolveOutBound, callback)
end

--- @return void
function UIHeroEvolve2:OnChangeHero()
    self.dataMaterials:Clear()
    self.dataHeroFood:Clear()
    self.dataOrbsSelect:Clear()
    self.dataIdsSelect:Clear()
    self:UpdateUI()
end

--- @return void
---@param view StatHeroEvolveChangeConfig
function UIHeroEvolve2:SetStat(view, base, upgrade)
    view.base.text = tostring(base)
    view.upgrade.text = UIUtils.SetColorString(UIUtils.color11, upgrade)
end

--- @return void
function UIHeroEvolve2:UpdateUI()
    ---@type HeroResource
    local heroResource = self.model.heroResource
    local star1 = heroResource.heroStar
    local star2 = heroResource.heroStar + 1
    local heroDataService = ResourceMgr.GetServiceConfig():GetHeroes()
    local heroLevelData1 = heroDataService:GetHeroSkillLevelData(star1)
    local heroLevelData2 = heroDataService:GetHeroSkillLevelData(star2)
    local heroDataEntry = heroDataService:GetHeroDataEntry(heroResource.heroId)

    self.config.textHeroName.text = LanguageUtils.LocalizeNameHero(heroResource.heroId)
    self.config.iconFaction.sprite = ResourceLoadUtils.LoadFactionIcon(ClientConfigUtils.GetFactionIdByHeroId(heroResource.heroId))
    self.config.iconClass.sprite = ResourceLoadUtils.LoadCLassIcon(ResourceMgr.GetHeroClassConfig():GetClass(heroResource.heroId))

    self.listSkillView:SetDataHeroEvolve(heroResource, heroResource.heroStar, true, true)
    if heroLevelData1 ~= nil and heroLevelData2 ~= nil then
        local isUnlock = false
        for i = 1, 4 do
            local lv1 = heroLevelData1.skillLevels:Get(i)
            local lv2 = heroLevelData2.skillLevels:Get(i)
            if heroDataEntry.allSkillDataDict:IsContainKey(i) and lv1 ~= lv2 then
                if lv2 > 1 then
                    isUnlock = false
                else
                    isUnlock = true
                end
            end
        end
        -----@type HeroLevelCapConfig
        --local heroLevelCap2 = ResourceMgr.GetHeroMenuConfig():GetHeroLevelCapDictionary(heroResource.heroStar + 1)
    --    self.config.textStatSkill.text = string.format(LanguageUtils.LocalizeCommon("hero_level_cap_to"),
    --            UIUtils.SetColorString(UIUtils.color2, tostring(heroLevelCap2.levelCap)))
    --    self.config.textStatSkill.gameObject:SetActive(true)
    --else
    --    self.config.textStatSkill.gameObject:SetActive(false)
    end

    ---@type HeroLevelCapConfig
    local heroLevelCap1 = ResourceMgr.GetHeroMenuConfig():GetHeroLevelCapDictionary(star1)
    ---@type HeroLevelCapConfig
    local heroLevelCap2 = ResourceMgr.GetHeroMenuConfig():GetHeroLevelCapDictionary(star2)

    ---@type Dictionary
    local statDict1 = ClientConfigUtils.GetBaseStatHero(heroResource.heroId, star1, heroResource.heroLevel)
    ---@type Dictionary
    local statDict2 = ClientConfigUtils.GetBaseStatHero(heroResource.heroId, star2, heroResource.heroLevel)
    self:SetStat(self.levelCap, heroLevelCap1.levelCap, heroLevelCap2.levelCap)
    self:SetStat(self.hp, statDict1:Get(StatType.HP), statDict2:Get(StatType.HP))
    self:SetStat(self.attack, statDict1:Get(StatType.ATTACK), statDict2:Get(StatType.ATTACK))
    self:SetStat(self.speed, statDict1:Get(StatType.SPEED), statDict2:Get(StatType.SPEED))


    --STAR
    local numberStar1 = heroResource.heroStar % 6
    local numberStar2 = (heroResource.heroStar + 1) % 6
    if numberStar1 == 0 then
        numberStar1 = 6
        self.config.buttonAwaken.gameObject:SetActive(true)
        self.config.buttonEvolve.gameObject:SetActive(false)
    else
        self.config.buttonAwaken.gameObject:SetActive(false)
        self.config.buttonEvolve.gameObject:SetActive(true)
    end
    if numberStar2 == 0 then
        numberStar2 = 6
    end
    --if heroResource.heroStar == 12 then
    --    numberStar2 = 6
    --end

    ---@type UnityEngine_Sprite
    local sprite1 = ResourceLoadUtils.LoadStarHeroEvolve(heroResource.heroStar)

    ---@type UnityEngine_Sprite
    local sprite2 = ResourceLoadUtils.LoadStarHeroEvolve(heroResource.heroStar + 1)
    local sizeStar1 = sprite1.border.x + sprite1.border.z
    local sizeStarDelta = sprite1.bounds.size.x * 100 - sizeStar1
    self.config.star1.sprite = sprite1
    self.config.star1.rectTransform.sizeDelta = U_Vector2(sizeStar1 + sizeStarDelta * (numberStar1 - 1), sprite1.bounds.size.y * 100)
    self.config.star2.sprite = sprite2
    self.config.star2.rectTransform.sizeDelta = U_Vector2(sizeStar1 + sizeStarDelta * (numberStar2 - 1), sprite2.bounds.size.y * 100)

    self:UpdateUIHeroMaterial()
end

--- @return void
function UIHeroEvolve2:UpdateUIHeroMaterial()
    self.heroEvolvePrice = ResourceMgr.GetHeroMenuConfig():GetHeroEvolvePriceConfig(self.model.heroResource.heroId, self.model.heroResource.heroStar + 1)
    if self.heroEvolvePrice ~= nil then
        if self.heroEvolvePrice.gold > 0 then
            self.config.textPriceGold.text = tostring(self.heroEvolvePrice.gold)
            self.config.textPriceGold.transform.parent.gameObject:SetActive(true)
        else
            self.config.textPriceGold.transform.parent.gameObject:SetActive(false)
        end
        if self.heroEvolvePrice.magicPotion > 0 then
            self.config.textPriceMagicPotion.text = tostring(self.heroEvolvePrice.magicPotion)
            self.config.textPriceMagicPotion.transform.parent.gameObject:SetActive(true)
        else
            self.config.textPriceMagicPotion.transform.parent.gameObject:SetActive(false)
        end
        if self.heroEvolvePrice.awakenBook > 0 then
            self.config.textPriceAwakenBook.text = tostring(self.heroEvolvePrice.awakenBook)
            self.config.textPriceAwakenBook.transform.parent.gameObject:SetActive(true)
        else
            self.config.textPriceAwakenBook.transform.parent.gameObject:SetActive(false)
        end

        local countView = self.materialConfig:Count()
        local countData1 = self.heroEvolvePrice.heroMaterialEvolveData:Count()
        local countData2 = self.heroEvolvePrice.orbEvolveData:Count()
        local countData = countData1 + countData2
        if countView < countData then
            for i = countView + 1, countData do
                local slot = i
                ---@type HeroMaterialIconView
                local material = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroMaterialIconView, self.config.heroMaterialParent)
                self.materialConfig:Add(material)
                material:AddListener(function()
                    self:OnSelectHeroMaterial(slot)
                end)
            end
        elseif countView > countData then
            local slotIndex = countView
            for i = countData + 1, countView do
                ---@type HeroMaterialIconView
                local material = self.materialConfig:Get(slotIndex)
                material:ReturnPool()
                self.materialConfig:RemoveByIndex(slotIndex)
                slotIndex = slotIndex - 1
            end
        end
        local temp = 0
        for i = 1, countData do
            local evolveData
            --XDebug.Log("HeroMaterialEvolveData".. LogUtils.ToDetail(heroMaterialEvolveData))
            local iconData
            local count = 0
            if i <= self.heroEvolvePrice.heroMaterialEvolveData:Count() then
                evolveData = self.heroEvolvePrice.heroMaterialEvolveData:Get(i)
                ---@type HeroIconData
                iconData = evolveData:GetHeroIconDataByHeroResource(self.model.heroResource)
                if self.dataMaterials:Get(i) ~= nil then
                    count = self.dataMaterials:Get(i):Count()
                end
                if self.dataHeroFood:Get(i) ~= nil then
                    ---@param heroFood HeroFood
                    for _, heroFood in pairs(self.dataHeroFood:Get(i):GetItems()) do
                        count = count + heroFood.number
                    end
                end
                temp = temp + 1
            else
                evolveData = self.heroEvolvePrice.orbEvolveData:Get(i - temp)
                iconData = evolveData:GetHeroIconDataByHeroResource(self.model.heroResource)
                if self.dataOrbsSelect:Get(i - temp) ~= nil then
                    for i, v in pairs(self.dataOrbsSelect:Get(i - temp):GetItems()) do
                        count = count + v
                    end
                end
            end
            ---@type HeroMaterialIconView
            local material = self.materialConfig:Get(i)
            material:SetIconData(iconData, count, evolveData.number)
            --XDebug.Log(LogUtils.ToDetail(iconData))
        end
    end
end

--- @return void
function UIHeroEvolve2:ResetDataMaterial()
    ---@param v List
    for i, v in pairs(self.dataMaterials:GetItems()) do
        v:Clear()
    end
    ---@param v List
    for i, v in pairs(self.dataHeroFood:GetItems()) do
        v:Clear()
    end
end

--- @return void
--- @param slot number
function UIHeroEvolve2:OnSelectHeroMaterial(slot)
    if self:CheckCanEvolve(true) == true then
        local evolveData

        if slot <= self.heroEvolvePrice.heroMaterialEvolveData:Count() then
            evolveData = self.heroEvolvePrice.heroMaterialEvolveData:Get(slot)
            self:ShowPopupHeroMaterial(slot, evolveData)
        else
            evolveData = self.heroEvolvePrice.orbEvolveData:Get(slot - self.heroEvolvePrice.heroMaterialEvolveData:Count())
            self:ShowPopupSelectOrb(slot, evolveData, slot - self.heroEvolvePrice.heroMaterialEvolveData:Count())
        end
    end
end

--- @param evolveData OrbEvolveData
function UIHeroEvolve2:ShowPopupSelectOrb(slot, evolveData, slotOrb)
    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    ---@type HeroIconData
    local iconData = self.materialConfig:Get(slot).iconData
    ---@type HeroMaterialIconView
    local material = self.materialConfig:Get(slot)

    local data = {}
    data.callbackClose = function ()
        PopupMgr.HidePopup(UIPopupName.UISelectOrb)
        material:ActiveEffectSelect(false)
    end
    local callbackSelect = function(listIdSelect, orbSelect)
        while self.dataOrbsSelect:Count() < slotOrb do
            self.dataOrbsSelect:Add(Dictionary())
        end

        local listIdSelect1 = self.dataOrbsSelect:Get(slotOrb)
            listIdSelect1:Clear()
        for i, v in pairs(orbSelect:GetItems()) do
            listIdSelect1:Add(i,v)
        end

        while self.dataIdsSelect:Count() < slotOrb do
            self.dataIdsSelect:Add(Dictionary())
        end
        ---@type Dictionary
        local orbSelect1 = self.dataIdsSelect:Get(slotOrb)
            orbSelect1:Clear()
        for i, v in pairs(listIdSelect:GetItems()) do
            orbSelect1:Add(i,v)
        end
        self:UpdateUIHeroMaterial()
        material:ActiveEffectSelect(false)
    end
    data.sortFaction = ClientConfigUtils.GetFactionIdByHeroId(self.model.heroResource.heroId)
    if iconData.faction ~= nil then
        data.isSortFaction = true
    else
        data.isSortFaction = false
    end
    data.maxNumber = evolveData.number
    data.callbackSelect = callbackSelect

    local listIdSelectTemp = Dictionary()
    if self.dataIdsSelect:Get(slotOrb) ~= nil then
        for i, v in pairs(self.dataIdsSelect:Get(slotOrb):GetItems()) do
            listIdSelectTemp:Add(i,v)
        end
    end

    local orbSelectTemp = Dictionary()
    if self.dataOrbsSelect:Get(slotOrb) ~= nil then
        for i, v in pairs(self.dataOrbsSelect:Get(slotOrb):GetItems()) do
            orbSelectTemp:Add(i,v)
        end
    end

    local allOrbSelectTemp = Dictionary()
    for _, v in pairs(self.dataOrbsSelect:GetItems()) do
        for i1, v1 in pairs(v:GetItems()) do
            if not allOrbSelectTemp:IsContainKey(i1) then
                allOrbSelectTemp:Add(i1,v1)
            else
                local number = allOrbSelectTemp:Get(i1) + v1
                allOrbSelectTemp:RemoveByKey(i1)
                allOrbSelectTemp:Add(i1, number)
            end
        end
    end

    data.listIdSelect = listIdSelectTemp
    data.orbSelect = orbSelectTemp
    data.allOrbSelect = allOrbSelectTemp
    data.idSlotCount = evolveData:GetSlotIdSelectByOrbId()

    PopupMgr.ShowPopup(UIPopupName.UISelectOrb, data)
    material:ActiveEffectSelect(true)
end

--- @return void
--- @param slot number
function UIHeroEvolve2:ShowPopupHeroMaterial(slot, evolveData)
    ---@type HeroMaterialIconView
    local material = self.materialConfig:Get(slot)
    local callbackSelect = function(listHeroResource, listFoodSelect)
        while self.dataMaterials:Count() < slot do
            self.dataMaterials:Add(List())
        end
        ---@type List
        local listHeroResourceCurrentSlot = self.dataMaterials:Get(slot)
        listHeroResourceCurrentSlot:Clear()
        for i, heroResource in pairs(listHeroResource:GetItems()) do
            listHeroResourceCurrentSlot:Add(heroResource)
        end

        while self.dataHeroFood:Count() < slot do
            self.dataHeroFood:Add(List())
        end
        ---@type List
        local listHeroFoodCurrentSlot = self.dataHeroFood:Get(slot)
        listHeroFoodCurrentSlot:Clear()
        for i, heroFood in pairs(listFoodSelect:GetItems()) do
            listHeroFoodCurrentSlot:Add(heroFood)
        end

        self:UpdateUIHeroMaterial()
        material:ActiveEffectSelect(false)
    end

    ---@type List
    local listAllSlotSelect = List()
    for _, v in pairs(self.dataMaterials:GetItems()) do
        for _, heroResource in pairs(v:GetItems()) do
            listAllSlotSelect:Add(heroResource)
        end
    end

    ---@type List
    local listAllHeroFoodSelect = List()
    for _, v in pairs(self.dataHeroFood:GetItems()) do
        for _, heroFood in pairs(v:GetItems()) do
            listAllHeroFoodSelect:Add(heroFood)
        end
    end
    ---@type HeroIconData
    local iconData = self.materialConfig:Get(slot).iconData
    PopupMgr.ShowPopup(UIPopupName.UISelectMaterialHeroes,
            { ["heroId"] = iconData.heroId, ["listAllSlotSelect"] = listAllSlotSelect, ["maxSelect"] = evolveData.number,
              ["sortFaction"] = iconData.faction, ["heroResourceIgnor"] = self.model.heroResource,
              ["sortStar"] = iconData.star, ["listCurrentSlotSelect"] = self.dataMaterials:Get(slot),
              ["listCurrentHeroFoodSelect"] = self.dataHeroFood:Get(slot), ["listAllHeroFoodSelect"] = listAllHeroFoodSelect,
              ["callbackClose"] = function ()
                  PopupMgr.HidePopup(UIPopupName.UISelectMaterialHeroes)
                  material:ActiveEffectSelect(false)
              end,
              ["callbackSelect"] = callbackSelect })
    material:ActiveEffectSelect(true)
end

--- @return boolean
---@param noti boolean
function UIHeroEvolve2:CheckMaterialEvolve(noti)
    local canEvolve = true
    for i = 1, self.heroEvolvePrice.heroMaterialEvolveData:Count() do
        -----@type HeroMaterialEvolveData
        local heroMaterialEvolveData = self.heroEvolvePrice.heroMaterialEvolveData:Get(i)
        local count = 0
        if self.dataMaterials:Count() >= i then
            count = count + self.dataMaterials:Get(i):Count()
        end
        if self.dataHeroFood:Count() >= i then
            ---@param v HeroFood
            for _, v in pairs(self.dataHeroFood:Get(i):GetItems()) do
                count = count + v.number
            end
        end
        if count < heroMaterialEvolveData.number then
            canEvolve = false
            break
        end
    end

    for i = 1, self.heroEvolvePrice.orbEvolveData:Count() do
        -----@type OrbEvolveData
        local orbEvolveData = self.heroEvolvePrice.orbEvolveData:Get(i)
        local count = 0
        if self.dataOrbsSelect:Count() >= i then
            for k, v in pairs(self.dataOrbsSelect:Get(i):GetItems()) do
                count = count + v
            end
        end
        if count < orbEvolveData.number then
            canEvolve = false
            break
        end
    end

    if canEvolve == false and noti == true then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("enough_hero_material"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end
    return canEvolve
end

--- @return boolean
---@param noti boolean
function UIHeroEvolve2:CheckCanEvolve(noti)
    if not self.model.heroResource:IsCanEvolveLevel() then
        if noti == true then
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("need_up_max_level"))
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        end
        return false
    elseif ClientConfigUtils.CheckHeroInTraining(self.model.heroResource.inventoryId) then
        if noti == true then
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("hero_in_training"))
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        end
        return false
    elseif not self.model.heroResource:IsCanEvolveStar() then
        if noti == true then
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("hero_max_star"))
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        end
        return false
    else
        return true
    end
end

--- @return void
function UIHeroEvolve2:OnClickEvolve(isAwaken)
    if self:CheckCanEvolve(true) == true then
        local evolve = function()
            if self:CheckMaterialEvolve(true) == true then
                local canRequest = InventoryUtils.IsEnoughMultiResourceRequirement(self.heroEvolvePrice:GetListResource(), true)
                if canRequest then
                    self:RequestEvolveHero(isAwaken)
                    zg.audioMgr:PlaySfxUi(SfxUiType.BUY)
                end
            end
        end
        if self.model.heroResource:IsConverting() then
            PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("notice_evolve_hero_converting"),
                    nil, evolve)
        else
            evolve()
        end
    end
end