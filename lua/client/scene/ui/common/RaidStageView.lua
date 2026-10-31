---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.RaidStageConfig"

--- @class RaidStageView : MotionIconView
RaidStageView = Class(RaidStageView, MotionIconView)

--- @return void
function RaidStageView:Ctor()
    MotionIconView.Ctor(self)
    ---@type RaidRewardConfig
    self.raidRewardConfig = nil
    ---@type number
    self.power = nil
    ---@type List
    self.listItem = List()
    ---@type number
    self.stage = nil
    ---@type List
    self.listItemHero = List()
    self.callbackClickChallenge = nil
    self.callbackClickSweep = nil
end

--- @return void
function RaidStageView:SetPrefabName()
    self.prefabName = 'raid_stage_view'
    self.uiPoolType = UIPoolType.RaidStageView
end

--- @return void
--- @param transform UnityEngine_Transform
function RaidStageView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    --- @type RaidStageConfig
    ---@type RaidStageConfig
    self.config = UIBaseConfig(transform)

    self.config.buttonChallenge.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickChallenge()
    end)
    self.config.buttonSweep.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSweep()
    end)
end

--- @return void
---@param ap number
---@param raidRewardConfig RaidRewardConfig
function RaidStageView:SetData(ap, raidRewardConfig, callbackClickChallenge, callbackSweep, battleTeamInfo, playableStage, raidModeType)
    self:InitLocalization()
    local raid = ResourceMgr.GetRaidConfig()
    self.power = math.floor(ap)
    self.raidRewardConfig = raidRewardConfig
    self.stage = raidRewardConfig.stage
    self.callbackClickChallenge = callbackClickChallenge
    self.callbackClickSweep = callbackSweep
    ---@param v ItemIconData
    for _, v in ipairs(self.raidRewardConfig.listRewardItem:GetItems()) do
        ---@type RootIconView
        local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.item)
        iconView:SetIconData(ItemIconData.Clone(v))
        iconView:RegisterShowInfo()
        self.listItem:Add(iconView)
    end

    --- @param heroBattleInfo HeroBattleInfo
    local showPopupHeroInfo = function(heroBattleInfo, battleTeam)
        zg.battleMgr:RequireBattleTeam(battleTeam)
        local teamPowerCalculator = TeamPowerCalculator()
        teamPowerCalculator:SetDefenderTeamInfo(battleTeam)
        --- @type Dictionary -- <number, number>
        local powerMap = teamPowerCalculator:CalculatePowerDetail(ResourceMgr.GetServiceConfig():GetBattle(),
                ResourceMgr.GetServiceConfig():GetHeroes(), BattleConstants.DEFENDER_TEAM_ID)

        local battleSlot = ClientConfigUtils.GetSlotNumberByPositionInfo(battleTeam.formation,
                heroBattleInfo.isFrontLine,
                heroBattleInfo.position)
        if heroBattleInfo ~= nil then
            local data = {}
            data.heroResource = HeroResource.CreateInstanceByHeroBattleInfo(heroBattleInfo)
            data.power = powerMap:Get(battleSlot)
            data.statDict = ClientConfigUtils.GetHeroStatDictByHeroBattleInfo(heroBattleInfo, teamPowerCalculator)
            PopupMgr.ShowPopup(UIPopupName.UIHeroSummonInfo, data)
        end
    end

    if raidModeType == RaidModeType.MAGIC_POTION - 1 then
        self.config.arrow.gameObject:SetActive(false)
        self.config.defenderTeamAnchor.gameObject:SetActive(false)
        self.config.bgDoiHinhBack.gameObject:SetActive(true)
        self.config.bgDoiHinhFront.gameObject:SetActive(true)
        self.config.waveAnchor.gameObject:SetActive(false)
        --- @param heroBattleInfo HeroBattleInfo
        for _, heroBattleInfo in ipairs(battleTeamInfo.listHeroInfo:GetItems()) do
            ---@type RootIconView
            local iconView = nil
            if heroBattleInfo.isFrontLine then
                iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.bgDoiHinhFront)
            else
                iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.bgDoiHinhBack)
            end
            local iconData = HeroIconData.CreateByHeroBattleInfo(heroBattleInfo)
            iconView:SetIconData(iconData)
            iconView:RegisterShowInfo()
            iconView:RemoveAllListeners()
            iconView:AddListener(function()
                showPopupHeroInfo(heroBattleInfo, battleTeamInfo)
            end)
            self.listItemHero:Add(iconView)
        end
    elseif raidModeType == RaidModeType.GOLD - 1 then
        self.config.arrow.gameObject:SetActive(false)
        self.config.defenderTeamAnchor.gameObject:SetActive(true)
        self.config.bgDoiHinhBack.gameObject:SetActive(false)
        self.config.bgDoiHinhFront.gameObject:SetActive(false)
        self.config.waveAnchor.gameObject:SetActive(false)
        self.config.defenderTeamAnchor.localPosition = U_Vector3(-309, 0.3, 0)
        --- @param heroBattleInfo HeroBattleInfo
        for _, heroBattleInfo in ipairs(battleTeamInfo.listHeroInfo:GetItems()) do
            ---@type RootIconView
            local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.defenderTeamAnchor)
            local iconData = HeroIconData.CreateByHeroBattleInfo(heroBattleInfo)
            iconView:SetIconData(iconData)
            iconView:RegisterShowInfo()
            iconView:RemoveAllListeners()
            iconView:AddListener(function()
                showPopupHeroInfo(heroBattleInfo, battleTeamInfo)
            end)
            self.listItemHero:Add(iconView)
        end
    else
        --- @type Dictionary
        self.listRaidDefenderFragmentConfig = raid:GetListDefenderTeamFragmentStageConfig(self.raidRewardConfig.stage)
        self.config.arrow.gameObject:SetActive(true)
        self.config.defenderTeamAnchor.gameObject:SetActive(true)
        self.config.bgDoiHinhBack.gameObject:SetActive(false)
        self.config.bgDoiHinhFront.gameObject:SetActive(false)
        self.config.waveAnchor.gameObject:SetActive(true)
        self.config.defenderTeamAnchor.localPosition = U_Vector3(-309, -14, 0)
        for wave, defenderTeamData in ipairs(self.listRaidDefenderFragmentConfig:GetItems()) do
            local battleTeamInfo1 = defenderTeamData:GetBattleTeamInfo()
            --- @param heroBattleInfo1 HeroBattleInfo
            for _, heroBattleInfo1 in ipairs(battleTeamInfo1.listHeroInfo:GetItems()) do
                ---@type RootIconView
                local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.defenderTeamAnchor)
                local iconData = HeroIconData.CreateByHeroBattleInfo(heroBattleInfo1)
                iconView:SetIconData(iconData)
                iconView:RegisterShowInfo()
                iconView:RemoveAllListeners()
                iconView:AddListener(function()
                    showPopupHeroInfo(heroBattleInfo1, battleTeamInfo)
                end)
                self.listItemHero:Add(iconView)
            end
        end
    end


    self.config.textIconRaid.text = tostring(self.raidRewardConfig.stage)
    self.config.textApRaid.text = tostring(self.power)

    if self.raidRewardConfig.stage < playableStage then
        self.config.buttonChallenge.gameObject:SetActive(false)
        self.config.buttonSweep.gameObject:SetActive(true)
        self.config.textSweep.text = LanguageUtils.LocalizeCommon("sweep")
    elseif self.raidRewardConfig.stage == playableStage then
        self.config.buttonChallenge.gameObject:SetActive(true)
        self.config.buttonSweep.gameObject:SetActive(false)
        UIUtils.SetInteractableButton(self.config.buttonChallenge, true)
        self.config.textComplete.text = LanguageUtils.LocalizeCommon("challenge")
    else
        self.config.buttonChallenge.gameObject:SetActive(true)
        self.config.buttonSweep.gameObject:SetActive(false)
        UIUtils.SetInteractableButton(self.config.buttonChallenge, false)
        self.config.textComplete.text = LanguageUtils.LocalizeCommon("lock_level")
    end

    self.config.tick:SetActive(self.raidRewardConfig.stage < playableStage)

    self.config.raidStageView:SetActive(self.raidRewardConfig.stage ~= playableStage)
    self.config.raidStageViewSelected:SetActive(self.raidRewardConfig.stage == playableStage)

    self.config.iconRaid.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconRaidLevel, 11)
    self.config.iconRaid:SetNativeSize()
