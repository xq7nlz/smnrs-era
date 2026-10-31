require "lua.client.core.network.item.blackSmith.UpgradeItemSmithOutBound"

--- @class UIBlackSmithView : UIBaseView
UIBlackSmithView = Class(UIBlackSmithView, UIBaseView)

--- @return void
--- @param model UIBlackSmithModel
function UIBlackSmithView:Ctor(model)
    ---@type UIBlackSmithConfig
    self.config = nil
    --- @type UISelect
    self.tab = nil

    ---@type UILoopScroll
    self.uiScroll = nil
    ---@type ItemIconView
    self.iconView1 = nil
    ---@type ItemIconView
    self.iconView2 = nil
    ---@type InputNumberView
    self.inputView = nil
    --- @type MoneyBarView
    self.goldBarView = nil
    --- @type MoneyBarView
    self.magicCrystalBarView = nil
    ---@type UnityEngine_GameObject
    self.effect = nil

    self.rewardNeedList = List()
    -- init variables here
    UIBaseView.Ctor(self, model)
    ---@type UIBlackSmithModel
    self.model = model
end

--- @return void
function UIBlackSmithView:OnReadyCreate()
    ---@type UIBlackSmithConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.effect = ResourceLoadUtils.LoadUIEffect("fx_ui_blacksmith", self.config.fxUiBlacksmith)
    self.effect:SetActive(false)

    --- @type FeatureConfigInBound
    local featureConfigInBound = zg.playerData:GetMethod(PlayerDataMethod.FEATURE_CONFIG)
    local remoteConfigNewEquipment = featureConfigInBound:GetFeatureConfigInBound(FeatureType.ITEM_REVOLUTION)
    self.isShowNewEquipment = remoteConfigNewEquipment:IsAvailableToGoFeature(false)

    -- Tab
    --- @param obj UITabPopupConfig
    --- @param isSelect boolean
    local onSelect = function(obj, isSelect, indexTab)
        if obj ~= nil then
            obj.button.interactable = not isSelect
            obj.imageOn.gameObject:SetActive(isSelect)
        end
    end

    local onChangeSelect = function(indexTab)
        if indexTab ~= nil then
            self:ShowEquipment(indexTab)
        end
    end
    self.tab = UISelect(self.config.tabParent, UIBaseConfig, onSelect, onChangeSelect)

    --- @param obj ItemIconView
    --- @param index number
    local onUpdateItem = function(obj, index)
        if self.model.selectItemIndex == index + 1 then
            obj:ActiveEffectSelect(true)
        else
            obj:ActiveEffectSelect(false)
        end

        local id = self.model.itemSort:Get(index + 1)
        if id == nil then
            return
        end

        local numberMaterial = InventoryUtils.Get(ResourceType.ItemEquip, id - 1)
        if numberMaterial >= self.model.materialCount then
            obj:ActiveNotification(true)
        else
            obj:ActiveNotification(false)
        end

        obj.iconData.spriteName = self:GetSprite(id)
        obj:UpdateView()
    end

    --- @param obj ItemIconView
    --- @param index number
    local onCreateItem = function(obj, index)
        local id = self.model.itemSort:Get(index + 1)

        obj:EnableButton(true)
        obj:SetIconData(ItemIconData.CreateInstance(ResourceType.ItemEquip, id, nil),
                self:GetSprite(id))
        obj:AddListener(function()
            self:OnClickItem(index + 1)
            zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        end)
        onUpdateItem(obj, index)
    end

    self.uiScroll = UILoopScrollAsync(self.config.scroll, UIPoolType.ItemIconView, onCreateItem, onUpdateItem)
    self.uiScroll:SetUpMotion(MotionConfig(0, 0, 0, 0.015, 2))

    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonForge.onClick:AddListener(function()
        self:OnClickForge()
    end)
    self.config.buttonTutorial.onClick:AddListener(function()
        self:OnClickHelpInfo()
    end)
end

