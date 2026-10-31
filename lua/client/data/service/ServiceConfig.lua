require "lua.logicBattle.services.ServiceController"

PREDEFINE_TEAM_ITEM_PATH = "csv/predefine_team/team_item.csv"
PREDEFINE_TEAM_MASTERY_PATH = "csv/predefine_team/team_mastery.csv"
PREDEFINE_TEAM_SUMMONER_PATH = "csv/predefine_team/team_summoner.csv"
PREDEFINE_TEAM_STAR_PATH = "csv/predefine_team/team_star.csv"
PREDEFINE_TEAM_LEVEL_PATH = "csv/predefine_team/team_level.csv"
PREDEFINE_TEAM_LEVEL_SPECIAL_PATH = "csv/predefine_team/team_level_special.csv"
PREDEFINE_TEAM_FORMATION_PATH = "csv/client/predefine_team_formation.json"
PREDEFINE_BOSS_SLOT_PATH = "csv/predefine_team/boss_slot.csv"
PREDEFINE_BOSS_STAT_PATH = "csv/predefine_team/boss_stat.csv"

DUNGEON_PASSIVE_BUFF_PATH = "csv/dungeon/passive_buff.csv"
DUNGEON_ACTIVE_BUFF_PATH = "csv/dungeon/active_buff.csv"
DUNGEON_ATTACKER_PATH = "csv/dungeon/dungeon_config.csv"

HERO_LEVEL_PATH = "csv/hero_level/hero_skill_level.csv"
HERO_LEVEL_CAP_PATH = "csv/hero_level/hero_level_cap.csv"
FORM_DATA_PATH = "csv/battle/formation.csv"
FORM_BUFF_DATA_PATH = "csv/battle/formation_buff.csv"
HERO_POWER_GAIN_PATH = "csv/battle/hero_power_gain.csv"
HERO_COMPANION_BUFF_PATH = "csv/battle/companion_buff.csv"
HERO_LINKING_PATH = "csv/hero/hero_linking.csv"

ITEM_EQUIPMENT_SET_PATH = "csv/item/equipment_set.csv"
ITEM_STONE_PATH = "csv/item/stone.csv"
ITEM_ARTIFACT_PATH = "csv/item/artifact.csv"
ITEM_EQUIPMENT_PATH = "csv/item/equipment.csv"
ITEM_SKIN_PATH = "csv/item/skin/skin.csv"
TOWER_LEVEL_DEFENSE_PATH = "csv/defense_mode/land_%s/tower_level_config.csv"
HERO_LINKING_DATA_PATH = "csv/hero_linking/bonus_tier_config.csv"
SKIN_NOT_SHOW_LIST_PATH = "csv/client/skin_not_show.csv"
ITEM_TALENT_PATH = "csv/item/talent/talent_stat.csv"
ITEM_PASSIVE_ID_LIST_PATH = "csv/item/item_passive/item_passive_list.csv"
ITEM_PASSIVE_PATH = "csv/item/item_passive/%s.csv"
ITEM_EFFECT_PATH = "csv/item/idle_effect/idle_effect.csv"
ITEM_EFFECT_NOT_SHOW_LIST_PATH = "csv/client/effect_not_show.csv"
--- @class ServiceConfig
ServiceConfig = Class(ServiceConfig)

function ServiceConfig:Ctor()
    self.serviceController = ServiceController()
    --- @type List
    self.skinNotShowList = List()
    self.effectNotShowList = List()
end

--- @return DungeonDataService
function ServiceConfig:GetDungeon()
    if self.serviceController.dungeonDataService == nil then
        self:InitDungeonDataService()
    end
    return self.serviceController.dungeonDataService
end

--- @return HeroDataService
function ServiceConfig:GetHeroes()
    if self.serviceController.heroDataService == nil then
        self:InitHeroDataService()
    end
    return self.serviceController.heroDataService
end

--- @return BattleService
function ServiceConfig:GetBattle()
    if self.serviceController.battleService == nil then
        local battleService = BattleService()
        self.serviceController:SetBattleService(battleService)
        battleService:SetDependencies(
                self:GetHeroes(),
                self:GetItems(),
                self:GetDungeon(),
                self:GetPredefineTeam(),
                self:GetLinkingDataService())
    end
    return self.serviceController.battleService
end

--- @return ItemDataService
function ServiceConfig:GetItems()
    if self.serviceController.itemDataService == nil then
        self:InitItemDataService()
    end
    return self.serviceController.itemDataService
end

----- @return DefenseDataService
--function ServiceConfig:GetDefenseDataService()
--    if self.serviceController.defenseDataService == nil then
--        self:InitDefenseDataService()
--    end
--    return self.serviceController.defenseDataService
--end

