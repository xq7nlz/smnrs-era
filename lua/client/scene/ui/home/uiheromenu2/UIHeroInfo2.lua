require "lua.client.scene.ui.common.prefabHeroInfo.PrefabHeroInfo2View"
require "lua.client.scene.ui.home.uiHeroMenu2.UISlotEquip"
require "lua.client.core.network.item.equipItem.EquipItemOutBound"
require "lua.client.core.network.item.upgradeItemHeroInfo.UpgradeItemEquipHeroOutBound"
require "lua.client.core.network.item.upgradeStone.UpgradeStoneInBound"
require "lua.client.core.network.item.upgradeStone.UpgradeStoneOutBound"
require "lua.client.scene.ui.common.TalentPopupView"

--- @class UIHeroInfo2
UIHeroInfo2 = Class(UIHeroInfo2)

--- @return void
--- @param transform UnityEngine_Transform
--- @param heroMenuView UIHeroMenu2View
function UIHeroInfo2:Ctor(transform, model, heroMenuView)
    --- @type UIHeroMenu2Model
    self.model = model
    --- @type UIHeroMenu2View
    self.heroMenuView = heroMenuView
    ---@type UIHeroInfo2Config
    self.config = UIBaseConfig(transform)
    ---@type PrefabHeroInfo2View
    self.prefabHeroInfoView = PrefabHeroInfo2View(self.config.prefabHeroInfo)
    ---@type HeroResource
    self.heroResource = nil
    ---@type number
    self.timeLevelUp = nil
    ---@type HeroLevelDataConfig
    self.heroLevelData = nil
    ---@type HeroLevelCapConfig
    self.heroLevelCap = nil
    ---@type number
    self.selectSlot = nil
    ---@type number
    self.typeSlot = nil

    ---@type UISlotEquip
    self.weapon = UISlotEquip(self.config.weapon)
    ---@type UISlotEquip
    self.armor = UISlotEquip(self.config.armor)
    ---@type UISlotEquip
    self.helm = UISlotEquip(self.config.hat)
    ---@type UISlotEquip
    self.accessory = UISlotEquip(self.config.ring)
    ---@type UISlotEquip
    self.artifact = UISlotEquip(self.config.chain)
    ---@type ItemIconView
    self.talentSlot = ItemIconView()
    ---@type ItemIconView
    self.stone = nil
    --- @type TalentPopupView
    self.talentPopup = TalentPopupView(self.config.talentPopup)
    self.talentPopup:ToggleShow()
    ---@type UnityEngine_GameObject
    self.particleUnlock = ResourceLoadUtils.LoadUIEffect("fx_ui_equip_unlock", self.config.fx)
    ---@type UnityEngine_GameObject
    self.particleLock = ResourceLoadUtils.LoadUIEffect("fx_ui_equip_iconlock", self.config.fx)
    -----@type UnityEngine_GameObject
    --self.particleFlip = ResourceLoadUtils.LoadUIEffect("fx_ui_equip_flip", self.config.fx)
    self.faction = nil
    self.class = nil
    ---@type PlayerRaiseLevelInbound
    self.raiseLevelHeroInbound = nil
    ---@type UISlotEquip[]
    self.slotEquip = {}
    self.slotEquip[SlotEquipmentType.Weapon] = self.weapon
    self.slotEquip[SlotEquipmentType.Armor] = self.armor
    self.slotEquip[SlotEquipmentType.Helm] = self.helm
    self.slotEquip[SlotEquipmentType.Accessory] = self.accessory
    self.slotEquip[SlotEquipmentType.Artifact] = self.artifact

    ---@type function
    self.currentRequest = nil
    ---@type EquipItemOutBound
    self.equipItemOutBound = EquipItemOutBound()
    ---@type UpgradeItemEquipHeroOutBound
    self.upgradeItemEquipHeroOutBound = UpgradeItemEquipHeroOutBound()

    ---@type ItemCollectionInBound
    self.itemCollectionInBound = nil

    self.config.buttonAutoEquip.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:AutoEquip()
    end)
    self.config.buttonUnEquip.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:UnEquip()
    end)
    self.weapon.config.button.onClick:AddListener(function()
        self:SelectSlot(SlotEquipmentType.Weapon)
    end)
    self.armor.config.button.onClick:AddListener(function()
        self:SelectSlot(SlotEquipmentType.Armor)
    end)
    self.helm.config.button.onClick:AddListener(function()
        self:SelectSlot(SlotEquipmentType.Helm)
    end)
    self.accessory.config.button.onClick:AddListener(function()
        self:SelectSlot(SlotEquipmentType.Accessory)
    end)
    self.artifact.config.button.onClick:AddListener(function()
        self:SelectSlot(SlotEquipmentType.Artifact)
    end)
    self.config.buttonStone.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:SelectStone()
    end)

    self.config.talentSlot.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:ShowTalentPopup()
    end)

    self.config.buttonUpLv.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickLevelUp()
    end)
    self.config.buttonLvMax.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickMaxLevel()
    end)
    self.config.buttonEvolve.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEvolve()
    end)

    UIUtils.SetTrigger(self.config.eventTriggerLevelUp, nil, function()
        self:OnPointExitLevelUp()
    end, function()
        self:OnClickLevelUp()
    end, function()
        self.config.animatorLevelUp:SetTrigger("Normal")
        self:OnPointExitLevelUp()
    end, nil, function()
        self.config.animatorLevelUp:SetTrigger("Pressed")
        self:OnPointEnterLevelUp()
    end)
end

--- @return void
function UIHeroInfo2:InitLocalization()
    self.config.localizeLvToMax.text = LanguageUtils.LocalizeCommon("level_to_max")
    self.config.localizeLvUp.text = LanguageUtils.LocalizeCommon("level_up")
    self.config.localizeEvolve.text = LanguageUtils.LocalizeCommon("evolve")
    self.config.localizeLevelMax.text = LanguageUtils.LocalizeCommon("hero_info_max_level")
    self.config.localizeAutoEquip.text = LanguageUtils.LocalizeCommon("auto_equip")
    self.config.localizeUnEquip.text = LanguageUtils.LocalizeCommon("unequip")
    self.config.textLockLevel.text = string.format(LanguageUtils.LocalizeCommon("unlock_level"), 40)
    self.config.heroInRaiseLevelText.text = LanguageUtils.LocalizeCommon("hero_in_raise_level")
end

