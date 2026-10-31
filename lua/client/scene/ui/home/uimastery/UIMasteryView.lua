require "lua.client.core.network.mastery.MasteryUpgradeInBound"
require "lua.client.core.network.mastery.MasteryResetInBound"

local SLOT_FIRST = 1
local SLOT_FINAL = 6

--- @class UIMasteryView : UIBaseView
UIMasteryView = Class(UIMasteryView, UIBaseView)

--- @return void
--- @param model UIMasteryModel
function UIMasteryView:Ctor(model)
    ---@type UIMasteryConfig
    self.config = nil
    --- @type UISelect

    self.tabDic = Dictionary()
    --- @type UISkillMasteryConfig[]
    self.skills = {}
    ---@type Dictionary()
    self.particleBottomDict = Dictionary()
    ---@type UnityEngine_GameObject
    self.particleBottom = nil
    ---@type Dictionary()
    self.particleUpgradeDict = Dictionary()
    ---@type Dictionary()
    self.particleUpgradeCenterDict = Dictionary()
    ---@type UnityEngine_GameObject
    self.particleCenter = nil
    ---@type UnityEngine_GameObject
    self.particleTop = nil
    ---@type Dictionary()
    self.particleTopDict = Dictionary()
    ---@type Dictionary()
    self.particleUnlockDict = Dictionary()
    ---@type Coroutine
    self.coroutineEffect = nil

    --- @type MoneyBarView
    self.goldBarView = nil
    --- @type MoneyBarView
    self.gemBarView = nil
    --- @type MoneyBarView
    self.masteryPointBarView = nil

    --- @type MoneyBarLocalView
    self.goldLocalBarView = nil
    --- @type MoneyBarLocalView
    self.arenaTokenLocalBarView = nil

    -- init variables here
    UIBaseView.Ctor(self, model)
    --- @type UIMasteryModel
    self.model = model
end

--- @return void
function UIMasteryView:OnReadyCreate()
    ---@type UIMasteryConfig
    self.config = UIBaseConfig(self.uiTransform)
    if self.goldLocalBarView == nil then
        self.goldLocalBarView = MoneyBarLocalView(self.config.textGoldUpgrade)
    end
    if self.arenaTokenLocalBarView == nil then
        self.arenaTokenLocalBarView = MoneyBarLocalView(self.config.textArenaCoinUpgrade)
    end
    self:InitTabs()
    --Skills
    self:InitMasteryButton()

    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonUpgrade.onClick:AddListener(function()
        self:OnClickUpgrade()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.buttonReset.onClick:AddListener(function()
        self:OnClickReset()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.buttonHelp.onClick:AddListener(function()
        self:OnClickHelpInfo()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

function UIMasteryView:InitTabs()
    self.currentTab = HeroClassType.MAGE
    self.selectTab = function(currentTab)
        self.currentTab = currentTab
        ---@param v UITabItem
        for k, v in pairs(self.tabDic:GetItems()) do
            local isSelect = k == currentTab
            if isSelect == true then
                self:SelectClass(currentTab)
                v.config.rectTransform.sizeDelta = U_Vector2(0, 30)
            else
                v.config.rectTransform.sizeDelta = U_Vector2(0, 0)
            end
            v:SetTabState(isSelect)
            --if isSelect then
            --v.config.textTabName.color = U_Color(80/255, 68/255, 56/255, 1)
            --end
        end
        self.config.tabLayout.enabled = false
        self.config.tabLayout.enabled = true
    end
    local addTab = function(tabId, anchor, localizeFunction)
        self.tabDic:Add(tabId, UITabItem(anchor, self.selectTab, localizeFunction, tabId))
    end
    addTab(HeroClassType.MAGE, self.config.mageTab, function()
        return LanguageUtils.LocalizeClass(HeroClassType.MAGE)
    end)
    addTab(HeroClassType.WARRIOR, self.config.warriorTab, function()
        return LanguageUtils.LocalizeClass(HeroClassType.WARRIOR)
    end)
    addTab(HeroClassType.PRIEST, self.config.priestTab, function()
        return LanguageUtils.LocalizeClass(HeroClassType.PRIEST)
    end)
    addTab(HeroClassType.ASSASSIN, self.config.assasinTab, function()
        return LanguageUtils.LocalizeClass(HeroClassType.ASSASSIN)
    end)
    addTab(HeroClassType.RANGER, self.config.rangerTab, function()
        return LanguageUtils.LocalizeClass(HeroClassType.RANGER)
    end)
end

function UIMasteryView:InitMasteryButton()
    for i = 1, self.config.skill.childCount do
        local index = i
        ---@type UISkillMasteryConfig
        local skill = UIBaseConfig(self.config.skill:GetChild(index - 1))
        skill.button.onClick:AddListener(function()
            if self.model.slotIndex ~= index then
                self:SelectSlot(index)
                zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
            end
        end)
        self.skills[index] = skill
    end
end

function UIMasteryView:InitLocalization()
    self.config.localizeMastery.text = LanguageUtils.LocalizeCommon("mastery")
    self.config.localizeUpgrade.text = LanguageUtils.LocalizeCommon("upgrade")
    self.config.localizeReset.text = LanguageUtils.LocalizeCommon("reset")
    self.config.textLoaiSkill.text = UIUtils.SetColorString(UIUtils.brown, LanguageUtils.LocalizeCommon("mastery_skill"))

    if self.tabDic ~= nil then
        --- @param v UITabItem
        for _, v in pairs(self.tabDic:GetItems()) do
            v:InitLocalization()
        end
    end
end

--- @return void
function UIMasteryView:_InitMoneyBar()
    self.goldBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.config.goldRoot)
    self.goldBarView:SetIconData(MoneyType.GOLD)

    self.gemBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.config.gemRoot)
    self.gemBarView:SetIconData(MoneyType.MASTERY_POINT)

    self.masteryPointBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.config.arenaRoot)
    self.masteryPointBarView:SetIconData(MoneyType.TALENT_CORE)

    if self.tabDic ~= nil then
        --- @param v UITabItem
        for _, v in pairs(self.tabDic:GetItems()) do
            v:InitLocalization()
        end
    end