--- @return PredefineTeamDataService
function ServiceConfig:GetPredefineTeam()
    if self.serviceController.predefineDataService == nil then
        self:InitPredefineTeamDataService()
        self.serviceController.predefineDataService:SetDependencies(self:GetHeroes())
    end
    return self.serviceController.predefineDataService
end

--- @return HeroLinkingDataService
function ServiceConfig:GetLinkingDataService()
    if self.serviceController.heroLinkingDataService == nil then
        self:InitHeroLinkingDataService()
    end
    return self.serviceController.heroLinkingDataService
end

--- @return number
--- @param type ResourceType
--- @param id number
function ServiceConfig:GetItemRarity(type, id)
    if type == ResourceType.ItemArtifact then
        ---@type ArtifactDataEntry
        local dataConfig = self:GetItems().artifactDataEntries:Get(id)
        if dataConfig ~= nil then
            if dataConfig.rarity > 1 then
                return dataConfig.rarity + 1
            end
            return dataConfig.rarity
        end
    elseif type == ResourceType.ItemEquip then
        ---@type EquipmentDataEntry
        local dataConfig = self:GetItems().equipmentDataEntries:Get(id)
        if dataConfig ~= nil then
            return dataConfig.rarity
        end
    elseif type == ResourceType.ItemStone then
        ---@type StoneDataEntry
        local dataConfig = self:GetItems().stoneDataEntries:Get(id)
        if dataConfig ~= nil then
            return dataConfig.rarity
        end
    elseif type == ResourceType.Skin then
        ---@type SkinDataEntry
        local dataConfig = self:GetItems().skinDataEntries:Get(id)
        if dataConfig ~= nil then
            return dataConfig.rarity
        end
    end
    return 1
end

--- @return number
--- @param type ResourceType
--- @param id number
function ServiceConfig:GetItemStar(type, id)
    local dataConfig = nil
    if type == ResourceType.ItemArtifact then
        dataConfig = self:GetItems().artifactDataEntries:Get(id)
    elseif type == ResourceType.ItemEquip then
        dataConfig = self:GetItems().equipmentDataEntries:Get(id)
    elseif type == ResourceType.ItemStone then
        dataConfig = self:GetItems().stoneDataEntries:Get(id)
    end
    if dataConfig ~= nil then
        return dataConfig.star
    else
        return 0
    end
end

--- @return {itemData}
--- @param resourceType ResourceType
--- @param id number
function ServiceConfig:GetItemData(resourceType, id)
    local item
    if resourceType == ResourceType.ItemEquip then
        item = self:GetItems().equipmentDataEntries:Get(id)
    elseif resourceType == ResourceType.ItemArtifact then
        item = self:GetItems().artifactDataEntries:Get(id)
    elseif resourceType == ResourceType.ItemStone then
        item = self:GetItems().stoneDataEntries:Get(id)
    elseif resourceType == ResourceType.Skin then
        item = self:GetItems().skinDataEntries:Get(id)
    elseif resourceType == ResourceType.Talent then
        item = self:GetItems().talentStatDataEntries:Get(id)
    end
    return item
end

--- @return HeroClassType
--- @param heroId number
function ServiceConfig:GetClassIdByHeroId(heroId)
    ---@type HeroDataEntry
    local heroDataEntry = self:GetHeroes():GetHeroDataEntry(heroId)
    ---@type HeroData
    local heroData = heroDataEntry.baseStats:Get(1)
    return heroData.class
end

function ServiceConfig:InitService()
    self.serviceController:BindDependencies()
end

--- @return void
function ServiceConfig:InitHeroDataService()
    local heroDataService = HeroDataService()
    self.serviceController:SetHeroDataService(heroDataService)
    self:InitFormationDataEntry(heroDataService)
    self:InitPowerGainEntry(heroDataService)
    self:InitHeroLevelData(heroDataService)
    self:InitHeroLevelCap(heroDataService)
    self:InitCompanionBuff(heroDataService)
    --self:InitHeroLinking(heroDataService)
end

--- @return void
function ServiceConfig:InitItemDataService()
    local itemDataService = ItemDataService()
    local heroDataService = self:GetHeroes()
    self:AddItemPassiveData(itemDataService, heroDataService)
    self:InitEquipmentDataEntry(itemDataService, heroDataService)
    self:InitArtifactDataEntry(itemDataService, heroDataService)
    self:InitStoneDataEntry(itemDataService, heroDataService)
    self:InitEquipmentSetDataEntry(itemDataService, heroDataService)
    self:InitSkinDataEntry(itemDataService, heroDataService)
    self:InitTalentDataEntry(itemDataService, heroDataService)
    self:InitIdleEffectDataEntry(itemDataService, heroDataService)
    self.serviceController:SetItemDataService(itemDataService)