--- @return void
function UIHeroInfo2:Show()
    self.heroMenuView:SetButtonNextHero(self.config.buttonUpLv.transform.position)
    self.playerRaiseInbound = zg.playerData:GetRaiseLevelHero()
    self.raiseLevelHeroInbound = zg.playerData:GetRaiseLevelHero()
    if self.model.heroResource.inventoryId == nil then
        self.config.equipment:SetActive(false)
        self.config.middleContent:SetActive(false)
    else
        self.config.equipment:SetActive(true)
        self.config.middleContent:SetActive(true)
    end
    self.itemCollectionInBound = zg.playerData:GetMethod(PlayerDataMethod.ITEM_COLLECTION)

    self:UpdateUIInfo()

    self:UpdateUIEquip()
end

--- @return void
function UIHeroInfo2:Hide()
    self.talentPopup:Disable()
    self:CheckRequestLevelUp()
    self.prefabHeroInfoView:OnHide()
    PopupUtils.CheckAndHideSkillPreview()
    self:HideEquip()
end

--- @return void
function UIHeroInfo2:OnPointEnterLevelUp()
    self:OnPointExitLevelUp()
    self.coroutineLevelUp = Coroutine.start(function()
        coroutine.waitforseconds(0.5)
        while (self.model.heroResource.heroLevel < self.heroLevelCap.levelCap) do
            self:OnClickLevelUp()
            self.config.animatorLevelUp:SetTrigger("Pressed")
            coroutine.waitforseconds(0.1)
        end
    end)
end

--- @return void
function UIHeroInfo2:OnPointExitLevelUp()
    if self.coroutineLevelUp ~= nil then
        Coroutine.stop(self.coroutineLevelUp)
        self.coroutineLevelUp = nil
    end
end

--- @return void
function UIHeroInfo2:CheckRequestLevelUp()
    if self.heroResource ~= nil then
        local callback = function(result)
            local onSuccess = function()

            end
            local onFailed = function(logicCode)
                SmartPoolUtils.LogicCodeNotification(logicCode)
            end
            NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
        end
        NetworkUtils.Request(OpCode.HERO_LEVEL_UP, UnknownOutBound.CreateInstance(PutMethod.Long, self.heroResource.inventoryId, PutMethod.Short, self.heroResource.heroLevel), callback)
        self.heroResource = nil
    end
    if self.up ~= nil then
        Coroutine.stop(self.up)
        self.up = nil
    end
end

--- @return void
function UIHeroInfo2:DelayCheckRequestLevelUp()
    self.timeLevelUp = zg.timeMgr:GetServerTime()
    if self.up == nil then
        self.up = Coroutine.start(function()
            while zg.timeMgr:GetServerTime() - self.timeLevelUp <= 1 do
                coroutine.waitforendofframe()
            end
            self:CheckRequestLevelUp()
            self.up = nil
        end)
    end
end

--- @return void
function UIHeroInfo2:OnChangeHero()
    self:CheckRequestLevelUp()

    self:UpdateUIInfo()

    self:UpdateUIEquip()
end

--- @return void
function UIHeroInfo2:UpdateUITalent()
    self.config.talentNotifi:SetActive(self:HasTalentNotification())

    if self.model.heroResource.heroStar < 13 then
        self.talentPopup:Disable()
        return
    end

    self.talentPopup:UpdateAllUITalent(self.model.heroResource)
end

function UIHeroInfo2:HasTalentNotification()
    for i = SlotEquipmentType.Talent, SlotEquipmentType.Talent do
        if self.model.heroResource.heroItem:Get(i) == nil and self.model.heroResource.heroStar >= 13 then
            return true
        end
    end
    return false
end

function UIHeroInfo2:ShowHeroUpgradeResourceNumber(number, moneyType)
    return ClientConfigUtils.FormatTextAPB(number, InventoryUtils.Get(ResourceType.Money, moneyType))
end

---@param heroLevelData HeroLevelDataConfig
function UIHeroInfo2:ShowHeroUpgradeResource(heroLevelData)
    local temp = Dictionary()
    if heroLevelData.magicPotion and heroLevelData.magicPotion > 0 then
        temp:Add(MoneyType.MAGIC_POTION, heroLevelData.magicPotion)
    end
    if heroLevelData.ancientPotion and heroLevelData.ancientPotion > 0 then
        temp:Add(MoneyType.ANCIENT_POTION, heroLevelData.ancientPotion)
    end
    if heroLevelData.awakenBook and heroLevelData.awakenBook > 0 then
        temp:Add(MoneyType.AWAKEN_BOOK, heroLevelData.awakenBook)
    end

    self.config.bgUpgrade2Resource:SetActive(temp:Count() < 2)
    self.config.bgUpgrade3Resource:SetActive(not (temp:Count() < 2))

    self.config.awakenBook:SetActive(false)
    self.config.ancientPotion:SetActive(false)

    self.config.textGold.text = ClientConfigUtils.FormatTextAPB(self.heroLevelData.gold, InventoryUtils.Get(ResourceType.Money, MoneyType.GOLD))
    if temp:Count() == 3 then
        self.config.awakenBook:SetActive(true)
        self.config.ancientPotion:SetActive(true)
        self.config.textGem.text = self:ShowHeroUpgradeResourceNumber(temp:Get(MoneyType.MAGIC_POTION), MoneyType.MAGIC_POTION)
        self.config.textAncientPotion.text = self:ShowHeroUpgradeResourceNumber(temp:Get(MoneyType.ANCIENT_POTION), MoneyType.ANCIENT_POTION)
        self.config.textAwakenBook.text = self:ShowHeroUpgradeResourceNumber(temp:Get(MoneyType.AWAKEN_BOOK), MoneyType.AWAKEN_BOOK)
    elseif temp:Count() == 2 then
        for k, v in pairs(temp:GetItems()) do
            if k == MoneyType.MAGIC_POTION then
                self.config.iconMagicPotion.sprite = ResourceLoadUtils.LoadMoneyIcon(MoneyType.MAGIC_POTION)
                self.config.textGem.text = self:ShowHeroUpgradeResourceNumber(v, k)
            elseif k == MoneyType.ANCIENT_POTION then
                self.config.ancientPotion:SetActive(true)
                self.config.textAncientPotion.text = self:ShowHeroUpgradeResourceNumber(v, k)
            elseif k == MoneyType.AWAKEN_BOOK then
                self.config.awakenBook:SetActive(true)
                self.config.textAwakenBook.text = self:ShowHeroUpgradeResourceNumber(v, k)
            end
        end
    else
        for k, v in pairs(temp:GetItems()) do
            if k == MoneyType.MAGIC_POTION then
                self.config.iconMagicPotion.sprite = ResourceLoadUtils.LoadMoneyIcon(MoneyType.MAGIC_POTION)
                self.config.textGem.text = self:ShowHeroUpgradeResourceNumber(v, k)
            elseif k == MoneyType.ANCIENT_POTION then
                self.config.iconMagicPotion.sprite = ResourceLoadUtils.LoadMoneyIcon(MoneyType.ANCIENT_POTION)
                self.config.textGem.text = self:ShowHeroUpgradeResourceNumber(v, k)
            elseif k == MoneyType.AWAKEN_BOOK then
                self.config.iconMagicPotion.sprite = ResourceLoadUtils.LoadMoneyIcon(MoneyType.AWAKEN_BOOK)
                self.config.textGem.text = self:ShowHeroUpgradeResourceNumber(v, k)
            end
        end
    end