end

--- @return void
function UIMasteryView:OnReadyShow()
    self.model:InitData()
    self.selectTab(HeroClassType.MAGE)
    self.config.verticalScroll.verticalNormalizedPosition = 1
    self:SelectSlot(HeroClassType.MAGE)
    self:_InitMoneyBar()
    --if self.model.masteryUpgradePrice ~= nil then
    --    self.goldLocalBarView:SetIconData(self.model.masteryUpgradePrice.moneyType1, false)
    --    self.arenaTokenLocalBarView:SetIconData(self.model.masteryUpgradePrice.moneyType2, false)
    --end
end

--- @return void
function UIMasteryView:Hide()
    UIBaseView.Hide(self)
    if self.goldBarView ~= nil then
        self.goldBarView:ReturnPool()
    end
    if self.gemBarView ~= nil then
        self.gemBarView:ReturnPool()
    end
    self.isUpgrade = false
    self.masteryPointBarView:ReturnPool()
    self:CheckRequestUpgrade()
    self:ClearEffect()
end

--- @return void
---@param class HeroClassType
function UIMasteryView:SelectClass(class)
    self.model.classIndex = class
    self:SelectSlot(HeroClassType.MAGE)
    self:ClearEffect()
end

--- @return void
---@param slot number
function UIMasteryView:SelectSlot(slot)
    local slot = slot or SLOT_FIRST
    --if slot == SLOT_FINAL and self.model.canUpgradeCustomMastery == false then
    --    PopupUtils.ShowPopupNotificationOK(string.format(LanguageUtils.LocalizeCommon("need_level_mastery"), ResourceMgr.GetMasteryConfig().basicMasteryLevelToUnlockCustomMastery))
    --    zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    --end
    self.model.slotIndex = slot
    self.model:UpdateData()
    self:UpdateUI()

    if slot == SLOT_FINAL then
        self:ActiveEffectPreview(slot)
    else
        self:ActiveEffectPreview(self.model.classIndex)
    end

    self:CheckRequestUpgrade()
end

