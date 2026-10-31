--- @class BattleHistoryItem : MotionIconView
BattleHistoryItem = Class(BattleHistoryItem, MotionIconView)

--- @return void
function BattleHistoryItem:Ctor()
    ---@type BattleHistoryItemConfig
    self.config = nil
    --- @type RootIconView
    self.rootIconView = nil
    ---@type List
    self.listHeroIcon = List()
    MotionIconView.Ctor(self)
end

function BattleHistoryItem:SetPrefabName()
    self.prefabName = 'battle_history_item'
    self.uiPoolType = UIPoolType.BattleHistoryItem
end

--- @param transform UnityEngine_Transform
function BattleHistoryItem:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type BattleHistoryItemConfig
    self.config = UIBaseConfig(transform)
    ---@type BattleTeamView
    self.battleTeamView = BattleTeamView(self.config.lineupAnchor)
end

function BattleHistoryItem:SetItemData(data)
    self.config.textTeam.text = LanguageUtils.LocalizeCommon("your_team")
    self:SetLocalize(data.difficulty, data.createdTime, data.isWin)
    self:SetIconWinOrLose(data.isWin)
    if data.listReward and data.listReward:Count() > 0 then
        ---@param v RewardInBound
        for k, v in pairs(data.listReward:GetItems()) do
            self:SetItemReward(v)
        end
    end
    self:ShowEnemyHero(data.teamFormation)
    --self:ShowEnemyFormation(data.teamFormation,data.summonerId,data.summonerStar)
end

function BattleHistoryItem:ShowEnemyHero(data)
    ---@type List
    local listHero = List()
    for k, v in pairs(data.frontLineDict:GetItems()) do
        listHero:Add(v)
    end
    for k, v in pairs(data.backLineDict:GetItems()) do
        listHero:Add(v)
    end
    for k, v in pairs(listHero:GetItems()) do
        ---@type HeroIconView
        local heroIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.enemyAnchor)
        local hero = HeroResource()
        hero:SetData(nil, v.heroId, v.heroStar, v.heroLevel)
        hero.level = v.heroLevel
        hero.type = ResourceType.Hero
        hero.faction = ClientConfigUtils.GetFactionIdByHeroId(v.heroId)
        heroIconView:SetIconData(hero)
        heroIconView:SetSize()
        --heroIconView:EnableButton()
        --heroIconView:RegisterShowInfo()
        --heroIconView:SetSize()
        --local result = {}
        --result.heroResource = hero
        --heroIconView:AddListener(function()
        --    PopupMgr.ShowPopup(UIPopupName.UIHeroSummonInfo, result)
        --end)
        self.listHeroIcon:Add(heroIconView)
    end
end

--- @param battleTeamInfo BattleTeamInfo
function BattleHistoryItem:ShowEnemyFormation(battleTeamInfo)
    self.battleTeamView:Show()
    self.battleTeamView:SetDataDefender(UIPoolType.HeroIconView, battleTeamInfo, nil, nil, true)
    self.battleTeamView.uiTeamView:SetSummonerInfo()
    self.battleTeamView.uiTeamView:ActiveBuff(false)
    self.battleTeamView.uiTeamView:ActiveLinking(false)
end

function BattleHistoryItem:SetIconWinOrLose(isWin)
    self.config.iconWin.gameObject:SetActive(isWin)
    self.config.iconLose.gameObject:SetActive(not isWin)
end

function BattleHistoryItem:SetLocalize(difficultLevel, createdTime, isWin)
    if isWin then
        self.config.textBattleResult.text = UIUtils.SetColorString(UIUtils.green_light, LanguageUtils.LocalizeCommon("win"))
    else
        self.config.textBattleResult.text = UIUtils.SetColorString(UIUtils.red_light, LanguageUtils.LocalizeCommon("lose"))
    end
    self.config.textBattleDetail.text = string.format("%s: %s\n%s: %s",
            LanguageUtils.LocalizeCommon("difficult"),
            UIUtils.SetColorString(UIUtils.red_light, difficultLevel),
            LanguageUtils.LocalizeCommon("created_time"),
            UIUtils.SetColorString(UIUtils.red_light, TimeUtils.GetDeltaTimeAgo(zg.timeMgr:GetServerTime() - createdTime)))
    --print("server time", zg.timeMgr:GetServerTime(), "createdTime", createdTime)
end

---@param rewardInBound RewardInBound
function BattleHistoryItem:SetItemReward(rewardInBound)
    if self.rootIconView == nil then
        self.rootIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.rewardAnchor)
    end
    self.rootIconView:SetIconData(rewardInBound:GetIconData())
    --self.rootIconView:RegisterShowInfo()
end

function BattleHistoryItem:ReturnPool()
    MotionIconView.ReturnPool(self)
    if self.battleTeamView ~= nil then
        self.battleTeamView:Hide()
    end

    if self.rootIconView ~= nil then
        self.rootIconView:ReturnPool()
        self.rootIconView = nil
    end

    ---@param v HeroIconView
    for k, v in pairs(self.listHeroIcon:GetItems()) do
        v:ReturnPool()
    end
    self.listHeroIcon:Clear()
end

return BattleHistoryItem