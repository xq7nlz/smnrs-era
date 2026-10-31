--- @class LanguageUtils
LanguageUtils = {
    Common = "common",
    Mail = "mail",
    EnumType = "enum_type",
    EnumContent = "enum_content",
    Skill = "localize_form_skill_format",
    Quest = "quest_localize_format",
    Tutorial = "tutorial",
    HeroSkillName = "hero_skill_name_localize",
    SummonerSkillName = "summoner_skill_name_localize",
    ItemOption = "item_option",
    ItemOption2 = "item_option_2",
    ItemOption3 = "item_option_3",
    ItemOption10 = "item_option_10",
    HelpInfo = "mode_game_info",
    Equipment = "equipment",
    Artifact = "artifact",
    Stone = "stone",
    EquipmentSet = "equipment_set",
    Summoner = "summoner",
    QuestTavern = "quest_tavern",
}

---@type List
LanguageUtils._languageList = nil

--- @return List
function LanguageUtils.GetLanguageList()
    if LanguageUtils._languageList == nil then
        require "lua.client.data.Language.Language"
        local languageList = List()
        LanguageUtils._languageList = languageList
        languageList:Add(Language("en", "English", U_SystemLanguage.English, false))
        languageList:Add(Language("de", "Deutsch", U_SystemLanguage.German, false))
        languageList:Add(Language("fr", "Français", U_SystemLanguage.French, false))
        languageList:Add(Language("ja", "日本語", U_SystemLanguage.Japanese, false))
        languageList:Add(Language("ko", "한국어", U_SystemLanguage.Korean, false))
        languageList:Add(Language("zhcn", "简体中文", U_SystemLanguage.ChineseSimplified, false))
        languageList:Add(Language("zhtw", "繁體中文", U_SystemLanguage.ChineseTraditional, false))
        languageList:Add(Language("ru", "Русский", U_SystemLanguage.Russian, false))
        languageList:Add(Language("br", "Português", U_SystemLanguage.Portuguese, false))
        languageList:Add(Language("id", "Bahasa Indonesia", U_SystemLanguage.Indonesian, false))
        languageList:Add(Language("sp", "Español", U_SystemLanguage.Spanish, false))
        languageList:Add(Language("vi", "Tiếng Việt", U_SystemLanguage.Vietnamese, false))
        if IS_IOS_PLATFORM == false then
            languageList:Add(Language("th", "ไทย", U_SystemLanguage.Thai, false))
        end
    end
    return LanguageUtils._languageList
end

--- @return Dictionary
---@param type string
function LanguageUtils.GetLanguageByType(type)
    ---@param v  Language
    for _, v in ipairs(LanguageUtils.GetLanguageList():GetItems()) do
        if v.keyLanguage == type then
            return v
        end
    end
    return nil
end

--- @return string
--- @param key string
--- @param popup string
function LanguageUtils.Localize(key, popup)
    return zg.languageMgr:GetLocalize(key, popup)
end

--- @return string
--- @param key string
--- @param popup string
function LanguageUtils.Contain(key, popup)
    return zg.languageMgr:Contain(key, popup)
end

--- @return string
--- @param key string
function LanguageUtils.LocalizeCommon(key)
    return LanguageUtils.Localize(key, LanguageUtils.Common):gsub("%%S", "%%s")
end

--- @return MonthString
--- @param monthEnum MonthEnum
function LanguageUtils.LocalizeMonth(monthEnum)
    local key
    if monthEnum == MonthEnum.January then
        key = MonthString.January
    elseif monthEnum == MonthEnum.February then
        key = MonthString.February
    elseif monthEnum == MonthEnum.March then
        key = MonthString.March
    elseif monthEnum == MonthEnum.April then
        key = MonthString.April
    elseif monthEnum == MonthEnum.May then
        key = MonthString.May
    elseif monthEnum == MonthEnum.June then
        key = MonthString.June
    elseif monthEnum == MonthEnum.July then
        key = MonthString.July
    elseif monthEnum == MonthEnum.August then
        key = MonthString.August
    elseif monthEnum == MonthEnum.September then
        key = MonthString.September
    elseif monthEnum == MonthEnum.October then
        key = MonthString.October
    elseif monthEnum == MonthEnum.November then
        key = MonthString.November
    elseif monthEnum == MonthEnum.December then
        key = MonthString.December
    end
    if not key then
        XDebug.Log("monthEnum is not Valid", monthEnum)
        return ""
    end
    return LanguageUtils.Localize("month_" .. key, LanguageUtils.EnumType)
end

--- @return string
--- @param id string
function LanguageUtils.LocalizeHeroFoodInfo(id)
    id = ClientConfigUtils.GetTypeAndStarHeroFood(id)
    local str = ""
    if id == HeroFoodType.MOON then
        str = LanguageUtils.LocalizeCommon("hero_food_moon_info")
    elseif id == HeroFoodType.SUN then
        str = LanguageUtils.LocalizeCommon("hero_food_sun_info")
    else
        str = LanguageUtils.LocalizeCommon("hero_food_faction_info_" .. id)
    end
    return str
end

--- @return string
--- @param id number
function LanguageUtils.LocalizeRanking(id)
    return LanguageUtils.Localize(string.format("ranking_%s", id), LanguageUtils.Common)
end

--- @return string
--- @param key string
function LanguageUtils.LocalizeHelpInfo(key, dayStart, dayEnd)
    if dayStart and dayEnd then
        return string.format(LanguageUtils.Localize(key, LanguageUtils.HelpInfo), dayStart, dayEnd)
    end
    return LanguageUtils.Localize(key, LanguageUtils.HelpInfo)
end

--- @return string
--- @param key string
function LanguageUtils.LocalizeMail(key)
    return LanguageUtils.Localize(key, LanguageUtils.Mail)
end

--- @return string
--- @param key string
function LanguageUtils.LocalizeTutorial(key)
    return LanguageUtils.Localize(key, LanguageUtils.Tutorial)
end

--- @return string
--- @param id StatType
function LanguageUtils.LocalizeStat(id)
    return LanguageUtils.Localize(string.format("stat_type_%s", id), LanguageUtils.EnumType)
end

--- @return string
--- @param id StatType
function LanguageUtils.LocalizeEffect(id)
    return LanguageUtils.Localize(string.format("effect_type_%s", id), LanguageUtils.EnumType)
end

--- @return string
--- @param id HeroClassType
function LanguageUtils.LocalizeClass(id)
    return LanguageUtils.Localize(string.format("class_type_%s", id), LanguageUtils.EnumType)
end

--- @return string
--- @param id HeroFactionType
function LanguageUtils.LocalizeFaction(id)
    return LanguageUtils.Localize(string.format("faction_type_%s", id), LanguageUtils.EnumType)
end

--- @return string
--- @param featureType FeatureType
function LanguageUtils.LocalizeFeature(featureType)
    return LanguageUtils.Localize(string.format("feature_%s", featureType), LanguageUtils.EnumType)
end

--- @return string
function LanguageUtils.LocalizeTalent(id)
    return LanguageUtils.Localize(string.format("talent_%s", id), LanguageUtils.EnumType)
end

--- @return string
--- @param id FeatureType
function LanguageUtils.LocalizeLand(id)
    local msg = LanguageUtils.Localize(string.format("land_%s", id), LanguageUtils.EnumType)
    return LanguageUtils.Localize(string.format("land_%s", id), LanguageUtils.EnumType)
end

--- @return string
--- @param id FeatureType
function LanguageUtils.LocalizeLandRule(id)
    return LanguageUtils.Localize(string.format("restrict_type_%s", id), LanguageUtils.EnumType)
end

--- @return string
--- @param id FeatureType
function LanguageUtils.LocalizeFeatureContent(id)
    return LanguageUtils.Localize(string.format("feature_content_%s", id), LanguageUtils.EnumContent)
end

--- @return string
--- @param moneyType MoneyType
function LanguageUtils.LocalizeMoneyType(moneyType)
    return LanguageUtils.Localize(string.format("money_type_%s", moneyType), LanguageUtils.EnumType)
end

--- @return string
--- @param id number
function LanguageUtils.LocalizeSummonerName(id)
    return LanguageUtils.Localize(string.format("name_%s", id), LanguageUtils.Summoner)
end

--- @return string
--- @param id number
function LanguageUtils.LocalizeSummonerInfo(id)
    return LanguageUtils.Localize(string.format("info_%s", id), LanguageUtils.Summoner)
end

--- @return string
--- @param key string
function LanguageUtils.LocalizeVip(key)
    return LanguageUtils.Localize(key, "vip")
end

--- @return string
--- @param id SummonType
function LanguageUtils.LocalizeSummonType(id)
    return LanguageUtils.Localize(string.format("summon_type_%s", id), LanguageUtils.EnumType)
end

--- @return string
--- @param id CasinoType
function LanguageUtils.LocalizeCasinoType(id)
    return LanguageUtils.Localize(string.format("casino_type_%s", id), LanguageUtils.EnumType)
end

--- @return string
--- @param id RaidModeType
function LanguageUtils.LocalizeRaidType(id)
    return LanguageUtils.Localize(string.format("raid_type_%s", id), LanguageUtils.EnumType)
end

--- @return string
--- @param id GameMode
function LanguageUtils.LocalizeGameMode(id)
    return LanguageUtils.Localize(string.format("game_mode_%s", id), LanguageUtils.EnumType)
end

--- @return string
--- @param key string
function LanguageUtils.LocalizeChestRewardDailyBoss(key)
    return LanguageUtils.Localize(key, "daily_boss_chess")