--- @return void
function UIMasteryView:ActiveEffectPreview(index)
    ---@type UnityEngine_GameObject
    local newParticle
    if self.particleTopDict:IsContainKey(index) == false then
        newParticle = ResourceLoadUtils.LoadUIEffect("fx_ui_mastery_icon_skill_preview_" .. index, self.config.fxUiMasteryfullitemTop)
        newParticle.transform.position = self.config.bgSkillPreview.transform.position
        self.particleTopDict:Add(index, newParticle)
    else
        newParticle = self.particleTopDict:Get(index)
    end
    if newParticle ~= self.particleTop then
        if self.particleTop ~= nil then
            self.particleTop:SetActive(false)
        end
        self.particleTop = newParticle
        self.particleTop:SetActive(true)
    end
end

--- @return void
function UIMasteryView:OnClickUpgrade()
    if self.model:CanUpgradeMastery(self.model.slotIndex) then
        local isUnlock = self.model.canUpgradeCustomMastery
        local canUpgrade = InventoryUtils.IsEnoughMultiResourceRequirement(self.model:GetUseResourceList())
        if canUpgrade then
            self.model:UseResources()
            self.model.cacheClassMasteryUpgrade = self.model.classIndex
            self.model.cacheMasteryUpgrade = self.model.slotIndex
            self.model.cacheLevelMasteryUpgrade = self.model.levelSkillSelect + 1
            self.model:SetLevelSkillSelect(self.model.cacheLevelMasteryUpgrade)
            self.model:UpdateData()
            self.isUpgrade = true
            self:UpdateUI()
            if (isUnlock == false and self.model.canUpgradeCustomMastery == true) or (self.model:CheckCanUpgradeCustomMastery() and self.model.slotIndex ~= SLOT_FINAL) then
                if self.particleBottomDict:IsContainKey(self.model.classIndex) == false then
                    self.particleBottom = ResourceLoadUtils.LoadUIEffect("fx_ui_masteryfullitem_top_" .. self.model.classIndex, self.config.fxUiMasteryfullitemBottom)
                    self.particleCircleCenter = ResourceLoadUtils.LoadUIEffect("fx_ui_masteryfullitem_boomcenter", self.config.fxUiMasterfullitemBoomer)
                    self.particleBottomDict:Add(self.model.classIndex, self.particleBottom)
                else
                    self.particleBottom = self.particleBottomDict:Get(self.model.classIndex)
                end
                if self.particleCircleCenter ~= nil then
                    self.particleCircleCenter:SetActive(false)
                    self.particleCircleCenter:SetActive(true)
                end
                self.particleBottom:SetActive(false)
                self.particleBottom:SetActive(true)
            else
                if self.particleCenter ~= nil then
                    self.particleCenter:SetActive(false)
                end
                if self.model.slotIndex == SLOT_FINAL then
                    if self.particleUpgradeCenterDict:IsContainKey(self.model.classIndex) == false then
                        self.particleCenter = ResourceLoadUtils.LoadUIEffect("fx_ui_upgrade_icon_skill_" .. self.model.classIndex, self.config.fxUiMasteryfullitemBottom)
                        self.particleUpgradeCenterDict:Add(self.model.classIndex, self.particleCenter)
                    else
                        self.particleCenter = self.particleUpgradeCenterDict:Get(self.model.classIndex)
                    end
                elseif self.model.levelSkillSelect == ResourceMgr.GetMasteryConfig().basicMasteryLevelToUnlockCustomMastery then
                    if self.particleUnlockDict:IsContainKey(self.model.classIndex) == false then
                        self.particleCenter = ResourceLoadUtils.LoadUIEffect("fx_ui_matery_icon_full10_" .. self.model.classIndex, self.config.fxUiMasteryfullitemBottom)
                        self.particleUnlockDict:Add(self.model.classIndex, self.particleCenter)
                    else
                        self.particleCenter = self.particleUnlockDict:Get(self.model.classIndex)
                    end
                else
                    if self.particleUpgradeDict:IsContainKey(self.model.classIndex) == false then
                        self.particleCenter = ResourceLoadUtils.LoadUIEffect("fx_ui_mastery_upgrade_icon_" .. self.model.classIndex, self.config.fxUiMasteryfullitemBottom)
                        self.particleUpgradeDict:Add(self.model.classIndex, self.particleCenter)
                    else
                        self.particleCenter = self.particleUpgradeDict:Get(self.model.classIndex)
                    end
                end

                self.particleCenter:SetActive(false)
                self.particleCenter.transform.position = self.skills[self.model.slotIndex].transform.position
                self.particleCenter:SetActive(true)
            end
            self:DelayCheckRequestUpgrade()
            zg.audioMgr:PlaySfxUi(SfxUiType.BUY)

            --Select next slot upgradeable
            if self.model:CanUpgradeMastery(self.model.slotIndex) == false then
                self:SelectSlotIdUpgradeable()
            end
        end
    else
        local stepUpgrade = ResourceMgr.GetMasteryConfig().basicMasteryLevelToUnlockCustomMastery
        local levelRequire = (math.max(math.floor(self.model.masteryResource:Get(self.model.classIndex):Get(SLOT_FINAL) / stepUpgrade), 0) + 1) * stepUpgrade
        PopupUtils.ShowPopupNotificationOK(string.format(LanguageUtils.LocalizeCommon("need_level_mastery"), levelRequire))
    end