end

--- @return void
function UIHeroInfo2:UpdateUIInfo()
    ---@type HeroResource
    local heroResource = self.model.heroResource
    local heroTier = ResourceMgr.GetHeroesConfig():GetHeroTier():GetHeroTier(heroResource.heroId)

    --- @type UnityEngine_Sprite
    local iconRankSprite
    local iconRankSpriteName = "icon"
    if heroTier ~= nil and heroTier > 3 then
        iconRankSpriteName = string.format("%s_%s", iconRankSpriteName, heroTier)
    else
        heroTier = 3
        iconRankSpriteName = string.format("%s_%s", iconRankSpriteName, heroTier)
    end
    iconRankSprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconHeroCardBorder, iconRankSpriteName)
    self.config.iconRank.sprite = iconRankSprite

    self.heroLevelData = ResourceMgr.GetHeroMenuConfig():GetHeroLevelDataDictionary(heroResource.heroLevel + 1)
    self.heroLevelCap = ResourceMgr.GetHeroMenuConfig():GetHeroLevelCapDictionary(heroResource.heroStar)
    if self.heroLevelData ~= nil then
        self:ShowHeroUpgradeResource(self.heroLevelData)
        self.config.iconMagicPotion:SetNativeSize()
    end
    if self.heroLevelCap ~= nil then
        local isInRaisedHero = self.raiseLevelHeroInbound:IsInRaisedSlot(heroResource.inventoryId)
        if heroResource.heroLevel >= self.heroLevelCap.levelCap then
            self.config.lvUp:SetActive(false)
            self.config.lvMax:SetActive(not isInRaisedHero)
            self.config.buttonLvMax.gameObject:SetActive(false)
            self.config.buttonEvolve.gameObject:SetActive(not isInRaisedHero)
            self.config.heroInRaiseLevelText.gameObject:SetActive(isInRaisedHero)
            self.config.buttonUpLv.gameObject:SetActive(false)
        else
            self.config.lvMax:SetActive(false)
            self.config.buttonEvolve.gameObject:SetActive(false)
            if isInRaisedHero then
                self.config.lvUp:SetActive(false)
                self.config.buttonUpLv.gameObject:SetActive(false)
                self.config.heroInRaiseLevelText.gameObject:SetActive(true)
                self.config.buttonLvMax.gameObject:SetActive(false)
            else
                self.config.lvUp:SetActive(true)
                self.config.buttonUpLv.gameObject:SetActive(true)
                self.config.heroInRaiseLevelText.gameObject:SetActive(false)
                ---@type HeroLevelDataConfig
                local heroLevelData = ResourceMgr.GetHeroMenuConfig():GetHeroLevelDataDictionary(self.model.heroResource.heroLevel + 1)
                if heroLevelData.ancientPotion > 0 then
                    self.config.buttonLvMax.gameObject:SetActive(false)
                else
                    self.config.buttonLvMax.gameObject:SetActive(true)
                end
            end
        end
    end
    self.prefabHeroInfoView:SetData(heroResource)
end

--- @return void
function UIHeroInfo2:UpdateStatHeroInfo()
    self.prefabHeroInfoView:SetData(self.model.heroResource)
end

--- @return void
function UIHeroInfo2:UpdateUIUnlockStone()
    if self.model.heroResource.heroLevel >= 40 then
        self.config.textLockLevel.gameObject:SetActive(false)
        self.particleLock:SetActive(true)
    else
        self.config.textLockLevel.gameObject:SetActive(true)
    end
end

--- @return void
function UIHeroInfo2:UpLevelTo(levelTo)
    local currentGold = InventoryUtils.Get(ResourceType.Money, MoneyType.GOLD)
    local currentMagicPotion = InventoryUtils.Get(ResourceType.Money, MoneyType.MAGIC_POTION)
    local currentAncientPotion = InventoryUtils.Get(ResourceType.Money, MoneyType.ANCIENT_POTION)
    local currentAwakenBook = InventoryUtils.Get(ResourceType.Money, MoneyType.AWAKEN_BOOK) or 0
    local enoughGold = false
    local enoughMagicPotion = false
    local enoughAncientPotion = false
    local enoughAwakenBook = false
    local gold = 0
    local magicPotion = 0
    local ancientPotion = 0
    local awakenBook = 0
    local levelCanUp = self.model.heroResource.heroLevel
    for i = self.model.heroResource.heroLevel + 1, levelTo do
        ---@type HeroLevelDataConfig
        local heroLevelData = ResourceMgr.GetHeroMenuConfig():GetHeroLevelDataDictionary(i)
        if not heroLevelData.awakenBook then
            heroLevelData.awakenBook = 0
        end
        enoughGold = currentGold - gold < heroLevelData.gold
        enoughMagicPotion = currentMagicPotion - magicPotion < heroLevelData.magicPotion
        enoughAncientPotion = currentAncientPotion - ancientPotion < heroLevelData.ancientPotion
        enoughAwakenBook = currentAwakenBook - awakenBook < heroLevelData.awakenBook
        if enoughGold or enoughMagicPotion or enoughAncientPotion or enoughAwakenBook then
            break
        else
            gold = gold + heroLevelData.gold
            magicPotion = magicPotion + heroLevelData.magicPotion
            ancientPotion = ancientPotion + heroLevelData.ancientPotion
            awakenBook = awakenBook + heroLevelData.awakenBook
            levelCanUp = levelCanUp + 1
        end
    end
    if levelCanUp > self.model.heroResource.heroLevel then
        InventoryUtils.Sub(ResourceType.Money, MoneyType.GOLD, gold)
        InventoryUtils.Sub(ResourceType.Money, MoneyType.MAGIC_POTION, magicPotion)
        InventoryUtils.Sub(ResourceType.Money, MoneyType.ANCIENT_POTION, ancientPotion)
        InventoryUtils.Sub(ResourceType.Money, MoneyType.AWAKEN_BOOK, awakenBook)
        self.heroResource = self.model.heroResource
        self.heroResource.heroLevel = levelCanUp
        self.playerRaiseInbound:UpdateLowestLevel(self.heroResource)
        if self.heroResource.heroLevel == 40 then
            self:CheckRequestLevelUp()
        else
            self:DelayCheckRequestLevelUp()
        end
        self.model.canSortHero = true
        if levelCanUp == self.heroLevelCap.levelCap then
            self.heroMenuView.previewHeroMenu:LevelUpMax()
        else
            self.heroMenuView.previewHeroMenu:LevelUp()
        end
        zg.audioMgr:PlaySfxUi(SfxUiType.HERO_LEVEL_UP)
        self:UpdateUIInfo()
        self.heroMenuView:ChangeStatHero()
        self:UpdateUIUnlockStone()
    else
        ---@type HeroLevelDataConfig
        local heroLevelData = ResourceMgr.GetHeroMenuConfig():GetHeroLevelDataDictionary(self.model.heroResource.heroLevel + 1)
        local listReward = List()
        listReward:Add(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.GOLD, heroLevelData.gold))
        listReward:Add(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.MAGIC_POTION, heroLevelData.magicPotion))
        listReward:Add(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.ANCIENT_POTION, heroLevelData.ancientPotion))
        listReward:Add(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.AWAKEN_BOOK, heroLevelData.awakenBook))
        InventoryUtils.IsEnoughMultiResourceRequirement(listReward, true)
    end
