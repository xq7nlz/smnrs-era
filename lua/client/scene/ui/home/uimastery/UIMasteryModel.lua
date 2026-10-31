--- @class UIMasteryModel : UIBaseModel
UIMasteryModel = Class(UIMasteryModel, UIBaseModel)

--- @return void
function UIMasteryModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UIMastery, "popup_mastery")
    --- @type UIPopupType
    self.type = UIPopupType.NO_BLUR_POPUP
    ---@type HeroClassType
    self.classIndex = 0
    ---@type HeroClassType
    self.slotIndex = 0
    ---@type Dictionary  --<classId, Dictionary<slotId, level>>
    self.masteryResource = nil
    ---@type number
    self.levelSkillSelect = 0
    ---@type MasteryUpgradePriceConfig
    self.masteryUpgradePrice = nil
    ---@type boolean
    self.canUpgradeCustomMastery = false
    ---@type boolean
    self.canResetMastery = false
    ---@type number
    self.cacheClassMasteryUpgrade = nil
    ---@type number
    self.cacheMasteryUpgrade = nil
    ---@type number
    self.cacheLevelMasteryUpgrade = nil

    self.bgDark = false
end

--- @return void
function UIMasteryModel:InitData()
    self.masteryResource = zg.playerData:GetMethod(PlayerDataMethod.MASTERY).classDict
end

--- @return void
function UIMasteryModel:UpdateData()
    self.levelSkillSelect = 0
    if self.masteryResource:IsContainKey(self.classIndex) then
        ---@type List
        local listSlot = self.masteryResource:Get(self.classIndex)
        self.levelSkillSelect = listSlot:Get(self.slotIndex)
        if self.levelSkillSelect < 0 then
            self.levelSkillSelect = 0
        end
    end
    if self.levelSkillSelect >= ResourceMgr.GetMasteryConfig().masteryUpgradePriceDictionary:Count() then
        self.masteryUpgradePrice = nil
    else
        self.masteryUpgradePrice = ResourceMgr.GetMasteryConfig().masteryUpgradePriceDictionary:Get(self.levelSkillSelect + 1)
    end
    self:CheckUnlockCustomMastery()
    self:CheckCanResetMastery()
end

--- @return void
---@param skillId number
function UIMasteryModel:GetLevelSkill(skillId)
    local level = 0
    if self.masteryResource:IsContainKey(self.classIndex) then
        ---@type List
        local listSlot = self.masteryResource:Get(self.classIndex)
        level = listSlot:Get(skillId)
        if level < 0 then
            level = 0
        end
    end
    return level
end

--- @return void
function UIMasteryModel:CheckUnlockCustomMastery()
    self.canUpgradeCustomMastery = true
    if self.masteryResource:IsContainKey(self.classIndex) then
        ---@type List
        local listSlot = self.masteryResource:Get(self.classIndex)
        for i = 1, 5 do
            local level = listSlot:Get(i)
            if level < ResourceMgr.GetMasteryConfig().basicMasteryLevelToUnlockCustomMastery then
                self.canUpgradeCustomMastery = false
                break
            end
        end
    else
        self.canUpgradeCustomMastery = false
    end
end

--- @return void
function UIMasteryModel:CheckCanUpgradeCustomMastery()
    local canUpgrade = true
    local levelCache = nil
    if self.masteryResource:IsContainKey(self.classIndex) then
        local stepUpgrade = ResourceMgr.GetMasteryConfig().basicMasteryLevelToUnlockCustomMastery
        ---@type List
        local listSlot = self.masteryResource:Get(self.classIndex)
        for i = 1, 5 do
            local level = listSlot:Get(i)
            if levelCache ~= nil then
                if level < stepUpgrade or level ~= levelCache or level % stepUpgrade ~= 0 then
                    canUpgrade = false
                    break
                end
            else
                levelCache = level
            end
        end
    else
        canUpgrade = false
    end
    return canUpgrade
end

--- @return boolean
function UIMasteryModel:GetLevelSlot(id)
    ---@type List
    local listSlot = self.masteryResource:Get(self.classIndex)
    return math.max(0, listSlot:Get(id))
end

--- @return boolean
function UIMasteryModel:CanUpgradeMastery(id)
    local canUpgrade = true
    if self.masteryResource:IsContainKey(self.classIndex) then
        local stepUpgrade = ResourceMgr.GetMasteryConfig().basicMasteryLevelToUnlockCustomMastery
        if id == 6 then
            local step = math.floor(self:GetLevelSlot(6) / stepUpgrade) + 1
            for i = 1, 5 do
                if math.floor(self:GetLevelSlot(i) / stepUpgrade) < step then
                    canUpgrade = false
                    break
                end
            end
        else
            local step = math.max(math.floor(self:GetLevelSlot(6) / stepUpgrade), 0)
            if math.floor(self:GetLevelSlot(id) / stepUpgrade) > step then
                canUpgrade = false
            end
        end
    elseif id == 6 then
        canUpgrade = false
    end
    return canUpgrade
end

--- @return void
function UIMasteryModel:CheckCanResetMastery()
    self.canResetMastery = true
    if self:GetLevelSkill(6) > 0 and self.slotIndex ~= 6 then
        self.canResetMastery = false
    end
end

--- @return void
function UIMasteryModel:CanResetMastery()
    local canReset = false
    if self.masteryResource:IsContainKey(self.classIndex) then
        ---@type List
        local listSlot = self.masteryResource:Get(self.classIndex)
        for _, v in pairs(listSlot:GetItems()) do
            if v > 0 then
                canReset = true
                break
            end
        end
    end
    return canReset
end

--- @return void
--- @param level number
function UIMasteryModel:SetLevelSkill(skill, level)
    ---@type List
    local listSlot
    if self.masteryResource:IsContainKey(self.classIndex) then
        listSlot = self.masteryResource:Get(self.classIndex)
    else
        listSlot = List()
        self.masteryResource:Add(self.classIndex, listSlot)
    end
    listSlot:SetItemAtIndex(level, skill)
end

--- @return void
--- @param level number
function UIMasteryModel:SetLevelSkillSelect(level)
    self.levelSkillSelect = level
    self:SetLevelSkill(self.slotIndex, level)
end

--- @return boolean
function UIMasteryModel:GetUseResourceList()
    if self.rewardList == nil then
        self.rewardList = List()
    else
        self.rewardList:Clear()
    end
    self.rewardList:Add(RewardInBound.CreateBySingleParam(ResourceType.Money, self.masteryUpgradePrice.moneyType1, self.masteryUpgradePrice.number1))
    self.rewardList:Add(RewardInBound.CreateBySingleParam(ResourceType.Money, self.masteryUpgradePrice.moneyType2, self.masteryUpgradePrice.number2))
    return self.rewardList
end

--- @return boolean
function UIMasteryModel:UseResources()
    InventoryUtils.Sub(ResourceType.Money, self.masteryUpgradePrice.moneyType1, self.masteryUpgradePrice.number1)
    InventoryUtils.Sub(ResourceType.Money, self.masteryUpgradePrice.moneyType2, self.masteryUpgradePrice.number2)
end