end

--- @return string
--- @param id number
function LanguageUtils.LocalizeEquipmentName(id)
    return LanguageUtils.Localize(tostring(id), LanguageUtils.Equipment)
end

--- @return string
--- @param id number
function LanguageUtils.LocalizeArtifactName(id)
    return LanguageUtils.Localize(tostring(math.floor(id / 1000)), LanguageUtils.Artifact)
end

--- @return string
--- @param id number
function LanguageUtils.LocalizeStoneName(id)
    return LanguageUtils.Localize(tostring(id % 100), LanguageUtils.Stone)
end

--- @return string
--- @param id number
function LanguageUtils.LocalizeEquipmentSetName(id)
    return LanguageUtils.Localize(tostring(id), LanguageUtils.EquipmentSet)
end

--- @return string
--- @param id number
function LanguageUtils.LocalizeResourceType(id)
    return LanguageUtils.Localize(string.format("resource_type_%s", id), LanguageUtils.EnumType)
end

--- @return string
--- @param star number
function LanguageUtils.LocalizeNameQuestTavern(star, id)
    return LanguageUtils.Localize(string.format("%s_%s", star,
            id % 2 + 1), LanguageUtils.QuestTavern)
end

--- @return string
--- @param heroId number
function LanguageUtils.LocalizeNameHero(heroId)
    return LanguageUtils.Localize(tostring(heroId), "heroes_name")
end

--- @return string
--- @param id number
function LanguageUtils.LocalizeHeroTextDetail(id)
    return LanguageUtils.Localize(string.format("hero_detail_%s", id), LanguageUtils.EnumType)
end

--- @return string
--- @param id number
function LanguageUtils.LocalizeNameItem(type, id)
    local name = ""
    if type == ResourceType.Hero then
        name = LanguageUtils.LocalizeNameHero(id)
    elseif type == ResourceType.HeroFragment then
        if id < HeroConstants.FACTION_HERO_ID_DELTA then
            name = LanguageUtils.LocalizeResourceType(ResourceType.HeroFragment)
        else
            name = LanguageUtils.LocalizeNameHero(ClientConfigUtils.GetHeroIdByFragmentId(id))
        end
    elseif type == ResourceType.Money then
        name = LanguageUtils.LocalizeMoneyType(id)
    elseif type == ResourceType.ItemEquip then
        name = LanguageUtils.LocalizeEquipmentName(id)
    elseif type == ResourceType.ItemArtifact then
        name = LanguageUtils.LocalizeArtifactName(id)
    elseif type == ResourceType.ItemStone then
        name = LanguageUtils.LocalizeStoneName(id)
    elseif type == ResourceType.EvolveFoodMaterial then
        name = LanguageUtils.LocalizeHeroFoodInfo(id)
    elseif type == ResourceType.Skin then
        name = LanguageUtils.LocalizeSkinName(id)
    elseif type == ResourceType.Avatar then
        name = LanguageUtils.LocalizeAvatarName(id)
    elseif type == ResourceType.AvatarFrame then
        name = LanguageUtils.LocalizeAvatarFrameName(id)
    end
    if name == "" then
        name = LanguageUtils.LocalizeResourceType(type)
    end
    return name
end

--- @return string
--- @param id number
function LanguageUtils.LocalizeNameCompanion(id)
    return LanguageUtils.Localize(string.format("companion_type_remake_%s", id), LanguageUtils.EnumType)
end

--- @return string
--- @param id number
function LanguageUtils.LocalizeNameLinking(id)
    return LanguageUtils.Localize(string.format("linking_%s", id), LanguageUtils.EnumType)
end

--- @return string
--- @param id number
function LanguageUtils.LocalizeMoneyDescription(id)
    local str = LanguageUtils.Localize(string.format("money_type_%s", id), "money_info")
    if id == MoneyType.EVENT_PUZZLE_PIECE then
        str = StringUtils.FormatLocalizeStart1(LanguageUtils.Localize(string.format("money_type_%s", id), "money_info"),
                LanguageUtils.LocalizeCommon("event_puzzle"))
    end
    return str
end

--- @return string
--- @param id number
function LanguageUtils.LocalizeHeroFragmentDescription(id)
    local str = ""
    return str
end

--- @return string
--- @param id number
function LanguageUtils.LocalizeLogicCode(logicCode)
    return string.format("%s(%s)", LanguageUtils.Localize(tostring(logicCode), "logic_code"), logicCode)
end

--- @return string
--- @param id number
function LanguageUtils.LocalizeGiftCodeResult(logicCode)
    local localize = ""
    if logicCode <= 9 then
        localize = LanguageUtils.Localize(tostring(logicCode), "logic_code")
    else
        localize = LanguageUtils.Localize(tostring(logicCode), "gift_code_result")
    end
    return string.format("%s(_%s)", localize, logicCode)
end

--- @return string
--- @param disconnectReason DisconnectReason
function LanguageUtils.LocalizeDisconnectReasonCode(disconnectReason)
    return LanguageUtils.Localize(tostring(disconnectReason), "disconnect_reason")
end

--- @return void
function LanguageUtils.SetLocalizeInputField(...)
    local args = { ... }
    local enterText = LanguageUtils.LocalizeCommon("enter_text")
    for i = 1, #args do
        args[i].placeholder:GetComponent(ComponentName.UnityEngine_UI_Text).text = enterText
    end
end

--- @return string
--- @param data table
--- @param keyCsv string
function LanguageUtils.GetStatCsv(data, keyCsv)
    local value = data[keyCsv]
    if value == nil then
        value = "nil"
    end
    return value
end

--- @return string
--- @param localize string
function LanguageUtils.ReplaceColor(localize)
    localize = string.gsub(localize, "<c1>", string.format("<color=#%s>", UIUtils.color6), 10)
    localize = string.gsub(localize, "<c2>", string.format("<color=#%s>", UIUtils.color2), 10)
    localize = string.gsub(localize, "<c>", "</color>", 10)
    return localize
end

--- @return string
--- @param localize string
function LanguageUtils.ReplaceEnum(localize)
    local replace = function(v)
        return LanguageUtils.Localize(string.sub(v, 2, string.len(v) - 1), LanguageUtils.EnumType)
    end
    return string.gsub(localize, "{e(.-)}", replace, 10)
end

--- @return string
--- @param localize string
function LanguageUtils.ReplaceCommonReference(localize)
    local replace = function(v)
        return LanguageUtils.Localize(string.sub(v, 2, string.len(v) - 1), LanguageUtils.Common)
    end
    return string.gsub(localize, "{cm(.-)}", replace, 10)
end

--- @return string
--- @param func function
--- @param v string
function LanguageUtils.ReplaceCsv(func, v)
    --return func(string.sub(v,2, string.len(v) - 1))
    return UIUtils.SetColorString(UIUtils.color6, func(string.sub(v, 2, string.len(v) - 1)))
end

--- @return string
--- @param func function
--- @param v string
function LanguageUtils.ReplaceCsvSplit(func, v)
    local a = func(string.sub(v, 2, string.len(v) - 1))
    local pos = string.sub(a, 1, 1)
    for i = 2, #a do
        pos = pos .. ", " .. string.sub(a, i, i)
    end
    return UIUtils.SetColorString(UIUtils.color6, pos)
end

--- @return string
--- @param func function
--- @param v string
function LanguageUtils.ReplaceCsvPercent(func, v)
    --return math.floor(tonumber(func(string.sub(v,2, string.len(v) - 1))) * 100) .. "%"
    return UIUtils.SetColorString(UIUtils.color6, string.format("%.1f", tonumber(func(string.sub(v, 2, string.len(v) - 1))) * 100) .. "%")
end

--- @return string
--- @param func function
--- @param v string
--- @param dataLevel table
function LanguageUtils.ReplaceQuery(func, v, dataLevel)
    local query = zg.languageMgr:GetDataQueryCache(string.sub(v, 2, string.len(v) - 1))
    local f = string.sub(query, 1, 4)
    if f == "{ct(" then
        -- calculation Type
        local s = (string.sub(query, 5, string.len(query) - 2)):Split("~")
        local value = dataLevel[s[2]]
        if value ~= nil and tonumber(value) > 2 then
            --query = func(s[1])
            query = UIUtils.SetColorString(UIUtils.color6, func(s[1]))
        else
            --query = math.floor(tonumber(func(s[1])) * 100) .. "%"
            query = UIUtils.SetColorString(UIUtils.color6, string.format("%.1f", tonumber(func(s[1])) * 100) .. "%")
        end
    elseif f == "{tp(" then
        -- target position
        local s = (string.sub(query, 5, string.len(query) - 2)):Split("~")
        local position = func(s[2])
        local number = func(s[3])

        local value = s[1] .. "_" .. position .. "_" .. number
        if LanguageUtils.Contain(value, LanguageUtils.EnumType) then
            value = LanguageUtils.Localize(value, LanguageUtils.EnumType)
        else
            value = s[1] .. "_" .. position
            value = LanguageUtils.Localize(value, LanguageUtils.EnumType)
        end
        if value ~= nil then
            if position == "52" then
                local class = nil
                if s[4] ~= nil then
                    class = func(s[4])
                end
                if class == nil then
                    class = number
                end
                query = string.gsub(value, "{0}", UIUtils.SetColorString(UIUtils.color6, LanguageUtils.LocalizeClass(class)), 1)
            elseif position == "61" then
                local position = number:sub(1, 1)
                if #number > 1 then
                    for i = 2, #number do
                        position = string.format("%s,%s", position, number:sub(i, i))
                    end
                end
                query = string.gsub(value, "{0}", UIUtils.SetColorString(UIUtils.color6, position), 1)
            else
                query = string.gsub(value, "{0}", UIUtils.SetColorString(UIUtils.color6, number), 1)
            end
        end
    elseif f == "{et(" then
        -- Enum type
        local s = (string.sub(query, 5, string.len(query) - 2)):Split("~")
        local value = s[1] .. "_" .. func(s[2])
        --query = LanguageUtils.Localize(value, LanguageUtils.EnumType)
        query = UIUtils.SetColorString(UIUtils.color6, LanguageUtils.Localize(value, LanguageUtils.EnumType))
    elseif f == "{tmm" then
        -- target min max
        local s = (string.sub(query, 6, string.len(query) - 2)):Split("~")
        local position = func(s[2])
        local numberMin = func(s[3])
        local numberMax = func(s[4])
        local value = s[1] .. "_" .. position
        value = LanguageUtils.Localize(value, LanguageUtils.EnumType)
        if value ~= nil then
            --query = string.gsub(value, "{0}", string.format("%s-%s", numberMin, numberMax) ,1)
            query = string.gsub(value, "{0}", UIUtils.SetColorString(UIUtils.color6, string.format("%s-%s", numberMin, numberMax)), 1)
        end
    end
    return query