end

--- @return void
function UIHeroInfo2:OnClickLevelUp()
    self:UpLevelTo(self.model.heroResource.heroLevel + 1)
end

--- @return void
function UIHeroInfo2:OnClickMaxLevel()
    local nextLevel = nil
    for i = self.model.heroResource.heroLevel + 1, self.heroLevelCap.levelCap do
        ---@type HeroLevelDataConfig
        local heroLevelData = ResourceMgr.GetHeroMenuConfig():GetHeroLevelDataDictionary(i)
        if heroLevelData.ancientPotion > 0 then
            break
        else
            nextLevel = i
        end
    end
    if nextLevel ~= nil then
        self:UpLevelTo(nextLevel)
    end
end

--- @return void
function UIHeroInfo2:OnClickEvolve()
    if self.heroMenuView:CheckCanOpenEvolve(true) == true then
        self.heroMenuView.tab:Select(2)
    end
end

--- @return void
function UIHeroInfo2:UpdateFaction()
    --self.config.bgFaction.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.bgFactions, ClientConfigUtils.GetFactionIdByHeroId(self.model.heroResource.heroId))
end

--- @return void
function UIHeroInfo2:UpdateUIEquip()
    self.faction = ClientConfigUtils.GetFactionIdByHeroId(self.model.heroResource.heroId)
    self.class = ResourceMgr.GetHeroClassConfig():GetClass(self.model.heroResource.heroId)
    self.particleUnlock:SetActive(false)
    self.particleLock:SetActive(false)
    for i = 1, 5 do
        ---@type UISlotEquip
        local slot = self.slotEquip[i]
        local idItem
        if self.model.heroResource.heroItem:IsContainKey(i) and self.model.heroResource.heroItem:Get(i) > 0 then
            idItem = self.model.heroResource.heroItem:Get(i)
        end
        if idItem ~= nil and idItem > 0 then
            if slot.itemEquipView == nil then
                slot.itemEquipView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.ItemIconView, slot.config.transform)
            end
            slot.itemEquipView.config.gameObject:SetActive(true)
            local sortId = idItem
            if i <= 4 then
                -- equipment
                slot.itemEquipView:SetIconData(ItemIconData.CreateInstance(ResourceType.ItemEquip, idItem))
                sortId = self:GetIdMaxTier(i, idItem)
            elseif i == 5 then
                -- artifact
                slot.itemEquipView:SetIconData(ItemIconData.CreateInstance(ResourceType.ItemArtifact, idItem))
                sortId = self:GetIdMaxArtifact(idItem)
            end
            if sortId == idItem then
                slot.itemEquipView:ActiveNotification(false)
            else
                slot.itemEquipView:ActiveNotification(true)
            end
        else
            if slot.itemEquipView ~= nil then
                slot.itemEquipView:ReturnPool()
                slot.itemEquipView = nil
            end
            ---@type List
            local listItem
            if i <= 4 then
                listItem = InventoryUtils.GetEquipment(i)
            else
                listItem = InventoryUtils.GetArtifact()
            end
            slot:ActiveAddImage(listItem:Count() > 0)
        end
    end

    self:UpdateUIStone()

    self:UpdateUITalent()
end

function UIHeroInfo2:UpdateUIStone()
    if self.model.heroResource.heroItem:IsContainKey(SlotEquipmentType.Stone) and self.model.heroResource.heroItem:Get(SlotEquipmentType.Stone) > 0 then
        local idItem = self.model.heroResource.heroItem:Get(SlotEquipmentType.Stone)
        if self.stone == nil then
            self.stone = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.ItemIconView, self.config.itemEquipInfoStone)
        end
        self.stone.config.gameObject:SetActive(true)
        self.stone:SetIconData(ItemIconData.CreateInstance(ResourceType.ItemStone, idItem))
    else
        if self.stone ~= nil then
            self.stone.config.gameObject:SetActive(false)
        end
        self:UpdateUIUnlockStone()
    end
end

---@return ResourceType
function UIHeroInfo2:GetResourceTypeBySlot(slotId)
    if slotId > 0 and slotId < 5 then
        return ResourceType.ItemEquip
    elseif slotId == 5 then
        return ResourceType.ItemArtifact
    elseif slotId == 6 then
        return ResourceType.ItemStone
    end
end

