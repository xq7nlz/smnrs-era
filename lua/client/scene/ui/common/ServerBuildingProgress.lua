--- @class ServerBuildingProgress : MotionIconView
ServerBuildingProgress = Class(ServerBuildingProgress, MotionIconView)

--- @return void
function ServerBuildingProgress:Ctor()
    ---@type DifficultRewardItemConfig
    self.config = nil
    MotionIconView.Ctor(self)
end

function ServerBuildingProgress:SetPrefabName()
    self.prefabName = 'server_building_progress'
    self.uiPoolType = UIPoolType.ServerBuildingProgress
end

--- @param transform UnityEngine_Transform
function ServerBuildingProgress:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type ServerBuildingProgressConfig
    self.config = UIBaseConfig(transform)
end

---@param data {floorNumber, listReward|List, isClaimed, currentValue}
function ServerBuildingProgress:SetItemData(data, localize)
    self:SetLabelText(localize, data.floorNumber)
    self:SetItemReward(data.listReward, data.isClaimed)
    self:SetProgressText(data.currentValue, data.floorNumber)
    self:SetProgressLength(data.currentValue, data.floorNumber)
    self:SetNoti(data.isClaimed, data.currentValue >= data.floorNumber)
end

function ServerBuildingProgress:SetLabelText(localize, floorNumber)
    self.config.labelText.text = string.format("%s %s", localize, floorNumber)
end

function ServerBuildingProgress:SetNoti(isClaimed, isCollectable)
    if isClaimed then
        self.config.iconNoti:SetActive(not isClaimed)
    elseif not isClaimed and isCollectable then
        self.config.iconNoti:SetActive(isCollectable)
    else
        self.config.iconNoti:SetActive(false)
    end
end

function ServerBuildingProgress:SetProgressLength(currentValue, floorNumber)
    self.config.progressBarGreen.fillAmount = currentValue / floorNumber
end

function ServerBuildingProgress:SetProgressText(currentValue, progressValue)
    self.config.textProgress.text = string.format("%s/%s", currentValue, progressValue)
end

---@param listReward List
function ServerBuildingProgress:SetItemReward(listReward, isClaimed)
    self.listRewardIcon = List()
    ---@param v RewardInBound
    for _, v in pairs(listReward:GetItems()) do
        ---@type RootIconView
        local rootIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.rewardAnchor)
        rootIconView:SetIconData(v:GetIconData())
        rootIconView:SetSize(0, 0)
        rootIconView:ActiveTickSelect(isClaimed, U_Vector2(183, 158))
        rootIconView:AddListener(function()
            rootIconView:ShowInfo()
        end)
        self.listRewardIcon:Add(rootIconView)
    end
end

function ServerBuildingProgress:ReturnPoolListIcon()
    ---@param v RootIconView
    for _, v in pairs(self.listRewardIcon:GetItems()) do
        v:ReturnPool()
    end
    self.listRewardIcon:Clear()
end

function ServerBuildingProgress:ReturnPool()
    MotionIconView.ReturnPool(self)
    self:ReturnPoolListIcon()
end

return ServerBuildingProgress