--- @return string
--- @param id number
function UIBlackSmithView:GetSprite(id)
    if id % 1000 >= 28 then
        return StarsAtlas.starEquipment2
    else
        return StarsAtlas.starEquipment1
    end
end

--- @return void
function UIBlackSmithView:InitLocalization()
    self.config.localizeForge.text = LanguageUtils.LocalizeCommon("forge")
    --self.config.localizeAvailableForge.text = LanguageUtils.LocalizeCommon("available_to_forge")
    self.config.localizeArmor.text = LanguageUtils.LocalizeCommon("armor")
    self.config.localizeWeapon.text = LanguageUtils.LocalizeCommon("weapon")
    self.config.localizeHelmet.text = LanguageUtils.LocalizeCommon("helmet")
    self.config.localizeRing.text = LanguageUtils.LocalizeCommon("ring")
end

--- @return void
function UIBlackSmithView:_InitMoneyBar()
    self.goldBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.config.goldBar)
    self.goldBarView:SetIconData(MoneyType.GOLD)

    if self.isShowNewEquipment then
        self.magicCrystalBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.config.goldBar)
        self.magicCrystalBarView:SetIconData(MoneyType.MAGIC_CRYSTAL)
    end
end

--- @return void
function UIBlackSmithView:ActiveUI(isActive)
    self.config.item1.parent.gameObject:SetActive(isActive)
    self.config.item2.parent.gameObject:SetActive(isActive)
    self.config.inputView.gameObject:SetActive(isActive)
    self.config.buttonForge.gameObject:SetActive(isActive)
end

--- @return void
function UIBlackSmithView:OnReadyShow()
    if self.config.skeleton.Skeleton ~= nil then
        self.config.skeleton.Skeleton:SetToSetupPose()
    end
    self.config.fx_start:SetActive(true)
    self.config.skeleton.AnimationState:SetAnimation(0, "start", false)
    self.config.skeleton.AnimationState:AddAnimation(0, "idle", true, 0)
    zg.audioMgr:PlaySfxUi(SfxUiType.ENTER_BLACKSMITH)

    self:ActiveUI(false)
    self.coroutineStart = Coroutine.start(function()
        coroutine.waitforseconds(0.5)
        self:ActiveUI(true)
    end)

    if self.inputView == nil then
        self.inputView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.InputNumberView, self.config.inputView)
        local changeInput = function(value)
            self:OnChangeInput(value)
        end
        self.inputView.onChangeInput = changeInput
    end
    self:_InitMoneyBar()
    if self.iconView1 == nil then
        self.iconView1 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.ItemIconView, self.config.item1)
        self.iconView1:RegisterShowInfo()
    end
    if self.iconView2 == nil then
        self.iconView2 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.ItemIconView, self.config.item2)
        self.iconView2:RegisterShowInfo()
    end
    self.tab:Select(1)
    --self:ShowEquipment(1)
    self:CheckNotificationTab()
    self.uiScroll:PlayMotion()
end

--- @return void
function UIBlackSmithView:OnFinishAnimation()
    UIBaseView.OnFinishAnimation(self)
    self:CheckAndInitTutorial()
    local selected = self.model.selectItemIndex
    local obj = self.uiScroll:GetItems()
end

--- @return void
function UIBlackSmithView:CheckNotificationTab()
    ---@type List
    local listId = List()
    ---@type List
    local listItem = InventoryUtils.GetEquipment(nil, 1)
    for i, v in ipairs(listItem:GetItems()) do
        if self.model.itemBlackSmith:IsContainValue(v + 1) and InventoryUtils.Get(ResourceType.ItemEquip, v) >= self.model.materialCount then
            local id = math.floor(v / 1000)
            if listId:IsContainValue(id) == false then
                listId:Add(id)
            end
        end
    end
    self.config.notification1:SetActive(listId:IsContainValue(EquipmentType.Weapon))
    self.config.notification2:SetActive(listId:IsContainValue(EquipmentType.Armor))
    self.config.notification3:SetActive(listId:IsContainValue(EquipmentType.Helm))
    self.config.notification4:SetActive(listId:IsContainValue(EquipmentType.Accessory))