---@return void
function UIHeroInfo2:SetEquipSlot(slotId, id)
    local idItemSlot = self.model.heroResource.heroItem:Get(slotId)
    if idItemSlot ~= id then
        ---@type ResourceType
        local type = self:GetResourceTypeBySlot(slotId)

        if idItemSlot ~= nil and idItemSlot > 0 then
            InventoryUtils.Add(type, idItemSlot, 1)                         -- RETURN ITEM TO INVENTORY
            if id == nil or id <= 0 then
                -- UN EQUIP
                self.model.heroResource.heroItem:RemoveByKey(slotId)
                self.equipItemOutBound.listData:Add(EquipItemRecordOutBound(self.model.heroResource.inventoryId, slotId, -1))
            end
        end

        if id ~= nil and id > 0 then
            -- EQUIP
            InventoryUtils.Sub(type, id, 1)
            self.model.heroResource.heroItem:Add(slotId, id)
            self.equipItemOutBound.listData:Add(EquipItemRecordOutBound(self.model.heroResource.inventoryId, slotId, id))
        end
    end
end

---@return void
function UIHeroInfo2:AutoEquip()
    for i = 1, 4 do
        local idItem
        if self.model.heroResource.heroItem:IsContainKey(i) and self.model.heroResource.heroItem:Get(i) > 0 then
            idItem = self.model.heroResource.heroItem:Get(i)
        end
        local sortId = self:GetIdMaxTier(i, idItem)
        if sortId ~= nil then
            self:SetEquipSlot(i, sortId)
        end
    end

    -- artifact
    local idItem
    if self.model.heroResource.heroItem:IsContainKey(SlotEquipmentType.Artifact) and self.model.heroResource.heroItem:Get(SlotEquipmentType.Artifact) > 0 then
        idItem = self.model.heroResource.heroItem:Get(SlotEquipmentType.Artifact)
    end
    local sortId = self:GetIdMaxArtifact(idItem)
    if sortId ~= nil then
        self:SetEquipSlot(SlotEquipmentType.Artifact, sortId)
    end
    self:CheckRequest(self.CheckRequestEquipItem, true)
    self:UpdateUIEquip()
    self.heroMenuView:ChangeStatHero()
    self:UpdateStatHeroInfo()
end

---@return void
function UIHeroInfo2:UnEquip()
    for i = 1, 4 do
        if self.model.heroResource.heroItem:IsContainKey(i) and self.model.heroResource.heroItem:Get(i) > 0 then
            self:SetEquipSlot(i, nil)
        end
    end

    -- artifact
    if self.model.heroResource.heroItem:IsContainKey(SlotEquipmentType.Artifact) and self.model.heroResource.heroItem:Get(SlotEquipmentType.Artifact) > 0 then
        self:SetEquipSlot(SlotEquipmentType.Artifact, nil)
    end
    self:CheckRequest(self.CheckRequestEquipItem, true)
    self:UpdateUIEquip()
    self.heroMenuView:ChangeStatHero()
    self:UpdateStatHeroInfo()
end

---@return number
---@param equipmentType number
---@param idDefault number
function UIHeroInfo2:GetIdMaxTier(equipmentType, idDefault)
    local items = InventoryUtils.GetEquipment(equipmentType, 1)
    local count = items:Count()
    local sortId = idDefault
    local tier = -1
    if sortId ~= nil then
        tier = ResourceMgr.GetServiceConfig():GetItems().equipmentDataEntries:Get(sortId).tier
    end
    if count > 0 then
        local id = items:Get(1)
        local newTier = ResourceMgr.GetServiceConfig():GetItems().equipmentDataEntries:Get(id).tier
        if sortId == nil or (newTier > tier) or (newTier == tier and (ResourceMgr.GetServiceConfig():GetItems().equipmentDataEntries:IsContainKey(sortId - 1) or ResourceMgr.GetServiceConfig():GetItems().equipmentDataEntries.IsContainKey(sortId + 1))) then
            sortId = id
            tier = newTier
        end
    end
    return sortId
end

---@return number
---@param idDefault number
function UIHeroInfo2:GetIdMaxArtifact(idDefault)
    local items = InventoryUtils.GetArtifact(1)
    local count = items:Count()
    local sortId = idDefault
    if count > 0 then
        local id = items:Get(1)
        if sortId ~= nil then
            local tempId = items:Get(1)
            if sortId ~= tempId then
                local artifactDataEntries = ResourceMgr.GetServiceConfig():GetItems().artifactDataEntries
                local item1 = artifactDataEntries:Get(sortId)
                local item2 = artifactDataEntries:Get(tempId)
                if (item2.rarity > item1.rarity) or (item2.rarity == item1.rarity and item2.star > item1.star) then
                    sortId = tempId
                end
            end
        else
            sortId = id
        end
    end
    return sortId
end

---@return void
function UIHeroInfo2:GetNumberSet(type, idItem)
    local numberSet
    ---@type table
    local itemData = ResourceMgr.GetServiceConfig():GetItemData(type, idItem)
    if itemData.setId ~= nil then
        for i = 1, 4 do
            if self.model.heroResource.heroItem:IsContainKey(i) and self.model.heroResource.heroItem:Get(i) > 0 then
                local tempIdItem = self.model.heroResource.heroItem:Get(i)
                ---@type EquipmentDataEntry
                local equipmentData = ResourceMgr.GetServiceConfig():GetItemData(ResourceType.ItemEquip, tempIdItem)
                if itemData.setId == equipmentData.setId then
                    if numberSet == nil then
                        numberSet = 1
                    else
                        numberSet = numberSet + 1
                    end
                end
            end
        end
    end
    return numberSet
end