end

function RaidStageView:InitLocalization()
    self.config.textWave1.text = string.format("%s %s", LanguageUtils.LocalizeCommon("wave"), 1)
    self.config.textWave2.text = string.format("%s %s", LanguageUtils.LocalizeCommon("wave"), 2)
    self.config.textWave3.text = string.format("%s %s", LanguageUtils.LocalizeCommon("wave"), 3)
    self.config.textLevel.text = LanguageUtils.LocalizeCommon("floor")
end

--- @return void
function RaidStageView:ReturnPool()
    MotionIconView.ReturnPool(self)
    ---@param v IconView
    for _, v in pairs(self.listItem:GetItems()) do
        v:ReturnPool()
    end
    self.listItem:Clear()

    ---@param v IconView
    for _, v in pairs(self.listItemHero:GetItems()) do
        v:ReturnPool()
    end
    self.listItemHero:Clear()

    self.callbackClickChallenge = nil
    self.callbackClickSweep = nil
end

--- @return void
function RaidStageView:OnClickChallenge()
    if self.callbackClickChallenge ~= nil then
        self.callbackClickChallenge()
    end
end

--- @return void
function RaidStageView:OnClickSweep()
    if self.callbackClickSweep ~= nil then
        self.callbackClickSweep()
    end
end

return RaidStageView