end

--- @return void
function UIMasteryView:SelectSlotIdUpgradeable()
    for i = SLOT_FIRST, SLOT_FINAL, 1 do
        if i ~= self.model.slotIndex and self.model:CanUpgradeMastery(i) then
            self:SelectSlot(i)
            return
        end
    end
end

--- @return void
function UIMasteryView:ClearEffect()
    if self.particleCenter ~= nil then
        self.particleCenter:SetActive(false)
    end
    if self.particleBottom ~= nil then
        self.particleBottom:SetActive(false)
    end
end

--- @return void
function UIMasteryView:DelayCheckRequestUpgrade()
    self.timeUpgrade = zg.timeMgr.serverTime
    if self.up == nil then
        self.up = Coroutine.start(function()
            while zg.timeMgr.serverTime - self.timeUpgrade <= 1 do
                coroutine.waitforendofframe()
            end
            self:CheckRequestUpgrade()
            self.up = nil
        end)
    end
end

--- @return void
function UIMasteryView:CheckRequestUpgrade()
    if self.model.cacheMasteryUpgrade ~= nil then
        local callback = function(result)
            local onSuccess = function()
                XDebug.Log("Upgrade Mastery Success")
            end
            local onFailed = function(logicCode)
                SmartPoolUtils.LogicCodeNotification(logicCode)
            end
            NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
            self.model.cacheMasteryUpgrade = nil
        end
        NetworkUtils.Request(OpCode.MASTERY_UPGRADE, UnknownOutBound.CreateInstance(PutMethod.Byte, self.model.cacheClassMasteryUpgrade, PutMethod.Byte, self.model.cacheMasteryUpgrade, PutMethod.Byte, self.model.cacheLevelMasteryUpgrade), callback)
    end
end

--- @return void
function UIMasteryView:RequestReset()
    self:CheckRequestUpgrade()
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Reset Mastery Success")
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.MASTERY_RESET, UnknownOutBound.CreateInstance(PutMethod.Byte, self.model.classIndex), callback)
end

--- @return void
function UIMasteryView:OnClickHelpInfo()
    local info = LanguageUtils.LocalizeHelpInfo("mastery_info")
    ---@type MasteryResetPriceConfig
    local config = ResourceMgr.GetMasteryConfig().masteryResetPriceDictionary:Get(1)
    info = StringUtils.FormatLocalizeStart1(info, MathUtils.Round(config.returnRate * 100) .. "%%",
            ResourceMgr.GetMasteryConfig().basicMasteryLevelToUnlockCustomMastery)
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, info)
end

