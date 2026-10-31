--- @class RoundRewardItem : IconView
RoundRewardItem = Class(RoundRewardItem, IconView)

function RoundRewardItem:Ctor()
    --- @type RootIconView
    self.rootIconView = nil
    IconView.Ctor(self)
end

function RoundRewardItem:SetPrefabName()
    self.prefabName = 'round_reward_item'
    self.uiPoolType = UIPoolType.RoundRewardItem
end

--- @param transform UnityEngine_Transform
function RoundRewardItem:SetConfig(transform)
    ---@type RoundRewardItemConfig
    self.config = UIBaseConfig(transform)
end

--- @param rewardInBound RewardInBound
--- @param roundState QuestState
function RoundRewardItem:SetIconData(round, rewardInBound, roundState, clickCallback)
    self.config.textRound.text = string.format("%s %s", LanguageUtils.LocalizeCommon("round"), round)

    if roundState == QuestState.COMPLETED then
        self:ActiveMaskSelect(true)
    end

    self:EnableHighlight(roundState == QuestState.DONE_REWARD_NOT_CLAIM)

    if self.rootIconView == nil then
        self.rootIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.rewardAnchor)
    end

    self.rootIconView:SetIconData(rewardInBound:GetIconData())

    self.rootIconView:AddListener(function ()
        if clickCallback then
            clickCallback()
        end
    end)
end

function RoundRewardItem:EnableHighlight(isEnable)
    self.config.highlight:SetActive(isEnable)
end

function RoundRewardItem:ShowRewardInfo()
    self.rootIconView:ShowInfo()
end

function RoundRewardItem:ReturnPool()
    IconView.ReturnPool(self)

    if self.rootIconView ~= nil then
        self.rootIconView:ReturnPool()
        self.rootIconView = nil
    end
end

return RoundRewardItem