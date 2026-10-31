require "lua.client.utils.LanguageUtils"

local LOCALIZATION = "csv/localization/%s/%s.csv"
local LOCALIZE_QUERY_CACHE = "csv/localization/query_cache.csv"
local LOCALIZE_SKILL_HERO_DICT = "csv/localization/skill_hero_dict.csv"

--- @class LanguageMgr
LanguageMgr = Class(LanguageMgr)

--- @return void
function LanguageMgr:Ctor()
    ---@type Dictionary
    self.languageDict = Dictionary()
    --- @type string
    self.currentPopup = nil
    ---@type Dictionary
    self.queryCacheDict = nil
    ---@type Dictionary
    self.skillHeroDict = nil

    self:DetectSystemLanguage()
end

function LanguageMgr:DetectSystemLanguage()
    if PlayerSettingData.language == nil or LanguageUtils.GetLanguageByType(PlayerSettingData.language) == nil then
        ---@type Language
        local language = LanguageUtils.GetLanguageByType(U_Application.systemLanguage:ToString())
        if language == nil then
            language = LanguageUtils.GetLanguageByType(U_SystemLanguage.English:ToString())
        end
        if language ~= nil then
            PlayerSettingData.language = language.keyLanguage
        else
            XDebug.Log(string.format("[LanguageMgr]Language is not exist: %s", U_SystemLanguage.English:ToString()))
        end
    end
end

--- @return void
function LanguageMgr:SwitchLanguage()
    self.languageDict:Clear()
    uiCanvas:SetLocalize()
end

--- @return string
--- @param key string
function LanguageMgr:GetDataQueryCache(key)
    if self.dataQueryCache == nil then
        self.dataQueryCache = Dictionary()
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(LOCALIZE_QUERY_CACHE)
        for i = 1, #parsedData do
            self.dataQueryCache:Add(parsedData[i].key, parsedData[i].value)
        end
    end
    return self.dataQueryCache:Get(key)
end

--- @return string
--- @param heroId number
--- @param skillId number
function LanguageMgr:GetKeySkillHero(heroId, skillId)
    if self.skillHeroDict == nil then
        self.skillHeroDict = Dictionary()
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(LOCALIZE_SKILL_HERO_DICT)
        for i = 1, #parsedData do
            self.skillHeroDict:Add(parsedData[i].key, parsedData[i].value)
        end
    end
    return self.skillHeroDict:Get(string.format("%s_%s", heroId, skillId))
end

--- @return string
--- @param key string
--- @param popup string
function LanguageMgr:Contain(key, popup)
    ---@type Dictionary
    local data = self.languageDict:Get(popup)
    if data == nil then
        data = self:LoadLocalize(popup)
    end
    return data:IsContainKey(key)
end

--- @return string
--- @param key string
--- @param popup string
function LanguageMgr:GetLocalize(key, popup)
    if popup ~= nil then
        self.currentPopup = popup
    end

    local value
    if self.currentPopup ~= nil then
        local data = self.languageDict:Get(self.currentPopup)
        if data == nil then
            data = self:LoadLocalize(self.currentPopup)
        end
        value = data:Get(key)
    end

    if value == nil then
        print(string.format("[LanguageMgr]nil_key: %s, popup: %s, language: %s", key, self.currentPopup, PlayerSettingData.language or "en"))
        value = string.format("%s(%s)", key, popup)
    end
    return value
end

--- @return Dictionary
--- @param popup string
function LanguageMgr:LoadLocalize(popup)
    local dict = Dictionary()
    ---@type Language
    local language = LanguageUtils.GetLanguageByType(PlayerSettingData.language)
    if language ~= nil then
        local path = string.format(LOCALIZATION, popup, language.code)
        local data = CsvReaderUtils.ReadAndParseLocalFile(path, "<>")
        if data ~= nil then
            for _, value in ipairs(data) do
                local key = value['key']
                local localize = value['value']
                if key ~= nil and localize ~= nil then
                    localize = string.gsub(localize, "\\n", "\n")
                    dict:Add(key, localize)
                end
            end
            self.languageDict:Add(popup, dict)
        else
            print(string.format("[LanguageMgr]nil_localize_%s", popup))
        end
    end
    return dict
end




