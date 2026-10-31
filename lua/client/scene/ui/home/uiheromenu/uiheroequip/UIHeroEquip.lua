---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiHeroMenu.uiHeroEquip.UIHeroEquipConfig"
require "lua.client.scene.ui.home.uiHeroMenu2.UISlotEquip"
require "lua.client.core.network.item.equipItem.EquipItemOutBound"
require "lua.client.core.network.item.upgradeItemHeroInfo.UpgradeItemEquipHeroOutBound"
require "lua.client.core.network.item.upgradeStone.UpgradeStoneInBound"
require "lua.client.core.network.item.upgradeStone.UpgradeStoneOutBound"

--- @class UIHeroEquip
UIHeroEquip = Class(UIHeroEquip)

--- @return void
--- @param transform UnityEngine_Transform
function UIHeroEquip:Ctor(transform, model, heroMenuView)
    ---@type UIHeroMenu2Model
    self.model = model
    --- @type UIHeroMenu2View
    self.heroMenuView = heroMenuView
    ---@type UIHeroEquipConfig
    ---@type UIHeroEquipConfig
    self.config = UIBaseConfig(transform)
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
    self.stone = nil
    ---@type UnityEngine_GameObject
    self.particleUnlock = ResourceLoadUtils.LoadUIEffect("fx_ui_equip_unlock", self.config.fx)
    ---@type UnityEngine_GameObject
    self.particleLock = ResourceLoadUtils.LoadUIEffect("fx_ui_equip_iconlock", self.config.fx)
    -----@type UnityEngine_GameObject
    --self.particleFlip = ResourceLoadUtils.LoadUIEffect("fx_ui_equip_flip", self.config.fx)
    self.faction = nil
    self.class = nil

    ---@type UISlotEquip[]
    self.slotEquip = {}
    self.slotEquip[SlotEquipmentType.Weapon] = self.weapon
    self.slotEquip[SlotEquipmentType.Armor] = self.armor
    self.slotEquip[SlotEquipmentType.Helm] = self.helm
    self.slotEquip[SlotEquipmentType.Accessory] = self.accessory
    self.slotEquip[SlotEquipmentType.Artifact] = self.artifact

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

    ---@type function
    self.currentRequest = nil
    ---@type EquipItemOutBound
    self.equipItemOutBound = EquipItemOutBound()
    ---@type UpgradeItemEquipHeroOutBound
    self.upgradeItemEquipHeroOutBound = UpgradeItemEquipHeroOutBound()

    ---@type ItemCollectionInBound
    self.itemCollectionInBound = nil
end

--- @return void
function UIHeroEquip:InitLocalization()
    self.config.localizeAutoEquip.text = LanguageUtils.LocalizeCommon("auto_equip")
    self.config.localizeUnEquip.text = LanguageUtils.LocalizeCommon("unequip")
    self.config.textLockLevel.text = string.format(LanguageUtils.LocalizeCommon("unlock_level"), 40)
end

--- @return void
function UIHeroEquip:Show()
    self.itemCollectionInBound = zg.playerData:GetMethod(PlayerDataMethod.ITEM_COLLECTION)
    self:UpdateFaction()
    self:UpdateUIEquip()
end

---@return void
function UIHeroEquip:Hide()
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

--- @return void
function UIHeroEquip:CheckRequest(func, runNow)
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
function UIHeroEquip:CheckRequestEquipItem()
    if self.equipItemOutBound.listData:Count() > 0 then
        NetworkUtils.RequestAndCallback(OpCode.ITEM_EQUIP, self.equipItemOutBound)
        self.equipItemOutBound.listData:Clear()
    end
end

--- @return void
function UIHeroEquip:CheckRequestUpgradeItemEquip()
    if self.upgradeItemEquipHeroOutBound.listDataEquipment:Count() > 0 then
        NetworkUtils.RequestAndCallback(OpCode.ITEM_EQUIPMENT_UPGRADE_ON_HERO, self.upgradeItemEquipHeroOutBound, function()
            RxMgr.mktTracking:Next(MktTrackingType.forge, 1)
        end)
        self.upgradeItemEquipHeroOutBound.listDataEquipment:Clear()
    end
end

--- @return void
function UIHeroEquip:OnChangeHero()
    self:UpdateFaction()
    self:UpdateUIEquip()
end

--- @return void
function UIHeroEquip:UpdateFaction()
    --self.config.bgFaction.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.bgFactions, ClientConfigUtils.GetFactionIdByHeroId(self.model.heroResource.heroId))
end

--- @return void
function UIHeroEquip:UpdateUIEquip()
    --XDebug.Log(LogUtils.ToDetail(self.model.heroResource))
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

    --XDebug.Log(LogUtils.ToDetail(self.model.heroResource.heroItem:GetItems()))
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
        if self.model.heroResource.heroLevel >= 40 then
            self.config.textLockLevel.gameObject:SetActive(false)
            self.particleLock:SetActive(true)
        else
            self.config.textLockLevel.gameObject:SetActive(true)
        end
    end