end

--- @return string
--- @param summonerId number
--- @param skillId number
--- @param tier number
--- @param levelSkill number
function LanguageUtils.LocalizeSkillSummonerDescription(summonerId, skillId, tier, levelSkill)
    local key = string.format("summoner_%s_%s_%s", summonerId, skillId, tier)
    --XDebug.Log(key)
    local csvLocalize = "summoner_skill_localize_format"
    ---@type Dictionary
    local data = zg.languageMgr.languageDict:Get(csvLocalize)
    if data == nil then
        data = zg.languageMgr:LoadLocalize(csvLocalize)
    end
    local contentCsv = CsvReaderUtils.ReadLocalFile(ResourceMgr.GetHeroesConfig():GetSummonerCsv():GetSkillPath(summonerId, skillId, tier))
    local content = CsvReader.ReadContent(contentCsv)
    --XDebug.Log(LogUtils.ToDetail(content) .. levelSkill)
    local dataLevel = content[math.max(1, levelSkill)]
    if dataLevel == nil then
        assert(false, key .. " level " .. levelSkill .. LogUtils.ToDetail(content))
    end
    local localize = ""
    ---@param k string
    ---@param v string
    for k, v in pairs(data:GetItems()) do
        if k == key then
            localize = v
            break
        else
            if string.match(k, key) then
                local s = k:Split("~")
                local value = tonumber(dataLevel[s[2]])
                if s[3] == "0" and (value == nil or value == 1) then
                    localize = v
                    break
                elseif s[3] == "1" and value ~= nil and value < 1 then
                    localize = v
                    break
                end
            end
        end
    end

    local getStat = function(keyCsv)
        return LanguageUtils.GetStatCsv(dataLevel, keyCsv)
    end
    local replaceCsv = function(v)
        return LanguageUtils.ReplaceCsv(getStat, v)
    end
    local replaceCsvSplit = function(v)
        return LanguageUtils.ReplaceCsvSplit(getStat, v)
    end
    local replaceCsvPercent = function(v)
        return LanguageUtils.ReplaceCsvPercent(getStat, v)
    end
    local replaceQuery = function(v)
        return LanguageUtils.ReplaceQuery(getStat, v, dataLevel)
    end
    localize = string.gsub(localize, "{p(.-)}", replaceCsvPercent, 10)
    localize = string.gsub(localize, "{c(.-)}", replaceCsv, 10)
    localize = string.gsub(localize, "{s(.-)}", replaceCsvSplit, 10)
    localize = string.gsub(localize, "{q(.-)}", replaceQuery, 10)
    return LanguageUtils.ReplaceColor(localize)
end

--- @return string
--- @param heroId number
--- @param skillId number
--- @param levelSkill number
function LanguageUtils.LocalizeSkillDescription(heroId, skillId, levelSkill)
    local contentCsv = ResourceMgr.GetHeroesConfig():GetHeroCsv():GetSkill(heroId):Get(skillId)
    if contentCsv == nil then
        assert(false, string.format("Missing heroId %s, skillId %s", heroId, skillId))
    end
    local dataLevel = CsvReader.ReadContent(contentCsv)[levelSkill]
    if dataLevel == nil then
        assert(false, string.format("Missing heroId %s, skillId %s, level %s", heroId, skillId, levelSkill))
    end
    local key = zg.languageMgr:GetKeySkillHero(heroId, skillId)
    if key == nil then
        XDebug.Error(string.format("Missing KeySkillHero heroId %s, skillId %s", heroId, skillId))
        return ""
    end
    if string.match(key, "~") then
        local s = key:Split("~")
        local value = tonumber(dataLevel[s[2]])
        local checkValue
        if #s > 2 then
            checkValue = tonumber(s[3])
        end
        if checkValue == 1 then
            if value == nil or value == 0 then
                key = string.format("%s~%s~0", s[1], s[2])
            elseif value ~= nil and value > 0 then
                key = string.format("%s~%s~1", s[1], s[2])
            end
        else
            if value == nil or value == 1 then
                key = string.format("%s~%s~0", s[1], s[2])
            elseif value ~= nil and value < 1 then
                key = string.format("%s~%s~1", s[1], s[2])
            end
        end
    end
    local localize = LanguageUtils.Localize(key, LanguageUtils.Skill)
    if localize == nil then
        XDebug.Error(string.format("Missing LocalizeSkill heroId %s, skillId %s, key %s", heroId, skillId, key))
        return ""
    end
    local getStat = function(keyCsv)
        return LanguageUtils.GetStatCsv(dataLevel, keyCsv)
    end
    local replaceCsv = function(v)
        return LanguageUtils.ReplaceCsv(getStat, v)
    end
    local replaceCsvPercent = function(v)
        return LanguageUtils.ReplaceCsvPercent(getStat, v)
    end
    local replaceQuery = function(v)
        return LanguageUtils.ReplaceQuery(getStat, v, dataLevel)
    end
    localize = string.gsub(localize, "{p(.-)}", replaceCsvPercent, 10)
    localize = string.gsub(localize, "{c(.-)}", replaceCsv, 10)
    localize = string.gsub(localize, "{q(.-)}", replaceQuery, 10)
    return LanguageUtils.ReplaceColor(localize)
end

--- @return string
--- @param key string
function LanguageUtils.LocalizeQuestTreeName(key)
    return LanguageUtils.Localize(key, "name_quest_tree")
end

--- @return string
--- @param id CampaignDifficultLevel
function LanguageUtils.LocalizeDifficult(id)
    return LanguageUtils.Localize("difficult_type_" .. id, LanguageUtils.EnumType)
end

--- @return string
--- @param sheet string
--- @param questElementConfig QuestElementConfig
--- @param fixedTarget number
function LanguageUtils.LocalizeQuestDescriptionBySheet(questElementConfig, sheet, fixedTarget, questId)
    local newDefenseStagePassQuest = questElementConfig._questType == QuestType.DEFENSE_STAGE_PASS
    local key = "quest_" .. questElementConfig._questType
    for i = 1, 6 do
        if questElementConfig._listRequirements:IsContainKey(i) then
            key = key .. "_" .. i
        end
    end
    local localize = LanguageUtils.Localize(key, sheet)
    local replaceCsv = function(v)
        local value = tonumber(string.sub(v, 2, string.len(v) - 1))
        if (newDefenseStagePassQuest) then
            --print("defense stage pass ", v, "value ", value)
            if (v == "(2)") then
                local landId = questElementConfig._listRequirements:Get(2)
                if (landId ~= nil) then
                    return LanguageUtils.LocalizeLand(tonumber(landId))
                end
            end
        end
        if fixedTarget ~= nil and value == 1 then
            return tostring(ClientConfigUtils.FormatNumber(fixedTarget))
        end
        return tostring(ClientConfigUtils.FormatNumber(questElementConfig._listRequirements:Get(value)))
    end
    local replaceMap = function(v)
        local id = questElementConfig._listRequirements:Get(tonumber(string.sub(v, 2, string.len(v) - 1)))
        local difficult, map, stage = ClientConfigUtils.GetIdFromStageId(id)
        return StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("map_stage"), map, stage,
                LanguageUtils.LocalizeDifficult(difficult))
    end
    local replaceHeroName = function(v)
        local index = tonumber(string.sub(v, 2, string.len(v) - 1))
        local value = tonumber(questElementConfig._listRequirements:Get(index))
        return LanguageUtils.LocalizeNameHero(value, LanguageUtils.EnumType)
    end
    local replaceCsvPercent = function(v)
        return string.format("%.1f", questElementConfig._listRequirements:Get(tonumber(string.sub(v, 2, string.len(v) - 1))) * 100) .. "%"
    end
    local replaceEnum = function(v)
        local s = (string.sub(v, 2, string.len(v) - 1)):Split("~")
        local index = tonumber(s[2])
        local value
        if s[1] and questElementConfig._listRequirements:Get(index) then
            value = s[1] .. questElementConfig._listRequirements:Get(index)
        else
            value = s[1]
        end
        return LanguageUtils.Localize(value, LanguageUtils.EnumType)
    end
    local replaceTime = function(v)
        local seconds = questElementConfig._listRequirements:Get(1)
        local hours = math.floor((seconds % 86400) / 3600)
        local minutes = math.floor((seconds % 3600) / 60)
        local seconds = math.floor(seconds % 60)
        local timeResult = ""
        if hours > 0 then
            timeResult = timeResult .. string.format("%sh", hours)
        end
        if minutes > 0 then
            timeResult = timeResult .. string.format(" %sm", minutes)
        end
        if seconds > 0 then
            timeResult = timeResult .. string.format(" %ss", seconds)
        end
        return timeResult
    end
    if localize ~= nil then
        localize = string.gsub(localize, "{c(.-)}", replaceCsv, 5)
        localize = string.gsub(localize, "{m(.-)}", replaceMap, 5)
        localize = string.gsub(localize, "{e(.-)}", replaceEnum, 5)
        localize = string.gsub(localize, "{p(.-)}", replaceCsvPercent, 5)
        localize = string.gsub(localize, "{n(.-)}", replaceHeroName, 5)
        localize = string.gsub(localize, "{t(.-)}", replaceTime, 5)
    else
        localize = "NIL " .. key
        XDebug.Warning(localize)
    end
    return localize
