--- @class DefenseModeStageRewardItemView : MotionIconView
DefenseModeStageRewardItemView = Class(DefenseModeStageRewardItemView, MotionIconView)
DefenseModeStageRewardItemView.MaxTopRankHasIcon = 3

function DefenseModeStageRewardItemView:Ctor()
    --- @type ItemsTableView
    self.itemsTableView = nil
    MotionIconView.Ctor(self)
    self:InitItemTableView()
end

function DefenseModeStageRewardItemView:SetPrefabName()
    self.prefabName = 'defense_mode_stage_reward_item'
    self.uiPoolType = UIPoolType.StageRewardItemVew
end

--- @param transform UnityEngine_Transform
function DefenseModeStageRewardItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    --- @type LeaderBoardItemConfig
    self.config = UIBaseConfig(transform)
end

function DefenseModeStageRewardItemView:ReturnPool()
    MotionIconView.ReturnPool(self)
end

--- @return ItemsTableView
function DefenseModeStageRewardItemView:InitItemTableView()
    self.itemsTableView = ItemsTableView(self.config.rewardAnchor)
    return self.itemsTableView
end

--- @return ItemsTableView
function DefenseModeStageRewardItemView:IsEnableMask(isEnable)
    self.itemsTableView:ActiveMaskSelect(isEnable)
end

function DefenseModeStageRewardItemView:SetData(stageId, listReward)
    self.config.name.text = string.format("%s %s", LanguageUtils.LocalizeCommon("stage"), stageId)
    self.itemsTableView:SetData(listReward)
end

--- @param isUser boolean
function DefenseModeStageRewardItemView:SetBgText(isUser)
    local changeColor_1 = isUser and UIUtils.white or UIUtils.brown
    if self.config.name ~= nil then
        self.config.name.text = UIUtils.SetColorString(changeColor_1, self.config.name.text)
    end
    self.config.bgGrown:SetActive(not isUser)
    self.config.bgYellow:SetActive(isUser)
end

return DefenseModeStageRewardItemView