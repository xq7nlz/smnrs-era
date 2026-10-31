---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiPopupDamageStats.UIPopupDamageStatsConfig"

--- @class UIPopupDamageStatsView : UIBaseView
UIPopupDamageStatsView = Class(UIPopupDamageStatsView, UIBaseView)

--- @return void
--- @param model UIPopupDamageStatsModel
function UIPopupDamageStatsView:Ctor(model, ctrl)
    ---@type UIPopupDamageStatsConfig
    self.config = nil

    ---@type BossStatisticsInBound
    self.bossStatisticsInBound = nil
    --- @type List
    self.listGuildDungeonStatisticInBound = nil
    ---@type number
    self.maxDamage = nil
    --- @type boolean
    self.isScrollBossStatisticsInBound = true

    UIBaseView.Ctor(self, model, ctrl)
    --- @type UIPopupDamageStatsModel
    self.model = model
end

--- @return void
function UIPopupDamageStatsView:OnReadyCreate()
    ---@type UIPopupDamageStatsConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)

    --- @param obj DamageStatItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        local rank = index + 1
        local playerName
        local playerAvatar
        local playerLevel
        local damage

        if self.isScrollBossStatisticsInBound == true then
            --- @type BossStatistics
            local bossStatistics = self.bossStatisticsInBound.listBossStatistics:Get(rank)
            playerName = bossStatistics.playerName
            playerAvatar = bossStatistics.playerAvatar
            playerLevel = bossStatistics.playerLevel
            damage = bossStatistics.damage
        else
            --- @type GuildDungeonStatisticsInBound
            local guildDungeonStatisticsInBound = self.listDungeonStatisticInBound:Get(rank)
            playerName = guildDungeonStatisticsInBound.playerName
            playerAvatar = guildDungeonStatisticsInBound.playerAvatar
            playerLevel = guildDungeonStatisticsInBound.playerLevel
            damage = guildDungeonStatisticsInBound.playerScore
        end
        obj:SetData(rank, playerName, playerAvatar, playerLevel, damage, self.maxDamage)
    end

    --- @type UILoopScroll
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.DamageStatItemView, onCreateItem, onCreateItem)
end

--- @return void
function UIPopupDamageStatsView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("damage_stat")
    self.config.textEmpty.text = LanguageUtils.LocalizeCommon("no_data")
end

--- @return void
function UIPopupDamageStatsView:OnReadyShow(result)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    if result == nil then
        self.config.empty:SetActive(true)
        return
    end
    self.config.empty:SetActive(false)
    local isGuildDungeonBossStatistic = result.isGuildDungeonBossStatistic
    if isGuildDungeonBossStatistic == true then
        self:SetGuildDungeonStatisticData(result.listOfGuildDungeonStatistics)
        return
    end
    self.isScrollBossStatisticsInBound = true
    self.bossStatisticsInBound = result.bossStatisticsInBound
    self.maxDamage = 0
    ---@param v BossStatistics
    for _, v in pairs(self.bossStatisticsInBound.listBossStatistics:GetItems()) do
        self.maxDamage = self.maxDamage + v.damage
    end
    self.uiScroll:Resize(self.bossStatisticsInBound.listBossStatistics:Count())
    if self.bossStatisticsInBound.listBossStatistics:Count() == 0 then
        self.config.empty:SetActive(true)
    end
end

--- @param listData List
function UIPopupDamageStatsView:SetGuildDungeonStatisticData(listData)
    self.isScrollBossStatisticsInBound = false

    self.listDungeonStatisticInBound = listData
    self.maxDamage = 0
    for i = 1, self.listDungeonStatisticInBound:Count() do
        --- @type GuildDungeonStatisticsInBound
        local guildDungeonStatisticsInBound = self.listDungeonStatisticInBound:Get(i)
        self.maxDamage = self.maxDamage + guildDungeonStatisticsInBound.playerScore
    end
    self.uiScroll:Resize(self.listDungeonStatisticInBound:Count())
    if self.listDungeonStatisticInBound:Count() == 0 then
        self.config.empty:SetActive(true)
    end
end

---@return void
function UIPopupDamageStatsView:Hide()
    UIBaseView.Hide(self)
    self.uiScroll:Hide()
end