end

--- @return string
--- @param questId number
--- @param questElementConfig QuestElementConfig
--- @param fixedTarget number
function LanguageUtils.LocalizeQuestDescription(questId, questElementConfig, fixedTarget)
    return LanguageUtils.LocalizeQuestDescriptionBySheet(questElementConfig, LanguageUtils.Quest, fixedTarget, questId)
end

--- @return string
--- @param questElementConfig QuestElementConfig
function LanguageUtils.LocalizeGuildQuestDescription(questElementConfig)
    return LanguageUtils.LocalizeQuestDescriptionBySheet(questElementConfig, LanguageUtils.Quest)
end

function LanguageUtils.LocalizeQuestTittle()

end

--- @return string
--- @param heroId number
--- @param skillId number
function LanguageUtils.LocalizeHeroSkillName(heroId, skillId)
    return LanguageUtils.Localize(string.format("%s_%s", heroId, skillId),
            LanguageUtils.HeroSkillName)
end

--- @return string
--- @param summonerId number
--- @param skillId number
--- @param tier number
function LanguageUtils.LocalizeSummonerSkillName(summonerId, skillId, tier)
    return LanguageUtils.Localize(string.format("summoner_%s_%s_%s", summonerId, skillId, tier),
            LanguageUtils.SummonerSkillName)
end

--- @return Dictionary
--- @param list List
function LanguageUtils._ListStatToDict(list)
    ---@type Dictionary
    local dict = Dictionary()
    for i, v in ipairs(list:GetItems()) do
        local number = tonumber(v)
        if number >= 0 then
            dict:Add(i, number)
        end
    end
    return dict
end

--- @return string
--- @param param string
function LanguageUtils.LocalizeListParam(param, localizeFunc)
    local localize = nil
    if not StringUtils.IsNilOrEmpty(param) then
        local split = param:Split(";")
        localize = localizeFunc(tostring(split[1]))
        if #split > 1 then
            for i = 2, #split do
                localize = string.format("%s, %s", localize, localizeFunc(tostring(split[i])))
            end
        end
    end
    return localize
end

--- @return string
--- @param param string
function LanguageUtils.LocalizeListFaction(param)
    return LanguageUtils.LocalizeListParam(param, LanguageUtils.LocalizeFaction)
end

--- @return string
--- @param param string
function LanguageUtils.LocalizeListClass(param)
    return LanguageUtils.LocalizeListParam(param, LanguageUtils.LocalizeClass)
end

--- @return string
--- @param param string
function LanguageUtils.LocalizeListHero(param)
    return LanguageUtils.LocalizeListParam(param, LanguageUtils.LocalizeNameHero)
end

--- @return string
--- @param option BaseItemOption
function LanguageUtils.LocalizeBaseStatItemOption(option)
    local localize = ""
    if option.type == ItemOptionType.STAT_CHANGE then
        local startType = tonumber(option.params:Get(1))
        local amount = tonumber(option.params:Get(2))
        local calculation = option.params:Get(3)
        if StringUtils.IsNilOrEmpty(calculation) then
            calculation = nil
        else
            calculation = tonumber(calculation)
        end
        local key = "1_1_2"
        if startType == StatType.POWER then
            key = key .. "_power"
        end
        localize = LanguageUtils.Localize(key, LanguageUtils.ItemOption)
        if calculation ~= nil and calculation >= 3 then
            localize = string.gsub(localize, "{1}", tostring(amount))
        else
            localize = string.gsub(localize, "{1}", string.format("%.1f", amount * 100) .. "%%")
        end
        localize = string.gsub(localize, "{2}", LanguageUtils.LocalizeStat(startType))
    elseif option.type == ItemOptionType.DAMAGE_AGAINST then
        local key = "2"
        for i = 1, 4 do
            ---@type string
            local v = option.params:Get(i)
            if (not StringUtils.IsNilOrEmpty(v)) then
                key = string.format("%s_%s", key, i)
            end
        end
        localize = LanguageUtils.Localize(key, LanguageUtils.ItemOption)
        local index = 1
        for i = 1, 4 do
            ---@type string
            local v = option.params:Get(i)
            if (not StringUtils.IsNilOrEmpty(v)) then
                local replace = ""
                if i == 1 then
                    replace = string.format("%.1f", tonumber(v) * 100) .. "%%"
                elseif i == 2 then
                    replace = LanguageUtils.LocalizeListFaction(v)
                elseif i == 3 then
                    replace = LanguageUtils.LocalizeListClass(v)
                elseif i == 4 then
                    replace = LanguageUtils.LocalizeListFaction(v)
                end
                if (not StringUtils.IsNilOrEmpty(replace)) then
                    localize = string.gsub(localize, string.format("{%s}", index), replace)
                    index = index + 1
                end
            end
        end
    elseif option.type == ItemOptionType.REDUCE_DAMAGE_TAKEN then
        local key = "5"
        for i = 1, 4 do
            ---@type string
            local v = option.params:Get(i)
            if (not StringUtils.IsNilOrEmpty(v)) then
                key = string.format("%s_%s", key, i)
            end
        end
        localize = LanguageUtils.Localize(key, LanguageUtils.ItemOption)
        local index = 1
        for i = 1, 4 do
            ---@type string
            local v = option.params:Get(i)
            if (not StringUtils.IsNilOrEmpty(v)) then
                local replace = ""
                if i == 1 then
                    replace = string.format("%.1f", tonumber(v) * 100) .. "%%"
                elseif i == 2 then
                    replace = LanguageUtils.LocalizeListFaction(v)
                elseif i == 3 then
                    replace = LanguageUtils.LocalizeListClass(v)
                elseif i == 4 then
                    replace = LanguageUtils.LocalizeListFaction(v)
                end
                if (not StringUtils.IsNilOrEmpty(replace)) then
                    localize = string.gsub(localize, string.format("{%s}", index), replace)
                    index = index + 1
                end

            end
        end
        if option:GetOptionParam(6) then
            return localize, tonumber(option:GetOptionParam(6))
        end
    elseif option.type == ItemOptionType.ITEM_PASSIVE then
        return LanguageUtils.LocalizePassiveBuffByOption(option), tonumber(option:GetOptionParam(2))
    else
        XDebug.Warning("equipment support option type: " .. tostring(option.type))
    end
    return localize
end

--- @return string
--- @param option BaseItemOption
function LanguageUtils.LocalizeStatItemOption(option, checkFaction, checkClass, checkHeroId)
    local localize = ""
    local faction
    local class
    local heroId
    if option.type == ItemOptionType.STAT_CHANGE then
        local startType = tonumber(option.params:Get(1))
        local amount = tonumber(option.params:Get(2))
        local calculation = option.params:Get(3)
        if StringUtils.IsNilOrEmpty(calculation) then
            calculation = nil
        else
            calculation = tonumber(calculation)
        end
        local class = LanguageUtils.LocalizeListClass(option.params:Get(4))

        local faction = LanguageUtils.LocalizeListFaction(option.params:Get(5))

        local heroId = LanguageUtils.LocalizeListHero(option.params:Get(6))

        local key = "1"
        for i = 1, 5 do
            ---@type string
            local v = option.params:Get(i)
            if (not StringUtils.IsNilOrEmpty(v)) and i ~= 3 then
                key = string.format("%s_%s", key, i)
            end
        end

        if startType == StatType.POWER then
            key = key .. "_power"
        end
        localize = LanguageUtils.Localize(key, LanguageUtils.ItemOption)
        if calculation ~= nil and calculation >= 3 then
            localize = string.gsub(localize, "{1}", tostring(amount))
        else
            localize = string.gsub(localize, "{1}", string.format("%.1f", amount * 100) .. "%%")
        end
        localize = string.gsub(localize, "{2}", LanguageUtils.LocalizeStat(startType))
        if class ~= nil then
            localize = string.gsub(localize, "{3}", class)
            if faction ~= nil then
                localize = string.gsub(localize, "{4}", faction)
            end
        elseif faction ~= nil then
            localize = string.gsub(localize, "{3}", faction)
        end
    elseif option.type == ItemOptionType.DAMAGE_AGAINST then
        local key = "2"
        for i = 1, 4 do
            ---@type string
            local v = option.params:Get(i)
            if (not StringUtils.IsNilOrEmpty(v)) and tonumber(v) >= 0 then
                key = string.format("%s_%s", key, i)
            end
        end

        localize = LanguageUtils.Localize(key, LanguageUtils.ItemOption)
        local index = 1
        for i = 1, 4 do
            ---@type string
            local v = option.params:Get(i)
            if (not StringUtils.IsNilOrEmpty(v)) then
                local value = tonumber(v)
                if value >= 0 then
                    local replace = ""
                    if i == 1 then
                        replace = string.format("%.1f", tonumber(v) * 100) .. "%%"
                    elseif i == 2 then
                        replace = LanguageUtils.LocalizeListFaction(v)
                    elseif i == 3 then
                        replace = LanguageUtils.LocalizeListClass(v)
                    elseif i == 4 then
                        replace = LanguageUtils.LocalizeListFaction(v)
                    end
                    if (not StringUtils.IsNilOrEmpty(replace)) then
                        localize = string.gsub(localize, string.format("{%s}", index), replace)
                        index = index + 1
                    end
                end
            end
        end
    elseif option.type == ItemOptionType.REDUCE_DAMAGE_TAKEN then
        local key = "5"
        for i = 1, 4 do
            ---@type string
            local v = option.params:Get(i)
            if (not StringUtils.IsNilOrEmpty(v)) and tonumber(v) >= 0 then
                key = string.format("%s_%s", key, i)
            end
        end

        localize = LanguageUtils.Localize(key, LanguageUtils.ItemOption)
        local index = 1
        for i = 1, 4 do
            ---@type string
            local v = option.params:Get(i)
            if (not StringUtils.IsNilOrEmpty(v)) then
                local value = tonumber(v)
                if value >= 0 then
                    local replace = ""
                    if i == 1 then
                        replace = string.format("%.1f", tonumber(v) * 100) .. "%%"
                    elseif i == 2 then
                        replace = LanguageUtils.LocalizeListFaction(v)
                    elseif i == 3 then
                        replace = LanguageUtils.LocalizeListClass(v)
                    elseif i == 4 then
                        replace = LanguageUtils.LocalizeListFaction(v)
                    end
                    if (not StringUtils.IsNilOrEmpty(replace)) then
                        localize = string.gsub(localize, string.format("{%s}", index), replace)
                        index = index + 1
                    end
                end
            end
        end
    end
    if (checkFaction ~= nil and faction ~= nil and checkFaction ~= faction) or (checkClass ~= nil and class ~= nil and checkClass ~= class) then
        localize = UIUtils.SetColorString(UIUtils.brown, localize)
    end
    return localize