---@return void
---@param slotEquip SlotEquipmentType
function UIHeroInfo2:SelectSlot(slotEquip)
    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    self.selectSlot = slotEquip
    if slotEquip <= 4 then
        self.typeSlot = ResourceType.ItemEquip
    elseif slotEquip == 5 then
        self.typeSlot = ResourceType.ItemArtifact
    end
    --XDebug.Log("self.model.heroResource.heroItem" .. LogUtils.ToDetail(self.model.heroResource.heroItem:GetItems()))
    if self.model.heroResource.heroItem:IsContainKey(slotEquip) and self.model.heroResource.heroItem:Get(slotEquip) > 0 then
        local idItem = self.model.heroResource.heroItem:Get(slotEquip)
        local type = self.typeSlot
        local callbackRemove = function()
            self:RemoveItem()
        end
        local callbackReplace = function()
            self:ReplaceItem()
        end
        local callbackUpgrade
        if self.typeSlot == ResourceType.ItemEquip then
            if ResourceMgr.GetServiceConfig():GetItems().equipmentDataEntries:IsContainKey(idItem + 1) then
                ---

                --- @type FeatureConfigInBound
                local featureConfigInBound = zg.playerData:GetMethod(PlayerDataMethod.FEATURE_CONFIG)
                local remoteConfigNewEquipment = featureConfigInBound:GetFeatureConfigInBound(FeatureType.ITEM_REVOLUTION)
                local isShowNewEquipment = remoteConfigNewEquipment:IsAvailableToGoFeature(false)

                ---@type EquipmentDataEntry
                local equipmentDataConfig = ResourceMgr.GetServiceConfig():GetItems()
                                                       .equipmentDataEntries:Get(idItem + 1)

                if equipmentDataConfig ~= nil and (isShowNewEquipment or not equipmentDataConfig.isNewEquipment) then
                    callbackUpgrade = function()
                        local callbackComplete = function(id)
                            self.model.heroResource.heroItem:Add(slotEquip, id)
                            self.upgradeItemEquipHeroOutBound.listDataEquipment:Add(UpgradeEquipmentHeroInfoOutBound(self.model.heroResource.inventoryId, id))
                            self:UpdateUIEquip()
                            self:CheckRequest(self.CheckRequestUpgradeItemEquip, true)
                            self.heroMenuView:ChangeStatHero()
                            self:UpdateStatHeroInfo()
                        end
                        PopupMgr.HidePopup(UIPopupName.UIItemPreview)
                        PopupMgr.ShowPopup(UIPopupName.UIFastForge, { ["idItem"] = idItem, ["callbackComplete"] = callbackComplete })
                    end
                else
                end

                ---
            else
                --callbackUpgrade = function()
                --    -- TODO need check localize or logic code
                --    SmartPoolUtils.ShowShortNotification("Max item level")
                --end
            end
        elseif self.typeSlot == ResourceType.ItemArtifact then
            if ResourceMgr.GetServiceConfig():GetItems().artifactDataEntries:IsContainKey(idItem + 1) then
                callbackUpgrade = function()
                    self:CheckRequest()
                    ---@type HeroResource
                    local heroResource = self.model.heroResource
                    local callbackComplete = function(id)
                        heroResource.heroItem:Add(SlotEquipmentType.Artifact, id)
                        --self:UpdateUIEquip()
                        --self.heroMenuView:ChangeStatHero()
                        --self:UpdateStatHeroInfo()
                    end
                    local callbackClose = function()
                        PopupMgr.ShowAndHidePopup(UIPopupName.UIHeroMenu2, nil, UIPopupName.UIUpgradeArtifact)
                    end
                    PopupMgr.HidePopup(UIPopupName.UIHeroMenu2)
                    PopupMgr.HidePopup(UIPopupName.UIItemPreview)
                    PopupMgr.ShowPopup(UIPopupName.UIUpgradeArtifact, { ["heroResource"] = self.model.heroResource, ["callbackComplete"] = callbackComplete, ["callbackClose"] = callbackClose })
                end
            else
                --callbackUpgrade = function()
                --    -- TODO need check localize or logic code
                --    SmartPoolUtils.ShowShortNotification("Max artifact level")
                --end
            end
        end
        local button1 = { ["name"] = LanguageUtils.LocalizeCommon("remove"), ["callback"] = callbackRemove }
        local button2
        if callbackUpgrade ~= nil then
            button2 = { ["name"] = LanguageUtils.LocalizeCommon("upgrade"), ["callback"] = callbackUpgrade }
        end

        PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = { ["type"] = type, ["id"] = idItem, ["setNumber"] = self:GetNumberSet(type, idItem),
                                                                      ["class"] = self.class, ["faction"] = self.faction, ["heroId"] = self.model.heroResource.heroId,
                                                                      ["callbackReplace"] = callbackReplace,
                                                                      ["button1"] = button1,
                                                                      ["button2"] = button2 } })
    else
        local callbackSelectItem = function(id)
            self:PreviewUseItem(id)
        end
        PopupMgr.ShowPopup(UIPopupName.UISelectItemInventory,
                { ["type"] = self.typeSlot, ["slot"] = self.selectSlot, ["callbackSelectItem"] = callbackSelectItem, ["faction"] = self.faction })
    end
end

---@return void
function UIHeroInfo2:RemoveItem()
    PopupMgr.HidePopup(UIPopupName.UIItemPreview)
    self:SetEquipSlot(self.selectSlot, nil)
    self:CheckRequest(self.CheckRequestEquipItem, true)
    self:UpdateUIEquip()
    self.heroMenuView:ChangeStatHero()
    self:UpdateStatHeroInfo()
end

---@return void
function UIHeroInfo2:ReplaceItem()
    PopupMgr.HidePopup(UIPopupName.UIItemPreview)
    local callbackSelectItem = function(id)
        self:PreviewReplaceItem(id)
    end
    PopupMgr.ShowPopup(UIPopupName.UISelectItemInventory, { ["type"] = self.typeSlot, ["slot"] = self.selectSlot, ["callbackSelectItem"] = callbackSelectItem, ["faction"] = self.faction })
end

---@return void
function UIHeroInfo2:PreviewUseItem(id)
    local callbackUseItem = function()
        self:CallBackUseItem(id)
    end
    PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = { ["type"] = self.typeSlot, ["id"] = id, ["setNumber"] = self:GetNumberSet(self.typeSlot, id),
                                                                  ["class"] = self.class, ["faction"] = self.faction, ["heroId"] = self.model.heroResource.heroId,
                                                                  ["button2"] = { ["name"] = LanguageUtils.LocalizeCommon("use"), ["callback"] = callbackUseItem } } })
end

---@return void
function UIHeroInfo2:PreviewReplaceItem(id)
    local idItem = self.model.heroResource.heroItem:Get(self.selectSlot)
    local callbackReplace = function()
        self:CallBackReplaceItem(id)
    end
    PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = { ["type"] = self.typeSlot, ["id"] = idItem, ["setNumber"] = self:GetNumberSet(self.typeSlot, idItem), ["class"] = self.class, ["faction"] = self.faction, ["heroId"] = self.model.heroResource.heroId },
                                                    ["data2"] = { ["type"] = self.typeSlot, ["id"] = id, ["setNumber"] = self:GetNumberSet(self.typeSlot, id),
                                                                  ["button2"] = { ["name"] = LanguageUtils.LocalizeCommon("replace"), ["callback"] = callbackReplace } } })
end