end

--- @return void
function UIBlackSmithView:Hide()
    UIBaseView.Hide(self)
    if self.effect ~= nil and self.effect.activeInHierarchy then
        self.effect:SetActive(false)
    end
    self.goldBarView:ReturnPool()
    self.goldBarView = nil
    if self.isShowNewEquipment then
        self.magicCrystalBarView:ReturnPool()
        self.magicCrystalBarView = nil
    end
    self.inputView:ReturnPool()
    self.inputView = nil
    self.uiScroll:Hide()
    self.tab:Select(nil)

    if self.coroutineStart ~= nil then
        Coroutine.stop(self.coroutineStart)
        self.coroutineStart = nil
    end

    self.config.fx_start:SetActive(false)
    for i = 1, self.config.fx_forge.transform.childCount do
        self.config.fx_forge.transform:GetChild(i - 1).gameObject:SetActive(false)
    end

    self:RemoveListenerTutorial()
end

--- @return void
function UIBlackSmithView:RequestUpgrade(success, failed)
    if self.model.equipmentDict:Count() > 0 then
        local callback = function(result)
            local onSuccess = function()
                if success ~= nil then
                    success()
                end
            end
            local onFailed = function(logicCode)
                SmartPoolUtils.LogicCodeNotification(logicCode)
                if failed ~= nil then
                    failed()
                end
            end
            NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
            --TouchUtils.Enable()
        end
        ---@type UpgradeItemSmithOutBound
        local upgradeItemSmithOutBound = UpgradeItemSmithOutBound()
        --XDebug.Log(LogUtils.ToDetail(self.model.equipmentDict:GetItems()))
        for i, v in pairs(self.model.equipmentDict:GetItems()) do
            upgradeItemSmithOutBound.listDataEquipment:Add(UpgradeEquipmentSmithOutBound(i, v))
        end
        self.model.equipmentDict:Clear()
        --XDebug.Log("ITEM_UPGRADE_ON_BLACKSMITH" .. LogUtils.ToDetail(self.model.equipmentDict:GetItems()))
        NetworkUtils.Request(OpCode.ITEM_UPGRADE_ON_BLACKSMITH, upgradeItemSmithOutBound, callback, false)
        --TouchUtils.Disable()
    end
end

--- @return void
--- @param number number
function UIBlackSmithView:OnChangeInput(number)
    ---@type number
    local numberMaterial = InventoryUtils.Get(ResourceType.ItemEquip, self.model.currentId - 1)
    -----@type number
    --local numberMax = math.floor(numberMaterial / self.model.materialCount)
    ---@type EquipmentDataEntry
    local equipmentDataConfig = ResourceMgr.GetServiceConfig():GetItems().equipmentDataEntries:Get(self.model.currentId)
    self.model.priceForge = equipmentDataConfig.priceForge * number
    self.model.priceMagicCrystalForge = equipmentDataConfig.priceMagicalCrystalForge * number
    self.iconView1:SetIconData(ItemIconData.CreateInstance(ResourceType.ItemEquip, self.model.currentId - 1, self.model.materialCount * number),
            self:GetSprite(self.model.currentId - 1))

    self.config.textNumber.text = string.format("%s/%s", numberMaterial, self.model.materialCount * number)
    self.config.progressBar.fillAmount = MathUtils.Clamp(numberMaterial / self.model.materialCount * number, 0, 1)

    self.config.goldIco.sprite = ResourceLoadUtils.LoadMoneyIcon(MoneyType.GOLD)
    self.config.goldTxt.text = ClientConfigUtils.FormatNumber(self.model.priceForge)
    if self.model.priceMagicCrystalForge > 0 then
        self.config.crystalGo:SetActive(true)
        self.config.crystalIco.sprite = ResourceLoadUtils.LoadMoneyIcon(MoneyType.MAGIC_CRYSTAL)
        self.config.crystalTxt.text = ClientConfigUtils.FormatNumber(self.model.priceMagicCrystalForge)
    else
        self.config.crystalGo:SetActive(false)
    end
