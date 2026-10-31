---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiFastForge.UIFastForgeConfig"
require "lua.client.scene.ui.common.MoneyBarLocalView"
require "lua.client.scene.ui.home.uiFastForge.UIItemPreviewFastForgeView"
--- @class UIFastForgeView : UIBaseView
UIFastForgeView = Class(UIFastForgeView, UIBaseView)

--- @return void
--- @param model UIFastForgeModel
function UIFastForgeView:Ctor(model)
    ---@type UIFastForgeConfig
    self.config = nil
    ---@type UIItemPreviewFastForgeView
    self.previewTwoItem = nil
    ---@type ItemIconView
    self.item1 = nil
    ---@type ItemIconView
    self.item2 = nil
    ---@type ItemIconView
    self.itemMaterial = nil
    ---@type MoneyBarLocalView
    self.moneyBarView = nil
    ---@type MoneyBarLocalView
    self.moneyBarInfoCrystalView = nil
    ---@type function
    self.callbackComplete = nil

    -- init variables here
    UIBaseView.Ctor(self, model, ctrl)
    --- @type UIFastForgeModel
    self.model = model
end

function UIFastForgeView:OnReadyCreate()
    ---@type UIFastForgeConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.previewTwoItem = UIItemPreviewFastForgeView(self.config.itemPreviewFastForge)
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonUpgrade.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickUpgrade()
    end)
    self.config.fxuiUpgradeArtifactIcon.gameObject:SetActive(false)
end

--- @return void
function UIFastForgeView:InitLocalization()
    self.config.localizeTitle.text = LanguageUtils.LocalizeCommon("forge")
    self.config.localizeMaterial.text = LanguageUtils.LocalizeCommon("material")
    self.config.localizeUpgrade.text = LanguageUtils.LocalizeCommon("upgrade")
end

--- @return void
---@param result {idItem}
function UIFastForgeView:OnReadyShow(result)
    if self.config.fxuiUpgradeArtifactIcon ~= nil then
        self.config.fxuiUpgradeArtifactIcon.gameObject:SetActive(false)
    end
    self.model.idItem = result.idItem
    self.callbackComplete = result.callbackComplete
    self:UpdateUI()
end

--- @return void
function UIFastForgeView:UpdateUI()
    self.model.equipmentDataConfig = ResourceMgr.GetServiceConfig():GetItems().equipmentDataEntries:Get(self.model.idItem + 1)
    local data = { ["data1"] = { ["type"] = ResourceType.ItemEquip, ["id"] = self.model.idItem, ["rate"] = self.model.rate },
                   ["data2"] = { ["type"] = ResourceType.ItemEquip, ["id"] = self.model.idItem + 1, ["rate"] = self.model.rate }
    }
    self.previewTwoItem:ShowPreview(data)
    if self.itemMaterial == nil then
        self.itemMaterial = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.ItemIconView, self.config.itemMaterial)
    end
    self.itemMaterial:SetIconData(ItemIconData.CreateInstance(ResourceType.ItemEquip, self.model.idItem, self.model.materialCount))
    local itemCount = InventoryUtils.Get(ResourceType.ItemEquip, self.model.idItem)
    local txt = string.format("%s/%s", itemCount, self.model.materialCount)
    if itemCount < self.model.materialCount then
        self.itemMaterial.config.number.text = UIUtils.SetColorString(UIUtils.color7, txt)
    else
        self.itemMaterial.config.number.text = UIUtils.SetColorString(UIUtils.green_light, txt)
    end
    self.itemMaterial:RegisterShowInfo()
    if self.moneyBarView == nil then
        self.moneyBarView = MoneyBarLocalView(self.config.moneyBarInfo)
        self.moneyBarView:SetIconData(MoneyType.GOLD, false, true)
    end
    self.config.upgradeMoneyText.text = ClientConfigUtils.FormatNumber(self.model.equipmentDataConfig.priceForge)
    local resourceCount = InventoryUtils.Get(ResourceType.Money, MoneyType.GOLD)

    local priceMagicCrystalForge = self.model.equipmentDataConfig.priceMagicalCrystalForge
    if (priceMagicCrystalForge ~= nil and priceMagicCrystalForge > 0) then
        self.config.upgradeMoneyCrystalText.text = priceMagicCrystalForge
        self.config.crystalGroup.gameObject:SetActive(true)

        if self.moneyBarInfoCrystalView == nil then
            self.moneyBarInfoCrystalView = MoneyBarLocalView(self.config.moneyBarInfoCrystal)
            self.moneyBarInfoCrystalView:SetIconData(MoneyType.MAGIC_CRYSTAL, false, true)
        end
        if self.moneyBarInfoCrystalView ~= nil then
            local resourceCrystalCount = InventoryUtils.Get(ResourceType.Money, MoneyType.MAGIC_CRYSTAL)
            if resourceCrystalCount < priceMagicCrystalForge then
                self.moneyBarInfoCrystalView.config.textMoney.color = U_Color.red
            else
                self.moneyBarInfoCrystalView.config.textMoney.color = U_Color(186 / 255, 254 / 255, 5 / 255, 1)
            end
        end
        self.config.moneyBarInfoCrystal.gameObject:SetActive(true)
    else
        self.config.crystalGroup.gameObject:SetActive(false)
        self.config.moneyBarInfoCrystal.gameObject:SetActive(false)
    end
    local priceForge = self.model.equipmentDataConfig.priceForge
    if resourceCount < priceForge then
        self.moneyBarView.config.textMoney.color = U_Color.red
    else
        self.moneyBarView.config.textMoney.color = U_Color(186 / 255, 254 / 255, 5 / 255, 1)
    end