end

--- @return string
--- @param statBonus StatBonus
function LanguageUtils.LocalizeStatBonus(statBonus)
    local localize = ""
    local key = "1_1_2"
    if statBonus.affectedFaction ~= nil then
        key = "1_1_2_5"
    end
    localize = LanguageUtils.Localize(key, LanguageUtils.ItemOption)
    localize = string.gsub(localize, "{2}", LanguageUtils.LocalizeStat(statBonus.statType))
    if statBonus.calculationType ~= nil and statBonus.calculationType >= 3 then
        localize = string.gsub(localize, "{1}", tostring(statBonus.amount))
    else
        localize = string.gsub(localize, "{1}", string.format("%.1f", statBonus.amount * 100) .. "%%")
    end
    if statBonus.affectedFaction ~= nil then
        localize = string.gsub(localize, "{3}", LanguageUtils.LocalizeFaction(statBonus.affectedFaction))
    end
    return localize
end

--- @return string
--- @param listStatBonus List
function LanguageUtils.LocalizeListStatBonus(listStatBonus, space)
    local localize = ""
    local _space = space
    if _space == nil then
        _space = "\n"
    end
    ---@param v StatBonus
    for _, v in ipairs(listStatBonus:GetItems()) do
        if localize == "" then
            localize = LanguageUtils.LocalizeStatBonus(v)
        else
            localize = localize .. _space .. LanguageUtils.LocalizeStatBonus(v)
        end
    end
    return localize
end

--- @return string
--- @param statBonus1 StatBonus
--- @param statBonus2 StatBonus
function LanguageUtils.LocalizeStatBonus2(statBonus1, statBonus2)
    local localize = ""
    local key = "1_1_2"

    local affectedFaction
    if statBonus1 ~= nil and statBonus1.affectedFaction ~= nil then
        affectedFaction = statBonus1.affectedFaction
        key = "1_1_2_5"
    end
    if affectedFaction == nil and statBonus2 ~= nil and statBonus2.affectedFaction ~= nil then
        affectedFaction = statBonus2.affectedFaction
        key = "1_1_2_5"
    end

    local calculationType
    if statBonus1 ~= nil and statBonus1.calculationType ~= nil then
        calculationType = statBonus1.calculationType
    end
    if statBonus2 ~= nil and calculationType == nil and statBonus2.calculationType ~= nil then
        calculationType = statBonus2.calculationType
    end

    local statType
    if statBonus1 ~= nil and statBonus1.statType ~= nil then
        statType = statBonus1.statType
    end
    if statBonus2 ~= nil and statType == nil and statBonus2.statType ~= nil then
        statType = statBonus2.statType
    end

    local amount = 0
    if statBonus1 ~= nil and statBonus1.amount ~= nil then
        amount = statBonus1.amount
    end

    localize = LanguageUtils.LocalizeStat(statType) .. " " .. LanguageUtils.Localize(key, LanguageUtils.ItemOption)
    localize = string.gsub(localize, "{2}", " ")
    if calculationType ~= nil and calculationType >= 3 then
        localize = string.gsub(localize, "{1}", tostring(amount))
    else
        localize = string.gsub(localize, "{1}", string.format("%.1f", amount * 100) .. "%%")
    end
    if affectedFaction ~= nil then
        localize = string.gsub(localize, "{3}", LanguageUtils.LocalizeFaction(affectedFaction))
    end
    if statBonus2 ~= nil and statBonus2.amount ~= nil then
        local amountNext = statBonus2.amount - amount
        if calculationType == nil or calculationType < 3 then
            amountNext = string.format("%.1f", amountNext * 100) .. "%"
        end
        localize = localize .. UIUtils.SetColorString(UIUtils.green_light, string.format("(+%s)", amountNext))
    end
    return localize
end

--- @return string
--- @param listStatBonus1 List
--- @param listStatBonus2 List
function LanguageUtils.LocalizeListStatBonus2(listStatBonus1, listStatBonus2)
    local localize = ""
    ---@type StatBonus
    local stat1
    ---@type StatBonus
    local stat2
    local count
    if listStatBonus1 ~= nil then
        count = listStatBonus1:Count()
    end
    if count == nil and listStatBonus2 ~= nil then
        count = listStatBonus2:Count()
    end
    for i = 1, count do
        if listStatBonus1 == nil or listStatBonus1:Count() < i then
            stat1 = nil
        else
            stat1 = listStatBonus1:Get(i)
        end
        if listStatBonus2 == nil or listStatBonus2:Count() < i then
            stat2 = nil
        else
            stat2 = listStatBonus2:Get(i)
        end
        if localize == "" then
            localize = LanguageUtils.LocalizeStatBonus2(stat1, stat2)
        else
            localize = localize .. "\n" .. LanguageUtils.LocalizeStatBonus2(stat1, stat2)
        end
    end
    return localize
end

--- @return StatChangerCalculationType
--- @param type ResourceType
--- @param id number
function LanguageUtils.GetStringResourceType(type, id)
    local str = ""
    if type == ResourceType.ItemEquip then
        if id ~= nil then
            local typeItem = (math.floor(id / 1000))
            if typeItem == EquipmentType.Weapon then
                str = LanguageUtils.LocalizeCommon("weapon")
            elseif typeItem == EquipmentType.Armor then
                str = LanguageUtils.LocalizeCommon("armor")
            elseif typeItem == EquipmentType.Helm then
                str = LanguageUtils.LocalizeCommon("helmet")
            elseif typeItem == EquipmentType.Accessory then
                str = LanguageUtils.LocalizeCommon("ring")
            end
        else
            str = LanguageUtils.LocalizeResourceType(type)
        end
    else
        str = LanguageUtils.LocalizeResourceType(type)
    end
    return str
end

--- @return StatChangerCalculationType
--- @param type ResourceType
--- @param id number
function LanguageUtils.GetStringResourceInfo(type, id)
    local str = ""
    if type == ResourceType.HeroFragment then
        local star = ClientConfigUtils.GetHeroFragmentStar(id)
        ---@type HeroFragmentNumberConfig
        local heroFragmentNumberConfig = ResourceMgr.GetFragmentConfig().heroFragmentNumberDictionary:Get(star)
        str = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("hero_fragment_info"),
                heroFragmentNumberConfig.number)
    elseif type == ResourceType.Money then
        str = LanguageUtils.LocalizeMoneyDescription(id)
    elseif type == ResourceType.EvolveFoodMaterial then
        str = LanguageUtils.LocalizeHeroFoodInfo(id)
    elseif type == ResourceType.ItemFragment then
        ---@type ArtifactFragmentConfig
        local artifactConfig = ResourceMgr.GetFragmentConfig().artifactFragmentDictionary:Get(id)
        str = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("artifact_fragment_info"),
                artifactConfig.price)
    elseif type == ResourceType.CampaignQuickBattleTicket then
        ---@type QuickBattleTicketData
        local quickBattleTicketData = ResourceMgr.GetCampaignQuickBattleTicketConfig():GetTicket(id)
        local time = quickBattleTicketData:GetHour()
        if quickBattleTicketData.resourceType == ResourceType.Money then
            if quickBattleTicketData.resourceId == MoneyType.GOLD then
                str = LanguageUtils.LocalizeCommon("speed_up_gold_info")
            elseif quickBattleTicketData.resourceId == MoneyType.MAGIC_POTION then
                str = LanguageUtils.LocalizeCommon("speed_up_hero_exp_info")
            end
        elseif quickBattleTicketData.resourceType == ResourceType.SummonerExp then
            str = LanguageUtils.LocalizeCommon("speed_up_summoner_exp_info")
        end
        str = string.format(str, time)
    elseif type == ResourceType.Skin then
        str = LanguageUtils.LocalizeCommon("skin")
    end
    return str
