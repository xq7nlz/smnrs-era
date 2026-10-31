local HERO_IMPACT_CONFIG = "csv/client/hero_impact_config.csv"

--- @class HeroImpactConfig
HeroEffectImpactConfig = Class(HeroEffectImpactConfig)

local defaultSkinId = -1

function HeroEffectImpactConfig:Ctor()
    --- @type Dictionary
    self.impactDict = Dictionary()
    self:Init()
end

function HeroEffectImpactConfig:Init()
    local csvImpactConfig = CsvReaderUtils.ReadAndParseLocalFile(HERO_IMPACT_CONFIG)
    for i = 1, #csvImpactConfig do
        local heroId = tonumber(csvImpactConfig[i].hero_id)
        --- @type Dictionary
        local fxSkinDict = self.impactDict:Get(heroId)
        if fxSkinDict == nil then
            fxSkinDict = Dictionary()
            self.impactDict:Add(heroId, fxSkinDict)
        end
        local skinId = tonumber(csvImpactConfig[i].skin_id)
        if fxSkinDict:IsContainKey(skinId) then
            XDebug.Error(string.format("Already has hero impact %s by skin id %s", tostring(heroId), skinId))
        else
            fxSkinDict:Add(skinId, csvImpactConfig[i])
        end
    end
end

--- @param skinId number
function HeroEffectImpactConfig:Get(heroId, skinId)
    --- @type Dictionary
    local fxSkinDict = self.impactDict:Get(heroId)
    if fxSkinDict ~= nil then
        local data = fxSkinDict:Get(skinId)
        if data == nil then
            data = fxSkinDict:Get(defaultSkinId)
            if data == nil then
                XDebug.Error(string.format("heroId impact config nil: %s", tostring(heroId)))
            end
            return data
        else
            return data
        end
    end
end

--- @return table
--- @param heroId number
--- @param isBasicAttack boolean
--- @param skinId number
function HeroEffectImpactConfig:GetFx(heroId, isBasicAttack, skinId)
    local action = "skill"
    if isBasicAttack == true then
        action = "attack"
    end

    local heroImpact = self:Get(heroId, skinId)
    if heroImpact == nil then
        return
    end
    local skillImpactTable = {}
    local type = string.format("%s_impact_type", action)
    local name = string.format("%s_impact_name", action)
    if heroImpact[type] == "" or heroImpact[type] == nil or heroImpact[name] == "" or heroImpact[name] == nil then
        return nil
    end
    skillImpactTable.skill_impact_type = heroImpact[type]
    skillImpactTable.skill_impact_name = heroImpact[name]

    return skillImpactTable
end

return HeroEffectImpactConfig