---@return void
function UIHeroInfo2:CallBackUseItem(id)
    PopupMgr.HidePopup(UIPopupName.UIItemPreview)
    PopupMgr.HidePopup(UIPopupName.UISelectItemInventory)
    self:SetEquipSlot(self.selectSlot, id)
    self:CheckRequest(self.CheckRequestEquipItem, true)
    self:UpdateUIEquip()
    self.heroMenuView:ChangeStatHero()
    self:UpdateStatHeroInfo()
end

---@return void
function UIHeroInfo2:CallBackReplaceItem(id)
    PopupMgr.HidePopup(UIPopupName.UIItemPreview)
    PopupMgr.HidePopup(UIPopupName.UISelectItemInventory)
    self:SetEquipSlot(self.selectSlot, id)
    self:CheckRequest(self.CheckRequestEquipItem, true)
    self:UpdateUIEquip()
    self.heroMenuView:ChangeStatHero()
    self:UpdateStatHeroInfo()
end

--- @return void
function UIHeroInfo2:ConvertStone()
    local idItem = self.model.heroResource.heroItem:Get(SlotEquipmentType.Stone)
    ---@type HeroResource
    local heroResource = self.model.heroResource
    local callbackComplete = function(id)
        heroResource.heroItem:Add(SlotEquipmentType.Stone, id)
        self:UpdateUIEquip()
        self.heroMenuView:ChangeStatHero()
        self:UpdateStatHeroInfo()
    end
    PopupMgr.ShowAndHidePopup(UIPopupName.UIConvertStone, { ["heroResource"] = self.model.heroResource, ["stoneId"] = idItem, ["convert"] = true,
                                                            ["callbackComplete"] = callbackComplete },
            UIPopupName.UIItemPreview)
    self:CheckRequest()
end

--- @return void
function UIHeroInfo2:UpgradeStone()
    local upgrade = function()
        local idItem = self.model.heroResource.heroItem:Get(SlotEquipmentType.Stone)
        ---@type HeroResource
        local heroResource = self.model.heroResource
        local callbackComplete = function(id)
            heroResource.heroItem:Add(SlotEquipmentType.Stone, id)
            --self:UpdateUIEquip()
            --self.heroMenuView:ChangeStatHero()
            --self:UpdateStatHeroInfo()
        end
        local callbackClose = function()
            PopupMgr.ShowAndHidePopup(UIPopupName.UIHeroMenu2, nil, UIPopupName.UIUpgradeStone)
        end
        PopupMgr.ShowAndHidePopup(UIPopupName.UIUpgradeStone, { ["heroResource"] = self.model.heroResource, ["stoneId"] = idItem, ["upgrade"] = true,
                                                                ["callbackComplete"] = callbackComplete, ["callbackClose"] = callbackClose },
                UIPopupName.UIItemPreview, UIPopupName.UIHeroMenu2)
        self:CheckRequest()
    end
    if self.itemCollectionInBound:IsConvertingStone(self.model.heroResource.inventoryId) then
        PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("notice_upgrade_stone_converting"),
                nil, upgrade)
    else
        upgrade()
    end
end

--- @return void
function UIHeroInfo2:RequestUnlockStone(callbackSuccess)
    ---@type UpgradeStoneOutBound
    local _upgradeStoneOutBound = UpgradeStoneOutBound(self.model.heroResource.inventoryId, true)
    local callback = function(result)
        ---@type UpgradeStoneInBound
        local upgradeStoneInBound
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            upgradeStoneInBound = UpgradeStoneInBound(buffer)
        end
        local onSuccess = function()
            if callbackSuccess ~= nil then
                callbackSuccess(upgradeStoneInBound)
            end
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.ITEM_STONE_UPGRADE, _upgradeStoneOutBound, callback)
end

function UIHeroInfo2:OnTalentResetResponse(result, opCode, slotEquipmentType)
    ---@type List
    local listId = List()
    --- @param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        local size = buffer:GetByte()
        for i = 1, size do
            listId:Add(buffer:GetInt())
        end
    end

    local onSuccess = function()
        --XDebug.Log("i return ")
        local data = {}
        data.heroInventoryId = self.model.heroResource.inventoryId
        data.slotId = slotEquipmentType
        data.listId = listId
        self.model.heroResource.heroItem[slotEquipmentType] = nil
        self.model.heroResource.heroItem:RemoveByKey(slotEquipmentType)
        self.heroMenuView:ChangeStatHero()
        self:UpdateStatHeroInfo()
        self:UpdateUITalent()
        data.callbackSelectId = function(id)
            --XDebug.Log("id return " .. id)
            self.model.heroResource.heroItem:Add(slotEquipmentType, id)
            self.heroMenuView:ChangeStatHero()
            self:UpdateStatHeroInfo()
            self:UpdateUITalent()

        end
        if (opCode == OpCode.ITEM_TALENT_RESET) then
            local talentConfigList = ResourceMgr.GetHeroRefreshTalentConfig():GetTalentConfigListBySlotEquipment(slotEquipmentType)
            --- @param talentConfig TalentConfig
            for i, talentConfig in ipairs(talentConfigList:GetItems()) do
                talentConfig.resetMoneyData:SubToInventory()
            end
        end
        if data.slotId == SlotEquipmentType.Talent then
            PopupMgr.ShowPopup(UIPopupName.UISelectTalent, data)
        else
            PopupMgr.ShowPopup(UIPopupName.UISelectTalent2, data)
        end

    end
    local onFailed = function(logicCode)
        SmartPoolUtils.LogicCodeNotification(logicCode)
    end
    NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
end

function UIHeroInfo2:ShowTalentPopup()

    --- @type FeatureConfigInBound
    local featureConfigInBound = zg.playerData:GetMethod(PlayerDataMethod.FEATURE_CONFIG)
    local talentConfigInBound = featureConfigInBound:GetFeatureConfigInBound(FeatureType.TALENT)
    if talentConfigInBound:IsAvailableToGoFeature(true) == false then
        return
    end
    if self.model.heroResource.heroStar < 13 then
        SmartPoolUtils.ShowShortNotification(string.format(LanguageUtils.LocalizeCommon("unlock_star"), 13))
        return
    end

    self.talentPopup:ToggleShow()
    local callback = function(slotEquipmentType)
        self:SelectTalent(slotEquipmentType)
    end
    self.talentPopup:InitTalentButtonListener(callback)
end

