local HERO_SFX_IMPACT_CONFIG = "csv/client/hero_sfx_impact_config.csv"

--- @class HeroSfxImpactConfig
HeroSfxImpactConfig = Class(HeroSfxImpactConfig)

function HeroSfxImpactConfig:Ctor()
    --- @type Dictionary
    self.impactDict = nil
    self:Init()
end

function HeroSfxImpactConfig:Get(heroId)
    return self.impactDict:Get(heroId)
end

--- @return {sfx_impact_type, sfx_impact_name}
--- @param heroId number
--- @param skinName string
--- @param isBasicAttack boolean
function HeroSfxImpactConfig:GetSfx(heroId, skinName, isBasicAttack)
    local heroSfxImpactSkinDict = self:Get(heroId)
    if heroSfxImpactSkinDict == nil then
        return nil
    end

    local heroImpact = {}
    local heroSfxImpactConfig
    if heroSfxImpactSkinDict:IsContainKey(skinName) == true then
        heroSfxImpactConfig = heroSfxImpactSkinDict:Get(skinName)
    else
        heroSfxImpactConfig = heroSfxImpactSkinDict:Get(ClientConfigKey.DEFAULT_SPINE_ANIM)
    end
    local action = isBasicAttack and "atk" or "skill"
    local type = string.format("%s_sound_type", action)
    local name = string.format("sfx_%s_impact", action)
    heroImpact.sfx_impact_type = heroSfxImpactConfig[type]
    heroImpact.sfx_impact_name = heroSfxImpactConfig[name]
    if heroImpact.sfx_impact_type == nil or heroImpact.sfx_impact_type == "" or heroImpact.sfx_impact_name == nil or heroImpact.sfx_impact_name == "" then
        heroImpact = nil
    end
    return heroImpact
end

function HeroSfxImpactConfig:Init()
    local decodeData = CsvReaderUtils.ReadAndParseLocalFile(HERO_SFX_IMPACT_CONFIG)

    self.impactDict = Dictionary()
    for i = 1, #decodeData do
        local heroId = tonumber(decodeData[i].hero_id)
        local heroSkillDict = self.impactDict:Get(heroId)
        if heroSkillDict == nil then
            heroSkillDict = Dictionary()
            self.impactDict:Add(heroId, heroSkillDict)
        end

        local skinName = decodeData[i].skin_name
        if heroSkillDict:IsContainKey(skinName) then
            XDebug.Error(string.format("sfx config for hero [%d] skin [%s] is exist", heroId, skinName))
        else
            local tempTable = {}
            tempTable.atk_sound_type = decodeData[i].atk_sound_type
            tempTable.sfx_atk_impact = decodeData[i].sfx_atk_impact

            tempTable.skill_sound_type = decodeData[i].skill_sound_type
            tempTable.sfx_skill_impact = decodeData[i].sfx_skill_impact

            heroSkillDict:Add(skinName, tempTable)
        end
    end
end

return HeroSfxImpactConfig