--- @return void
function UIMasteryView:OnClickReset()
    --if self.model.canResetMastery then
    --    local level = self.model.levelSkillSelect
    --    if level > 0 then
    local moneyType = nil
    local resetPrice = 0
    -----@type MasteryResetPriceConfig
    --local masteryResetPrice = ResourceMgr.GetMasteryConfig().masteryResetPriceDictionary:Get(self.model.levelSkillSelect)

    ---@type List
    local listSlot = self.model.masteryResource:Get(self.model.classIndex)
    for _, v in pairs(listSlot:GetItems()) do
        if v > 0 then
            ---@type MasteryResetPriceConfig
            local masteryResetPrice = ResourceMgr.GetMasteryConfig().masteryResetPriceDictionary:Get(v)
            moneyType = masteryResetPrice.moneyType
            resetPrice = resetPrice + masteryResetPrice.number
        end
    end
    local reset = function()
        local canReset = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, moneyType, resetPrice))
        if canReset then
            InventoryUtils.Sub(ResourceType.Money, moneyType, resetPrice)
            self:RequestReset()
            local moneyTypeDict = self:GetMoneyTypeMasteryUpgradePrice()
            for skillId, v in ipairs(listSlot:GetItems()) do
                if v > 0 then
                    local level = v
                    for i = 1, level do
                        ---@type MasteryUpgradePriceConfig
                        local masteryUpgradePrice = ResourceMgr.GetMasteryConfig().masteryUpgradePriceDictionary:Get(i)

                        if moneyTypeDict:IsContainKey(masteryUpgradePrice.moneyType1) then
                            moneyTypeDict:Add(masteryUpgradePrice.moneyType1, moneyTypeDict:Get(masteryUpgradePrice.moneyType1) + masteryUpgradePrice.number1)
                        end
                        if moneyTypeDict:IsContainKey(masteryUpgradePrice.moneyType2) then
                            moneyTypeDict:Add(masteryUpgradePrice.moneyType2, moneyTypeDict:Get(masteryUpgradePrice.moneyType2) + masteryUpgradePrice.number2)
                        end
                    end
                    ---@type MasteryResetPriceConfig
                    local tempMasteryResetPrice = ResourceMgr.GetMasteryConfig().masteryResetPriceDictionary:Get(level)
                    for key , value in pairs(moneyTypeDict:GetItems()) do
                        value = value + math.floor(value * tempMasteryResetPrice.returnRate)
                    end
                    self.model:SetLevelSkill(skillId, 0)
                end
            end
            for key , value in pairs(moneyTypeDict:GetItems()) do
                InventoryUtils.Add(ResourceType.Money, key, value)
            end

            self.model:UpdateData()
            self:UpdateUI()
        end
    end
    if resetPrice > 0 then
        PopupUtils.ShowPopupNotificationUseResource(moneyType, resetPrice, reset)
    else
        PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("want_to_reset"), nil, reset)
    end
    --end
    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    --else
    --    PopupUtils.ShowPopupNotificationOK(LanguageUtils.LocalizeCommon("need_reset_main_mastery"))
    --end
end

--- @return List
function UIMasteryView:GetMoneyTypeMasteryUpgradePrice()
    --- @type Dictionary --<lv, MasteryUpgradePriceConfig>
    local masteryUpgradePrice = ResourceMgr.GetMasteryConfig().masteryUpgradePriceDictionary

    ---@type List
    local dict = Dictionary()

    --- @param data MasteryUpgradePriceConfig
    for _ , data in ipairs(masteryUpgradePrice:GetItems()) do
        if dict:IsContainKey(data.moneyType1) == false then
            dict:Add(data.moneyType1, 0)
        end
        if dict:IsContainKey(data.moneyType2) == false then
            dict:Add(data.moneyType2, 0)
        end
    end

    return dict
end

