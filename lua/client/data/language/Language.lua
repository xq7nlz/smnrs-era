--- @class Language
Language = Class(Language)

--- @return void
---@param code number
---@param name number
--- @param systemLanguage string
--- @param isSpecialFont boolean
function Language:Ctor(code, name, systemLanguage, isSpecialFont)
    ---@type LanguageCode
    self.code = code
    ---@type number
    self.name = name
    ---@type UnityEngine_SystemLanguage
    self.language = systemLanguage
    ---@type UnityEngine_SystemLanguage
    self.keyLanguage = self.language:ToString()
    --- @type boolean
    self.isSpecialFont = isSpecialFont
end