---@return void
function UIHeroInfo2:SelectTalent(slotEquipmentType)
    if slotEquipmentType == SlotEquipmentType.Talent2 and self.model.heroResource.heroStar < 14 then
        SmartPoolUtils.ShowShortNotification(string.format(LanguageUtils.LocalizeCommon("unlock_star"), 14))
        return
    end

    local id = self.model.heroResource.heroItem:Get(slotEquipmentType)
    if id ~= nil and id > 0 then
        PopupMgr.ShowPopup(UIPopupName.UIItemPreview, {
            ["data1"] = {
                ["type"] = ResourceType.Talent,
                ["id"] = id,
                ["talentReset"] = self.model.heroResource.inventoryId,
                ["slotEquipmentType"] = slotEquipmentType,
                ["callbackConfirmReset"] = function(result1)
                    self:OnTalentResetResponse(result1, OpCode.ITEM_TALENT_RESET, slotEquipmentType)
                end
            },
        })
    else
        self:CheckRequest()
        local callback = function(result)
            self:OnTalentResetResponse(result, OpCode.ITEM_TALENT_UNLOCK, slotEquipmentType)
        end
        NetworkUtils.Request(OpCode.ITEM_TALENT_UNLOCK, UnknownOutBound.CreateInstance(PutMethod.Long,
                self.model.heroResource.inventoryId, PutMethod.Int, slotEquipmentType), callback)
    end

end

---@return void
function UIHeroInfo2:SelectStone()
    --XDebug.Log(LogUtils.ToDetail(self.model.heroResource.heroItem:GetItems()))
    if self.model.heroResource.heroItem:IsContainKey(SlotEquipmentType.Stone) and
            self.model.heroResource.heroItem:Get(SlotEquipmentType.Stone) > 0 then

        local idItem = self.model.heroResource.heroItem:Get(SlotEquipmentType.Stone)
        local type = ResourceType.ItemStone
        ---@type StoneDataEntry
        local stoneCostConfig = ResourceMgr.GetServiceConfig():GetItems():GetStoneData(idItem)
        local convert
        ---@param v StoneDataEntry
        for k, v in pairs(ResourceMgr.GetServiceConfig():GetItems().stoneDataEntries:GetItems()) do
            if v.id ~= idItem and v.group == stoneCostConfig.group then
                convert = { ["name"] = LanguageUtils.LocalizeCommon("convert"), ["callback"] = function()
                    self:ConvertStone()
                end }
                break
            end
        end

        local upgrade
        ---@type StoneDataConfig
        local stoneDataConfig = ResourceMgr.GetServiceConfig():GetItems().stoneDataEntries:Get(idItem)
        if stoneDataConfig.group < ResourceMgr.GetEquipmentConfig().maxGroupStone then
            upgrade = { ["name"] = LanguageUtils.LocalizeCommon("upgrade"), ["callback"] = function()
                self:UpgradeStone()
            end }
        end
        PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = { ["type"] = type, ["id"] = idItem,
                                                                      ["class"] = self.class,
                                                                      ["faction"] = self.faction,
                                                                      ["heroId"] = self.model.heroResource.heroId,
                                                                      ["button1"] = convert,
                                                                      ["button2"] = upgrade } })
    else
        --XDebug.Log(SlotEquipmentType.Stone)
        if self.model.heroResource.heroLevel >= 40 then
            self:CheckRequest()
            ---@param upgradeStoneInBound UpgradeStoneInBound
            local requestSuccess = function(upgradeStoneInBound)
                local touchObject = TouchUtils.Spawn("UIHeroInfo2:SelectStone")
                local idStone = upgradeStoneInBound.stoneId
                self.model.heroResource.heroItem:Add(SlotEquipmentType.Stone, idStone)
                self:UpdateUIEquip()
                self.particleUnlock:SetActive(true)
                local rewardList = List()
                local iconData = ItemIconData.CreateInstance(ResourceType.ItemStone, idStone)
                rewardList:Add(iconData)
                local callbackDelay = function()
                    touchObject:Enable()
                end
                PopupMgr.ShowPopupDelay(1, UIPopupName.UIPopupReward,
                        { ["resourceList"] = rewardList,
                          ["activeEffectBlackSmith"] = true },
                        nil, callbackDelay)
            end
            self:RequestUnlockStone(requestSuccess)
        else
            SmartPoolUtils.ShowShortNotification(string.format(LanguageUtils.LocalizeCommon("require_level_x"),
                    40))
        end
    end
end

---@return number
function UIHeroInfo2:GetIdStoneUnlock()
    local r = ClientMathUtils.randomHelper:RandomMinMax(0, 100)
    ---@type StoneDataConfig
    local stoneDataConfig
    for k, v in pairs(ResourceMgr.GetServiceConfig():GetItems().stoneDataEntries:GetItems()) do
        if v.group == 1 and v.rate >= r and (stoneDataConfig == nil or v.rate < stoneDataConfig.rate) then
            stoneDataConfig = v
        end
    end
    return stoneDataConfig.id
end

--- @return void
function UIHeroInfo2:CheckRequest(func, runNow)
    if self.currentRequest ~= nil and self.currentRequest ~= func then
        self.currentRequest(self)
    end
    self.currentRequest = func
    if runNow == true then
        self.currentRequest(self)
        self.currentRequest = nil
    end
end

--- @return void
function UIHeroInfo2:CheckRequestEquipItem()
    if self.equipItemOutBound.listData:Count() > 0 then
        NetworkUtils.RequestAndCallback(OpCode.ITEM_EQUIP, self.equipItemOutBound)
        self.equipItemOutBound.listData:Clear()
    end
end

--- @return void
function UIHeroInfo2:CheckRequestUpgradeItemEquip()
    if self.upgradeItemEquipHeroOutBound.listDataEquipment:Count() > 0 then
        NetworkUtils.RequestAndCallback(OpCode.ITEM_EQUIPMENT_UPGRADE_ON_HERO, self.upgradeItemEquipHeroOutBound, function()
            RxMgr.mktTracking:Next(MktTrackingType.forge, 1)
        end)
        self.upgradeItemEquipHeroOutBound.listDataEquipment:Clear()
    end
end

---@return void
function UIHeroInfo2:HideEquip()
    if self.stone ~= nil then
        self.stone:ReturnPool()
        self.stone = nil
    end
    for i = 1, 5 do
        ---@type UISlotEquip
        local slot = self.slotEquip[i]
        if slot.itemEquipView ~= nil then
            slot.itemEquipView:ReturnPool()
            slot.itemEquipView = nil
        end
    end

    self:CheckRequest()
end