end

---@return ResourceType
function UIHeroEquip:GetResourceTypeBySlot(slotId)
    if slotId > 0 and slotId < 5 then
        return ResourceType.ItemEquip
    elseif slotId == 5 then
        return ResourceType.ItemArtifact
    elseif slotId == 6 then
        return ResourceType.ItemStone
    end
end

---@return void
function UIHeroEquip:SetEquipSlot(slotId, id)
    local idItemSlot = self.model.heroResource.heroItem:Get(slotId)
    if idItemSlot ~= id then
        ---@type ResourceType
        local type = self:GetResourceTypeBySlot(slotId)

        if idItemSlot ~= nil and idItemSlot > 0 then
            InventoryUtils.Add(type, idItemSlot, 1)                         -- RETURN ITEM TO INVENTORY
            if id == nil or id <= 0 then                                    -- UN EQUIP
                self.model.heroResource.heroItem:RemoveByKey(slotId)
                self.equipItemOutBound.listData:Add(
                        EquipItemRecordOutBound(self.model.heroResource.inventoryId,
                                slotId,
                                -1))
            end
        end

        if id ~= nil and id > 0 then                                        -- EQUIP
            InventoryUtils.Sub(type, id, 1)
            self.model.heroResource.heroItem:Add(slotId, id)
            self.equipItemOutBound.listData:Add(
                    EquipItemRecordOutBound(self.model.heroResource.inventoryId, slotId, id))
        end
    end
end

---@return void
function UIHeroEquip:AutoEquip()
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
end

---@return void
function UIHeroEquip:UnEquip()
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
end

---@return number
---@param equipmentType number
---@param idDefault number
function UIHeroEquip:GetIdMaxTier(equipmentType, idDefault)
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
function UIHeroEquip:GetIdMaxArtifact(idDefault)
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
function UIHeroEquip:GetNumberSet(type, idItem)
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
function UIHeroEquip:SelectSlot(slotEquip)
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
                callbackUpgrade = function()
                    local callbackComplete = function(id)
                        self.model.heroResource.heroItem:Add(slotEquip, id)
                        self.upgradeItemEquipHeroOutBound.listDataEquipment:Add(UpgradeEquipmentHeroInfoOutBound(self.model.heroResource.inventoryId, id))
                        self:UpdateUIEquip()
                        self:CheckRequest(self.CheckRequestUpgradeItemEquip, true)
                        self.heroMenuView:ChangeStatHero()
                    end
                    PopupMgr.HidePopup(UIPopupName.UIItemPreview)
                    PopupMgr.ShowPopup(UIPopupName.UIFastForge, { ["idItem"] = idItem, ["callbackComplete"] = callbackComplete })

                end
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
                    local callbackComplete = function(id)
                        self.model.heroResource.heroItem:Add(SlotEquipmentType.Artifact, id)
                        self:UpdateUIEquip()
                        self.heroMenuView:ChangeStatHero()
                    end
                    PopupMgr.HidePopup(UIPopupName.UIItemPreview)
                    PopupMgr.ShowPopup(UIPopupName.UIUpgradeArtifact, { ["heroResource"] = self.model.heroResource, ["callbackComplete"] = callbackComplete })
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
        PopupMgr.ShowPopup(UIPopupName.UISelectItemInventory, { ["type"] = self.typeSlot, ["slot"] = self.selectSlot, ["callbackSelectItem"] = callbackSelectItem })
    end
end

---@return void
function UIHeroEquip:RemoveItem()
    PopupMgr.HidePopup(UIPopupName.UIItemPreview)
    self:SetEquipSlot(self.selectSlot, nil)
    self:CheckRequest(self.CheckRequestEquipItem, true)
    self:UpdateUIEquip()
    self.heroMenuView:ChangeStatHero()
end

---@return void
function UIHeroEquip:ReplaceItem()
    PopupMgr.HidePopup(UIPopupName.UIItemPreview)
    local callbackSelectItem = function(id)
        self:PreviewReplaceItem(id)
    end
    PopupMgr.ShowPopup(UIPopupName.UISelectItemInventory, { ["type"] = self.typeSlot, ["slot"] = self.selectSlot, ["callbackSelectItem"] = callbackSelectItem })
end

---@return void
function UIHeroEquip:PreviewUseItem(id)
    local callbackUseItem = function()
        self:CallBackUseItem(id)
    end
    PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = { ["type"] = self.typeSlot, ["id"] = id, ["setNumber"] = self:GetNumberSet(self.typeSlot, id),
                                                                  ["class"] = self.class, ["faction"] = self.faction, ["heroId"] = self.model.heroResource.heroId,
                                                                  ["button2"] = { ["name"] = LanguageUtils.LocalizeCommon("use"), ["callback"] = callbackUseItem } } })
end