--- @return void
function UIMasteryView:UpdateUI()
    local maxLevelConfig = ResourceMgr.GetMasteryConfig().masteryUpgradePriceDictionary:Count()
    local maxLevel = maxLevelConfig
    for i = 1, #self.skills do
        local levelSkill = self.model:GetLevelSkill(i)
        if maxLevel > levelSkill then
            maxLevel = levelSkill
        end
    end
    local stepUpgrade = ResourceMgr.GetMasteryConfig().basicMasteryLevelToUnlockCustomMastery
    maxLevel = math.min(math.floor(maxLevel / stepUpgrade) * stepUpgrade + stepUpgrade, maxLevelConfig)
    local count = 0
    for i = 1, #self.skills do
        ---@type UISkillMasteryConfig
        local skill = self.skills[i]
        skill.bgSkill.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.bgSkillMasteries, self.model.classIndex)
        skill.icon.sprite = ResourceLoadUtils.LoadSkillMasteryIcon(self.model.classIndex, i)
        skill.icon:SetNativeSize()
        skill.textLevelSkill.text = string.format("%d/%d", self.model:GetLevelSkill(i), maxLevel)
        count = count + 1
    end

    local lastSkill = self.skills[count]
    if self.model.canUpgradeCustomMastery == true then
        if self.isUpgrade == true then
            Coroutine.start(function()
                coroutine.waitforseconds(1.3)
                lastSkill.icon.material = nil
                self.isUpgrade = false
            end)
        else
            lastSkill.icon.material = nil
        end
    else
        --self.config.layerDisableCustomMastery:SetActive(true)
        local material = ResourceLoadUtils.LoadMaterial("ui_gray_mat")
        lastSkill.icon.material = material
    end

    ---@type UISkillMasteryConfig
    local skill = self.skills[self.model.slotIndex]
    self.config.iconSkill.sprite = ResourceLoadUtils.LoadSkillMasteryIconPreview(self.model.classIndex, self.model.slotIndex)
    self.config.iconSkill:SetNativeSize()

    if self.model.slotIndex == SLOT_FINAL then
        self.config.selectCenter:SetActive(true)
        self.config.selectQuad:SetActive(false)
        self.config.bgSkillPreview.gameObject:SetActive(false)
    else
        self.config.selectCenter:SetActive(false)
        self.config.selectQuad:SetActive(true)

        self.config.selectQuad.transform.position = self.skills[self.model.slotIndex].transform.position
        self.config.bgSkillPreview.gameObject:SetActive(true)
        self.config.bgSkillPreview.sprite = skill.bgSkill.sprite
    end

    ---@type SkillMasteryConfig
    local skillMastery = ResourceMgr.GetMasteryConfig():GetSkillMasteryDictionary(self.model.classIndex):Get(self.model.slotIndex)
    local levelNext = self.model.levelSkillSelect + 1
    local maxLevelSkillMastery = skillMastery.dicLevelStat:Count()
    ---@type List
    local listStatCurrent = skillMastery.dicLevelStat:Get(self.model.levelSkillSelect)
    ---@type List
    local listStatNext
    if levelNext <= maxLevelSkillMastery then
        listStatNext = skillMastery.dicLevelStat:Get(levelNext)
    end

    local statType
    if listStatCurrent ~= nil then
        statType = listStatCurrent:Get(1).statType
    else
        if listStatNext ~= nil then
            statType = listStatNext:Get(1).statType
        end
    end

    self.config.textStat.text = LanguageUtils.LocalizeClass(self.model.classIndex) .. " " .. LanguageUtils.LocalizeListStatBonus2(listStatCurrent, listStatNext)
    if statType ~= nil then
        self.config.textTenMasterySkill.text = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("mastery_name"),
                LanguageUtils.LocalizeStat(statType),
                LanguageUtils.LocalizeClass(self.model.classIndex))
    end

    if self.model.masteryUpgradePrice == nil then
        self.config.materialUpgrade:SetActive(false)
        self.config.buttonUpgrade.gameObject:SetActive(false)
        self.config.bottomContent:SetActive(false)
    else
        self.config.bottomContent:SetActive(true)
        self.config.materialUpgrade:SetActive(true)
        self.config.buttonUpgrade.gameObject:SetActive(true)
        self.goldLocalBarView:SetIconData(self.model.masteryUpgradePrice.moneyType1, false)
        self.arenaTokenLocalBarView:SetIconData(self.model.masteryUpgradePrice.moneyType2, false)
        self.goldLocalBarView:SetMoneyRequirementText(self.model.masteryUpgradePrice.moneyType1, self.model.masteryUpgradePrice.number1)
        self.arenaTokenLocalBarView:SetMoneyRequirementText(self.model.masteryUpgradePrice.moneyType2, self.model.masteryUpgradePrice.number2)
        --if self.model.slotIndex == SLOT_FINAL and self.model.canUpgradeCustomMastery == false then
        --    UIUtils.SetInteractableButton(self.config.buttonUpgrade, false)
        --else
        --    UIUtils.SetInteractableButton(self.config.buttonUpgrade, true)
        --end
    end

    self.config.buttonReset.gameObject:SetActive(self.model:CanResetMastery())

end