end

--- @return void
--- @param index number
function UIBlackSmithView:OnClickItem(index)
    self.model.selectItemIndex = index
    self.model.currentId = self.model.itemSort:Get(index)
    self.uiScroll:RefreshCells()
    self:UpdateUI()
end

--- @return void
function UIBlackSmithView:AutoSelectItemCanUpgrade()
    for i, v in ipairs(self.model.itemSort:GetItems()) do
        ---@type number
        local numberMaterial = InventoryUtils.Get(ResourceType.ItemEquip, v - 1)
        if numberMaterial >= self.model.materialCount then
            self:OnClickItem(i)
            return
        end
    end
    if self.model.currentId == nil then
        self:OnClickItem(1)
    end
end

--- @return void
function UIBlackSmithView:UpdateUI()
    local color = UIUtils.color_rarity_1

    UIUtils.SetInteractableButton(self.config.buttonForge, true)
    ---@type number
    local numberMaterial = InventoryUtils.Get(ResourceType.ItemEquip, self.model.currentId - 1)
    ---@type number
    local number = math.max(math.floor(numberMaterial / self.model.materialCount), 1)
    self.iconView1:SetIconData(ItemIconData.CreateInstance(ResourceType.ItemEquip, self.model.currentId - 1, self.model.materialCount * number),
            self:GetSprite(self.model.currentId - 1))
    self.config.textNumber.text = string.format("%s/%s", numberMaterial, self.model.materialCount * number)
    self.config.progressBar.fillAmount = MathUtils.Clamp(numberMaterial / self.model.materialCount * number, 0, 1)
    self.config.textSkillName.text = LanguageUtils.GetStringResourceName(ResourceType.ItemEquip, self.model.currentId - 1)
    self.config.textType.text = LanguageUtils.GetStringResourceType(ResourceType.ItemEquip, self.model.currentId - 1)

    color = UIUtils.GetColorRarity(ResourceMgr.GetServiceConfig():GetItemRarity(ResourceType.ItemEquip, self.model.currentId - 1))
    --self.config.textSkillName.text = string.format("<color=#%s>%s</color>", color, self.config.textSkillName.text)
    --self.config.textType.text = string.format("<color=#%s>%s</color>", color, self.config.textType.text)

    if self.inputView ~= nil then
        self.inputView:SetData(number, 1, number)
    end
    self:OnChangeInput(number)
    self.iconView2:SetIconData(ItemIconData.CreateInstance(ResourceType.ItemEquip, self.model.currentId, nil),
            self:GetSprite(self.model.currentId))
end

--- @return void
function UIBlackSmithView:UpdateTab()
    self.model.currentId = nil
    self:AutoSelectItemCanUpgrade()
    self.uiScroll:Resize(self.model.itemSort:Count())
end

--- @return void
function UIBlackSmithView:ShowEquipment(equipment)
    if equipment == EquipmentType.Weapon then
        self.model.itemSort = self.model.itemSortWeapon
    elseif equipment == EquipmentType.Armor then
        self.model.itemSort = self.model.itemSortArmor
    elseif equipment == EquipmentType.Helm then
        self.model.itemSort = self.model.itemSortHelm
    elseif equipment == EquipmentType.Accessory then
        self.model.itemSort = self.model.itemSortAccessory
    end
    self:UpdateTab()
end

--- @return void
function UIBlackSmithView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIBlackSmithView:OnClickBackOrClose()
    self:OnReadyHide()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
end

function UIBlackSmithView:UpdateRewardNeeds(number)
    self.rewardNeedList:Clear()
    self.rewardNeedList:Add(self.model:GetUseGold())
    self.rewardNeedList:Add(self.model:GetUseMagicCrystal())
    if number == 1 then
        self.rewardNeedList:Add(RewardInBound.CreateBySingleParam(ResourceType.ItemEquip, self.model.currentId - 1, self.model.materialCount))
    end