end

--- @return void
function ServiceConfig:InitDefenseDataService()
    local defenseDataService = DefenseDataService()
    for i = 1, 10 do
        defenseDataService:AddLandData(i, CsvReaderUtils.ReadLocalFile(string.format(TOWER_LEVEL_DEFENSE_PATH, i)))
    end
    self.serviceController:SetDefenseDataService(defenseDataService)
end

function ServiceConfig:InitHeroLinkingDataService()
    ---@type HeroLinkingDataService
    local heroLinkingDataService = HeroLinkingDataService()
    heroLinkingDataService:AddHeroLinkingData(CsvReaderUtils.ReadLocalFile(HERO_LINKING_DATA_PATH))
    self.serviceController:SetHeroLinkingDataService(heroLinkingDataService)
end

function ServiceConfig:InitPredefineTeamDataService()
    local predefineTeam = PredefineTeamDataService()
    self.serviceController:SetPredefineDataService(predefineTeam)

    local csvSummoner = CsvReaderUtils.ReadLocalFile(PREDEFINE_TEAM_SUMMONER_PATH)
    predefineTeam:SetSummonerPredefine(csvSummoner)

    local csvStar = CsvReaderUtils.ReadLocalFile(PREDEFINE_TEAM_STAR_PATH)
    predefineTeam:SetTeamStarData(csvStar)

    local csvLevel = CsvReaderUtils.ReadLocalFile(PREDEFINE_TEAM_LEVEL_SPECIAL_PATH)
    predefineTeam:SetTeamLevelData(csvLevel)

    local csvItem = CsvReaderUtils.ReadLocalFile(PREDEFINE_TEAM_ITEM_PATH)
    predefineTeam:SetTeamItemData(csvItem)

    local csvMastery = CsvReaderUtils.ReadLocalFile(PREDEFINE_TEAM_MASTERY_PATH)
    predefineTeam:SetTeamMasteryData(csvMastery)

    local csvBossSlot = CsvReaderUtils.ReadLocalFile(PREDEFINE_BOSS_SLOT_PATH)
    predefineTeam:SetBossSlot(csvBossSlot)

    local csvBossStat = CsvReaderUtils.ReadLocalFile(PREDEFINE_BOSS_STAT_PATH)
    predefineTeam:SetBossStatMultiplierList(csvBossStat)
end

--- @return void
function ServiceConfig:InitDungeonDataService()
    local data = DungeonDataService()
    local heroDataService = self:GetHeroes()

    local content
    content = CsvReaderUtils.ReadLocalFile(DUNGEON_PASSIVE_BUFF_PATH)
    data:LoadPassiveBuffData(content, heroDataService)

    content = CsvReaderUtils.ReadLocalFile(DUNGEON_ATTACKER_PATH)
    data:LoadAttackerData(content)

    content = CsvReaderUtils.ReadLocalFile(DUNGEON_ACTIVE_BUFF_PATH)
    data:LoadActiveBuffData(content)

    self.serviceController:SetDungeonDataService(data)
end

--- @return void
--- @param heroDataService HeroDataService
function ServiceConfig:InitHeroLevelData(heroDataService)
    local csvHeroLevel = CsvReaderUtils.ReadLocalFile(HERO_LEVEL_PATH)
    heroDataService:AddHeroSkillLevelData(csvHeroLevel)
end

--- @return void
--- @param heroDataService HeroDataService
function ServiceConfig:InitHeroLevelCap(heroDataService)
    local csvHeroLevel = CsvReaderUtils.ReadLocalFile(HERO_LEVEL_CAP_PATH)
    heroDataService:AddHeroLevelCap(csvHeroLevel)
end

--- @return void
--- @param heroDataService HeroDataService
function ServiceConfig:InitFormationDataEntry(heroDataService)
    local csvFormationData = CsvReaderUtils.ReadLocalFile(FORM_DATA_PATH)
    heroDataService:AddFormationData(csvFormationData)

    local csvFormationBuffData = CsvReaderUtils.ReadLocalFile(FORM_BUFF_DATA_PATH)
    heroDataService:AddFormationBuffData(csvFormationBuffData)
end

--- @return void
--- @param heroDataService HeroDataService
function ServiceConfig:InitPowerGainEntry(heroDataService)
    local csvHeroPowerGainData = CsvReaderUtils.ReadLocalFile(HERO_POWER_GAIN_PATH)
    heroDataService:AddPowerGainData(csvHeroPowerGainData)
end

