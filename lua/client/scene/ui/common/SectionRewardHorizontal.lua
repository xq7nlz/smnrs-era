--- @class SectionRewardHorizontal : MotionIconView
SectionRewardHorizontal = Class(SectionRewardHorizontal, MotionIconView)

--- @return void
function SectionRewardHorizontal:Ctor()
    ---@type SectionRewardHorizontalConfig
    self.config = nil
    ---@type List
    self.listRootIconView = List()
    MotionIconView.Ctor(self)
end

function SectionRewardHorizontal:SetPrefabName()
    self.prefabName = 'section_reward_horizontal'
    self.uiPoolType = UIPoolType.SectionRewardHorizontal
end

function SectionRewardHorizontal:InitButton(isUpper)
    self.config.buttonShowReward.onClick:AddListener(function()
        self:SetArrowUpperEnable(isUpper)
    end)
    self.config.buttonCloseReward.onClick:AddListener(function()
        self:DisableAllArrow()
    end)
end

--- @param transform UnityEngine_Transform
function SectionRewardHorizontal:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    self.config = UIBaseConfig(transform)
end

function SectionRewardHorizontal:SetSectionValue(value, isReached)
    local color
    if isReached then
        color = UIUtils.black1
    else
        color = UIUtils.white
    end
    self.config.sectionText.text = UIUtils.SetColorString(color, value)
end

function SectionRewardHorizontal:DisableAllArrow()
    self.config.arrowUpper:SetActive(false)
    self.config.arrowBelow:SetActive(false)
    self.config.buttonCloseReward.gameObject:SetActive(false)
end

function SectionRewardHorizontal:SetArrowUpperEnable(isUpper)
    self.config.arrowUpper:SetActive(isUpper)
    self.config.arrowBelow:SetActive(not isUpper)
    self.config.buttonCloseReward.gameObject:SetActive(true)
end

---@param listRewardInBound List|RewardInBoundo
function SectionRewardHorizontal:SetSectionReward(listRewardInBound, isUpper, isCollected)
    local anchor
    if isUpper then
        anchor = self.config.rewardAnchorUpper
    else
        anchor = self.config.rewardAnchorBelow
    end
    ---@param v RewardInBound
    for _, v in pairs(listRewardInBound:GetItems()) do
        ---@type RootIconView
        local rootIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, anchor)
        rootIconView:SetIconData(v:GetIconData())
        rootIconView:ActiveTickSelect(isCollected, U_Vector2(183, 158))
        self.listRootIconView:Add(rootIconView)
    end
end

function SectionRewardHorizontal:IsSectionReached(isReached)
    self.config.sectionBgReached:SetActive(isReached)
    self.config.sectionBgNormal:SetActive(not isReached)
end

---@param data {sectionValue|number, sectionListReward|List, sliderValue|number, isCollected|boolean}
function SectionRewardHorizontal:SetData(data, isUpper)
    local isReached = data.sectionValue <= data.sliderValue
    self:DisableAllArrow()
    self:InitButton(isUpper)
    self:SetSectionValue(data.sectionValue, isReached)
    self:IsSectionReached(isReached)
    self:SetSectionReward(data.sectionListReward, isUpper, data.isCollected)
end

function SectionRewardHorizontal:ReturnPoolRootIconView()
    ---@param v RootIconView
    for _, v in pairs(self.listRootIconView:GetItems()) do
        v:ReturnPool()
    end
    self.listPoolType:Clear()
end

function SectionRewardHorizontal:ReturnPool()
    MotionIconView.ReturnPool(self)
    self:ReturnPoolRootIconView()
    self:DisableAllArrow()
    self:IsSectionReached(false)
end

return SectionRewardHorizontal