end
--- @return void
function UIBlackSmithView:OnClickForge()
    ---@type number
    local number = self.inputView.value
    self:UpdateRewardNeeds(number)
    local canForge = InventoryUtils.IsEnoughMultiResourceRequirement(self.rewardNeedList, true)
    if number > 0 and canForge then
        local touchObject = TouchUtils.Spawn("UIBlackSmithView:OnClickForge")
        for i = 1, self.config.fx_forge.transform.childCount do
            local effect = self.config.fx_forge.transform:GetChild(i - 1).gameObject
            if effect.activeInHierarchy == false then
                effect:SetActive(true)
                Coroutine.start(function()
                    coroutine.waitforseconds(3)
                    effect:SetActive(false)
                end)
                break
            end
        end
        self.config.skeleton.AnimationState:SetAnimation(0, "end", false)
        self.config.skeleton.AnimationState:AddAnimation(0, "idle", true, 0)

        self:ActiveUI(false)

        UIUtils.SetInteractableButton(self.config.buttonForge, false)
        if self.model.equipmentDict:IsContainKey(self.model.currentId) then
            self.model.equipmentDict:Add(self.model.currentId, self.model.equipmentDict:Get(self.model.currentId) + number)
        else
            self.model.equipmentDict:Add(self.model.currentId, number)
        end

        self:RequestUpgrade()
        RxMgr.mktTracking:Next(MktTrackingType.forge, number)
        InventoryUtils.Add(ResourceType.ItemEquip, self.model.currentId, number)
        InventoryUtils.Sub(ResourceType.ItemEquip, self.model.currentId - 1, number * self.model.materialCount)
        InventoryUtils.Sub(ResourceType.Money, MoneyType.GOLD, self.model.priceForge)
        InventoryUtils.Sub(ResourceType.Money, MoneyType.MAGIC_CRYSTAL, self.model.priceMagicCrystalForge)
        self:CheckNotificationTab()

        local callbackDelay = function()
            self.uiScroll:RefreshCells()
            self:AutoSelectItemCanUpgrade()
            self:UpdateUI()
            self:ActiveUI(true)
        end
        SmartPoolUtils.ShowReward1Item(ItemIconData.CreateInstance(ResourceType.ItemEquip, self.model.currentId, number), callbackDelay, 1.5)
        zg.audioMgr:PlaySfxUi(SfxUiType.HAMMER_FORGE)

        Coroutine.start(function()
            coroutine.waitforseconds(2.5)
            touchObject:Enable()
        end)
    end
end

--- @return void
function UIBlackSmithView:OnClickHelpInfo()
    local info = LanguageUtils.LocalizeHelpInfo("black_smith_info")
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, info)
end

--- @return void
---@param tutorial UITutorialView
---@param step number
function UIBlackSmithView:ShowTutorial(tutorial, step)
    if step == TutorialStep.BLACK_SMITH_WEAPON then
        tutorial:ViewFocusCurrentTutorial(nil, 0.5,
                self.tab.uiTransform:GetChild(0).position)
    elseif step == TutorialStep.BLACK_SMITH_ARMOR then
        tutorial:ViewFocusCurrentTutorial(nil, 0.5,
                self.tab.uiTransform:GetChild(1).position)
    elseif step == TutorialStep.BLACK_SMITH_HELMET then
        tutorial:ViewFocusCurrentTutorial(nil, 0.5,
                self.tab.uiTransform:GetChild(2).position)
    elseif step == TutorialStep.BLACK_SMITH_RING then
        tutorial:ViewFocusCurrentTutorial(nil, 0.5,
                self.tab.uiTransform:GetChild(3).position)
    elseif step == TutorialStep.FORGE_CLICK then
        tutorial:ViewFocusCurrentTutorial(self.config.buttonForge, U_Vector2(500, 180), nil, nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.BACK_BLACK_SMITH then
        tutorial:ViewFocusCurrentTutorial(self.config.buttonBack, 0.5, self.config.buttonBack.transform:GetChild(0), nil, tutorial:GetHandType(TutorialHandType.MOVE_CLICK))
    end
end