end

--- @return void
function UIFastForgeView:Hide()
    UIBaseView.Hide(self)
    if self.item1 ~= nil then
        self.item1:ReturnPool()
        self.item1 = nil
    end
    if self.item2 ~= nil then
        self.item2:ReturnPool()
        self.item2 = nil
    end
    if self.itemMaterial ~= nil then
        self.itemMaterial:ReturnPool()
        self.itemMaterial = nil
    end
end
function UIFastForgeView:UpdateRewardNeeds()
    local reward1 = RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.GOLD, self.model.equipmentDataConfig.priceForge)
    local reward2 = RewardInBound.CreateBySingleParam(ResourceType.ItemEquip, self.model.idItem, self.model.materialCount)
    local crystalCount = self.model.equipmentDataConfig.priceMagicalCrystalForge
    local reward3 = nil
    if (crystalCount > 0) then
        reward3 = RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.MAGIC_CRYSTAL, crystalCount)
    end
    if self.rewardList == nil then
        self.rewardList = List()
        self.rewardList:Add(reward1)
        self.rewardList:Add(reward2)
    else
        self.rewardList:Clear()
        self.rewardList:Add(reward1)
        self.rewardList:Add(reward2)
    end
    if (reward3 ~= nil) then
        self.rewardList:Add(reward3)
    end
end

--- @return void
function UIFastForgeView:OnClickUpgrade()
    self:UpdateRewardNeeds()
    local canUpgrade = InventoryUtils.IsEnoughMultiResourceRequirement(self.rewardList, true)
    if canUpgrade then
        InventoryUtils.Sub(ResourceType.ItemEquip, self.model.idItem, self.model.materialCount)
        InventoryUtils.Sub(ResourceType.Money, MoneyType.GOLD, self.model.equipmentDataConfig.priceForge)
        InventoryUtils.Sub(ResourceType.Money, MoneyType.MAGIC_CRYSTAL, self.model.equipmentDataConfig.priceMagicalCrystalForge)
        if self.callbackComplete ~= nil then
            self.callbackComplete(self.model.idItem + 1)
        end
        self.config.fxuiUpgradeArtifactIcon.gameObject:SetActive(false)
        self.config.fxuiUpgradeArtifactIcon.gameObject:SetActive(true)
        local touchObject = TouchUtils.Spawn("UIFastForgeView:OnClickUpgrade")
        Coroutine.start(function()
            coroutine.waitforseconds(0.7)
            touchObject:Enable()
            self.model.idItem = self.model.idItem + 1

            --- @type FeatureConfigInBound
            local featureConfigInBound = zg.playerData:GetMethod(PlayerDataMethod.FEATURE_CONFIG)
            local remoteConfigNewEquipment = featureConfigInBound:GetFeatureConfigInBound(FeatureType.ITEM_REVOLUTION)
            local isShowNewEquipment = remoteConfigNewEquipment:IsAvailableToGoFeature(false)

            ---@type EquipmentDataEntry
            local equipmentDataConfig = ResourceMgr.GetServiceConfig():GetItems()
                                                   .equipmentDataEntries:Get(self.model.idItem + 1)
            local canUpgradeVer2 = equipmentDataConfig ~= nil and (isShowNewEquipment or not equipmentDataConfig.isNewEquipment)
            if canUpgradeVer2 and ResourceMgr.GetServiceConfig():GetItems().equipmentDataEntries:IsContainKey(self.model.idItem + 1) then
                self:UpdateUI()
            else
                PopupMgr.HidePopup(UIPopupName.UIFastForge)
            end
        end)
    end
end