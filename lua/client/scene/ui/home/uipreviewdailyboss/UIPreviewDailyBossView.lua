--- @class UIPreviewDailyBossView : UIBaseView
UIPreviewDailyBossView = Class(UIPreviewDailyBossView, UIBaseView)

--- @return void
--- @param model UIPreviewDailyBossModel
function UIPreviewDailyBossView:Ctor(model)
    --- @type UIPreviewDailyBossConfig
    self.config = nil
    --- @type List
    self.listHeroIconView = List()
    UIBaseView.Ctor(self, model)
    --- @type UIPreviewDailyBossModel
    self.model = model
end

function UIPreviewDailyBossView:OnReadyCreate()
    ---@type UIPreviewDailyBossConfig
    self.config = UIBaseConfig(self.uiTransform)
    self:InitButtonListener()
end

function UIPreviewDailyBossView:InitLocalization()
    self.config.tittle.text = LanguageUtils.LocalizeCommon("random_boss")
end

function UIPreviewDailyBossView:InitButtonListener()
    self.config.buttonClose.onClick:AddListener(function()
        self:OnReadyHide()
    end)
    self.config.bgClose.onClick:AddListener(function()
        self:OnReadyHide()
    end)
end

--- @param listHeroBattleInfo List
function UIPreviewDailyBossView:OnReadyShow(listHeroBattleInfo)
    self:HideBossIconView()
    for i = 1, listHeroBattleInfo:Count() do
        --- @type {heroBattleInfo : HeroBattleInfo, battleTeamInfo : BattleTeamInfo}
        local info = listHeroBattleInfo:Get(i)
        local heroBattleInfo = info.heroBattleInfo
        local battleTeamInfo = info.battleTeamInfo

        --- @type HeroIconView
        local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.tableView)
        iconView:SetIconData(HeroIconData.CreateByHeroBattleInfo(heroBattleInfo))
        self.listHeroIconView:Add(iconView)
        iconView:ActiveFrameBoss(true)
        iconView:RemoveAllListeners()
        iconView:AddListener(function()
            self:ShowPopupHeroInfo(heroBattleInfo, battleTeamInfo)
        end)
    end
end

function UIPreviewDailyBossView:Hide()
    UIBaseView.Hide(self)
    self:HideBossIconView()
end

function UIPreviewDailyBossView:HideBossIconView()
    if self.listHeroIconView == nil or self.listHeroIconView:Count() == 0 then
        return
    end
    ---@param iconView IconView
    for _, iconView in pairs(self.listHeroIconView:GetItems()) do
        iconView:ActiveFrameBoss(false)
        iconView:ReturnPool()
    end
    self.listHeroIconView = List()
end

--- @param heroBattleInfo HeroBattleInfo
--- @param battleTeamInfo BattleTeamInfo
function UIPreviewDailyBossView:ShowPopupHeroInfo(heroBattleInfo, battleTeamInfo)
    ClientConfigUtils.RequireBattleTeam(battleTeamInfo)
    local teamPowerCalculator = TeamPowerCalculator()
    teamPowerCalculator:SetDefenderTeamInfo(battleTeamInfo)
    --- @type Dictionary -- <number, number>
    local powerMap = teamPowerCalculator:CalculatePowerDetail(ResourceMgr.GetServiceConfig():GetBattle(),
            ResourceMgr.GetServiceConfig():GetHeroes(), battleTeamInfo.teamId)

    local battleSlot = ClientConfigUtils.GetSlotNumberByPositionInfo(battleTeamInfo.formation,
            heroBattleInfo.isFrontLine,
            heroBattleInfo.position)
    if heroBattleInfo ~= nil then
        local heroResource = HeroResource.CreateInstanceByHeroBattleInfo(heroBattleInfo)
        local power = powerMap:Get(battleSlot)
        local statDict = ClientConfigUtils.GetHeroStatDictByHeroBattleInfo(heroBattleInfo, teamPowerCalculator)
        PopupMgr.ShowPopup(UIPopupName.UIHeroSummonInfo, { ["heroResource"] = heroResource,
                                                           ["power"] = power,
                                                           ["statDict"] = statDict })
        zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    end
end
