--- @class ArenaRewardItemView : IconView
ArenaRewardItemView = Class(ArenaRewardItemView, IconView)

--- @return void
function ArenaRewardItemView:Ctor()
    --- @type UnityEngine_Color
    self.color = nil
    IconView.Ctor(self)
    ---@type ArenaRewardRankingConfig
    self.rewardRanking = nil
    ---@type List
    self.listReward = List()
end

--- @return void
function ArenaRewardItemView:SetPrefabName()
    self.prefabName = 'arena_reward_item_view'
    self.uiPoolType = UIPoolType.ArenaRewardItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function ArenaRewardItemView:SetConfig(transform)
    --- @type ArenaRewardItemConfig
    self.config = UIBaseConfig(transform)
    self.color = self.config.textRankName.color
end

--- @return void
---@param rewardRanking ArenaRewardRankingConfig
---@param isCurrentRanking boolean
function ArenaRewardItemView:SetData(rewardRanking, isCurrentRanking, featureType)
    self.config.currentRank:SetActive(isCurrentRanking or false)
    self.rewardRanking = rewardRanking
    if rewardRanking == ResourceMgr.GetArenaRewardRankingConfig():GetArenaTopRanking(1, featureType) then
        self.config.iconLeaderBoard.sprite = ResourceLoadUtils.LoadArenaRank12Icon(1)
        self.config.textRankName.text = LanguageUtils.LocalizeCommon("ranking_top_1")
    elseif rewardRanking == ResourceMgr.GetArenaRewardRankingConfig():GetArenaTopRanking(2, featureType) then
        self.config.iconLeaderBoard.sprite = ResourceLoadUtils.LoadArenaRank12Icon(2)
        self.config.textRankName.text = LanguageUtils.LocalizeCommon("ranking_top_2")
    elseif rewardRanking == ResourceMgr.GetArenaRewardRankingConfig():GetArenaTopRanking(3, featureType) then
        self.config.iconLeaderBoard.sprite = ResourceLoadUtils.LoadArenaRank12Icon(3)
        self.config.textRankName.text = LanguageUtils.LocalizeCommon("ranking_top_3")
    elseif rewardRanking == ResourceMgr.GetArenaRewardRankingConfig():GetArenaTopRanking(4, featureType) then
        self.config.iconLeaderBoard.sprite = ResourceLoadUtils.LoadArenaRank12Icon(4)
        self.config.textRankName.text = LanguageUtils.LocalizeCommon("ranking_top_6")
    elseif rewardRanking == ResourceMgr.GetArenaRewardRankingConfig():GetArenaTopRanking(5, featureType) then
        self.config.iconLeaderBoard.sprite = ResourceLoadUtils.LoadArenaRank12Icon(5)
        self.config.textRankName.text = LanguageUtils.LocalizeCommon("ranking_top_11")
    else
        self.config.iconLeaderBoard.sprite = ResourceLoadUtils.LoadArenaRankIcon(rewardRanking.rankType)
        self.config.textRankName.text = LanguageUtils.LocalizeRanking(rewardRanking.rankType)
    end
    self.config.iconLeaderBoard:SetNativeSize()
    local topRankingPoint = ""
    if rewardRanking.eloMin >= 0 and rewardRanking.eloMax >= 0 then
        topRankingPoint = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("point_x_x"),
                rewardRanking.eloMin, rewardRanking.eloMax)
    elseif rewardRanking.eloMin < 0 then
        topRankingPoint = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("point_x-"),
                rewardRanking.eloMax)
    elseif rewardRanking.eloMax < 0 then
        topRankingPoint = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("point_x+"),
                rewardRanking.eloMin)
    end

    local topReward = nil
    if rewardRanking.topMax ~= nil then
        if rewardRanking.topMax ~= rewardRanking.topMin then
            topReward = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("top_x_x"),
                    rewardRanking.topMin, rewardRanking.topMax)
        else
            topReward = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("top_x"),
                    rewardRanking.topMin)
        end
    elseif rewardRanking.topMin ~= 1 then
        topReward = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("top_x+"),
                rewardRanking.topMin)
    end
    if topReward ~= nil then
        topRankingPoint = string.format("%s , %s", topRankingPoint, UIUtils.SetColorString(UIUtils.color2, topReward))
    end

    self.config.textLeaderBoardTop.text = topRankingPoint
    --- @param v ItemIconData
    for _, v in pairs(rewardRanking.listRewardItem:GetItems()) do
        ---@type RootIconView
        local rootIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.reward)
        rootIconView:SetIconData(v)
        rootIconView:RegisterShowInfo()
        if v.itemId == 35 or v.itemId == 36 or v.itemId == 37 then
            rootIconView:RemoveAllListeners()
            rootIconView:AddListener(function()
                local data = {}
                zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
                data.listItemData = ResourceMgr.GetArenaRewardRankingConfig():GetArenaChestRewardConfig(v.itemId)
                data.chestName = LanguageUtils.LocalizeNameItem(v.type,v.itemId)
                data.chestInfo = LanguageUtils.LocalizeMoneyDescription(v.itemId)
                data.rewardText = LanguageUtils.LocalizeCommon("reward")
                data.iconChest = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconCurrencies,v.itemId)
                PopupMgr.ShowPopup(UIPopupName.UIPopupArenaChestPreview, data)
            end)
        end
        self.listReward:Add(rootIconView)
    end

    if isCurrentRanking == true then
        self.config.textRankName.color = U_Color.white
    else
        self.config.textRankName.color = self.color
    end
end

--- @return void
function ArenaRewardItemView:ReturnPoolListReward()
    ---@type IconView
    for _, v in pairs(self.listReward:GetItems()) do
        v:ReturnPool()
    end
    self.listReward:Clear()
end

--- @return void
function ArenaRewardItemView:ReturnPool()
    IconView.ReturnPool(self)
    self:ReturnPoolListReward()
end

return ArenaRewardItemView