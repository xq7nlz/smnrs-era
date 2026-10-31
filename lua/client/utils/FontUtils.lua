local Latin = "Latin"

local fontDict = {}

--- @return UnityEngine_Font
--- @param languageCode string
local GetFont = function(languageCode)
    local font = fontDict[languageCode]
    if font == nil then
        local resourceLoadPath = string.format("Fonts/Language/%s", string.lower(languageCode))
        font = ResourceLoadUtils.LoadObject(resourceLoadPath, ComponentName.UnityEngine_Font, true)
        if font == nil then
            font = fontDict[Latin]
        end
        fontDict[languageCode] = font
    end
    return font
end

fontDict[Latin] = GetFont(Latin)

local currentFont = Latin

--- @class FontUtils
FontUtils = {}

--- @param languageCode string
function FontUtils.RemoveFont(languageCode)
    fontDict[languageCode] = nil
end

--- @param languageCode string
function FontUtils.HasFont(languageCode)
    if FontUtils.IsSpecialFont(languageCode) and fontDict[languageCode] == nil then
        return false
    end
    return true
end

--- @param languageCode string
function FontUtils.IsSpecialFont(languageCode)
    return LanguageUtils.GetLanguageByType(languageCode).isSpecialFont
end

function FontUtils.GetFontByLanguage(languageCode)
    local font
    if FontUtils.IsSpecialFont(languageCode) then
        font = GetFont(languageCode)
        if font ~= nil then
            currentFont = languageCode
        end
    else
        if currentFont == Latin then
            return
        else
            font = GetFont(Latin)
            currentFont = Latin
        end
    end

    return font
end

--- @param transform UnityEngine_Transform
function FontUtils.SetNewFont(transform, languageCode)
    local font = FontUtils.GetFontByLanguage(languageCode)

    if font == nil then
        return
    end

    --XDebug.Log("Update font")
    local texts = transform:GetComponentsInChildren(ComponentName.UnityEngine_UI_Text, true)
    for i = 0, texts.Length - 1 do
        --- @type UnityEngine_UI_Text
        local text = texts[i]
        text.font = font
    end
end