---@return void
function UIHeroEquip:PreviewReplaceItem(id)
    local idItem = self.model.heroResource.heroItem:Get(self.selectSlot)
    local callbackReplace = function()
        self:CallBackReplaceItem(id)
    end
    PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = { ["type"] = self.typeSlot, ["id"] = idItem, ["setNumber"] = self:GetNumberSet(self.typeSlot, idItem), ["class"] = self.class, ["faction"] = self.faction, ["heroId"] = self.model.heroResource.heroId },
                                                    ["data2"] = { ["type"] = self.typeSlot, ["id"] = id, ["setNumber"] = self:GetNumberSet(self.typeSlot, id),
                                                                  ["button2"] = { ["name"] = LanguageUtils.LocalizeCommon("replace"), ["callback"] = callbackReplace } } })
end

---@return void
function UIHeroEquip:CallBackUseItem(id)
    PopupMgr.HidePopup(UIPopupName.UIItemPreview)
    PopupMgr.HidePopup(UIPopupName.UISelectItemInventory)
    self:SetEquipSlot(self.selectSlot, id)
    self:CheckRequest(self.CheckRequestEquipItem, true)
    self:UpdateUIEquip()
    self.heroMenuView:ChangeStatHero()
end

---@return void
function UIHeroEquip:CallBackReplaceItem(id)
    PopupMgr.HidePopup(UIPopupName.UIItemPreview)
    PopupMgr.HidePopup(UIPopupName.UISelectItemInventory)
    self:SetEquipSlot(self.selectSlot, id)
    self:CheckRequest(self.CheckRequestEquipItem, true)
    self:UpdateUIEquip()
    self.heroMenuView:ChangeStatHero()
end

--- @return void
function UIHeroEquip:ConvertStone()
    local idItem = self.model.heroResource.heroItem:Get(SlotEquipmentType.Stone)
    local callbackComplete = function(id)
        self.model.heroResource.heroItem:Add(SlotEquipmentType.Stone, id)
        self:UpdateUIEquip()
        self.heroMenuView:ChangeStatHero()
    end
    PopupMgr.ShowAndHidePopup(UIPopupName.UIUpgradeConvertStone, { ["heroResource"] = self.model.heroResource, ["stoneId"] = idItem, ["convert"] = true, ["callbackComplete"] = callbackComplete }, UIPopupName.UIItemPreview)
    self:CheckRequest()
end

--- @return void
function UIHeroEquip:UpgradeStone()
    local upgrade = function()
        local idItem = self.model.heroResource.heroItem:Get(SlotEquipmentType.Stone)
        local callbackComplete = function(id)
            self.model.heroResource.heroItem:Add(SlotEquipmentType.Stone, id)
            self:UpdateUIEquip()
            self.heroMenuView:ChangeStatHero()
        end
        PopupMgr.ShowAndHidePopup(UIPopupName.UIUpgradeConvertStone, { ["heroResource"] = self.model.heroResource, ["stoneId"] = idItem, ["upgrade"] = true, ["callbackComplete"] = callbackComplete }, UIPopupName.UIItemPreview)
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
function UIHeroEquip:RequestUnlockStone(callbackSuccess)
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
            XDebug.Log("Upgrade Stone Success")
            if callbackSuccess ~= nil then
                callbackSuccess(upgradeStoneInBound)
            end
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            XDebug.Log("Upgrade Stone Failed" .. LogUtils.ToDetail(_upgradeStoneOutBound.listDataStone:Get(1)))
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.ITEM_STONE_UPGRADE, _upgradeStoneOutBound, callback)
end

---@return void
function UIHeroEquip:SelectStone()
    --XDebug.Log(LogUtils.ToDetail(self.model.heroResource.heroItem:GetItems()))
    if self.model.heroResource.heroItem:IsContainKey(SlotEquipmentType.Stone) and self.model.heroResource.heroItem:Get(SlotEquipmentType.Stone) > 0 then

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
        PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = { ["type"] = type, ["id"] = idItem, ["class"] = self.class, ["faction"] = self.faction, ["heroId"] = self.model.heroResource.heroId,
                                                                      ["button1"] = convert,
                                                                      ["button2"] = upgrade } })
    else
        --XDebug.Log(SlotEquipmentType.Stone)
        if self.model.heroResource.heroLevel >= 40 then
            self:CheckRequest()
            ---@param upgradeStoneInBound UpgradeStoneInBound
            local requestSuccess = function(upgradeStoneInBound)
                local touchObject = TouchUtils.Spawn("UIHeroEquip:SelectStone")
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
                PopupMgr.ShowPopupDelay(1, UIPopupName.UIPopupReward, { ["resourceList"] = rewardList, ["activeEffectBlackSmith"] = true }, nil, callbackDelay)
            end
            self:RequestUnlockStone(requestSuccess)
        else
            SmartPoolUtils.ShowShortNotification(string.format(LanguageUtils.LocalizeCommon("require_level_x"), 40))
        end
    end
end

---@return number
function UIHeroEquip:GetIdStoneUnlock()
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