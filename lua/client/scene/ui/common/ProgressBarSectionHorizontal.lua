--- @class ProgressBarSectionHorizontal : IconView
ProgressBarSectionHorizontal = Class(ProgressBarSectionHorizontal, UIPrefabView)

--- @return void
------ @param transform UnityEngine_Transform
function ProgressBarSectionHorizontal:Ctor(transform)
    ---@type ProgressBarSectionHorizontalConfig
    self.config = nil
    ---@type List
    self.listSectionReward = List()
    self:SetConfig(transform)
end

--- @return void
function ProgressBarSectionHorizontal:SetPrefabName()
    self.prefabName = 'progress_bar_section_horizontal'
    self.uiPoolType = UIPoolType.ProgressBarSectionHorizontal
end

--- @return void
--- @param transform UnityEngine_Transform
function ProgressBarSectionHorizontal:SetConfig(transform)
    self.config = UIBaseConfig(transform)
end

function ProgressBarSectionHorizontal:SetSliderValue(sliderValue)
    if sliderValue > self.config.slider.maxValue then
        self.config.slider.value = self.config.slider.maxValue
    else
        self.config.slider.value = sliderValue
    end
    self.config.sliderText.text = UIUtils.SetColorString(UIUtils.red1, sliderValue)
end

---@param dictSection Dictionary{sectionValue|number, sectionListReward|List}
---@param sliderValue number
---@param listFloorNumberRequire List
---@param listServerBuildingCollected List
function ProgressBarSectionHorizontal:InitSection(dictSection, sliderValue, listFloorNumberRequire, listServerBuildingCollected)
    local i = 0
    for _, v in pairs(listFloorNumberRequire:GetItems()) do
        i = i + 1
        ---@type {sectionValue|number, sectionListReward|List, sliderValue|number}
        local data = {}
        data.sectionValue = v
        data.sectionListReward = dictSection:Get(v)
        data.sliderValue = sliderValue
        local isCollected = listServerBuildingCollected:IsContainValue(v)
        data.isCollected = isCollected
        ---@type SectionRewardHorizontal
        local sectionReward = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.SectionRewardHorizontal, self.config.sectionAnchor)
        --Check if i % 2 == 1 then set Object is Upper else is Below
        sectionReward:SetData(data, i % 2 == 1)
        self.listSectionReward:Add(sectionReward)
    end
end

---@param data {sliderValue, dictSection|Dictionary, listFloorNumberRequire|List, listServerBuildingCollected|List}
function ProgressBarSectionHorizontal:SetItemData(data)
    self:SetSliderValue(data.sliderValue)
    self:InitSection(data.dictSection, data.sliderValue, data.listFloorNumberRequire, data.listServerBuildingCollected)
end

function ProgressBarSectionHorizontal:ReturnPoolSectionReward()
    ---@param v SectionRewardHorizontal
    for _, v in pairs(self.listSectionReward:GetItems()) do
        v:ReturnPool()
    end
    self.listSectionReward:Clear()
end

function ProgressBarSectionHorizontal:DisablePopupSectionReward()
    ---@param v SectionRewardHorizontal
    for _, v in pairs(self.listSectionReward:GetItems()) do
        v:DisableAllArrow()
    end
end

function ProgressBarSectionHorizontal:ReturnPool()
    self:DisablePopupSectionReward()
    self:ReturnPoolSectionReward()
end

return ProgressBarSectionHorizontal