end

--- @return string
--- @param type ResourceType
--- @param id number
--- @param itemIconData ItemIconData
function LanguageUtils.GetStringResourceName(type, id, itemIconData)
    local str = ""
    if type == ResourceType.ItemEquip then
        str = LanguageUtils.LocalizeEquipmentName(id)
    elseif type == ResourceType.ItemArtifact then
        str = LanguageUtils.LocalizeArtifactName(id)
    elseif type == ResourceType.Hero and itemIconData.heroId then
        str = LanguageUtils.LocalizeNameHero(itemIconData.heroId)
    elseif type == ResourceType.ItemStone then
        str = LanguageUtils.LocalizeStoneName(id)
    elseif type == ResourceType.Money then
        str = LanguageUtils.LocalizeMoneyType(id)
    elseif type == ResourceType.HeroFragment then
        local heroId = ClientConfigUtils.GetHeroIdByFragmentHeroId(id)
        local faction = ClientConfigUtils.GetFactionFragmentIdByHeroId(id)
        local star = ClientConfigUtils.GetHeroFragmentStar(id)
        local isRedFragment = ClientConfigUtils.IsFragmentRedBorder(id)
        if heroId ~= nil then
            str = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("hero_fragment_name"),
                    LanguageUtils.LocalizeNameHero(heroId))
        elseif heroId ~= nil then
            str = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("hero_fragment_faction"),
                    LanguageUtils.LocalizeFaction(faction), star)
        elseif isRedFragment == true then
            str = LanguageUtils.LocalizeCommon("hero_fragment_" .. id)
        else
            str = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("hero_fragment_title_star"),
                    star)
        end
    elseif type == ResourceType.ItemFragment then
        str = LanguageUtils.LocalizeCommon(string.format("artifact_fragment_title_%s", id))
    elseif type == ResourceType.CampaignQuickBattleTicket then
        ---@type QuickBattleTicketData
        local quickBattleTicketData = ResourceMgr.GetCampaignQuickBattleTicketConfig():GetTicket(id)
        if quickBattleTicketData ~= nil then
            if quickBattleTicketData.resourceType == ResourceType.Money then
                if quickBattleTicketData.resourceId == MoneyType.GOLD then
                    str = LanguageUtils.LocalizeCommon("speed_up_gold")
                elseif quickBattleTicketData.resourceId == MoneyType.MAGIC_POTION then
                    str = LanguageUtils.LocalizeCommon("speed_up_hero_exp")
                end
            elseif quickBattleTicketData.resourceType == ResourceType.SummonerExp then
                str = LanguageUtils.LocalizeCommon("speed_up_summoner_exp")
            end
        else
            str = id .. " CampaignQuickBattleTicket Nil"
        end
    elseif type == ResourceType.EvolveFoodMaterial then
        local idFood, star = ClientConfigUtils.GetTypeAndStarHeroFood(id)
        if idFood == HeroFoodType.MOON then
            str = LanguageUtils.LocalizeCommon("hero_food_moon_title")
        elseif idFood == HeroFoodType.SUN then
            str = LanguageUtils.LocalizeCommon("hero_food_sun_title")
        else
            str = LanguageUtils.LocalizeCommon("hero_food_faction_title_" .. idFood)
        end
    elseif type == ResourceType.Skin then
        str = LanguageUtils.LocalizeSkinName(id)
    elseif type == ResourceType.Talent then
        str = LanguageUtils.LocalizeTalent(id)
    elseif type == ResourceType.Avatar then
        str = LanguageUtils.LocalizeAvatarName(id)
    elseif type == ResourceType.AvatarFrame then
        str = LanguageUtils.LocalizeAvatarFrameName(id)
    end
    return str
end

--- @return string
--- @param transform UnityEngine_Transform
--- @param type ResourceType
--- @param id number
function LanguageUtils.SetDescriptionItemData(transform, type, id, checkFaction, checkClass, checkHeroId, setNumber)
    ---@type {itemData}
    local itemData = ResourceMgr.GetServiceConfig():GetItemData(type, id)
    local listBase, dictClass, dictFaction, dictClassFaction, dictHeroId = ClientConfigUtils.SplitStat(itemData.optionList)
    for i = 1, transform.childCount - 1 do
        transform:GetChild(i).gameObject:SetActive(false)
    end
    transform:GetChild(0):GetComponent(ComponentName.UnityEngine_UI_Text).text = LanguageUtils.GetDescriptionListStat(listBase, nil, true)
    local index = 1
    for i, v in pairs(dictHeroId:GetItems()) do
        local bonus = UIUtils.SetColorString(UIUtils.color6,
                StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("bonus_hero"), LanguageUtils.LocalizeNameHero(i)))
                .. "\n"
        if i == checkHeroId then
            bonus = bonus .. UIUtils.SetColorString(UIUtils.green_normal, LanguageUtils.GetDescriptionListStat(v, nil, true))
        else
            bonus = bonus .. UIUtils.SetColorString(UIUtils.color12, LanguageUtils.GetDescriptionListStat(v, nil, true))
        end
        ---@type UnityEngine_UI_Text
        local text = transform:GetChild(index):GetComponent(ComponentName.UnityEngine_UI_Text)
        text.text = bonus
        text.gameObject:SetActive(true)
        index = index + 1
    end
    for i, v in pairs(dictClass:GetItems()) do
        local bonus = UIUtils.SetColorString(UIUtils.color6,
                StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("bonus_class"), LanguageUtils.LocalizeClass(i)))
                .. "\n"
        if i == checkClass then
            XDebug.Log(checkClass)
            bonus = bonus .. UIUtils.SetColorString(UIUtils.green_normal, LanguageUtils.GetDescriptionListStat(v, nil, true))
        else
            bonus = bonus .. UIUtils.SetColorString(UIUtils.color12, LanguageUtils.GetDescriptionListStat(v, nil, true))
        end
        ---@type UnityEngine_UI_Text
        local text = transform:GetChild(index):GetComponent(ComponentName.UnityEngine_UI_Text)
        text.text = bonus
        text.gameObject:SetActive(true)
        index = index + 1
    end
    for i, v in pairs(dictFaction:GetItems()) do
        local bonus = UIUtils.SetColorString(UIUtils.color6,
                StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("bonus_faction"), LanguageUtils.LocalizeFaction(i)))
                .. "\n"
        if i == checkFaction then
            bonus = bonus .. UIUtils.SetColorString(UIUtils.green_normal, LanguageUtils.GetDescriptionListStat(v, nil, true))
        else
            bonus = bonus .. UIUtils.SetColorString(UIUtils.color12, LanguageUtils.GetDescriptionListStat(v, nil, true))
        end
        ---@type UnityEngine_UI_Text
        local text = transform:GetChild(index):GetComponent(ComponentName.UnityEngine_UI_Text)
        text.text = bonus
        text.gameObject:SetActive(true)
        index = index + 1
    end
    for i, v in pairs(dictClassFaction:GetItems()) do
        local bonus = UIUtils.SetColorString(UIUtils.color6, StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("bonus_class_faction"),
                LanguageUtils.LocalizeClass(i.class), LanguageUtils.LocalizeFaction(i.faction)))
                .. "\n"
        if i.class == checkClass and i.faction == checkFaction then
            bonus = bonus .. UIUtils.SetColorString(UIUtils.green_normal, LanguageUtils.GetDescriptionListStat(v, nil, true))
        else
            bonus = bonus .. UIUtils.SetColorString(UIUtils.color12, LanguageUtils.GetDescriptionListStat(v, nil, true))
        end
        ---@type UnityEngine_UI_Text
        local text = transform:GetChild(index):GetComponent(ComponentName.UnityEngine_UI_Text)
        text.text = bonus
        text.gameObject:SetActive(true)
        index = index + 1
    end
    if itemData.setId ~= nil and itemData.setId >= 0 then
        local bonusSet = LanguageUtils.GetDescriptionSetItem(itemData, checkFaction, checkClass, setNumber)
        ---@type UnityEngine_UI_Text
        local text = transform:GetChild(index):GetComponent(ComponentName.UnityEngine_UI_Text)
        text.text = bonusSet
        text.gameObject:SetActive(true)
    end
end

--- @return string
--- @param listStatBonus List
--- @param step string
function LanguageUtils.GetDescriptionListStat(listStatBonus, step, ignoreClassFaction, checkFaction, checkClass)
    local dictFactionBuff = Dictionary()
    local description = ""
    local line = 1
    if step == nil then
        step = "\n"
    end
    local totalStatCount = listStatBonus:Count()
    local basisStatCount = 0
    for _, option in pairs(listStatBonus:GetItems()) do
        if option.type == ItemOptionType.STAT_CHANGE then
            basisStatCount = basisStatCount + 1
        end
    end
    for i = 1, totalStatCount do
        local option = listStatBonus:Get(i)
        if ignoreClassFaction == true then
            local description2, factionId = LanguageUtils.LocalizeBaseStatItemOption(option)
            if not factionId then
                if string.len(description2) > 1 then
                    description = description .. description2
                    if i ~= basisStatCount then
                        description = description .. step
                        line = line + 1
                    end
                end
            elseif factionId and string.len(description2) > 1 then
                dictFactionBuff:Add(factionId, description2)
            end
        else
            local description2 = LanguageUtils.LocalizeStatItemOption(option, checkFaction, checkClass)
            if string.len(description2) > 1 then
                description = description .. description2
                if i ~= basisStatCount then
                    description = description .. step
                    line = line + 1
                end
            end
        end
    end
    if dictFactionBuff:Count() > 0 then
        return description, line, dictFactionBuff
    else
        return description, line
    end
