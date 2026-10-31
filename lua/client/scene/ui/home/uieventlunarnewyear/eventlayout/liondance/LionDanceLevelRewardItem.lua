--- @class LionDanceLevelRewardItem : UIEventQuestItem
LionDanceLevelRewardItem = Class(LionDanceLevelRewardItem, UIEventQuestItem)

function LionDanceLevelRewardItem:Ctor()
    --- @type LionDanceRewardItemConfig
    self.config = nil
    ---@type List
    self.listIconData = List()
    --- @type List
    self.listItemSelect = List()
    --- @type List
    self.listItemSlot = List()
    UIEventQuestItem.Ctor(self)
    --- @type EventLunarNewYearModel
    self.eventModel = nil
    --self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_LUNAR_NEW_YEAR_2022)
    --- @type QuestElementConfig
    self.questElementConfig = nil
    --- @type QuestUnitInBound
    self.questUnitInBound = nil
    ---@type SlotHeroIconView
    self.iconSelectView = nil
    ---@type Dictionary
    self.selectionDict = Dictionary()
    --- @type List
    self.listIconItem = List()
end

function LionDanceLevelRewardItem:SetPrefabName()
    self.prefabName = 'lion_dance_level_reward'
    self.uiPoolType = UIPoolType.LionDanceLevelRewardItem
    self.lastPlayerId = PlayerSettingData.playerId
    self.lastServerId = PlayerSettingData.serverId
end

function LionDanceLevelRewardItem:InitLocalization()
end

--- @param isHighlight boolean
function LionDanceLevelRewardItem:Highlight(isHighlight)
    self.config.highlight:SetActive(isHighlight)
end

function LionDanceLevelRewardItem:SetClaimed(isClaimed)
    self.config.blackMask:SetActive(isClaimed)
end

function LionDanceLevelRewardItem:SetButtonVisual(questState, featureMapping)
    self.config.highlight.gameObject:SetActive(false)
    self.config.blackMask.gameObject:SetActive(false)
    if questState == QuestState.DONE_REWARD_NOT_CLAIM then
        self.config.highlight.gameObject:SetActive(true)
    elseif questState == QuestState.COMPLETED then
        self.config.blackMask.gameObject:SetActive(true)
    end
end

function LionDanceLevelRewardItem:CheckClearSelectionDict()
    local currentPlayerId = PlayerSettingData.playerId
    local currentSeverId = PlayerSettingData.serverId
    if currentPlayerId ~= self.lastPlayerId then
        self.selectionDict:Clear()
        self.lastPlayerId = currentPlayerId
    elseif currentSeverId ~= self.lastServerId then
        self.selectionDict:Clear()
        self.lastServerId = currentSeverId
    end
end

--- @param questElementConfig QuestElementConfig
--- @param questUnitInBound QuestUnitInBound
--- @param recordProgress number
--- @param extraReward RewardInBound
function LionDanceLevelRewardItem:SetData(questElementConfig, questUnitInBound, recordProgress, extraReward)
    self:CheckClearSelectionDict()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_LUNAR_NEW_YEAR_2022)
    self.eventConfig = self.eventModel:GetConfig()
    self.questUnitInBound = questUnitInBound
    self.questElementConfig = questElementConfig
    self.questId = self.questUnitInBound.questId
    --- @type QuestType
    local questType = self.questElementConfig:GetQuestType()
    local listIconReward = List()
    if self.questElementConfig.isSelectionReward then
        self:CreateItemSlot()
        self:CreateItemSelect()
    else
        listIconReward = RewardInBound.GetItemIconDataList(self.questElementConfig:GetListReward())
    end
    if extraReward ~= nil then
        listIconReward:Add(extraReward:GetIconData())
    end
    self.itemsTableView:SetData(listIconReward)
    local mainReq = self.questElementConfig:GetMainRequirementTarget()
    if self.questUnitInBound ~= nil then
        mainReq = self.questUnitInBound.fixedTarget or mainReq
        local number = self.questUnitInBound.number
        self:SetButtonVisual(self.questUnitInBound.questState, self.questElementConfig:GetFeatureMappingData())
        if questType == QuestType.HERO_COLLECT_ALL_BASE_STAR then
            local factionReq = self.questElementConfig:GetRequirements():Get(4)
            if MathUtils.IsNumber(factionReq) == true then
                mainReq = ResourceMgr.GetHeroMenuConfig():GetNumberOfHeroBaseByStarAndFaction(mainReq, factionReq)
            else
                mainReq = ResourceMgr.GetHeroMenuConfig():GetNumberOfHeroBaseByStarAndFaction(mainReq, nil)
            end
        end
    end
end

function LionDanceLevelRewardItem:SlotSelected()
    local listSelectId = self.eventModel:GetSelectItemLionDance(self.questId)
    if not listSelectId then
        listSelectId = self.selectionDict:Get(self.questId)
    end
    if (listSelectId ~= nil and listSelectId > 0) then
        return true
    end
    return false