--- @return void
--- @param heroDataService HeroDataService
function ServiceConfig:InitCompanionBuff(heroDataService)
    local csvCompanionBuff = CsvReaderUtils.ReadLocalFile(HERO_COMPANION_BUFF_PATH)
    heroDataService:AddHeroCompanionBuffData(csvCompanionBuff)
end

--- @param heroDataService HeroDataService
function ServiceConfig:InitHeroLinking(heroDataService)
    local csvLinkingData = CsvReaderUtils.ReadLocalFile(HERO_LINKING_PATH)
    heroDataService:AddHeroLinkingData(csvLinkingData)
end

--- @return void
--- @param itemDataService ItemDataService
--- @param heroDataService HeroDataService
function ServiceConfig:InitEquipmentDataEntry(itemDataService, heroDataService)
    local csvEquipmentData = CsvReaderUtils.ReadLocalFile(ITEM_EQUIPMENT_PATH)
    itemDataService:AddEquipmentData(csvEquipmentData, heroDataService)
end

--- @return void
--- @param itemDataService ItemDataService
--- @param heroDataService HeroDataService
function ServiceConfig:InitTalentDataEntry(itemDataService, heroDataService)
    local csvEquipmentData = CsvReaderUtils.ReadLocalFile(ITEM_TALENT_PATH)
    itemDataService:AddTalentStatData(csvEquipmentData, heroDataService)
end

--- @return void
--- @param itemDataService ItemDataService
--- @param heroDataService HeroDataService
function ServiceConfig:AddItemPassiveData(itemDataService, heroDataService)
    local csvEquipmentData = nil
    local idData = CsvReaderUtils.ReadAndParseLocalFile(ITEM_PASSIVE_ID_LIST_PATH)
    local data = nil
    for i = 1, #idData do
        data = idData[i]
        if data.passive_id ~= nil then
            csvEquipmentData = CsvReaderUtils.ReadLocalFile(string.format(ITEM_PASSIVE_PATH, data.passive_id))
            itemDataService:AddItemPassiveData(tonumber(data.passive_id), csvEquipmentData)
        end
    end
end

--- @return void
--- @param itemDataService ItemDataService
--- @param heroDataService HeroDataService
function ServiceConfig:InitArtifactDataEntry(itemDataService, heroDataService)
    local csvArtifactData = CsvReaderUtils.ReadLocalFile(ITEM_ARTIFACT_PATH)
    itemDataService:AddArtifactData(csvArtifactData, heroDataService)
end

--- @return void
--- @param itemDataService ItemDataService
--- @param heroDataService HeroDataService
function ServiceConfig:InitSkinDataEntry(itemDataService, heroDataService)
    local csvArtifactData = CsvReaderUtils.ReadLocalFile(ITEM_SKIN_PATH)
    itemDataService:AddSkinData(csvArtifactData, heroDataService)

    local skinConfig = CsvReaderUtils.ReadAndParseLocalFile(SKIN_NOT_SHOW_LIST_PATH)
    for i = 1, #skinConfig do
        self.skinNotShowList:Add(tonumber(skinConfig[i].skin_id))
    end
end

---@return List
function ServiceConfig:GetListSkinNotShow()
    return self.skinNotShowList
end

--- @return void
--- @param itemDataService ItemDataService
--- @param heroDataService HeroDataService
function ServiceConfig:InitIdleEffectDataEntry(itemDataService, heroDataService)
    local csvIdleEffectData = CsvReaderUtils.ReadLocalFile(ITEM_EFFECT_PATH)
    itemDataService:AddIdleEffectData(csvIdleEffectData, heroDataService)
    --[[    local effectConfig = CsvReaderUtils.ReadAndParseLocalFile(ITEM_EFFECT_NOT_SHOW_LIST_PATH)
        for i = 1, #effectConfig do
            self.effectNotShowList:Add(tonumber(effectConfig[i].skin_id))
        end]]
end

--- @return void
--- @param itemDataService ItemDataService
--- @param heroDataService HeroDataService
function ServiceConfig:InitStoneDataEntry(itemDataService, heroDataService)
    local csvStoneData = CsvReaderUtils.ReadLocalFile(ITEM_STONE_PATH)
    itemDataService:AddStoneData(csvStoneData, heroDataService)
end

--- @return void
--- @param itemDataService ItemDataService
--- @param heroDataService HeroDataService
function ServiceConfig:InitEquipmentSetDataEntry(itemDataService, heroDataService)
    local csvSetEquipmentData = CsvReaderUtils.ReadLocalFile(ITEM_EQUIPMENT_SET_PATH)
    itemDataService:AddEquipmentSetData(csvSetEquipmentData, heroDataService)
end

return ServiceConfig