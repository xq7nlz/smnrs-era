--- @class TowerOfEitriPopupQuestItem : MotionIconView
TowerOfEitriPopupQuestItem = Class(TowerOfEitriPopupQuestItem, MotionIconView)

--- @return void
function TowerOfEitriPopupQuestItem:Ctor()
    ---@type DifficultRewardItemConfig
    self.config = nil
    MotionIconView.Ctor(self)
end

function TowerOfEitriPopupQuestItem:SetPrefabName()
    self.prefabName = 'server_building_progress'
    self.uiPoolType = UIPoolType.TowerOfEitriPopupQuestItem
end

--- @param transform UnityEngine_Transform
function TowerOfEitriPopupQuestItem:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type ServerBuildingProgressConfig
    self.config = UIBaseConfig(transform)
end

---@param data {requireValue, listReward|List, isClaimed, currentValue, localize}
function TowerOfEitriPopupQuestItem:SetItemData(data)
    self:SetLabelText(data.localize)
    self:SetItemReward(data.listReward, data.isClaimed)
    self:SetProgressText(data.currentValue, data.requireValue)
    self:SetProgressLength(data.currentValue, data.requireValue)
    self:SetNoti(data.isClaimed, data.currentValue >= data.requireValue)
end

function TowerOfEitriPopupQuestItem:SetLabelText(localize)
    self.config.labelText.text = localize
end

function TowerOfEitriPopupQuestItem:SetNoti(isClaimed, isCollectable)
    if isClaimed then
        self.config.iconNoti:SetActive(not isClaimed)
    elseif not isClaimed and isCollectable then
        self.config.iconNoti:SetActive(isCollectable)
    else
        self.config.iconNoti:SetActive(false)
    end
end

function TowerOfEitriPopupQuestItem:SetProgressLength(currentValue, floorNumber)
    self.config.progressBarGreen.fillAmount = currentValue / floorNumber
end

function TowerOfEitriPopupQuestItem:SetProgressText(currentValue, progressValue)
    self.config.textProgress.text = string.format("%s/%s", currentValue, progressValue)
end

---@param listReward List
function TowerOfEitriPopupQuestItem:SetItemReward(listReward, isClaimed)
    self.listRewardIcon = List()
    ---@param v RewardInBound
    for _, v in pairs(listReward:GetItems()) do
        ---@type RootIconView
        local rootIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.rewardAnchor)
        rootIconView:SetIconData(v)
        rootIconView:SetSize(0, 0)
        rootIconView:ActiveTickSelect(isClaimed, U_Vector2(183, 158))
        rootIconView:AddListener(function()
            rootIconView:ShowInfo()
        end)
        self.listRewardIcon:Add(rootIconView)
    end
end

function TowerOfEitriPopupQuestItem:ReturnPoolListIcon()
    ---@param v RootIconView
    for _, v in pairs(self.listRewardIcon:GetItems()) do
        v:ReturnPool()
    end
    self.listRewardIcon:Clear()
end

function TowerOfEitriPopupQuestItem:ReturnPool()
    MotionIconView.ReturnPool(self)
    self:ReturnPoolListIcon()
end

return TowerOfEitriPopupQuestItem