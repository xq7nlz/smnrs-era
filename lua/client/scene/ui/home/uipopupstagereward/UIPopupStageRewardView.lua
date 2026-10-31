--- @class UIPopupStageRewardView : UIBaseView
UIPopupStageRewardView = Class(UIPopupStageRewardView, UIBaseView)

--- @type UnityEngine_Vector2
local scrollSizeWithUserItem = U_Vector2(1355, 635)
--- @type UnityEngine_Vector2
local scrollSizeWithoutUserItem = U_Vector2(1355, 780)
--- @type UnityEngine_Vector3
local scrollPosition = U_Vector3(0, -170, 0)
--- @type UnityEngine_Vector3
local rankInfoAnchorPosition = U_Vector3(-37.5, 0, 0)
--- @type UnityEngine_Vector3
local itemSize = U_Vector2(1300, 148)

function UIPopupStageRewardView:Ctor(model)
    UIBaseView.Ctor(self, model)
    --- @type UIPopupStageRewardModel
    self.model = model
    --- @type DefenseModeStageRewardItemView
    self.userLeaderBoardItemView = nil
    ---@type LandConfig
    self.stageConfig = nil
end

function UIPopupStageRewardView:OnReadyCreate()
    ---@type DefenseModeStageRewardConfig
    self.config = UIBaseConfig(self.uiTransform)
    self:InitScroll()
    self:InitButtons()
end

function UIPopupStageRewardView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("defense_stage_reward")
end

function UIPopupStageRewardView:InitButtons()
    self.config.bgNone.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end
--- @return void
function UIPopupStageRewardView:OnReadyShow(result)
    self.currentStage = result.currentStage
    self.landId = result.landId
    self.stageConfig = ResourceMgr.GetDefenseModeConfig():GetLandConfig(self.landId)

    self:ShowLeaderBoardData()
end

function UIPopupStageRewardView:SetupInfo()
    if self.currentStage > 0 then
        self:SetUserCurrentStage()
        self.config.scrollRect.sizeDelta = scrollSizeWithUserItem
    else
        self.config.scrollRect.sizeDelta = scrollSizeWithoutUserItem
    end
    self.config.scrollRect.anchoredPosition3D = scrollPosition
end

function UIPopupStageRewardView:ShowLeaderBoardData()
    self.size = self.stageConfig.dictLandStageConfig:Count()
    self.uiScroll:Resize(self.size)
    self:SetupInfo()
    --self.config.empty:SetActive(size == 0)
end

function UIPopupStageRewardView:SetUserCurrentStage()
    if self.userLeaderBoardItemView == nil then
        self.userLeaderBoardItemView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.StageRewardItemVew, self.config.userLeaderBoardItemAnchor)
    end
    self.userLeaderBoardItemView.config.gameObject:SetActive(true)
    self.userLeaderBoardItemView:SetData(self.currentStage, self.stageConfig:GetLandStageConfig(self.currentStage):GetListIconData())
    self.userLeaderBoardItemView:SetBgText(true)
    self.userLeaderBoardItemView:IsEnableMask(false)
end

function UIPopupStageRewardView:Hide()
    UIBaseView.Hide(self)
    if self.userLeaderBoardItemView ~= nil then
        self.userLeaderBoardItemView:IsEnableMask(false)
        self.userLeaderBoardItemView:ReturnPool()
        self.userLeaderBoardItemView = nil
    end
end

function UIPopupStageRewardView:InitScroll()
    --- @param obj DefenseModeStageRewardItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        ---@type LandConfig
        local data = self.stageConfig
        obj:SetData(dataIndex, data:GetLandStageConfig(dataIndex):GetListIconData())
        obj:SetBgText(false)
        obj:IsEnableMask(self.currentStage > dataIndex)
    end
    --- @type UILoopScroll
    self.uiScroll = UILoopScroll(self.config.loopScrollRect, UIPoolType.StageRewardItemVew, onCreateItem)
    self.uiScroll:SetUpMotion(MotionConfig(0, 0, 0, 0.02, 3))
end