end

function LionDanceLevelRewardItem:CreateItemSelect()
    -- index in list select id
    self:ReturnPoolItemSelect()
    ---@type SlotHeroIconView
    local slot = self.listItemSlot:Get(1)
    ---@type ItemIconView
    local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, slot.config.slot_hero)
    self.selection = self.eventModel:GetSelectItemLionDance(self.questId)
    if not self.selection then
        self.selection = self.selectionDict:Get(self.questId)
    end
    if (self.selection ~= nil) then
        --- @type RewardInBound
        local rewardInbound = self.questElementConfig.rewardSelectionItemDict:Get(self.selection).rewardInBound
        iconView:SetIconData(rewardInbound:GetIconData())
    end
    self.listItemSelect:Add(iconView)
    iconView:ActiveUIPool(UIPoolType.Noti, self.selection == nil)
    self:UpdateIconViewChange(iconView)
end

function LionDanceLevelRewardItem:CreateItemSlot()
    self:ReturnPoolItemSlot()
    if self.questElementConfig.isSelectionReward == true then
        for i = 1, self.eventConfig.numberSelect do
            ---@type SlotHeroIconView
            local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.SlotHeroIconView, self.config.itemAnchor)
            local index = i
            if not (self.questUnitInBound.questState == QuestState.COMPLETED) then
                iconView:AddListener(function()
                    self:SelectItem(iconView)
                end)
            end
            self:UpdateIconViewChange(iconView)
            self.listItemSlot:Add(iconView)
        end
    end
end

function LionDanceLevelRewardItem:ReturnPoolItemSlot()
    for i = 1, self.listItemSlot:Count() do
        self.listItemSlot:Get(i):ReturnPool()
    end
    self.listItemSlot:Clear()
    self.iconSelectView = nil
end

function LionDanceLevelRewardItem:ReturnPoolItemSelect()
    ---@param v ItemIconView
    for i, v in pairs(self.listItemSelect:GetItems()) do
        v:ReturnPool()
    end
    self.listItemSelect:Clear()
end

function LionDanceLevelRewardItem:UpdateIconViewChange(iconView)
    self.iconSelectView = iconView
    iconView:ActiveUIPool(UIPoolType.Change,
            not self.isSoldOut and self:SlotSelected(), U_Vector2(130, 130))
end

---@param iconView SlotHeroIconView
function LionDanceLevelRewardItem:SelectItem(iconView)
    if (self.questUnitInBound.questState == QuestState.COMPLETED) then
        local iconData = self.questElementConfig.rewardSelectionItemDict:Get(self.selection).rewardInBound:GetIconData()
        PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = { ["type"] = iconData.type, ["id"] = iconData.itemId } })
    else
        local listItem = List()
        local listItemSelect = List()
        ---@param v SelectReward
        for i, v in ipairs(self.questElementConfig.rewardSelectionList:GetItems()) do
            local item = v.rewardInBound:GetIconData()
            item.index = i
            listItem:Add(item)
        end
        local listSelectId = self.eventModel:GetSelectItemLionDance(self.questId)
        if not listSelectId then
            listSelectId = self.selectionDict:Get(self.questId)
        end
        if listSelectId ~= nil then
            listItemSelect:Add(listSelectId)
        end
        local data = {}
        data.packId = self.questId
        data.numberSelect = 1
        data.onSelectHeroSuccess = function(listIndex)
            self.eventModel:AddSelectItemLionDance(self.questId, listIndex:Get(1))
            self.selectionDict:Add(self.questId, listIndex:Get(1))
            self:CreateItemSelect()
        end
        local rewardPool = List()
        for i = 1, self.questElementConfig.rewardSelectionList:Count() do
            rewardPool:Add(self.questElementConfig.rewardSelectionList:Get(i).rewardInBound)
        end
        data.rewardSelectionList = rewardPool
        data.selectedIndex = -1
        data.selectItems = List()
        if (listItemSelect:Count() > 0) then
            data.selectedIndex = listItemSelect:Get(1)
            data.selectItems:Add(data.selectedIndex)
        end
        data.opCode = OpCode.EVENT_LUNAR_2022_LION_DANCE_SELECT
        PopupMgr.ShowPopup(UIPopupName.UIPreviewLionDanceFragment, data)
    end

end

function LionDanceLevelRewardItem:ReturnPool()
    IconView.ReturnPool(self)
    self.itemsTableView:Hide()
    self:ReturnPoolItemSelect()
    self:ReturnPoolItemSlot()
end

function LionDanceLevelRewardItem:ItemHasNoti()
    return self.eventModel:GetSelectItemLionDance(self.questId) == nil
end

--- @return void
function LionDanceLevelRewardItem:RemoveAllListeners()
end

return LionDanceLevelRewardItem