end

--- @return string
--- @param item EquipmentDataEntry
function LanguageUtils.GetDescriptionStatItem(item, checkFaction, checkClass)
    local description = ""
    ---@type number
    local count = item.optionList:Count()
    if count > 0 then
        description = LanguageUtils.GetDescriptionListStat(item.optionList, nil, false, checkFaction, checkClass)
    end
    return description
end

--- @return string
--- @param item EquipmentDataEntry
function LanguageUtils.GetDescriptionSetItem(item, checkFaction, checkClass, setNumber)
    local description = ""
    local line = 0

    -- SET EQUIPMENT
    if item.setId ~= nil and item.setId >= 0 then
        ---@type EquipmentSetDataEntry
        local setData = ResourceMgr.GetServiceConfig():GetItems():GetEquipmentSetData(item.setId)
        if setData ~= nil then
            local maxSet = 0
            for k, _ in pairs(setData.optionDict:GetItems()) do
                if k > maxSet then
                    maxSet = k
                end
            end
            ---@type number
            local count = setData.optionDict:Count()
            if count > 0 then
                if setNumber == nil then
                    setNumber = 0
                end
                description = UIUtils.SetColorString(UIUtils.green_normal,
                        LanguageUtils.LocalizeEquipmentSetName(setData.id) .. string.format("(%s/%s)", setNumber, maxSet))
                for k, v in pairs(setData.optionDict:GetItems()) do
                    local color = UIUtils.color12
                    if setNumber >= k then
                        color = UIUtils.green_normal
                    end
                    local localize = LanguageUtils.GetDescriptionListStat(v, nil, true, checkFaction, checkClass)
                    description = description .. "\n" .. UIUtils.SetColorString(color, localize)
                end
            end

        else
            XDebug.Error(string.format("Nil set equipment %s", item.setId))
        end
    end
    return description, line
end

--- @return string
--- @param item EquipmentDataEntry
function LanguageUtils.GetDescriptionSetItemByFaction(item, checkFaction, checkClass, setNumber)
    local setFactionBuff = Dictionary()
    if item.setId ~= nil and item.setId >= 0 then
        ---@type EquipmentSetDataEntry
        local setData = ResourceMgr.GetServiceConfig():GetItems():GetEquipmentSetData(item.setId)
        if setData ~= nil then
            ---@type number
            local count = setData.optionDict:Count()
            if count > 0 then
                if setNumber == nil then
                    setNumber = 0
                end
                for k, v in pairs(setData.optionDict:GetItems()) do
                    local localize, line, dictFactionBuff = LanguageUtils.GetDescriptionListStat(v, nil, true, checkFaction, checkClass)
                    if dictFactionBuff and dictFactionBuff:Count() > 0 then
                        setFactionBuff:Add(k, dictFactionBuff)
                    end
                end
            end
        else
            XDebug.Error(string.format("Nil set equipment %s", item.setId))
        end
    end
    return setFactionBuff
end

--- @return string
--- @param value number
function LanguageUtils.GetHardModeNameById(value)
    if value == 0 then
        return LanguageUtils.LocalizeDifficult(CampaignDifficultLevel.Normal)
    end
    return LanguageUtils.LocalizeDifficult(value)
end

--- @return string
--- @param vipUnlock number
--- @param levelRequire number
--- @param stageRequire number
function LanguageUtils.NotificationRequireVipOrLevelAndStage(vipUnlock, levelRequire, stageRequire)
    local noti = ""
    if levelRequire ~= nil then
        if stageRequire ~= nil then
            local difficult, map, stage = ClientConfigUtils.GetIdFromStageId(stageRequire)
            if vipUnlock ~= nil then
                noti = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("require_vip_or_level_stage"),
                        vipUnlock, levelRequire, LanguageUtils.LocalizeDifficult(difficult), map, stage)
            else
                noti = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("require_level_stage"),
                        levelRequire, LanguageUtils.LocalizeDifficult(difficult), map, stage)
            end
        else
            if vipUnlock ~= nil then
                noti = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("require_vip_or_level"),
                        vipUnlock, levelRequire)
            else
                noti = string.format(LanguageUtils.LocalizeCommon("require_level_x"), levelRequire)
            end
        end
    else
        if stageRequire ~= nil then
            local difficult, map, stage = ClientConfigUtils.GetIdFromStageId(stageRequire)
            if vipUnlock ~= nil then
                noti = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("require_vip_or_stage"),
                        vipUnlock, LanguageUtils.LocalizeDifficult(difficult), map, stage)
            else
                noti = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("require_stage_x"),
                        LanguageUtils.LocalizeDifficult(difficult), map, stage)
            end
        else
            if vipUnlock ~= nil then
                noti = string.format(LanguageUtils.LocalizeCommon("require_vip"), vipUnlock)
            end
        end
    end
    return noti
end

--- @return string
--- @param quickBattleTicketData QuickBattleTicketData
function LanguageUtils.LocalizeQuickBattleTicket(quickBattleTicketData)
    return StringUtils.FormatLocalizeStart1(
            LanguageUtils.LocalizeCommon(string.format("quick_battle_ticket_%s_%s",
                    quickBattleTicketData.resourceType, quickBattleTicketData.resourceId)), quickBattleTicketData:GetHour())
end

function LanguageUtils.CheckInitLocalize(own, func)
    if own.language ~= PlayerSettingData.language then
        own.language = PlayerSettingData.language
        if func ~= nil then
            func(own)
        end
    end
end

--- @return string
--- @param activeBuffDataEntry ActiveBuffDataEntry
function LanguageUtils.LocalizeDungeonActiveBuff(activeBuffDataEntry)
    ---@type List
    local listStat = List()
    local hp = 0
    if activeBuffDataEntry.hpPercent ~= nil and activeBuffDataEntry.hpPercent > 0 then
        hp = 1
        listStat:Add(UIUtils.SetColorString(UIUtils.color10, string.format("%.1f{percent}", activeBuffDataEntry.hpPercent * 100)))
        listStat:Add(LanguageUtils.LocalizeStat(StatType.HP))
    end
    local power = 0
    if activeBuffDataEntry.power ~= nil and activeBuffDataEntry.power > 0 then
        power = 1
        listStat:Add(UIUtils.SetColorString(UIUtils.color10, activeBuffDataEntry.power .. "{percent}"))
        listStat:Add(LanguageUtils.LocalizeStat(StatType.POWER))
    end
    local key = string.format("active_%s_%s_%s", activeBuffDataEntry.type, hp, power)
    local localize = LanguageUtils.Localize(key, "dungeon_active_buff")
    for i, v in ipairs(listStat:GetItems()) do
        localize = string.gsub(localize, string.format("{%s}", i), tostring(v), 10)
    end
    localize = string.gsub(localize, "{percent}", "%%", 10)
    return localize
end

--- @return string
--- @param passiveBuffDataEntry PassiveBuffDataEntry
function LanguageUtils.LocalizePassiveTalentBuff(passiveBuffDataEntry)
    ---@type BaseItemOption
    local option = passiveBuffDataEntry.optionList:Get(1)
    local passiveId
    local localize = ""
    local key

    if option.type == ItemOptionType.ITEM_PASSIVE then
        key = "10"
        for i = 1, 4 do
            ---@type string
            local v = option.params:Get(i)
            if (not StringUtils.IsNilOrEmpty(v)) then
                key = string.format("%s_%s", key, v)
                passiveId = v
                local talentPassiveStat = ResourceMgr.GetServiceConfig():GetItems():GetItemPassiveData(tonumber(v)).fields
                local count = TableUtils.CountKey(talentPassiveStat)
                local statIndex = 0
                for i = 3, count do
                    statIndex = statIndex + 1
                    key = string.format("%s_%s", key, statIndex)
                end
                break
            end
        end
    end

    local content = CsvReaderUtils.ReadLocalFile(string.format(ITEM_PASSIVE_PATH, passiveId))
    local csvTalentPassiveData = CsvReader.ReadContentToList(content)
    local talentPassiveHeaderData = csvTalentPassiveData:Get(1)
    local talentPassiveData = csvTalentPassiveData:Get(2)

    localize = LanguageUtils.Localize(key, LanguageUtils.ItemOption10)
    for i = 3, #talentPassiveHeaderData do
        local fieldName = tostring(talentPassiveHeaderData[i])
        local fieldValue = talentPassiveData[i]
        if string.find(fieldName, "stat_debuff_type") then
            localize = string.gsub(localize, string.format("{%s}", i - 2), LanguageUtils.LocalizeStat(tonumber(fieldValue)))
            localize = string.gsub(localize, string.format("{%s}", i - 1), UIUtils.SetColorString(UIUtils.color1, tostring(talentPassiveData[i + 1] * 100) .. "%%"))

        end
        if string.find(fieldName, "percent") or string.find(fieldName, "chance") then
            localize = string.gsub(localize, string.format("{%s}", i - 2), UIUtils.SetColorString(UIUtils.color1, tostring(fieldValue * 100) .. "%%"))
        else
            localize = string.gsub(localize, string.format("{%s}", i - 2), UIUtils.SetColorString(UIUtils.color1, tostring(fieldValue)))
        end
    end
    localize = UIUtils.SetColorString(UIUtils.brown, localize)
    return localize
end

--- @return string
--- @param passiveBuffDataEntry PassiveBuffDataEntry
function LanguageUtils.LocalizePassiveBuffByOption(option)
    ---@type BaseItemOption
    local passiveId
    local localize = ""
    local key
    key = "10"
    for i = 1, 4 do
        ---@type string
        local v = option.params:Get(i)
        if (not StringUtils.IsNilOrEmpty(v)) then
            key = string.format("%s_%s", key, v)
            passiveId = v
            local talentPassive = ResourceMgr.GetServiceConfig():GetItems():GetItemPassiveData(tonumber(v))
            if talentPassive and talentPassive.fields then
                local talentPassiveStat = talentPassive.fields
                local count = TableUtils.CountKey(talentPassiveStat)
                local statIndex = 0
                for i = 3, count do
                    statIndex = statIndex + 1
                    key = string.format("%s_%s", key, statIndex)
                end
                break
            end
        end
    end
    local content = CsvReaderUtils.ReadLocalFile(string.format(ITEM_PASSIVE_PATH, passiveId))
    local csvTalentPassiveData = CsvReader.ReadContentToList(content)
    local talentPassiveHeaderData = csvTalentPassiveData:Get(1)
    local talentPassiveData = csvTalentPassiveData:Get(2)

    localize = LanguageUtils.Localize(key, LanguageUtils.ItemOption10)
    for i = 3, #talentPassiveHeaderData do
        local fieldName = tostring(talentPassiveHeaderData[i])
        local fieldValue = talentPassiveData[i]
        if string.find(fieldName, "stat_debuff_type") then
            localize = string.gsub(localize, string.format("{%s}", i - 2), LanguageUtils.LocalizeStat(tonumber(fieldValue)))
            localize = string.gsub(localize, string.format("{%s}", i - 1), UIUtils.SetColorString(UIUtils.color1, tostring(talentPassiveData[i + 1] * 100) .. "%%"))
        elseif string.find(fieldName, "effect_apply_type") then
            localize = string.gsub(localize, string.format("{%s}", i - 2), UIUtils.SetColorString(UIUtils.color7, LanguageUtils.LocalizeEffect(tonumber(fieldValue))))
        elseif string.find(fieldName, "percent") or string.find(fieldName, "chance") then
            localize = string.gsub(localize, string.format("{%s}", i - 2), UIUtils.SetColorString(UIUtils.color6, tostring(fieldValue * 100) .. "%%"))
        else
            localize = string.gsub(localize, string.format("{%s}", i - 2), UIUtils.SetColorString(UIUtils.color1, tostring(fieldValue)))
        end
    end
    localize = string.format("%s\n%s", UIUtils.SetColorString(UIUtils.color6, talentPassiveData[2]), localize)
    --localize = UIUtils.SetColorString(UIUtils.green_dark, localize)
    return localize
end

--- @return string
--- @param passiveBuffDataEntry PassiveBuffDataEntry
function LanguageUtils.LocalizePassiveBuff(passiveBuffDataEntry, sheet)
    ---@type BaseItemOption
    local option = passiveBuffDataEntry.optionList:Get(1)
    local localize = ""

    ---@param param string
    ---@param getLocalize function
    local getDiscriptionParam = function(param, getLocalize)
        ---@type string
        local description = param
        if StringUtils.IsNilOrEmpty(description) then
            description = nil
        else
            local split = description:Split(";")
            description = getLocalize(split[1])
            if #split > 1 then
                for i = 2, #split do
                    description = string.format("%s, %s", description, getLocalize(split[i]))
                end
            end
        end
        return description
    end
    local key
    ---@type List
    local listParam = List()
    if option.type == ItemOptionType.STAT_CHANGE then

        ---@param baseItemOption BaseItemOption
        local getStatBaseItemOption = function(baseItemOption)
            local startType = LanguageUtils.LocalizeStat(tonumber(baseItemOption.params:Get(1)))
            local amount = tonumber(baseItemOption.params:Get(2))
            local calculation = baseItemOption.params:Get(3)
            if StringUtils.IsNilOrEmpty(calculation) then
                calculation = nil
            else
                calculation = tonumber(calculation)
            end
            if calculation ~= nil and calculation >= 3 then
                return string.format("%s %s", amount, startType)
            else
                return string.format("%s %s", string.format("%.1f{percent}", amount * 100), startType)
            end
        end
        local stat = getStatBaseItemOption(passiveBuffDataEntry.optionList:Get(1))
        if passiveBuffDataEntry.optionList:Count() > 1 then
            for i = 2, passiveBuffDataEntry.optionList:Count() do
                stat = string.format("%s, %s", stat, getStatBaseItemOption(passiveBuffDataEntry.optionList:Get(i)))
            end
        end
        listParam:Add(UIUtils.SetColorString(UIUtils.color10, stat))

        local class = LanguageUtils.LocalizeListClass(option.params:Get(4))
        if class ~= nil then
            listParam:Add(UIUtils.SetColorString(UIUtils.color10, class))
        end

        local faction = LanguageUtils.LocalizeListFaction(option.params:Get(5))
        if faction ~= nil then
            listParam:Add(UIUtils.SetColorString(UIUtils.color10, faction))
        end

        key = "1"
        for i = 1, 5 do
            ---@type string
            local v = option.params:Get(i)
            if (not StringUtils.IsNilOrEmpty(v)) and i ~= 3 then
                key = string.format("%s_%s", key, i)
            end
        end
        local anyRequirement = option.params:Get(6)
        if ((not StringUtils.IsNilOrEmpty(class)) or (not StringUtils.IsNilOrEmpty(faction)))
                and (not StringUtils.IsNilOrEmpty(anyRequirement)) and tonumber(anyRequirement) == ItemConstants.ITEM_OPTION_ANY_OF_REQUIREMENT then
            anyRequirement = "_or"
        else
            anyRequirement = nil
        end
        if anyRequirement ~= nil then
            key = key .. anyRequirement
        end

    elseif option.type == ItemOptionType.DAMAGE_AGAINST then
        listParam:Add(UIUtils.SetColorString(UIUtils.color10, string.format("%.1f{percent}", tostring(option.params:Get(1)) * 100)))

        local factionSelf = LanguageUtils.LocalizeListFaction(option.params:Get(2))
        if factionSelf ~= nil then
            listParam:Add(UIUtils.SetColorString(UIUtils.color10, factionSelf))
        end

        local class = LanguageUtils.LocalizeListClass(option.params:Get(3))
        if class ~= nil then
            listParam:Add(UIUtils.SetColorString(UIUtils.color10, class))
        end

        local faction = LanguageUtils.LocalizeListFaction(option.params:Get(4))
        if faction ~= nil then
            listParam:Add(UIUtils.SetColorString(UIUtils.color10, faction))
        end

        key = "2"
        for i = 1, 4 do
            ---@type string
            local v = option.params:Get(i)
            if (not StringUtils.IsNilOrEmpty(v)) then
                key = string.format("%s_%s", key, i)
            end
        end

        local anyRequirement = option.params:Get(6)
        if ((not StringUtils.IsNilOrEmpty(class)) or (not StringUtils.IsNilOrEmpty(faction)))
                and (not StringUtils.IsNilOrEmpty(anyRequirement)) and tonumber(anyRequirement) == ItemConstants.ITEM_OPTION_ANY_OF_REQUIREMENT then
            key = key .. "_or"
        else
            anyRequirement = nil
        end
    end
    localize = LanguageUtils.Localize(key, sheet)

    for i, v in ipairs(listParam:GetItems()) do
        localize = string.gsub(localize, string.format("{%s}", i), v)
    end
    localize = string.gsub(localize, "{percent}", "%%", 10)
    return localize
end

--- @return string
--- @param passiveBuffDataEntry PassiveBuffDataEntry
function LanguageUtils.LocalizeDungeonPassiveBuff(passiveBuffDataEntry)
    return LanguageUtils.LocalizePassiveBuff(passiveBuffDataEntry, LanguageUtils.ItemOption2)
end

--- @return string
--- @param passiveBuffDataEntry PassiveBuffDataEntry
function LanguageUtils.LocalizeTalentBuff(passiveBuffDataEntry)
    return LanguageUtils.LocalizePassiveBuff(passiveBuffDataEntry, LanguageUtils.ItemOption3)
end

--- @return string
--- @param id number
function LanguageUtils.LocalizeDungeonPassiveBuffName(id)
    return LanguageUtils.Localize(tostring(id), "dungeon_passive_buff_name")
end

--- @return string
--- @param id number
function LanguageUtils.LocalizeDungeonActiveBuffName(id)
    return LanguageUtils.Localize(tostring(id), "dungeon_active_buff_name")
end

--- @return string
--- @param id number
function LanguageUtils.LocalizeSkinName(id)
    return LanguageUtils.Localize(tostring(id), "skin_name")
end

--- @return string
--- @param id number
function LanguageUtils.LocalizeIdleEffect(id)
    return LanguageUtils.Localize(tostring(id), "idle_effect")
end

--- @return string
--- @param id number
function LanguageUtils.LocalizeAvatarName(id)
    return LanguageUtils.Localize(string.format("avatar_%s", id), LanguageUtils.EnumType)
end

--- @return string
--- @param id number
function LanguageUtils.LocalizeAvatarFrameName(id)
    return LanguageUtils.Localize(string.format("avatar_frame_%s", id), LanguageUtils.EnumType)
end