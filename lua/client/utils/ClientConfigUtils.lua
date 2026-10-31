local base64 = require("lua.client.utils.base64.Base64Helper")

--- @class ClientConfigUtils
ClientConfigUtils = {}
ClientConfigUtils.USE_HERO_MENU_IDLE_EFFECT = true
ClientConfigUtils.MAX_HERO = 1000
ClientConfigUtils.FACTION_HERO_FRAGMENT_ID_DELTA = 100
ClientConfigUtils.FACTION_HERO_FRAGMENT_RED_BORDER_ID_DELTA = 1000
ClientConfigUtils.FACTION_TARGET_HERO_FRAGMENT_ID_DELTA = 1000000
ClientConfigUtils.MIN_RATIO = 4 / 3
ClientConfigUtils.MAX_RATIO = 21 / 9

ClientConfigUtils.DefaultCameraSize = 5.07
ClientConfigUtils.FixedResolution = 1920 / 1080

ClientConfigUtils.HEAD_ANCHOR = 0
ClientConfigUtils.BODY_ANCHOR = 1
ClientConfigUtils.FOOT_ANCHOR = 2
ClientConfigUtils.TORSO_ANCHOR = 3

ClientConfigUtils.DEFAULT_BATTLE_EFFECT_TYPE = 1
ClientConfigUtils.SPINE_BATTLE_EFFECT_TYPE = 2

ClientConfigUtils.NORMAL_COLOR = { r = 1, g = 1, b = 1, a = 1 }
ClientConfigUtils.NORMAL_PHARSE = 0
ClientConfigUtils.PETRIFY_COLOR = { r = 0.5, g = 0.5, b = 0.5, a = 1 }
ClientConfigUtils.PETRIFY_PHARSE = 0.8

ClientConfigUtils.EXECUTE_MOVE_TIME = 0.15
ClientConfigUtils.ORDER_MULTIPLIER = 100
ClientConfigUtils.FPS = 30

ClientConfigUtils.MAX_EFFECT_ICON_ON_STATUS_BAR = 5

ClientConfigUtils.OFFSET_ACCOST_X = 2.5
ClientConfigUtils.OFFSET_ACCOST_Y = 0.02

ClientConfigUtils.SHAKE_NORMAL = { 0.2, 0.08, 0.15, 20, 0 }
ClientConfigUtils.SHAKE_MEDIUM = { 0.4, 0.1, 0.3, 25, 0 }
ClientConfigUtils.SHAKE_HARD = { 0.7, 0.1, 0.7, 25, 0 }
ClientConfigUtils.SHAKE_SUPPER_HARD = { 1.5, 0.2, 1.5, 30, 0 }

ClientConfigUtils.DELAY_TEXT_LOG_FOLLOW = 0.4
ClientConfigUtils.OFFSET_TEXT_LOG_FOLLOW_Y = 0.4

ClientConfigUtils.PROJECTILE_FRY_TIME = 0.167

ClientConfigUtils.DEFAULT_ATTACK_PROJECTILE = "attack_projectile"
ClientConfigUtils.DEFAULT_SKILL_PROJECTILE = "skill_projectile"

ClientConfigUtils.SPINE_SHADER = "Spine/Skeleton"
ClientConfigUtils.GRAY_SHADER = "Spine/SkeletonGray"
ClientConfigUtils.SPINE_CUSTOM_SHADER = "Spine/Spine-Skeleton-Custom"
ClientConfigUtils.SPINE_TINT_BLACK_SHADER = "Spine/Skeleton Tint Black"

ClientConfigUtils.FIELD_FILL_PHASE_ID = U_Shader.PropertyToID("_FillPhase")
ClientConfigUtils.FIELD_FILL_MIX_ID = U_Shader.PropertyToID("_FillMix")
ClientConfigUtils.FIELD_MIX_TEX_ID = U_Shader.PropertyToID("_MixTex")
ClientConfigUtils.FIELD_COLOR_BLACK_ID = U_Shader.PropertyToID("_Black")

ClientConfigUtils._shaderDict = Dictionary()

ClientConfigUtils.EFFECT_IMPACT_MELEE = "impact_melee"
ClientConfigUtils.EFFECT_IMPACT_RANGE = "impact_range"

ClientConfigUtils.DEFAULT_COVER_ALPHA = 0.5

ClientConfigUtils.DEFAULT_LAYER_ID = 0
ClientConfigUtils.BACKGROUND_LAYER_ID = 1271136563
ClientConfigUtils.BATTLE_LAYER_ID = 2669120773
ClientConfigUtils.FRONT_BATTLE_LAYER_ID = 1100096913
ClientConfigUtils.EFFECT_LAYER_ID = 3946029577
ClientConfigUtils.BATTLE_UI_LAYER_ID = 640371485
ClientConfigUtils.UI_LAYER_ID = 4138256387

ClientConfigUtils.SUMMON_ARTIFACT_NUMBER = 50

ClientConfigUtils.FACTION_WATER = 1
ClientConfigUtils.FACTION_FIRE = 2
ClientConfigUtils.FACTION_ABYSS = 3
ClientConfigUtils.FACTION_NATURE = 4
ClientConfigUtils.FACTION_LIGHT = 5
ClientConfigUtils.FACTION_DARK = 6

--- @type Dictionary
ClientConfigUtils._clientHeroRequire = Dictionary()

--- @return string
--- @param data string
function ClientConfigUtils.GetGunzipString(data)
    local jsonDecode = base64:decode64(data)
    return GzipDepacker.Gunzip(jsonDecode)
end

--- @return number
---@param eventConfig EventHeroReleaseConfig
function ClientConfigUtils.GetFactionIdByEventHeroRelease(eventConfig)
    local eventNewHeroSummonConfig = eventConfig:GetSummonConfig()
    local heroId, _ = eventNewHeroSummonConfig:GetHeroIdAndStar()
    return ClientConfigUtils.GetFactionIdByHeroId(heroId)
end

--- @return number faction by id hero
--- @param heroId number
function ClientConfigUtils.GetFactionIdByHeroId(heroId)
    if heroId then
        if heroId < HeroConstants.FACTION_HERO_ID_DELTA then
            return heroId + 1
        end
        return MathUtils.Round(heroId / HeroConstants.FACTION_HERO_ID_DELTA)
    end

    XDebug.Error(string.format("HeroId is nil: GetFactionIdByHeroId: %s", tostring(heroId)))
    return 1
end
function ClientConfigUtils.GetTextOverviewOutlineColorByFaction(faction)
    if (faction == 4) then
        return U_Color(0.01568628, 0.2039216, 0.03921569, 0.5019608)
    elseif (faction == 3) then
        return U_Color(0.08235294, 0.1176471, 0.1764706, 0.5019608)
    elseif (faction == 5) then
        return U_Color(0.4156863, 0.09411766, 0.03529412, 0.5019608)
    elseif (faction == 6) then
        return U_Color(0.3411765, 0.1254902, 0.4196079, 0.5019608)
    elseif (faction == 1) then
        return U_Color(0.02745098, 0.09411765, 0.1960784, 1)
    else
        return U_Color(0.01568628, 0.2039216, 0.03921569, 0.5019608)
    end
end

function ClientConfigUtils.GetTextOverviewColorByFaction(faction)
    if (faction == 4) then
        return U_Color(0.5450981, 1, 0.2509804, 1)
    elseif (faction == 5) then
        return U_Color(1, 0.9294118, 0.5686275, 1)
    elseif (faction == 2) then
        return U_Color(1, 0.9294118, 0.5686275, 1)
    elseif (faction == 3) then
        return U_Color(0.7803922, 1, 0.9450981, 1)
    elseif (faction == 6) then
        return U_Color(0.9450981, 0.8784314, 0.9921569, 1)
    elseif (faction == 1) then
        return U_Color(0.6666667, 0.9764706, 0.9921569, 1)
    else
        return U_Color(1, 0.9294118, 0.5686275, 1)
    end
end
function ClientConfigUtils.GetBGColorByFaction(faction)
    -- bg text color new hero banner
    if (faction == 4) then
        return U_Color(0.1137255, 0.5333334, 0.3372549, 0.6784314)
    elseif (faction == 5) then
        return U_Color(0.9339623, 0.6290855, 0.2423016, 0.7137255)
    elseif (faction == 2) then
        return U_Color(0.9019608, 0.4431373, 0.2901961, 0.7137255)
    elseif (faction == 3) then
        return U_Color(0, 0, 0, 0)
    elseif (faction == 6) then
        return U_Color(0.4235294, 0.2392157, 0.6313726, 0.7137255)
    elseif (faction == 1) then
        return U_Color(0.05882353, 0.6156863, 0.9686275, 0.7137255)
    else
        return U_Color(0.9339623, 0.6290855, 0.2423016, 0.7137255)
    end
end

function ClientConfigUtils.GetColorGlowByFaction(faction)
    -- bg text color battle pass
    if (faction == 4) then
        return U_Color(0.1137255, 0.5333334, 0.3372549, 0.6784314)
    elseif (faction == 5) then
        return U_Color(0.9339623, 0.6290855, 0.2423016, 0.7137255)
    elseif (faction == 2) then
        return U_Color(0.9019608, 0.4431373, 0.2901961, 0.7137255)
    elseif (faction == 6) then
        return U_Color(0.4235294, 0.2392157, 0.6313726, 0.7137255)
    elseif (faction == 1) then
        return U_Color(0.05882353, 0.6156863, 0.9686275, 0.7137255)
    else
        return U_Color(0, 1, 211 / 255, 128 / 255)
    end
end

--- @return number id hero
--- @param skinId number
function ClientConfigUtils.GetHeroIdBySkinId(skinId)
    return math.floor(skinId / 1000)
end

--- @return number faction by id hero
--- @param heroId number
function ClientConfigUtils.GetFactionFragmentIdByHeroId(heroId)
    if heroId < HeroConstants.FACTION_HERO_ID_DELTA then
        if heroId > ClientConfigUtils.FACTION_HERO_FRAGMENT_RED_BORDER_ID_DELTA then
            return MathUtils.Round((heroId - ClientConfigUtils.FACTION_HERO_FRAGMENT_RED_BORDER_ID_DELTA)
                    / ClientConfigUtils.FACTION_HERO_FRAGMENT_ID_DELTA)
        end
        return MathUtils.Round(heroId / ClientConfigUtils.FACTION_HERO_FRAGMENT_ID_DELTA)
    else
        return MathUtils.Round(heroId / ClientConfigUtils.FACTION_TARGET_HERO_FRAGMENT_ID_DELTA)
    end
end

--- @return boolean
--- @param fragmentId number
function ClientConfigUtils.IsFragmentRedBorder(fragmentId)
    if fragmentId ~= nil then
        if fragmentId < HeroConstants.FACTION_HERO_ID_DELTA then
            if fragmentId > ClientConfigUtils.FACTION_HERO_FRAGMENT_RED_BORDER_ID_DELTA then
                return true
            end
        end
    end
    return false
end

function ClientConfigUtils.SetSprite(image, filePath)
    image.sprite = ResourceLoadUtils.LoadObject(filePath, ComponentName.UnityEngine_Sprite)
end

--- @return number faction by id hero
--- @param heroId number
function ClientConfigUtils.GetHeroIdByFragmentHeroId(heroId)
    if heroId < HeroConstants.FACTION_HERO_ID_DELTA then
        return nil
    else
        return math.floor(heroId / 100)
    end
end

--- @return number faction by id hero
--- @param heroId number
function ClientConfigUtils.GetHeroIdByHeroInventoryId(heroId, heroResource)
    ---@type HeroResource
    local heroResource = InventoryUtils.GetHeroResourceByInventoryId(heroId, heroResource)
    if heroResource ~= nil then
        return heroResource.heroId
    else
        return nil
    end
end

--- @return number, number, number
--- @param numberStar number
function ClientConfigUtils.GetInfoIconByHeroStar(numberStar)
    local starLevel = 1
    local starNumber = 1
    local frameLevel = 1
    local avatarLevel = 1
    if numberStar > HeroConstants.AWAKENING_STAR then
        starLevel = 2
        starNumber = numberStar - HeroConstants.AWAKENING_STAR
        if numberStar < HeroConstants.MAX_STAR then
            starNumber = 2
        else
            frameLevel = 2
            starNumber = 3
        end
    else
        starNumber = numberStar
    end

    return starLevel, starNumber, frameLevel, avatarLevel
end

--- @return void
--- @param image UnityEngine_UI_Image
function ClientConfigUtils.SetFillSizeImage(image, x, y)
    image:SetNativeSize()
    if x ~= nil and y ~= nil then
        local ratito = image.rectTransform.sizeDelta.x / image.rectTransform.sizeDelta.y
        if ratito > x / y then
            image.rectTransform.sizeDelta = U_Vector2(x, x / ratito)
        else
            image.rectTransform.sizeDelta = U_Vector2(y * ratito, y)
        end
    end
end

--- @return string
--- @param listStatBonus List
function ClientConfigUtils.SplitStat(listStatBonus)
    ---@type List
    local listBase = List()
    ---@type Dictionary
    local dictClass = Dictionary()
    ---@type Dictionary
    local dictFaction = Dictionary()
    ---@type Dictionary
    local dictClassFaction = Dictionary()
    ---@type Dictionary
    local dictHeroId = Dictionary()
    ---@param v StatChangerItemOption
    for _, v in pairs(listStatBonus:GetItems()) do
        if v.type == ItemOptionType.STAT_CHANGE then
            if v.affectedHeroId:Count() > 0 then
                for _, heroId in ipairs(v.affectedHeroId:GetItems()) do
                    local list
                    if dictHeroId:IsContainKey(heroId) then
                        list = dictHeroId:Get(heroId)
                    end
                    if list == nil then
                        list = List()
                        dictHeroId:Add(heroId, list)
                    end
                    list:Add(v)
                end
            else
                if v.affectedHeroClass:Count() > 0 then
                    for _, class in ipairs(v.affectedHeroClass:GetItems()) do
                        if v.affectedHeroFaction:Count() > 0 then
                            for _, faction in ipairs(v.affectedHeroFaction:GetItems()) do
                                local list
                                for i, vv in pairs(dictClassFaction:GetItems()) do
                                    if i.class == class and i.faction == faction then
                                        list = vv
                                        break
                                    end
                                end
                                if list == nil then
                                    list = List()
                                    dictClassFaction:Add({ ["class"] = class, ["faction"] = faction }, list)
                                end
                                list:Add(v)
                            end
                        else
                            local list
                            if dictClass:IsContainKey(class) then
                                list = dictClass:Get(class)
                            end
                            if list == nil then
                                list = List()
                                dictClass:Add(class, list)
                            end
                            list:Add(v)
                        end
                    end
                else
                    if v.affectedHeroFaction:Count() > 0 then
                        for _, faction in ipairs(v.affectedHeroFaction:GetItems()) do
                            local list
                            if dictFaction:IsContainKey(faction) then
                                list = dictFaction:Get(faction)
                            end
                            if list == nil then
                                list = List()
                                dictFaction:Add(faction, list)
                            end
                            list:Add(v)
                        end
                    else
                        listBase:Add(v)
                    end
                end
            end
        elseif v.type == ItemOptionType.DAMAGE_AGAINST then
            if v.itemBearerHeroId ~= nil then
                local list
                if dictHeroId:IsContainKey(v.itemBearerHeroId) then
                    list = dictHeroId:Get(v.itemBearerHeroId)
                end
                if list == nil then
                    list = List()
                    dictHeroId:Add(v.itemBearerHeroId, list)
                end
                list:Add(v)
            else
                listBase:Add(v)
            end
        elseif v.type == ItemOptionType.REDUCE_DAMAGE_TAKEN then
            if v.itemBearerHeroId ~= nil then
                local list
                if dictHeroId:IsContainKey(v.itemBearerHeroId) then
                    list = dictHeroId:Get(v.itemBearerHeroId)
                end
                if list == nil then
                    list = List()
                    dictHeroId:Add(v.itemBearerHeroId, list)
                end
                list:Add(v)
            else
                listBase:Add(v)
            end
        else
            listBase:Add(v)
        end
    end
    --XDebug.Log("listBase" .. LogUtils.ToDetail(listBase:GetItems()))
    --XDebug.Log("dictClass" .. LogUtils.ToDetail(dictClass:GetItems()))
    --XDebug.Log("dictFaction" .. LogUtils.ToDetail(dictFaction:GetItems()))
    --XDebug.Log("dictClassFaction" .. LogUtils.ToDetail(dictClassFaction:GetItems()))
    return listBase, dictClass, dictFaction, dictClassFaction, dictHeroId
end

--- @return void
---@param dict Dictionary
---@param statType StatType
---@param value number
function ClientConfigUtils._AddStatToDict(dict, statType, value)
    --if dict:IsContainKey(statType) then
    --    dict:Add(statType, dict:Get(statType) + value)
    --else
    --    dict:Add(statType, value)
    --end
    local listValue
    if dict:IsContainKey(statType) then
        listValue = dict:Get(statType)
    else
        listValue = List()
        dict:Add(statType, listValue)
    end
    listValue:Add(value)
end

--- @return void
---@param dict Dictionary
---@param statType StatType
---@param value number
function ClientConfigUtils._MultiplyStatToDict(dict, statType, value)
    local listValue
    if dict:IsContainKey(statType) then
        listValue = dict:Get(statType)
    else
        listValue = List()
        dict:Add(statType, listValue)
    end
    listValue:Add(value)
end

--- @return void
---@param calculationTypeAdd Dictionary
---@param calculationTypePercent Dictionary
---@param calculationTypePercentMultiply Dictionary
---@param bonus StatBonus
function ClientConfigUtils._AddStatBonusToDict(calculationTypeAdd, calculationTypePercent, calculationTypePercentMultiply, bonus)
    local calculationType = bonus.calculationType
    if calculationType <= 0 then
        calculationType = StatChangerCalculationType.PERCENT_ADD
    end
    if calculationType == StatChangerCalculationType.RAW_ADD_BASE then
        ClientConfigUtils._AddStatToDict(calculationTypeAdd, bonus.statType, bonus.amount)
    elseif calculationType == StatChangerCalculationType.PERCENT_MULTIPLY then
        ClientConfigUtils._AddStatToDict(calculationTypePercentMultiply, bonus.statType, bonus.amount)
    elseif calculationType == StatChangerCalculationType.PERCENT_ADD then
        ClientConfigUtils._AddStatToDict(calculationTypePercent, bonus.statType, bonus.amount)
    end
end

--- @return void
---@param calculationTypeAdd Dictionary
---@param calculationTypePercent Dictionary
---@param calculationTypePercentMultiply Dictionary
---@param option BaseItemOption
function ClientConfigUtils._AddStatOptionToDict(calculationTypeAdd, calculationTypePercent, calculationTypePercentMultiply, option, factionCheck, classCheck, heroCheck)
    if option.type == ItemOptionType.STAT_CHANGE then
        --- @type StatChangerItemOption
        local changeOption = option
        if (changeOption.affectedHeroFaction:Count() == 0 or changeOption.affectedHeroFaction:IsContainValue(factionCheck)) and
                (changeOption.affectedHeroClass:Count() == 0 or changeOption.affectedHeroClass:IsContainValue(classCheck)) and
                (changeOption.affectedHeroId:Count() == 0 or changeOption.affectedHeroId:IsContainValue(heroCheck)) then
            if changeOption.calculationType == StatChangerCalculationType.RAW_ADD_BASE then
                ClientConfigUtils._AddStatToDict(calculationTypeAdd, changeOption.statType, changeOption.amount)
            elseif changeOption.calculationType == StatChangerCalculationType.PERCENT_MULTIPLY then
                ClientConfigUtils._AddStatToDict(calculationTypePercentMultiply, changeOption.statType, changeOption.amount)
            elseif changeOption.calculationType == StatChangerCalculationType.PERCENT_ADD then
                ClientConfigUtils._AddStatToDict(calculationTypePercent, changeOption.statType, changeOption.amount)
            end
        end
        --XDebug.Log(string.format("calculationType %s, stat %s, amount %s, class: %s, faction: %s", calculationType, stat, amount, faction, class))
    elseif option.type == ItemOptionType.DAMAGE_AGAINST or option.type == ItemOptionType.REDUCE_DAMAGE_TAKEN or option.type == ItemOptionType.ITEM_PASSIVE then

    else
        XDebug.Warning("Don't support option type: " .. tostring(option.type))
    end
end

--- @return void
---@param calculationTypeAdd Dictionary
---@param calculationTypePercent Dictionary
---@param calculationTypePercentMultiply Dictionary
---@param listBonus List
function ClientConfigUtils._AddStatListBonusToDict(calculationTypeAdd, calculationTypePercent, calculationTypePercentMultiply, listBonus)
    ---@param v StatBonus
    for _, v in pairs(listBonus:GetItems()) do
        ClientConfigUtils._AddStatBonusToDict(calculationTypeAdd, calculationTypePercent, calculationTypePercentMultiply, v)
    end
end

--- @return void
---@param calculationTypeAdd Dictionary
---@param calculationTypePercent Dictionary
---@param calculationTypePercentMultiply Dictionary
---@param listOption List
function ClientConfigUtils._AddStatListOptionToDict(calculationTypeAdd, calculationTypePercent, calculationTypePercentMultiply, listOption, faction, class, hero)
    ---@param v BaseItemOption
    for _, v in pairs(listOption:GetItems()) do
        ClientConfigUtils._AddStatOptionToDict(calculationTypeAdd, calculationTypePercent, calculationTypePercentMultiply, v, faction, class, hero)
    end
end

--- @return Dictionary
---@param heroDataEntry HeroDataEntry
---@param heroStar number
---@param heroLevel number
function ClientConfigUtils._GetBaseStatDictByLevel(heroDataEntry, heroStar, heroLevel)
    local getStat = function(statName)
        --- @type HeroData
        local baseStat = heroDataEntry:GetBaseStats(heroStar)
        local stat = baseStat[statName]
        ---@type HeroLevelCapConfig
        local lastLevelCap = nil
        for i = 1, heroStar do
            if lastLevelCap == nil or heroLevel > lastLevelCap.levelCap then
                ---@type HeroLevelCapConfig
                local heroLevelCap = ResourceMgr.GetHeroMenuConfig():GetHeroLevelCapDictionary(i)
                --- @type HeroData
                local baseStatStar = heroDataEntry.levelStats:Get(i)
                local lastLevel = 0
                if lastLevelCap ~= nil then
                    lastLevel = lastLevelCap.levelCap
                end
                stat = stat + baseStatStar[statName] * math.min(heroLevelCap.levelCap - lastLevel, heroLevel - lastLevel)
                lastLevelCap = heroLevelCap
            else
                break
            end
        end
        if lastLevelCap ~= nil and heroLevel > lastLevelCap.levelCap then
            --- @type HeroData
            local baseStatStar = heroDataEntry.levelStats:Get(lastLevelCap.star)
            stat = stat + baseStatStar[statName] * (heroLevel - lastLevelCap.levelCap)
        end
        return stat
    end
    ---@type Dictionary
    local data = Dictionary()
    data:Add(StatType.ATTACK, getStat("attack"))
    data:Add(StatType.DEFENSE, getStat("defense"))
    data:Add(StatType.HP, getStat("hp"))
    data:Add(StatType.SPEED, getStat("speed"))
    data:Add(StatType.CRIT_RATE, getStat("critRate"))
    data:Add(StatType.CRIT_DAMAGE, getStat("critDamage"))
    data:Add(StatType.ACCURACY, getStat("accuracy"))
    data:Add(StatType.DODGE, getStat("dodge"))
    data:Add(StatType.PURE_DAMAGE, getStat("pureDamage"))
    data:Add(StatType.SKILL_DAMAGE, getStat("skillDamage"))
    data:Add(StatType.ARMOR_BREAK, getStat("armorBreak"))
    data:Add(StatType.CC_RESISTANCE, getStat("ccResistance"))
    data:Add(StatType.DAMAGE_REDUCTION, getStat("damageReduction"))
    data:Add(StatType.REDUCE_DAMAGE_REDUCTION, getStat("reduceDamageReduction"))
    --XDebug.Log("BaseStatHero" .. LogUtils.ToDetail(data:GetItems()))
    return data
end

--- @return Dictionary
---@param baseStat HeroData
---@param levelStat6 HeroData
---@param levelStat12 HeroData
---@param heroLevel number
function ClientConfigUtils._GetBaseStatDict(baseStat, levelStat6, levelStat12, heroLevel)
    ---@type HeroLevelCapConfig
    local heroLevelCap = ResourceMgr.GetHeroMenuConfig():GetHeroLevelCapDictionary(6)
    local level1 = math.min(heroLevel, heroLevelCap.levelCap)
    local level2 = math.max(heroLevel - heroLevelCap.levelCap, 0)
    ---@type Dictionary
    local data = Dictionary()
    data:Add(StatType.ATTACK, baseStat.attack + level1 * levelStat6.attack + level2 * levelStat12.attack)
    data:Add(StatType.DEFENSE, baseStat.defense + level1 * levelStat6.defense + level2 * levelStat12.defense)
    data:Add(StatType.HP, baseStat.hp + level1 * levelStat6.hp + level2 * levelStat12.hp)
    data:Add(StatType.SPEED, baseStat.speed + level1 * levelStat6.speed + level2 * levelStat12.speed)
    data:Add(StatType.CRIT_RATE, baseStat.critRate + level1 * levelStat6.critRate + level2 * levelStat12.critRate)
    data:Add(StatType.CRIT_DAMAGE, baseStat.critDamage + level1 * levelStat6.critDamage + level2 * levelStat12.critDamage)
    data:Add(StatType.ACCURACY, baseStat.accuracy + level1 * levelStat6.accuracy + level2 * levelStat12.accuracy)
    data:Add(StatType.DODGE, baseStat.dodge + level1 * levelStat6.dodge + level2 * levelStat12.dodge)
    data:Add(StatType.PURE_DAMAGE, baseStat.pureDamage + level1 * levelStat6.pureDamage + level2 * levelStat12.pureDamage)
    data:Add(StatType.SKILL_DAMAGE, baseStat.skillDamage + level1 * levelStat6.skillDamage + level2 * levelStat12.skillDamage)
    data:Add(StatType.ARMOR_BREAK, baseStat.armorBreak + level1 * levelStat6.armorBreak + level2 * levelStat12.armorBreak)
    data:Add(StatType.CC_RESISTANCE, baseStat.ccResistance + level1 * levelStat6.ccResistance + level2 * levelStat12.ccResistance)
    data:Add(StatType.DAMAGE_REDUCTION, baseStat.damageReduction + level1 * levelStat6.damageReduction + level2 * levelStat12.damageReduction)
    --XDebug.Log("BaseStatHero" .. LogUtils.ToDetail(data:GetItems()))
    return data
end

--- @return void
---@param data Dictionary
function ClientConfigUtils._CalculationPowerStat(data)
    data:Add(StatType.POWER, data:Get(StatType.ATTACK) * (1 + data:Get(StatType.CRIT_RATE) * data:Get(StatType.CRIT_DAMAGE)
            + data:Get(StatType.ARMOR_BREAK) * 0.2 + data:Get(StatType.PURE_DAMAGE) + data:Get(StatType.SKILL_DAMAGE) * 0.35)
            + data:Get(StatType.DEFENSE) * 5 + data:Get(StatType.HP) * (0.2 + data:Get(StatType.DAMAGE_REDUCTION))
            + data:Get(StatType.SPEED) * 3 + data:Get(StatType.ACCURACY) * 0.1 + data:Get(StatType.DODGE) * 0.12)
end

--- @return void
---@param data Dictionary
---@param calculationTypeAdd Dictionary
---@param calculationTypePercent Dictionary
---@param calculationTypePercentMultiply Dictionary
function ClientConfigUtils._CalculationFinalStat(data, calculationTypeAdd, calculationTypePercent, calculationTypePercentMultiply)
    ---@param statType StatType
    for statType, amount in pairs(data:GetItems()) do
        local add = 0
        if calculationTypeAdd:IsContainKey(statType) then
            for _, v in pairs(calculationTypeAdd:Get(statType):GetItems()) do
                add = add + v
            end
        end
        local percent = 0
        if calculationTypePercent:IsContainKey(statType) then
            for _, v in pairs(calculationTypePercent:Get(statType):GetItems()) do
                percent = percent + v
            end
        end
        local percentMultiply = 0
        if ClientConfigUtils.GetStatValueTypeByStatType(statType) == StatValueType.RAW then
            percentMultiply = 1
            if calculationTypePercentMultiply:IsContainKey(statType) then
                for _, v in pairs(calculationTypePercentMultiply:Get(statType):GetItems()) do
                    percentMultiply = percentMultiply * (1 + v)
                end
            end
        else
            if calculationTypePercentMultiply:IsContainKey(statType) then
                for _, v in pairs(calculationTypePercentMultiply:Get(statType):GetItems()) do
                    percentMultiply = percentMultiply + v
                end
            end
        end
        local finalStat = 0
        if ClientConfigUtils.GetStatValueTypeByStatType(statType) == StatValueType.RAW then
            finalStat = (amount + add) * (1 + percent) * percentMultiply
            --XDebug.Log(string.format("Type %s, add %s, 1+percent %s, percentMultiply %s", statType, (amount + add) , (1 + percent) , percentMultiply))
        else
            finalStat = (amount + add) + (percent) + (percentMultiply)
            --XDebug.Log(string.format("Type %s, add %s, percent %s, percentMultiply %s", statType, (amount + add) , (percent) , percentMultiply))
        end
        data:Add(statType, finalStat)
    end

    --POWER
    ClientConfigUtils._CalculationPowerStat(data)
end

--- @return Dictionary
function ClientConfigUtils.GetBaseStatHero(heroId, heroStar, heroLevel)
    return ClientConfigUtils._GetBaseStatDictByLevel(ResourceMgr.GetServiceConfig():GetHeroes():GetHeroDataEntry(heroId), heroStar, heroLevel)
end

--- @return Dictionary
--- @param heroResource HeroResource
---@param linkingId number
---@param companionId number
---@param buffAtk number
---@param buffHp number
---@param mastery Dictionary
---@param listBonusBySkillPassiveSummoner List
function ClientConfigUtils.GetStatHero(heroResource, mastery, linkingId, companionId, buffAtk, buffHp, listBonusBySkillPassiveSummoner)
    ---@type Dictionary
    local data
    ---@type Dictionary
    local calculationTypeAdd = Dictionary()
    ---@type Dictionary
    local calculationTypePercent = Dictionary()
    ---@type Dictionary
    local calculationTypePercentMultiply = Dictionary()
    local faction = ClientConfigUtils.GetFactionIdByHeroId(heroResource.heroId)
    local class = ResourceMgr.GetHeroClassConfig():GetClass(heroResource.heroId)
    local hero = heroResource.heroId

    --BASE STAT
    data = ClientConfigUtils.GetBaseStatHero(heroResource.heroId, heroResource.heroStar, heroResource.heroLevel)

    if heroResource.inventoryId ~= nil then
        --EQUIPMENT
        ---@type Dictionary
        local setEquipDict = Dictionary()
        for slot, itemId in pairs(heroResource.heroItem:GetItems()) do
            ---@type ResourceType
            local type
            if slot == HeroItemSlot.ARTIFACT then
                type = ResourceType.ItemArtifact
            elseif slot == HeroItemSlot.STONE then
                type = ResourceType.ItemStone
            elseif slot == HeroItemSlot.SKIN then
                type = ResourceType.Skin
            elseif slot == HeroItemSlot.TALENT_1
                    or slot == HeroItemSlot.TALENT_2
                    or slot == HeroItemSlot.TALENT_3 then
                type = ResourceType.Talent
            else
                type = ResourceType.ItemEquip
            end
            ---@type EquipmentDataEntry
            local itemData = ResourceMgr.GetServiceConfig():GetItemData(type, itemId)
            if itemData ~= nil then
                ClientConfigUtils._AddStatListOptionToDict(calculationTypeAdd, calculationTypePercent, calculationTypePercentMultiply, itemData.optionList, faction, class, hero)
                if type == ResourceType.ItemEquip then
                    if setEquipDict:IsContainKey(itemData.setId) then
                        setEquipDict:Add(itemData.setId, setEquipDict:Get(itemData.setId) + 1)
                    else
                        setEquipDict:Add(itemData.setId, 1)
                    end
                end
            end
        end
        --- SET EQUIPMENT
        for setId, number in pairs(setEquipDict:GetItems()) do
            if number > 1 then
                ---@type EquipmentSetDataEntry
                local setData = ResourceMgr.GetServiceConfig():GetItems():GetEquipmentSetData(setId)
                if setData ~= nil then
                    ---@param v List<BaseItemOption>
                    for i, v in pairs(setData.optionDict:GetItems()) do
                        if i <= number then
                            ClientConfigUtils._AddStatListOptionToDict(calculationTypeAdd, calculationTypePercent, calculationTypePercentMultiply, v, faction, class)
                        end
                    end
                else
                    --XDebug.Error(string.format("Nil set equipment %s", setId))
                end
            end
        end

        --MASTERY
        if mastery ~= nil then
            local heroClass = ResourceMgr.GetHeroClassConfig():GetClass(heroResource.heroId)
            if mastery:IsContainKey(heroClass) then
                ---@type Dictionary
                local skillMasteryDict = ResourceMgr.GetMasteryConfig():GetSkillMasteryDictionary(heroClass)
                ---@type List
                local listMastery = mastery:Get(heroClass)
                ---@param skillMastery SkillMasteryConfig
                for slot, skillMastery in pairs(skillMasteryDict:GetItems()) do
                    local level = 0
                    if listMastery:Count() >= slot then
                        level = listMastery:Get(slot)
                    end
                    if level > 0 then
                        local listStat = skillMastery.dicLevelStat:Get(level)
                        ClientConfigUtils._AddStatListBonusToDict(calculationTypeAdd, calculationTypePercent, calculationTypePercentMultiply, listStat)
                        --logBonus("BonusMastery", listStat)
                    end
                end
            end
        end

        --SKILL SUMMONER
        if listBonusBySkillPassiveSummoner ~= nil then
            ClientConfigUtils._AddStatListBonusToDict(calculationTypeAdd, calculationTypePercent, calculationTypePercentMultiply, listBonusBySkillPassiveSummoner)
            --logBonus("BonusSkillSummoner", listBonusBySkillPassiveSummoner)
        end

        --LINKING    chỗ nào có tính mastery mới tính linking
        if mastery ~= nil then
            ---@type HeroLinkingInBound
            local heroLinkingInBound = zg.playerData:GetMethod(PlayerDataMethod.HERO_LINKING)
            if heroLinkingInBound ~= nil then
                ClientConfigUtils._AddStatListBonusToDict(calculationTypeAdd, calculationTypePercent, calculationTypePercentMultiply, heroLinkingInBound:GetListBonusLinkingByHeroId(heroResource.heroId))
            end
        end
    end

    --SKILL
    local skillPassiveList = ResourceMgr.GetHeroesConfig():GetHeroSkillPassive():Get(heroResource.heroId)
    if skillPassiveList ~= nil then
        local heroDataService = ResourceMgr.GetServiceConfig():GetHeroes()
        local heroSkillLevel = heroDataService:GetHeroSkillLevelData(heroResource.heroStar)
        if heroSkillLevel ~= nil then
            ---@type HeroDataEntry
            local heroDataEntry = heroDataService:GetHeroDataEntry(heroResource.heroId)
            if heroDataEntry == nil then
                XDebug.Error("heroDataEntry == nil   id:" .. heroResource.heroId)
            end

            for _, skillId in pairs(skillPassiveList:GetItems()) do
                ---@type HeroSkillDataCollection
                local skillDataCollection = heroDataEntry.allSkillDataDict:Get(skillId)
                local lvSkill = heroSkillLevel.skillLevels:Get(skillId)
                if lvSkill > 0 then
                    ---@type BaseSkillData
                    local skillData = skillDataCollection.skillLevels:Get(lvSkill)
                    if skillData ~= nil then
                        ClientConfigUtils._AddStatListBonusToDict(calculationTypeAdd, calculationTypePercent, calculationTypePercentMultiply, skillData.bonuses)
                    else
                        XDebug.Error(string.format("nil hero %s, skill %s, level %s", heroResource.heroId, skillId, lvSkill))
                    end
                end
            end
        end
    else
        --XDebug.Error("Not skill buff" .. heroResource.heroId)
    end

    --LINKING
    if linkingId ~= nil and linkingId > 0 then
        ---@type BaseLinking
        local linking = ResourceMgr.GetServiceConfig():GetHeroes():GetHeroLinkingEntries():Get(linkingId)
        if linking ~= nil then
            ClientConfigUtils._AddStatListBonusToDict(calculationTypeAdd, calculationTypePercent, calculationTypePercentMultiply, linking.bonuses)
            --logBonus("BonusLinking", linking.bonuses)
        else
            XDebug.Error("NIL LINKING ID" .. linkingId)
        end
    end

    --COMPANION
    if companionId ~= nil and companionId > 0 then
        ---@type HeroCompanionBuffData
        local companion = ResourceMgr.GetServiceConfig():GetHeroes().heroCompanionBuffEntries:Get(companionId)
        ClientConfigUtils._AddStatListBonusToDict(calculationTypeAdd, calculationTypePercent, calculationTypePercentMultiply, companion.bonuses)
        --logBonus("BonusCompanion", companion.bonuses)
    end

    --BUFF FORMATION
    if buffAtk ~= nil then
        ClientConfigUtils._AddStatToDict(calculationTypePercent, StatType.ATTACK, buffAtk)
        --XDebug.Log("buffAtk" .. buffAtk)
    end
    if buffHp ~= nil then
        ClientConfigUtils._AddStatToDict(calculationTypePercent, StatType.HP, buffHp)
        --XDebug.Log("buffHp" .. buffHp)
    end

    --XDebug.Log("calculationTypeAdd" .. LogUtils.ToDetail(calculationTypeAdd:GetItems()))
    --XDebug.Log("calculationTypePercent" .. LogUtils.ToDetail(calculationTypePercent:GetItems()))
    --XDebug.Log("calculationTypePercentMultiply" .. LogUtils.ToDetail(calculationTypePercentMultiply:GetItems()))
    --Final calculation
    ClientConfigUtils._CalculationFinalStat(data, calculationTypeAdd, calculationTypePercent, calculationTypePercentMultiply)

    --XDebug.Log("FinalStatHero" .. LogUtils.ToDetail(data:GetItems()))
    return data
end

--- @return Dictionary
---@param summonerId number
---@param star number
---@param level number
function ClientConfigUtils.GetStatSummoner(summonerId, star, level)
    return ClientConfigUtils._GetBaseStatDictByLevel(ResourceMgr.GetServiceConfig():GetHeroes():GetSummonerDataEntry(summonerId), star, level)
end

--- @return Dictionary
function ClientConfigUtils.GetStatSummonerPlayer()
    return ClientConfigUtils.GetStatSummoner(zg.playerData:GetMethod(PlayerDataMethod.SUMMONER).summonerId,
            zg.playerData:GetMethod(PlayerDataMethod.SUMMONER).star,
            zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).level)
end

--- @return number
--- @param heroList List
function ClientConfigUtils.GetCompanionId(heroList)
    local heroPerFactions = Dictionary()
    for _, v in pairs(heroList:GetItems()) do
        local faction = ClientConfigUtils.GetFactionIdByHeroId(v)
        if heroPerFactions:IsContainKey(faction) then
            local number = heroPerFactions:Get(faction)
            heroPerFactions:Add(faction, number + 1)
        else
            heroPerFactions:Add(faction, 1)
        end
    end
    local buff = ResourceMgr.GetServiceConfig():GetHeroes():GetBestMatchCompanionBuff(heroPerFactions)
    if buff ~= nil then
        return buff.id
    else
        return 0
    end
end

--- @return number
--- @param battleTeam BattleTeamInfo
function ClientConfigUtils.GetCompanionIdByBattleTeamInfo(battleTeam)
    local heroList = List()
    ---@param v HeroBattleInfo
    for _, v in pairs(battleTeam.listHeroInfo:GetItems()) do
        heroList:Add(v.heroId)
    end
    return ClientConfigUtils.GetCompanionId(heroList)
end

--- @return number
--- @param teamFormation TeamFormationInBound
function ClientConfigUtils.GetCompanionIdBuyTeamFormation(teamFormation)
    local heroList = List()
    ---@param v HeroFormationInBound
    local addHero = function(v)
        local heroId = ClientConfigUtils.GetHeroIdByHeroInventoryId(v.heroInventoryId)
        if heroId ~= nil then
            heroList:Add(heroId)
        end
    end
    ---@param v HeroFormationInBound
    for _, v in pairs(teamFormation.backLine:GetItems()) do
        addHero(v)
    end
    ---@param v HeroFormationInBound
    for _, v in pairs(teamFormation.frontLine:GetItems()) do
        addHero(v)
    end
    if teamFormation.defenseFormation ~= nil then
        for i, v in pairs(teamFormation.defenseFormation.dictHeroSlot:GetItems()) do
            if v > 0 then
                heroList:Add(v)
            end
        end
    end
    return ClientConfigUtils.GetCompanionId(heroList)
end

--- @return number
--- @param teamFormation TeamFormationInBound
function ClientConfigUtils.GetCompanionIdBuyTeamFormationWithHeroResource(teamFormation, heroResource)
    local heroList = List()
    ---@param v HeroFormationInBound
    local addHero = function(v)
        local heroId = ClientConfigUtils.GetHeroIdByHeroInventoryId(v.heroInventoryId, heroResource)
        if heroId ~= nil then
            heroList:Add(heroId)
        end
    end
    ---@param v HeroFormationInBound
    for _, v in pairs(teamFormation.backLine:GetItems()) do
        addHero(v)
    end
    ---@param v HeroFormationInBound
    for _, v in pairs(teamFormation.frontLine:GetItems()) do
        addHero(v)
    end
    if teamFormation.defenseFormation ~= nil then
        for i, v in pairs(teamFormation.defenseFormation.dictHeroSlot:GetItems()) do
            if v > 0 then
                heroList:Add(v)
            end
        end
    end
    return ClientConfigUtils.GetCompanionId(heroList)
end

--- @return number
--- @param star number
function ClientConfigUtils.GetTierIdSummonerByStar(star)
    if star == 3 then
        return 0
    elseif star <= HeroConstants.SUMMONER_SKILL_TIER_1 then
        return 1
    elseif star <= HeroConstants.SUMMONER_SKILL_TIER_2 then
        return 2
    else
        return 3
    end
end

--- @return number
--- @param star number
function ClientConfigUtils.GetUILevelSkillSummonerByStar(star)
    local baseLevel
    if star == 3 then
        self.tier = 0
        baseLevel = 3
    elseif star <= HeroConstants.SUMMONER_SKILL_TIER_1 then
        self.tier = 1
        baseLevel = 3
    elseif star <= HeroConstants.SUMMONER_SKILL_TIER_2 then
        self.tier = 2
        baseLevel = HeroConstants.SUMMONER_SKILL_TIER_1
    else
        self.tier = 3
        baseLevel = HeroConstants.SUMMONER_SKILL_TIER_2
    end
    return star - baseLevel
end

--- @return List
--- @param heroList List
function ClientConfigUtils.GetListLinkingByListHeroId(heroList)
    local listLinking = List()
    -----@param linking BaseLinking
    --for i, linking in pairs(ResourceMgr.GetServiceConfig():GetHeroes().heroLinkingEntries:GetItems()) do
    --    local count = 0
    --    for _, heroId in pairs(linking.affectedHero:GetItems()) do
    --        if heroList:IsContainValue(heroId) then
    --            count = count + 1
    --        end
    --    end
    --    if count >= linking.affectedHero:Count() then
    --        listLinking:Add(i)
    --    end
    --end
    return listLinking
end

--- @return List
--- @param heroList List
function ClientConfigUtils.GetListLinkingByListHeroResource(heroList)
    ---@type List
    local listHeroId = List()
    ---@param heroResource HeroResource
    for _, heroResource in pairs(heroList:GetItems()) do
        listHeroId:Add(heroResource.heroId)
    end
    return ClientConfigUtils.GetListLinkingByListHeroId(listHeroId)
end

--- @return List
--- @param elo Number
function ClientConfigUtils.GetRankingTypeByElo(elo, featureType)
    return ResourceMgr.GetArenaRewardRankingConfig():GetRankingTypeByElo(elo, featureType)
end

--- @return number
--- @param battleTeamInfo BattleTeamInfo
--- @param isDetail boolean
function ClientConfigUtils.GetPowerByBattleTeamInfo(battleTeamInfo, isDetail)
    zg.battleMgr:RequireBattleTeam(battleTeamInfo)
    local teamPowerCalculator = TeamPowerCalculator()
    teamPowerCalculator:SetTeamInfo(battleTeamInfo)
    local power = 0
    if isDetail == true then
        power = teamPowerCalculator:CalculatePowerDetail(ResourceMgr.GetServiceConfig():GetBattle(),
                ResourceMgr.GetServiceConfig():GetHeroes(), battleTeamInfo.teamId)
    else
        power = math.floor(teamPowerCalculator:CalculatePower(ResourceMgr.GetServiceConfig():GetBattle()), battleTeamInfo.teamId)
    end
    return power
end

--- @return number, number
--- @param formationId number
function ClientConfigUtils.GetFormationBuff(formationId)
    --- @type HeroDataService
    local heroDataService = ResourceMgr.GetServiceConfig():GetBattle():GetHeroDataService()
    --- @type FormationData
    local formationData = heroDataService.formationDataEntries:Get(formationId)
    --- @type FormationBuffData
    local frontFormationBuffData = heroDataService.formationFrontLineBuffDataEntries:Get(formationId)
    --- @type StatBonus
    local frontBonusStat = frontFormationBuffData.bonuses:Get(1)
    --- @type FormationBuffData
    local backFormationBuffData = heroDataService.formationBackLineBuffDataEntries:Get(formationId)
    --- @type StatBonus
    local backBonusStat = backFormationBuffData.bonuses:Get(1)
    return frontBonusStat.amount / formationData.frontLine,
    backBonusStat.amount / formationData.backLine
end

--- @return StatValueType
--- @param statType StatType
function ClientConfigUtils.GetStatValueTypeByStatType(statType)
    if statType == StatType.ATTACK or statType == StatType.DEFENSE or statType == StatType.HP or statType == StatType.ACCURACY
            or statType == StatType.DODGE or statType == StatType.POWER or statType == StatType.SPEED then
        return StatValueType.RAW
    else
        return StatValueType.PERCENT
    end
end

--- @return string
--- @param statDict Dictionary
--- @param statType StatType
function ClientConfigUtils.GetValueStringStat(statDict, statType)
    if ClientConfigUtils.GetStatValueTypeByStatType(statType) == StatValueType.PERCENT then
        --return tostring(MathUtils.Round(statDict:Get(statType) * 100)) .. "%"
        return tostring(MathUtils.RoundDecimal(statDict:Get(statType) * 100, 1)) .. "%"
    else
        return tostring(MathUtils.Round(statDict:Get(statType)))
    end
end

--- @return void
function ClientConfigUtils.CheckMoneyNotification(...)
    local args = { ... }
    assert(#args % 2 == 0)
    local listEnough = List()
    for i = 1, #args / 2 do
        if InventoryUtils.GetMoney(args[i]) < args[i + 1] then
            listEnough:Add(args[i])
        end
    end
    local count = listEnough:Count()
    if count == 1 then
        SmartPoolUtils.NotiLackResource(listEnough:Get(1))
    elseif count > 1 then
        SmartPoolUtils.NotiLackResource()
    end
    return count == 0
end

--- @return number
--- @param id number
function ClientConfigUtils.GetHeroFragmentStar(id)
    return id % 100
end

--- @return number
--- @param id number
function ClientConfigUtils.GetHeroFragmentIdByHeroId(heroId)
    return string.format("%s%s", heroId, "05")
end

--- @return number
--- @param id number
function ClientConfigUtils.GetHeroIdByFragmentId(id)
    if id == nil then
        XDebug.Error("nil id")
    end
    if id < HeroConstants.FACTION_HERO_ID_DELTA then
        return id
    else
        return math.floor(id / 100)
    end
end

--- @return number
--- @param id number
function ClientConfigUtils.GetHeroFoodTypeById(id)
    if id == nil then
        XDebug.Error("nil id")
    end
    return math.floor(id / 100)
end

--- @return number
--- @param id number
function ClientConfigUtils.GetHeroFoodStarById(id)
    if id == nil then
        XDebug.Error("nil id")
    end
    return math.floor(id % 100)
end

--- @return number
--- @param heroId number
function ClientConfigUtils.IsDarkLightHero(heroId)
    if heroId == nil then
        XDebug.Error("nil id")
    else
        local factionId = math.floor(heroId / 10000)
        return factionId == ClientConfigUtils.FACTION_DARK or factionId == ClientConfigUtils.FACTION_LIGHT
    end
end

--- @return number
function ClientConfigUtils.GetCameraSizeFromViewSize(viewSize)
    local ratio = viewSize.x / viewSize.y
    if (ClientConfigUtils.FixedResolution < ratio) then
        return ClientConfigUtils.DefaultCameraSize
    else
        return ClientConfigUtils.DefaultCameraSize * ClientConfigUtils.FixedResolution / ratio
    end
end

--- @return number
--- @param avatarId number
--- @param borderId number
function ClientConfigUtils.GetAvatar(avatarId, borderId)
    return avatarId * 1000 + borderId
end

--- @return number
--- @param avatar number
function ClientConfigUtils.GetAvatarId(avatar)
    local avatarId = math.floor(avatar / 1000)
    local borderId = avatar % 1000
    return avatarId, borderId
end

--- @return number
function ClientConfigUtils.GetDefaultAvatarExpiredTime()
    ---@type BasicInfoInBound
    local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    local expiredTime = ClientConfigUtils.GetAvatarExpiredTime(basicInfoInBound.avatarData.previousAvatar)
end

function ClientConfigUtils.GetDefaultAvatar()
    ---@type BasicInfoInBound
    local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    return basicInfoInBound.avatarData.previousAvatar

end

function ClientConfigUtils.GetDefaultFrame()
    ---@type BasicInfoInBound
    local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    return basicInfoInBound.avatarData.previousFrame
end
--- @return boolean
function ClientConfigUtils.AvatarIsExpired(avatarID)
    local expiredTime = ClientConfigUtils.GetAvatarExpiredTime(avatarID)
    return ClientConfigUtils.AvatarFrameIsExpired(expiredTime)
end

--- @return boolean
function ClientConfigUtils.FrameIsExpired(frameID)
    local expiredTime = ClientConfigUtils.GetFrameExpiredTime(frameID)
    return ClientConfigUtils.AvatarFrameIsExpired(expiredTime)
end

--- @return boolean
function ClientConfigUtils.AvatarFrameIsExpired(expiredTime)
    return expiredTime > 0 and expiredTime < zg.timeMgr:GetServerTime()
end

--- @return number
--- @param avatarID number
function ClientConfigUtils.GetAvatarExpiredTime(avatarID)
    ---@type ClientResourceAvatar
    local clientResourceAvatar = InventoryUtils.Get(ResourceType.Avatar)
    if (clientResourceAvatar._avatarResourceDict:IsContainKey(avatarID)) then
        return clientResourceAvatar._avatarResourceDict:Get(avatarID)
    else
        -- XDebug.Log("NO KEY AVATAR " .. avatarID)
        return -1
    end
end

--- @return number
------ @param frameID number
function ClientConfigUtils.GetFrameExpiredTime(frameID)
    ---@type ClientResourceAvatar
    local clientResourceAvatar = InventoryUtils.Get(ResourceType.AvatarFrame)
    if (clientResourceAvatar._avatarResourceDict:IsContainKey(frameID)) then
        -- local number = clientResourceAvatar._avatarResourceDict:Get(frameID)
        -- XDebug.Log("time frame" .. number)
        -- return number
        return clientResourceAvatar._avatarResourceDict:Get(frameID)
    else
        -- XDebug.Log("NO KEY frame " .. frameID)
        return -1
    end


end

--- @return number, number, number
--- @param stageId number
function ClientConfigUtils.GetIdFromStageId(stageId)
    if stageId == nil then
        XDebug.Error("stageId is nil")
    end
    local stage = stageId % 1000
    local mapId = math.floor((stageId % 100000) / 1000)
    local difficultId = math.floor(stageId / 100000)
    return difficultId, mapId, stage
end

--- @return List <number>
function ClientConfigUtils.GetEquipmentCollection(equipmentType, sort, rarity)
    local dic = List()
    for k, v in pairs(ResourceMgr.GetServiceConfig():GetItems().equipmentDataEntries:GetItems()) do
        local typeItem = (math.floor(k / 1000))
        ---@type EquipmentDataEntry
        local equipmentDataConfig = v
        if (equipmentType == nil or typeItem == equipmentType) and (rarity == nil or equipmentDataConfig.rarity == rarity) then
            dic:Add(k)
        end
    end
    if sort == 1 then
        dic:SortWithMethod(SortUtils._EquipmentSortTier)
    elseif sort == -1 then
        dic:SortWithMethod(SortUtils._EquipmentSortTierFlip)
    end
    return dic
end

--- @return List <number>
function ClientConfigUtils.GetEquipmentBlackSmith(equipmentType, sort, rarity)
    --- @type FeatureConfigInBound
    local featureConfigInBound = zg.playerData:GetMethod(PlayerDataMethod.FEATURE_CONFIG)
    local remoteConfigNewEquipment = featureConfigInBound:GetFeatureConfigInBound(FeatureType.ITEM_REVOLUTION)
    local isShowNewEquipment = remoteConfigNewEquipment:IsAvailableToGoFeature(false)

    local list = List()
    for k, v in pairs(ResourceMgr.GetServiceConfig():GetItems().equipmentDataEntries:GetItems()) do
        local typeItem = (math.floor(k / 1000))
        ---@type EquipmentDataEntry
        local equipmentDataConfig = v
        if ResourceMgr.GetServiceConfig():GetItems().equipmentDataEntries:IsContainKey(k - 1)
                and (equipmentType == nil or typeItem == equipmentType)
                and (rarity == nil or equipmentDataConfig.rarity == rarity)
                and (isShowNewEquipment or not equipmentDataConfig.isNewEquipment) then
            list:Add(k)
        end
    end
    if sort == 1 then
        list:SortWithMethod(SortUtils._EquipmentSortTier)
    elseif sort == -1 then
        list:SortWithMethod(SortUtils._EquipmentSortTierFlip)
    end
    return list
end

--- @return IconView
function ClientConfigUtils.CreateItemInventoryPreview(parent, type, id, number)
    ---@type IconView
    local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.ItemIconView, parent)
    item:SetIconData(ItemIconData.CreateInstance(type, id, number))
    return item
end

--- @return IconView
function ClientConfigUtils.CreateFragmentInventoryPreview(parent, type, id)
    ---@type IconView
    local item
    if type == ResourceType.HeroFragment then
        item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, parent)
        item:SetIconData(ItemIconData.CreateInstance(ResourceType.HeroFragment, id))
    elseif type == ResourceType.ItemFragment then
        item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.ItemIconView, parent)
        item:SetIconData(ItemIconData.CreateInstance(ResourceType.ItemFragment, id))
    end
    return item
end

--- @return IconView
function ClientConfigUtils.CreateItemInventoryPreview(parent, type, id)
    ---@type IconView
    local item
    if type == ResourceType.ItemEquip or type == ResourceType.ItemArtifact or type == ResourceType.ItemStone or type == ResourceType.ItemFragment then
        item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.ItemIconView, parent)
    elseif type == ResourceType.Money then
        item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyIconView, parent)
    end
    item:SetIconData(ItemIconData.CreateInstance(type, id))
    return item
end

--- @return number
--- @param heroStar number
function ClientConfigUtils.GetSkinLevelByStar(heroId, heroStar)
    local heroTier = ResourceMgr.GetHeroesConfig():GetHeroTier():GetHeroTier(heroId)
    local skinLevel = 1
    if heroTier == nil or heroTier <= 4 or heroStar == nil then
        return skinLevel
    end

    if heroStar > 6 and heroStar <= 12 then
        skinLevel = 2
    elseif heroStar > 12 then
        if heroTier <= 5 then
            skinLevel = 2
        else
            skinLevel = 3
        end
    end
    return skinLevel
end

--- @return string
--- @param value Number
function ClientConfigUtils.FormatNumber(value)
    local str = ""
    if value < 10 ^ 4 then
        str = tostring(value)
    elseif value >= 10 ^ 10 then
        str = tostring(math.floor(value / 10 ^ 9)) .. "B"
    elseif value >= 10 ^ 7 then
        str = tostring(math.floor(value / 10 ^ 6)) .. "M"
    elseif value >= 10 ^ 4 then
        str = tostring(math.floor(value / 10 ^ 3)) .. "K"
    end
    return str
end

--- @return string
--- @param heroResource HeroResource
function ClientConfigUtils.GetSkinNameByHeroResource(heroResource)
    local equipments = heroResource.heroItem
    if equipments ~= nil then
        local skinItemId = equipments:Get(HeroItemSlot.SKIN)
        if skinItemId ~= nil and skinItemId ~= -1 and heroResource.isHideSkin ~= true then
            return string.format("skin_id_%s", skinItemId)
        end
    end
    return "skin_" .. ClientConfigUtils.GetSkinLevelByStar(heroResource.heroId, heroResource.heroStar)
end

--- @param heroStar number
function ClientConfigUtils.GetSkinNameByHeroStar(heroId, heroStar)
    return "skin_" .. ClientConfigUtils.GetSkinLevelByStar(heroId, heroStar)
end

--- @param baseHero BaseHero
function ClientConfigUtils.GetSkinNameByBaseHero(baseHero)
    local skinItemId = baseHero.equipmentController:GetItem(HeroItemSlot.SKIN)
    if skinItemId ~= nil and skinItemId ~= -1 and baseHero.equipmentController.isHideSkin ~= true then
        return string.format("skin_id_%s", skinItemId)
    end
    return ClientConfigUtils.GetSkinNameByHeroStar(baseHero.id, baseHero.star)
end

--- @param baseHero BaseHero
function ClientConfigUtils.GetSkinIdByBaseHero(baseHero)
    local skinItemId = baseHero.equipmentController:GetItem(HeroItemSlot.SKIN)
    if skinItemId ~= nil and baseHero.equipmentController.isHideSkin ~= true then
        return skinItemId
    end
    return -1
end

--- @return SkinRarity
--- @param baseHero BaseHero
function ClientConfigUtils.GetSkinRarityByBaseHero(baseHero)
    local skinItemId = baseHero.equipmentController:GetItem(HeroItemSlot.SKIN)
    if skinItemId ~= nil and skinItemId ~= -1 then
        return ClientConfigUtils.GetSkinRarity(skinItemId)
    end
    return SkinRarity.DEFAULT
end

function ClientConfigUtils.GetEffectNameById(id)
    return "idle_effect_" .. tostring(id)
end

--- @return number
--- @param heightY number
--- @param offset number
function ClientConfigUtils.CalculateBattleLayer(heightY, offset)
    offset = offset or 0
    return math.floor((-heightY + offset) * ClientConfigUtils.ORDER_MULTIPLIER)
end

--- @return number
--- @param effectLogType EffectLogType
function ClientConfigUtils.GetEffectTier(effectLogType)
    if effectLogType == EffectLogType.VENOM_STACK
            or effectLogType == EffectLogType.DRYAD_MARK
            or effectLogType == EffectLogType.BURNING_MARK
            or effectLogType == EffectLogType.HEAL
            or effectLogType == EffectLogType.BURN
            or effectLogType == EffectLogType.POISON
            or effectLogType == EffectLogType.BLEED then
        return 1
    elseif effectLogType == EffectLogType.CHANGE_ATTACK
            or effectLogType == EffectLogType.DEFENSE
            or effectLogType == EffectLogType.CRIT_RATE
            or effectLogType == EffectLogType.CRIT_DAMAGE
            or effectLogType == EffectLogType.SPEED then
        return 2
    elseif effectLogType == EffectLogType.ACCURACY
            or effectLogType == EffectLogType.DODGE
            or effectLogType == EffectLogType.CHANGE_CC_RESISTANCE then
        return 3
    end
    return 3
end

--- @return boolean
--- @param effectLogType EffectLogType
function ClientConfigUtils.IsCCEffectHasInstance(effectLogType)
    return effectLogType == EffectLogType.STUN
            or effectLogType == EffectLogType.FREEZE
            or effectLogType == EffectLogType.SLEEP
end

--- @return number
--- @param formationId number
function ClientConfigUtils.GetRealFormation(formationId)
    local real = 5 - formationId
    assert(real > 0 and real <= 4, string.format("formation is not valid:  %s", formationId))
    return real
end

--- @param tweener DG_Tweening_Tweener
function ClientConfigUtils.KillTweener(tweener)
    if tweener ~= nil then
        tweener:Kill()
        tweener = nil
    end
end

--- @param routineHolder Coroutine
function ClientConfigUtils.KillCoroutine(routineHolder)
    if routineHolder ~= nil then
        Coroutine.stop(routineHolder)
        routineHolder = nil
    end
end

--- @return BattleTeamInfo
--- @param uiFormationTeamData UIFormationTeamData
--- @param mastery Dictionary
--- @param teamId number
--- @param playerSummonerInBound PlayerSummonerInBound
--- @param levelSummoner number
function ClientConfigUtils.GetBattleTeamInfo(uiFormationTeamData, mastery, teamId, playerSummonerInBound, levelSummoner)
    local battleTeamInfo = BattleTeamInfo()
    battleTeamInfo:SetFormationId(uiFormationTeamData.formationId)
    ---@param v {heroResource:HeroResource, isFrontLine : boolean, position:number}
    for _, v in ipairs(uiFormationTeamData.heroList:GetItems()) do
        local heroInfo = HeroBattleInfo()
        local heroResource = v.heroResource
        heroInfo:SetInfo(teamId, heroResource.heroId, heroResource.heroStar, heroResource.heroLevel)
        heroInfo:SetItemsDict(heroResource.heroItem, heroResource.isHideSkin)
        heroInfo:SetPosition(v.isFrontLine, v.position)
        heroInfo:SetState(1, HeroConstants.DEFAULT_HERO_POWER)
        battleTeamInfo:AddHero(heroInfo)
    end

    for key, data in pairs(mastery:GetItems()) do
        battleTeamInfo:AddMasteriesClass(key, data:Get(1), data:Get(2), data:Get(3), data:Get(4), data:Get(5), data:Get(6))
    end

    local summoner = SummonerBattleInfo()
    local summonerStar = playerSummonerInBound.star
    summoner:SetInfo(teamId, playerSummonerInBound.summonerId, summonerStar, levelSummoner)
    ---@type SummonerSkillInBound
    local summonerSkill = playerSummonerInBound.summonerSkills:Get(playerSummonerInBound.summonerId)
    if summonerStar == 3 then
        summoner:SetSkills(3)
    else
        summoner:SetSkillList(playerSummonerInBound:GetListSkillBySummonerId())
    end
    battleTeamInfo:SetSummonerBattleInfo(summoner)

    return battleTeamInfo
end

--- @return BattleTeamInfo
--- @param detailsTeamFormation DetailTeamFormation
--- @param levelSummoner number
function ClientConfigUtils.GetBattleTeamInfoByDetailsTeamFormationSummoner(detailsTeamFormation, summonerId,
                                                                           summonerStar, levelSummoner, masteryDict, teamId, linkingDict, listSkill, isDummy, isIgnorItem)
    local battleTeamInfo = BattleTeamInfo()
    battleTeamInfo:SetFormationId(math.max(detailsTeamFormation.formationId, 1))

    ---@param heroResource HeroResource
    for position, heroResource in pairs(detailsTeamFormation.frontLineDict:GetItems()) do
        local heroInfo = HeroBattleInfo()
        heroInfo:SetInfo(teamId, heroResource.heroId, heroResource.heroStar, heroResource.heroLevel)
        if isIgnorItem ~= true then
            heroInfo:SetItemsDict(heroResource.heroItem, heroResource.isHideSkin)
        end
        heroInfo:SetPosition(true, position)
        heroInfo:SetState(1, HeroConstants.DEFAULT_HERO_POWER)

        battleTeamInfo:AddHero(heroInfo)
    end

    ---@param heroResource HeroResource
    for position, heroResource in pairs(detailsTeamFormation.backLineDict:GetItems()) do
        local heroInfo = HeroBattleInfo()
        heroInfo:SetInfo(teamId, heroResource.heroId, heroResource.heroStar, heroResource.heroLevel)
        if isIgnorItem ~= true then
            heroInfo:SetItemsDict(heroResource.heroItem, heroResource.isHideSkin)
        end
        heroInfo:SetPosition(false, position)
        heroInfo:SetState(1, HeroConstants.DEFAULT_HERO_POWER)

        battleTeamInfo:AddHero(heroInfo)
    end
    if masteryDict ~= nil then
        for key, data in pairs(masteryDict:GetItems()) do
            battleTeamInfo:AddMasteriesClass(key, data:Get(1), data:Get(2), data:Get(3), data:Get(4), data:Get(5), data:Get(6))
        end
    end
    local summoner = SummonerBattleInfo()
    if summonerStar == 3 then
        summoner:SetSkills(3)
    else
        summoner:SetSkillList(listSkill)
    end
    if linkingDict ~= nil then
        for i, v in pairs(linkingDict:GetItems()) do
            battleTeamInfo:AddLinkingGroup(i, v)
        end
    end

    if isDummy == true then
        summoner:SetInfo(teamId, HeroConstants.SUMMONER_NOVICE_ID, HeroConstants.DEFAULT_SUMMONER_STAR, 1)
        summoner:SetSkills(HeroConstants.DEFAULT_SUMMONER_STAR)
        summoner:SetDummy(true)
    else
        summoner:SetInfo(teamId, summonerId, summonerStar, levelSummoner)
        if summonerStar == HeroConstants.DEFAULT_SUMMONER_STAR then
            summoner:SetSkills(HeroConstants.DEFAULT_SUMMONER_STAR)
        else
            summoner:SetSkillList(listSkill)
        end
        summoner:SetDummy(false)
    end
    battleTeamInfo:SetSummonerBattleInfo(summoner)
    return battleTeamInfo
end

--- @return BattleTeamInfo
--- @param detailsTeamFormation DetailTeamFormation
--- @param summonerBattleInfoInBound SummonerBattleInfoInBound
function ClientConfigUtils.GetBattleTeamInfoByDetailsTeamFormationAndSummonerInfo(detailsTeamFormation, summonerBattleInfoInBound, teamId)
    return ClientConfigUtils.GetBattleTeamInfoByDetailsTeamFormationSummoner(detailsTeamFormation,
            summonerBattleInfoInBound.summonerBattleInfo.summonerId,
            summonerBattleInfoInBound.summonerBattleInfo.star, summonerBattleInfoInBound.summonerBattleInfo.level,
            summonerBattleInfoInBound.masteryDict, teamId, summonerBattleInfoInBound.linkingDict, summonerBattleInfoInBound.summonerBattleInfo.skills, summonerBattleInfoInBound.summonerBattleInfo.isDummy)
end

----- @return BattleTeamInfo
----- @param mode GameMode
----- @param mastery Dictionary
----- @param teamId number
----- @param summonerStar number
----- @param levelSummoner number
--function ClientConfigUtils.GetBattleTeamInfoByMode(mode, mastery, teamId, summonerStar, levelSummoner, linking)
--    ---@type DetailTeamFormation
--    local detailsTeamFormation
--    ---@type TeamFormationInBound
--    local teamFormationInBound = zg.playerData:GetFormationInBound().teamDict:Get(mode)
--    if zg.playerData:GetFormationInBound().teamDict:IsContainKey(mode) then
--        detailsTeamFormation = DetailTeamFormation.CreateByTeamFormationInBound(teamFormationInBound)
--    else
--        detailsTeamFormation = DetailTeamFormation()
--    end
--    return ClientConfigUtils.GetBattleTeamInfoByDetailsTeamFormationSummoner(detailsTeamFormation, teamFormationInBound.summonerId,
--            summonerStar, levelSummoner, mastery, teamId, linking)
--end

--- @return BattleTeamInfo
--- @param gameMode GameMode
function ClientConfigUtils.GetAttackCurrentBattleTeamInfoByMode(gameMode, listHeroResource)
    local formationInBound = zg.playerData:GetFormationInBound()
    ---@type BasicInfoInBound
    local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    ---@type PlayerSummonerInBound
    local summonerInBound = zg.playerData:GetMethod(PlayerDataMethod.SUMMONER)
    local masteryDict, linkingDict, isDummy, isIgnorItem
    if ClientConfigUtils.IsDomainMode(gameMode) == false then
        ---@type PlayerMasteryInBound
        local masteryInBound = zg.playerData:GetMethod(PlayerDataMethod.MASTERY)
        masteryDict = masteryInBound.classDict
        linkingDict = zg.playerData.battleResultLinking
    end
    if ClientConfigUtils.IsKazetsuMode(gameMode) then
        isDummy = true
        isIgnorItem = true
        masteryDict = nil
        linkingDict = nil
    end

    if ClientConfigUtils.IsBossChallengeMode(gameMode) then
        isDummy = true
        isIgnorItem = true
        masteryDict = nil
        linkingDict = nil
    end

    --- @type HeroLinkingInBound
    --local heroLinkingInBound = zg.playerData:GetMethod(PlayerDataMethod.HERO_LINKING)
    --- @type TeamFormationInBound
    local teamFormationInBound
    --- @type DetailTeamFormation
    local detailsTeamFormation
    if formationInBound.teamDict:IsContainKey(gameMode) then
        teamFormationInBound = formationInBound:GetTeamFormationInBound(gameMode)
        detailsTeamFormation = DetailTeamFormation.CreateByTeamFormationInBound(teamFormationInBound, listHeroResource)
    else
        detailsTeamFormation = DetailTeamFormation()
    end
    return ClientConfigUtils.GetBattleTeamInfoByDetailsTeamFormationSummoner(detailsTeamFormation, teamFormationInBound.summonerId,
            summonerInBound.star, basicInfoInBound.level, masteryDict, 1, linkingDict,
            summonerInBound:GetListSkillBySummonerId(teamFormationInBound.summonerId), isDummy, isIgnorItem)
end

function ClientConfigUtils.GetBattleTeamInfoByTeamFormationInBoundKazetsuTrial(teamFormationInBound, listHeroResource)
    ---@type BasicInfoInBound
    local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    ---@type PlayerSummonerInBound
    local summonerInBound = zg.playerData:GetMethod(PlayerDataMethod.SUMMONER)
    ---@type DetailTeamFormation
    local detailsTeamFormation = DetailTeamFormation.CreateByTeamFormationInBound(teamFormationInBound, listHeroResource)

    ---@type LandUnlockConfig
    local classDict = Dictionary()
    local activeLinking = Dictionary()
    return ClientConfigUtils.GetBattleTeamInfoByDetailsTeamFormationSummoner(detailsTeamFormation,
            teamFormationInBound.summonerId,
            summonerInBound.star,
            basicInfoInBound.level,
            classDict,
            BattleConstants.ATTACKER_TEAM_ID,
            activeLinking,
            summonerInBound:GetListSkillBySummonerId(teamFormationInBound.summonerId),
            true, true)
end

--- @return BattleTeamInfo
function ClientConfigUtils.GetDomainBattleTeamInfo()

end

--- @return BattleTeamInfo
--- @param teamFormationInBound TeamFormationInBound
function ClientConfigUtils.GetCurrentBattleTeamInfoByTeam(teamFormationInBound, teamId)
    ---@type BasicInfoInBound
    local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    ---@type PlayerSummonerInBound
    local summonerInBound = zg.playerData:GetMethod(PlayerDataMethod.SUMMONER)
    ---@type PlayerMasteryInBound
    local masteryInBound = zg.playerData:GetMethod(PlayerDataMethod.MASTERY)
    ---@type DetailTeamFormation
    local detailsTeamFormation = DetailTeamFormation.CreateByTeamFormationInBound(teamFormationInBound)

    return ClientConfigUtils.GetBattleTeamInfoByDetailsTeamFormationSummoner(detailsTeamFormation, teamFormationInBound.summonerId,
            summonerInBound.star, basicInfoInBound.level, masteryInBound.classDict, teamId, zg.playerData.battleResultLinking, summonerInBound:GetListSkillBySummonerId(teamFormationInBound.summonerId))
end

--- @return BattleTeamInfo
--- @param team number
--- @param id number
function ClientConfigUtils.GetBattleTeamInfoArenaTeam(team, id)
    local mode = team * 1000 + id
    ---@type BasicInfoInBound
    local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    ---@type PlayerSummonerInBound
    local summonerInBound = zg.playerData:GetMethod(PlayerDataMethod.SUMMONER)
    ---@type PlayerMasteryInBound
    local masteryInBound = zg.playerData:GetMethod(PlayerDataMethod.MASTERY)
    ---@type TeamFormationInBound
    local teamFormationInBound = zg.playerData:GetFormationInBound().arenaTeamDict:Get(mode)
    if teamFormationInBound == nil then
        teamFormationInBound = TeamFormationInBound()
        teamFormationInBound:SetDefaultTeam()
    end
    ---@type DetailTeamFormation
    local detailsTeamFormation = DetailTeamFormation.CreateByTeamFormationInBound(teamFormationInBound)
    return ClientConfigUtils.GetBattleTeamInfoByDetailsTeamFormationSummoner(detailsTeamFormation, teamFormationInBound.summonerId,
            summonerInBound.star, basicInfoInBound.level, masteryInBound.classDict, 1, zg.playerData.battleResultLinking, summonerInBound:GetListSkillBySummonerId(teamFormationInBound.summonerId))
end

function ClientConfigUtils.GetListHeroIgnor(team, id)
    ---@type List
    local list = List()
    ---@param teamFormationInBound TeamFormationInBound
    for i, teamFormationInBound in pairs(zg.playerData:GetFormationInBound().arenaTeamDict:GetItems()) do
        if math.floor(i / 1000) == team and i % 1000 ~= id then
            ---@param v HeroFormationInBound
            for _, v in pairs(teamFormationInBound.frontLine:GetItems()) do
                if v.heroInventoryId > 0 then
                    list:Add(v.heroInventoryId)
                end
            end

            ---@param v HeroFormationInBound
            for _, v in pairs(teamFormationInBound.backLine:GetItems()) do
                if v.heroInventoryId > 0 then
                    list:Add(v.heroInventoryId)
                end
            end
        end
    end
    return list
end

---@param listTeam List
function ClientConfigUtils.GetListHeroIgnorByListTeam(listTeam, index)
    ---@type List
    local list = List()
    ---@param teamFormationInBound TeamFormationInBound
    for i, teamFormationInBound in pairs(listTeam:GetItems()) do
        if i ~= index then
            ---@param v HeroFormationInBound
            for _, v in pairs(teamFormationInBound.frontLine:GetItems()) do
                if v.heroInventoryId > 0 then
                    list:Add(v.heroInventoryId)
                end
            end

            ---@param v HeroFormationInBound
            for _, v in pairs(teamFormationInBound.backLine:GetItems()) do
                if v.heroInventoryId > 0 then
                    list:Add(v.heroInventoryId)
                end
            end
        end
    end
    return list
end

--- @return BattleTeamInfo
--- @param teamFormationInBound TeamFormationInBound
--- @param mastery Dictionary
--- @param teamId number
--- @param playerSummonerInBound PlayerSummonerInBound
--- @param levelSummoner number
function ClientConfigUtils.GetBattleTeamInfoByTeamFormationInBound(teamFormationInBound, mastery, teamId, playerSummonerInBound, levelSummoner, linking)
    ---@type DetailTeamFormation
    local detailsTeamFormation = DetailTeamFormation.CreateByTeamFormationInBound(teamFormationInBound)
    return ClientConfigUtils.GetBattleTeamInfoByDetailsTeamFormationSummoner(detailsTeamFormation, teamFormationInBound.summonerId,
            playerSummonerInBound.star, levelSummoner, mastery, teamId, linking, playerSummonerInBound:GetListSkillBySummonerId(teamFormationInBound.summonerId))
end

---@return BattleTeamInfo
function ClientConfigUtils.GetAttackCurrentBattleTeamInfoByTeamFormationInBound(teamFormationInBound, gameMode, listHeroResource)
    ---@type BasicInfoInBound
    local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    ---@type PlayerSummonerInBound
    local summonerInBound = zg.playerData:GetMethod(PlayerDataMethod.SUMMONER)
    local masteryDict, linkingDict
    if ClientConfigUtils.IsDomainMode(gameMode) == false then
        ---@type PlayerMasteryInBound
        local masteryInBound = zg.playerData:GetMethod(PlayerDataMethod.MASTERY)
        masteryDict = masteryInBound.classDict

        linkingDict = zg.playerData.battleResultLinking
    end

    -----@type HeroLinkingInBound
    --local heroLinkingInBound = zg.playerData:GetMethod(PlayerDataMethod.HERO_LINKING)
    ---@type DetailTeamFormation
    local detailsTeamFormation = DetailTeamFormation.CreateByTeamFormationInBound(teamFormationInBound, listHeroResource)
    return ClientConfigUtils.GetBattleTeamInfoByDetailsTeamFormationSummoner(detailsTeamFormation, teamFormationInBound.summonerId,
            summonerInBound.star, basicInfoInBound.level, masteryDict, BattleConstants.ATTACKER_TEAM_ID, linkingDict, summonerInBound:GetListSkillBySummonerId(teamFormationInBound.summonerId))
end

function ClientConfigUtils.GetBattleTeamInfoByTeamFormationInBoundDefenseMode(teamFormationInBound, land)
    ---@type BasicInfoInBound
    local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    ---@type PlayerSummonerInBound
    local summonerInBound = zg.playerData:GetMethod(PlayerDataMethod.SUMMONER)
    ---@type PlayerMasteryInBound
    local masteryInBound = zg.playerData:GetMethod(PlayerDataMethod.MASTERY)
    ---@type DetailTeamFormation
    local detailsTeamFormation = DetailTeamFormation.CreateByTeamFormationInBound(teamFormationInBound)
    ---@type LandUnlockConfig
    local landUnlock = ResourceMgr.GetDefenseModeConfig():GetLandUnlockConfig(land)
    local classDict = masteryInBound.classDict
    if landUnlock.restrictType == DefenseRestrictType.UNBORN then
        classDict = Dictionary()
    end
    local isDummy = false
    if landUnlock.restrictType == DefenseRestrictType.DREAM then
        isDummy = true
    end
    local isIgnorItem = false
    if landUnlock.restrictType == DefenseRestrictType.LIBRARY then
        isIgnorItem = true
    end
    return ClientConfigUtils.GetBattleTeamInfoByDetailsTeamFormationSummoner(detailsTeamFormation, teamFormationInBound.summonerId,
            summonerInBound.star, basicInfoInBound.level, classDict, BattleConstants.ATTACKER_TEAM_ID, zg.playerData.battleResultLinking,
            summonerInBound:GetListSkillBySummonerId(teamFormationInBound.summonerId),
            isDummy, isIgnorItem)
end

--- @return string, string
function ClientConfigUtils.GetBattleMusicPath()
    local gameMode = zg.sceneMgr.gameMode
    local musicFileName
    if gameMode == GameMode.CAMPAIGN then
        local campaignData = zg.playerData:GetCampaignData()
        local diffLevel, mapId, stage
        if campaignData.stageCurrent > 0 then
            diffLevel, mapId, stage = ClientConfigUtils.GetIdFromStageId(campaignData.stageCurrent)
        else
            diffLevel, mapId, stage = ClientConfigUtils.GetIdFromStageId(campaignData.stageNext)
        end
        musicFileName = ClientConfigUtils.GetBattleMusicFileName(mapId)
    elseif gameMode == GameMode.TOWER or gameMode == GameMode.TOWER_RECORD then
        musicFileName = "m_battle_tower"
    elseif gameMode == GameMode.ARENA then
        musicFileName = "m_battle_pvp"
    else
        musicFileName = "m_battle_pvp"
    end
    return musicFileName
end

function ClientConfigUtils.GetBattleMusicFileName(worldId)
    if worldId > 7 then
        worldId = 7
    end
    return "m_battle_w" .. worldId
end

--- @return boolean
--- @param heroInventoryId number
--- @param gameMode GameMode
function ClientConfigUtils.CheckHeroInTeamMode(heroInventoryId, gameMode)
    local isLockInMode = false
    ---@type TeamFormationInBound
    local teamFormationInBound = nil
    if gameMode == GameMode.ARENA_TEAM then
        ---@param teamFormationInBound TeamFormationInBound
        for i, teamFormationInBound in pairs(zg.playerData:GetFormationInBound().arenaTeamDict:GetItems()) do
            if teamFormationInBound:IsContainHeroInventoryId(heroInventoryId) then
                isLockInMode = true
                break
            end
        end
    else
        if zg.playerData:GetFormationInBound().teamDict:IsContainKey(gameMode) then
            teamFormationInBound = zg.playerData:GetFormationInBound().teamDict:Get(gameMode)
            isLockInMode = teamFormationInBound:IsContainHeroInventoryId(heroInventoryId)
        end
    end
    if isLockInMode and gameMode == GameMode.GUILD_WAR then
        --- @type GuildWarTimeInBound
        local guildWarTimeInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_WAR_TIME)
        if guildWarTimeInBound ~= nil then
            if guildWarTimeInBound:CurrentPhase() == GuildWarPhase.SPACE then
                isLockInMode = false
            elseif teamFormationInBound:GetCountHero() > 1 and (guildWarTimeInBound:CurrentPhase() == GuildWarPhase.REGISTRATION or guildWarTimeInBound:CurrentPhase() == GuildWarPhase.SETUP_DEFENDER) then
                isLockInMode = false
            end
        end
    end
    return isLockInMode
end

--- @return string
--- @param heroId number
function ClientConfigUtils.GetClientHeroLuaRequire(heroId)
    if ClientConfigUtils._clientHeroRequire:IsContainKey(heroId) == false then
        local luaPath = string.format("lua.client.hero.ClientHero%s.ClientHero%s", heroId, heroId)
        ClientConfigUtils._clientHeroRequire:Add(heroId, luaPath)
    end
    return ClientConfigUtils._clientHeroRequire:Get(heroId)
end

---@return boolean
function ClientConfigUtils.CheckHeroInTraining(heroInventoryId)
    return zg.playerData:GetCampaignData().trainingSlotExp:IsContainValue(heroInventoryId)
end

---@return boolean
function ClientConfigUtils.CheckHeroInDomain(heroInventoryId)
    ---@type DomainInBound
    local inbound = zg.playerData:GetDomainInBound()
    return inbound.domainContributeHeroListInBound.listHeroContribute:IsContainValue(heroInventoryId)
end

---@return boolean
function ClientConfigUtils.CheckHeroInRaiseLevel(heroInventoryId)
    return zg.playerData:GetRaiseLevelHero():IsInRaisedSlot(heroInventoryId)
end

function ClientConfigUtils.CheckHeroInSupportHeroLinking(heroInventoryId)
    ---@type PlayerFriendInBound
    local inbound = zg.playerData:GetMethod(PlayerDataMethod.FRIEND)
    return inbound:IsInHeroSupport(heroInventoryId)
end

function ClientConfigUtils.CheckHeroInLinking(heroInventoryId)
    --- @type HeroLinkingInBound
    local heroLinkingInBound = zg.playerData:GetMethod(PlayerDataMethod.HERO_LINKING)
    return heroLinkingInBound:IsContainSelfHeroInLinking(heroInventoryId)
end

---@return boolean
---@param heroResource HeroResource
function ClientConfigUtils.CheckLockHero(heroResource)
    return ClientConfigUtils.GetNotiLockHero(heroResource) ~= nil
end

---@return boolean
function ClientConfigUtils.CheckHeroInAncientTree(heroInventoryId)
    ---@type ProphetTreeInBound
    local prophetTreeInBound = zg.playerData:GetMethod(PlayerDataMethod.PROPHET_TREE)
    return prophetTreeInBound ~= nil and prophetTreeInBound.heroInventoryId ~= nil and prophetTreeInBound.isConverting and heroInventoryId == prophetTreeInBound.heroInventoryId
end
---@return string
------@param  idType number
function ClientConfigUtils.GetKeyByTypeNumber(idType)
    if (idType == 2) then
        return FirebaseRemoteConfigKey.Summon
    elseif (idType == 1) then
        return FirebaseRemoteConfigKey.Campaign
    elseif (idType == 3) then
        return FirebaseRemoteConfigKey.WatchAd
    elseif (idType == 4) then
        return FirebaseRemoteConfigKey.ProgressPack
    elseif (idType == 5) then
        return FirebaseRemoteConfigKey.CampaignReward
    elseif (idType == 6) then
        return FirebaseRemoteConfigKey.FirstTopUp
    end
end

---@return string
---@param heroResource HeroResource
function ClientConfigUtils.GetNotiLockHeroInModeGame(heroResource)
    local noti = nil
    if ClientConfigUtils.CheckHeroInTeamMode(heroResource.inventoryId, GameMode.ARENA) then
        noti = LanguageUtils.LocalizeCommon("hero_in_arena")
    elseif ClientConfigUtils.CheckHeroInTraining(heroResource.inventoryId) then
        noti = LanguageUtils.LocalizeCommon("hero_in_training")
    elseif ClientConfigUtils.CheckHeroInRaiseLevel(heroResource.inventoryId) then
        noti = LanguageUtils.LocalizeCommon("hero_in_raise_level")
    elseif ClientConfigUtils.CheckHeroInSupportHeroLinking(heroResource.inventoryId) then
        noti = LanguageUtils.LocalizeCommon("hero_in_support_hero_linking")
    elseif ClientConfigUtils.CheckHeroInTeamMode(heroResource.inventoryId, GameMode.GUILD_WAR) then
        noti = LanguageUtils.LocalizeCommon("hero_in_guild_war")
    elseif ClientConfigUtils.CheckHeroInLinking(heroResource.inventoryId) then
        noti = LanguageUtils.LocalizeCommon("hero_in_linking")
    elseif ClientConfigUtils.CheckHeroInDomain(heroResource.inventoryId) then
        noti = LanguageUtils.LocalizeCommon("hero_in_domain")
    elseif ClientConfigUtils.CheckHeroInTeamMode(heroResource.inventoryId, GameMode.ARENA_TEAM) then
        noti = LanguageUtils.LocalizeCommon("hero_in_arena_team")
    end
    return noti
end

---@return string
---@param heroResource HeroResource
function ClientConfigUtils.GetNotiLockHeroInInventory(heroResource)
    local noti = nil
    if heroResource.isLock then
        noti = LanguageUtils.LocalizeCommon("hero_lock_in_inventory")
    end
    return noti
end

---@return string
---@param heroResource HeroResource
function ClientConfigUtils.GetNotiLockHero(heroResource)
    local noti = nil
    if heroResource.isLock then
        noti = ClientConfigUtils.GetNotiLockHeroInInventory(heroResource)
    else
        noti = ClientConfigUtils.GetNotiLockHeroInModeGame(heroResource)
    end
    return noti
end

function ClientConfigUtils.GetListFeatureLockHeroByInventoryId(inventoryId)
    local heroResource = InventoryUtils.GetHeroResourceByInventoryId(inventoryId)
    local featureList = List()
    if ClientConfigUtils.CheckHeroInTeamMode(heroResource.inventoryId, GameMode.ARENA) then
        featureList:Add(FeatureType.ARENA)
    end
    if ClientConfigUtils.CheckHeroInTeamMode(heroResource.inventoryId, GameMode.ARENA_TEAM) then
        featureList:Add(FeatureType.ARENA_TEAM)
    end
    if ClientConfigUtils.CheckHeroInTeamMode(heroResource.inventoryId, GameMode.GUILD_WAR) then
        featureList:Add(FeatureType.GUILD_WAR)
    end
    if ClientConfigUtils.CheckHeroInRaiseLevel(heroResource.inventoryId) then
        featureList:Add(FeatureType.RAISE_LEVEL)
    end
    if ClientConfigUtils.CheckHeroInLinking(heroResource.inventoryId) then
        featureList:Add(FeatureType.HERO_LINKING)
    end
    if ClientConfigUtils.CheckHeroInSupportHeroLinking(heroResource.inventoryId) then
        featureList:Add(FeatureType.HERO_LINKING_SUPPORT)
    end
    if ClientConfigUtils.CheckHeroInDomain(heroResource.inventoryId) then
        featureList:Add(FeatureType.DOMAINS)
    end
    if ClientConfigUtils.CheckHeroInTraining(heroResource.inventoryId) then
        featureList:Add(FeatureType.CAMPAIGN)
    end
    if heroResource.isLock then
        featureList:Add(FeatureType.INVENTORY)
    end
    return featureList
end

--- @return boolean
--- @param gameMode GameMode
function ClientConfigUtils.IsPVEGameMode(gameMode)
    return gameMode == GameMode.CAMPAIGN
            or gameMode == GameMode.TOWER
            or gameMode == GameMode.DUNGEON
            or gameMode == GameMode.RAID
            or gameMode == GameMode.RAID_HERO_FRAGMENT
            or gameMode == GameMode.GUILD_BOSS
            or gameMode == GameMode.GUILD_DUNGEON
            or gameMode == GameMode.GUILD_WAR
            or gameMode == GameMode.TEST
end

--- @return boolean
--- @param gameMode GameMode
function ClientConfigUtils.GetFeatureTypeByGameMode(gameMode)
    if gameMode == GameMode.CAMPAIGN then
        return FeatureType.CAMPAIGN
    elseif gameMode == GameMode.TOWER or gameMode == GameMode.TOWER_RECORD then
        return FeatureType.TOWER
    elseif gameMode == GameMode.RAID or gameMode == GameMode.RAID_HERO_FRAGMENT then
        return FeatureType.RAID
    elseif gameMode == GameMode.DOMAINS then
        return FeatureType.DOMAINS
    elseif gameMode == GameMode.DEFENSE_MODE then
        return FeatureType.DEFENSE
    end
end

--- @return number
function ClientConfigUtils.GetDeviceOS()
    if IS_ANDROID_PLATFORM then
        return DeviceOs.Android
    elseif IS_IOS_PLATFORM then
        return DeviceOs.iPhone
    else
        return DeviceOs.Editor
    end
end

--- @return string
--- @param opcode OpCode
--- @param packId number
--- @param dataId number
function ClientConfigUtils.GetPurchaseKey(opcode, packId, dataId)
    if dataId == nil then
        if not opcode or not packId then
            print(debug.traceback())
            print("NIL ? opcode: ", opcode, "packID:", packId)
            return ""
        end
        return string.format("%d_%d", opcode, packId)
    else
        -- use for event
        return string.format("%d_%d_%d", opcode, packId, dataId)
    end
end

--- @param level number
function ClientConfigUtils.GetTimeScaleBySpeedUpLevel(level)
    if level == 1 then
        return 1.5
    elseif level == 2 then
        return 2.5
    elseif level == 3 then
        return 3.5
    else
        return 1
    end
end

--- @param star number
function ClientConfigUtils.GetTierByStar(star)
    local tier = 1
    if star == 3 then
        tier = 1
    elseif star <= HeroConstants.SUMMONER_SKILL_TIER_1 then
        tier = 1
    elseif star <= HeroConstants.SUMMONER_SKILL_TIER_2 then
        tier = 2
    else
        tier = 3
    end
    return tier
end

---@return boolean
--- @param table table <FeatureLockData>
--- @param feature FeatureType
--- @param isShowNotify boolean
function ClientConfigUtils.CheckUnlockFeatureAndNotification(table, feature, isShowNotify)
    if feature == FeatureType.IAP_SHOP then
        return true
    end
    if isShowNotify == nil then
        isShowNotify = true
    end
    local campaignData = zg.playerData:GetCampaignData()
    local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    if basicInfoInBound == nil then
        return false
    end
    local showNotificationDenied = function(content)
        SmartPoolUtils.ShowShortNotification(content)
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end
    --- @param require FeatureLockData
    for i, require in pairs(table) do
        if i == feature then
            if require.level > basicInfoInBound.level then
                if require.stage >= campaignData.stageNext then
                    local difficult, map, stage = ClientConfigUtils.GetIdFromStageId(require.stage)
                    if isShowNotify == true then
                        showNotificationDenied(StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("require_level_stage"), require.level, LanguageUtils.LocalizeDifficult(difficult), map, stage))
                    end
                    return false
                else
                    if isShowNotify == true then
                        showNotificationDenied(string.format(LanguageUtils.LocalizeCommon("require_level_x"), require.level))
                    end
                    return false
                end
            else
                if (require.stage == nil) then
                    XDebug.Error("require stage nil feature " .. tostring(feature))
                    return false
                elseif campaignData.stageNext == nil then
                    XDebug.Error("campaignData stage next nil feature " .. tostring(feature))
                    return false
                end
                if require.stage >= campaignData.stageNext then
                    local difficult, map, stage = ClientConfigUtils.GetIdFromStageId(require.stage)
                    if isShowNotify == true then
                        showNotificationDenied(StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("require_stage_x"), LanguageUtils.LocalizeDifficult(difficult), map, stage))
                    end
                    return false
                else
                    return true
                end
            end
        end
    end
    return true
end

---@return GuildRole
function ClientConfigUtils.GetGuildRole()
    --- @type GuildBasicInfoInBound
    local guildBasicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_BASIC_INFO)
    --- @type GuildInfoInBound
    local guildInfoInBound = guildBasicInfoInBound.guildInfo
    --- @type GuildRole
    return guildInfoInBound.selfRole
end

---@return boolean
--- @param feature FeatureType
--- @param isShowNotify boolean
function ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(feature, isShowNotify)
    --- @type FeatureConfigInBound
    local featureConfigInBound = zg.playerData:GetMethod(PlayerDataMethod.FEATURE_CONFIG)
    if featureConfigInBound == nil then
        return false
    end
    ---@type FeatureItemInBound
    local featureItemInBound = featureConfigInBound:GetFeatureConfigInBound(feature)
    if (featureItemInBound == nil) then
        XDebug.Log("NIL " .. tostring(feature))
    end
    if featureConfigInBound:GetFeatureConfigInBound(feature):IsAvailableToGoFeature(isShowNotify) == false then
        return false
    end
    return ClientConfigUtils.CheckUnlockFeatureAndNotification(ResourceMgr.GetMajorFeatureLock().dict:GetItems(),
            feature, isShowNotify)
end

---@return boolean
--- @param feature MinorFeatureType
--- @param isShowNotify boolean
function ClientConfigUtils.CheckUnlockMinorFeatureAndNotification(feature, isShowNotify)
    return ClientConfigUtils.CheckUnlockFeatureAndNotification(ResourceMgr.GetMinorFeatureLock().dict:GetItems(), feature, isShowNotify)
end

--- @param feature MinorFeatureType
function ClientConfigUtils.GetLevelStageRequire(feature)
    local levelRequire
    local stageRequire
    ---@type BasicInfoInBound
    local basicInfo = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    if basicInfo == nil then
        return levelRequire, stageRequire
    end
    ---@type {level, stage}
    local require = ResourceMgr.GetMinorFeatureLock().dict:Get(feature)
    if require.level > basicInfo.level then
        levelRequire = require.level
    end
    if require.stage > zg.playerData:GetCampaignData().stageIdle then
        stageRequire = require.stage
    end
    return levelRequire, stageRequire
end

--- @param stage number
function ClientConfigUtils.CheckLevelUpAndUnlockFeature(stage, callbackSuccess)
    if UIBaseView.IsActiveTutorial() == false then
        -----@type List
        local listUnlock = List()
        ---@type BasicInfoInBound
        local basicInfo = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
        if basicInfo == nil then
            PopupUtils.UnlockListFeature(listUnlock, callbackSuccess)
            return
        end
        --- @type FeatureConfigInBound
        local featureConfigInBound = zg.playerData:GetMethod(PlayerDataMethod.FEATURE_CONFIG)
        --- @param featureType FeatureType
        ---@param require {level, stage}
        for featureType, require in pairs(ResourceMgr.GetMajorFeatureLock().dict:GetItems()) do
            if (require.level > basicInfo.lastLevel and
                    require.level <= basicInfo.level and
                    zg.playerData:GetCampaignData().stageNext > require.stage) or
                    (stage ~= nil and require.stage == stage) then
                if FeatureItemInBound.IsConfigByGO(featureType) then
                    --- @type FeatureItemInBound
                    local featureItemInBound = featureConfigInBound:GetFeatureConfigInBound(featureType)
                    if featureItemInBound:IsAvailableToGoFeature(false) then
                        listUnlock:Add(featureType)
                    end
                else
                    listUnlock:Add(featureType)
                end
            end
        end

        if basicInfo.level > basicInfo.lastLevel then
            local level = basicInfo.level
            ---@type List
            local listReward = List()
            for i = basicInfo.lastLevel + 1, basicInfo.level do
                ---@type MainCharacterExpConfig
                local mainCharacterExpConfig = ResourceMgr.GetMainCharacterConfig().mainCharacterExpDictionary:Get(i)
                ---@param v ItemIconData
                for _, v in pairs(mainCharacterExpConfig.listReward:GetItems()) do
                    ClientConfigUtils.AddIconDataToList(listReward, v)
                end
            end

            basicInfo.lastLevel = basicInfo.level
            local touchObject = TouchUtils.Spawn("ClientConfigUtils.CheckLevelUpAndUnlockFeature 1")
            Coroutine.start(function()
                coroutine.waitforseconds(0.1)
                touchObject:Enable()
                PopupMgr.ShowPopup(UIPopupName.UILevelUp, { ["level"] = level, ["listReward"] = listReward, ["callbackClose"] = function()
                    PopupMgr.HidePopup(UIPopupName.UILevelUp)
                    PopupUtils.UnlockListFeature(listUnlock, callbackSuccess)
                end })
            end)
        else
            local touchObject
            if listUnlock:Count() > 0 then
                touchObject = TouchUtils.Spawn("ClientConfigUtils.CheckLevelUpAndUnlockFeature 2")
            end
            Coroutine.start(function()
                coroutine.waitforseconds(0.5)
                if listUnlock:Count() > 0 then
                    touchObject:Enable()
                end
                PopupUtils.UnlockListFeature(listUnlock, callbackSuccess)
            end)
        end
    end
end

function ClientConfigUtils.FormatTextAPB(cost, currentMoney)
    return string.format("<color=#%s>%s/%s</color>",
            cost <= currentMoney and UIUtils.green_light or UIUtils.red_light,
            ClientConfigUtils.FormatNumber(currentMoney),
            ClientConfigUtils.FormatNumber(cost))
end

---@return void
---@param rewardList List
---@param iconData ItemIconData
function ClientConfigUtils.AddIconDataToList(rewardList, iconData)
    local contain = false
    ---@param v ItemIconData
    for _, v in pairs(rewardList:GetItems()) do
        if v.type == iconData.type and v.itemId == iconData.itemId then
            v.quantity = v.quantity + iconData.quantity
            contain = true
            break
        end
    end
    if contain == false then
        rewardList:Add(iconData)
    end
end

--- @return List
--- @param rewardList1 List
--- @param rewardList2 List
function ClientConfigUtils.CombineListRewardInBound(rewardList1, rewardList2)
    if rewardList1 ~= nil then
        for i = 1, rewardList1:Count() do
            --- @type RewardInBound
            local rewardAdd = rewardList1:Get(i)
            local isAdded = false
            for k = 1, rewardList2:Count() do
                --- @type RewardInBound
                local rewardInBound = rewardList2:Get(k)
                if rewardInBound.type == rewardAdd.type and rewardInBound.id == rewardAdd.id then
                    rewardInBound.number = rewardInBound.number + rewardAdd.number
                    isAdded = true
                    break
                end
            end
            if isAdded == false then
                rewardList2:Add(rewardAdd)
            end
        end
    end
    return rewardList2
end

--- @return List
--- @param rewardList1 List
--- @param rewardList2 List
function ClientConfigUtils.CombineListItemIconData(rewardList1, rewardList2)
    local list = List()
    for i, v in ipairs(rewardList2:GetItems()) do
        list:Add(ItemIconData.Clone(v))
    end
    if rewardList1 ~= nil then
        for i = 1, rewardList1:Count() do
            --- @type ItemIconData
            local rewardAdd = rewardList1:Get(i)
            local isAdded = false
            for k = 1, list:Count() do
                --- @type ItemIconData
                local rewardInBound = list:Get(k)
                if rewardInBound.type == rewardAdd.type and rewardInBound.itemId == rewardAdd.itemId then
                    rewardInBound.quantity = rewardInBound.quantity + rewardAdd.quantity
                    isAdded = true
                    break
                end
            end
            if isAdded == false then
                list:Add(ItemIconData.Clone(rewardAdd))
            end
        end
    end
    return list
end

--- @param battleTeamInfo BattleTeamInfo
--- @param formationSlotIndex number
function ClientConfigUtils.GetHeroBattleInfoInBattleTeamInfoBySlotIndex(battleTeamInfo, formationSlotIndex)
    --- @type FormationData
    local formationData = ResourceMgr.GetServiceConfig():GetHeroes():GetFormationData(battleTeamInfo.formation)
    --- @type {isFrontLine, position}
    local positionInfo = {}
    if formationSlotIndex <= formationData.frontLine then
        positionInfo.isFrontLine = true
        positionInfo.position = formationSlotIndex
    else
        positionInfo.isFrontLine = false
        positionInfo.position = formationSlotIndex - formationData.frontLine
    end
    local listHero = battleTeamInfo:GetListHero()
    for i = 1, listHero:Count() do
        --- @type HeroBattleInfo
        local heroBattleInfo = listHero:Get(i)
        if heroBattleInfo.isFrontLine == positionInfo.isFrontLine
                and heroBattleInfo.position == positionInfo.position then
            return heroBattleInfo
        end
    end
    return nil
end

--- @return UnityEngine_Sprite
--- @param rankType number
--- @param topNumber number
--- @param featureType FeatureType
function ClientConfigUtils.GetIconRankingArenaByRankType(rankType, topNumber, featureType)
    ---@type ArenaRewardRankingConfig
    local rankTop1 = ResourceMgr.GetArenaRewardRankingConfig():GetArenaTopRanking(1, featureType)
    ---@type ArenaRewardRankingConfig
    local rankTop2 = ResourceMgr.GetArenaRewardRankingConfig():GetArenaTopRanking(2, featureType)
    ---@type ArenaRewardRankingConfig
    local rankTop3 = ResourceMgr.GetArenaRewardRankingConfig():GetArenaTopRanking(3, featureType)
    ---@type ArenaRewardRankingConfig
    local rankTop4 = ResourceMgr.GetArenaRewardRankingConfig():GetArenaTopRanking(4, featureType)
    ---@type ArenaRewardRankingConfig
    local rankTop5 = ResourceMgr.GetArenaRewardRankingConfig():GetArenaTopRanking(5, featureType)

    if rankType == rankTop1.rankType and topNumber ~= nil then
        if rankTop1:IsCurrentRanking(topNumber) then
            return ResourceLoadUtils.LoadArenaRank12Icon(1)
        elseif rankTop2:IsCurrentRanking(topNumber) then
            return ResourceLoadUtils.LoadArenaRank12Icon(2)
        elseif rankTop3:IsCurrentRanking(topNumber) then
            return ResourceLoadUtils.LoadArenaRank12Icon(3)
        elseif rankTop4:IsCurrentRanking(topNumber) then
            return ResourceLoadUtils.LoadArenaRank12Icon(4)
        elseif rankTop5:IsCurrentRanking(topNumber) then
            return ResourceLoadUtils.LoadArenaRank12Icon(5)
        end
    end
    return ResourceLoadUtils.LoadArenaRankIcon(rankType)
end

--- @return UnityEngine_Sprite
--- @param elo number
--- @param topNumber number
function ClientConfigUtils.GetIconRankingArenaByElo(elo, topNumber, featureType)
    local rankType = ClientConfigUtils.GetRankingTypeByElo(elo, featureType)
    return ClientConfigUtils.GetIconRankingArenaByRankType(rankType, topNumber, featureType)
end

--- @param battleTeamInfo BattleTeamInfo
function ClientConfigUtils.RequireBattleTeam(battleTeamInfo)
    local battleMgr = zg.battleMgr
    --- @param heroBattleInfo HeroBattleInfo
    for _, heroBattleInfo in ipairs(battleTeamInfo:GetListHero():GetItems()) do
        local heroId = heroBattleInfo.heroId
        if battleMgr.requireDict[heroId] == nil then
            local luaFiles = ResourceMgr.GetHeroesConfig():GetHeroLua():Get(heroId)
            for _, value in pairs(luaFiles) do
                require(value)
            end
            battleMgr.requireDict[heroId] = true
        end
    end
end

--- @return Dictionary<StatType, number>
--- @param baseHero BaseHero
function ClientConfigUtils.GetHeroStatDictionaryByBaseHero(baseHero)
    local statDict = Dictionary()
    ---@param baseHeroStat BaseHeroStat
    for type, baseHeroStat in pairs(baseHero.heroStats:GetItems()) do
        statDict:Add(type, baseHeroStat:GetValue())
    end
    return statDict
end

--- @return number
--- @param formationId number
--- @param isFrontLine boolean
--- @param position number
function ClientConfigUtils.GetSlotNumberByPositionInfo(formationId, isFrontLine, position)
    --- @type FormationData
    local formationData = ResourceMgr.GetServiceConfig():GetHeroes():GetFormationData(formationId)
    if isFrontLine == true then
        return position
    else
        return position + formationData.frontLine
    end
end

--- @return number
--- @param id number
function ClientConfigUtils.GetTypeAndStarHeroFood(id)
    return math.floor(id / 100), id % 100
end

--- @return number
--- @param id number
function ClientConfigUtils.GetFactionHeroFoodType(id)
    if id > 10 then
        return id % 10
    else
        return nil
    end
end

--- @return number
--- @param id number
function ClientConfigUtils.GetFactionHeroFoodId(id)
    local heroFoodType = ClientConfigUtils.GetTypeAndStarHeroFood(id)
    return ClientConfigUtils.GetFactionHeroFoodType(heroFoodType)
end

--- @return void
---@param battleTeamInfo BattleTeamInfo
---@param listHeroState List
function ClientConfigUtils.GetPercentHpBattle(battleTeamInfo, listHeroState)
    local maxHp = 0
    local currentHp = 0
    ---@param v HeroBattleInfo
    for _, v in ipairs(battleTeamInfo.listHeroInfo:GetItems()) do
        ---@type Dictionary
        local statDict = ClientConfigUtils.GetBaseStatHero(v.heroId, v.star, v.level)
        local hp = statDict:Get(StatType.HP)
        maxHp = maxHp + hp
        currentHp = currentHp + hp
        ---@param heroStateInBound HeroStateInBound
        for _, heroStateInBound in ipairs(listHeroState:GetItems()) do
            if heroStateInBound.isFrontLine == v.isFrontLine and heroStateInBound.position == v.position then
                currentHp = currentHp - (1 - heroStateInBound.hp) * hp
                break
            end
        end
    end

    return currentHp / maxHp
end

--- @param shaderName string
function ClientConfigUtils.GetShaderByName(shaderName)
    local shader = ClientConfigUtils._shaderDict:Get(shaderName)
    if shader == nil then
        shader = U_Shader.Find(shaderName)
        if shader ~= nil then
            ClientConfigUtils._shaderDict:Add(shaderName, shader)
        else
            XDebug.Error("There is no shader with name: " .. shaderName)
            return nil
        end
    end
    return shader
end

--- @return SkinRarity
--- @param skinId number
function ClientConfigUtils.GetSkinRarity(skinId)
    return ResourceMgr.GetServiceConfig():GetItems().skinDataEntries:Get(skinId).rarity
    --return ResourceMgr.GetSkinRarityConfig():GetSkinRarity(skinId)
end

--- @param listBase List
---@param listAdd List
function ClientConfigUtils.AddListItemIconData(listBase, listAdd)
    local contain = false
    ---@param item ItemIconData
    for _, item in pairs(listAdd:GetItems()) do
        contain = false
        ---@param v ItemIconData
        for _, v in pairs(listBase:GetItems()) do
            if item.type == v.type and item.itemId == v.itemId then
                v.quantity = v.quantity + item.quantity
                contain = true
                break
            end
        end
        if contain == false then
            listBase:Add(ItemIconData.Clone(item))
        end
    end
end

--- @param listBase List
---@param listAdd List
function ClientConfigUtils.AddListRewardInBound(listBase, listAdd)
    local contain = false
    ---@param item RewardInBound
    for _, item in pairs(listAdd:GetItems()) do
        contain = false
        ---@param v RewardInBound
        for _, v in pairs(listBase:GetItems()) do
            if item.type == v.type and item.id == v.id then
                v.number = v.number + item.number
                contain = true
                break
            end
        end
        if contain == false then
            listBase:Add(RewardInBound.Clone(item))
        end
    end
end

---@param list List
function ClientConfigUtils.ReturnPoolList(list)
    ---@param v IconView
    for i, v in ipairs(list:GetItems()) do
        v:ReturnPool()
    end
    list:Clear()
end

---@return MoneyType
---@param foodType HeroFoodType
function ClientConfigUtils.GetOrbByHeroFood(foodType)
    if foodType == HeroFoodType.WATER then
        return MoneyType.WATER_ORB
    elseif foodType == HeroFoodType.FIRE then
        return MoneyType.FIRE_ORB
    elseif foodType == HeroFoodType.ABYSS then
        return MoneyType.ABYSS_ORB
    elseif foodType == HeroFoodType.NATURE then
        return MoneyType.NATURE_ORB
    elseif foodType == HeroFoodType.DARK then
        return MoneyType.DARK_ORB
    elseif foodType == HeroFoodType.LIGHT then
        return MoneyType.LIGHT_ORB
    elseif foodType == HeroFoodType.SUN then
        return MoneyType.SUN_ORB
    elseif foodType == HeroFoodType.MOON then
        return MoneyType.MOON_ORB
    end
end

---@return MoneyType
---@param faction HeroFactionType
function ClientConfigUtils.GetOrbByFaction(faction)
    if faction == HeroFactionType.WATER then
        return MoneyType.WATER_ORB
    elseif faction == HeroFactionType.FIRE then
        return MoneyType.FIRE_ORB
    elseif faction == HeroFactionType.ABYSS then
        return MoneyType.ABYSS_ORB
    elseif faction == HeroFactionType.NATURE then
        return MoneyType.NATURE_ORB
    elseif faction == HeroFactionType.DARK then
        return MoneyType.DARK_ORB
    elseif faction == HeroFactionType.LIGHT then
        return MoneyType.LIGHT_ORB
    end
end

---@return MoneyType
---@param faction HeroFactionType
function ClientConfigUtils.GetMoonSunOrbByFaction(faction)
    if faction == HeroFactionType.WATER then
        return MoneyType.MOON_ORB
    elseif faction == HeroFactionType.FIRE then
        return MoneyType.MOON_ORB
    elseif faction == HeroFactionType.ABYSS then
        return MoneyType.MOON_ORB
    elseif faction == HeroFactionType.NATURE then
        return MoneyType.MOON_ORB
    elseif faction == HeroFactionType.DARK then
        return MoneyType.SUN_ORB
    elseif faction == HeroFactionType.LIGHT then
        return MoneyType.SUN_ORB
    end
end

---@return HeroFoodType
---@param faction HeroFactionType
function ClientConfigUtils.GetFoodMoonSunByFaction(faction)
    if faction == HeroFactionType.WATER then
        return HeroFoodType.MOON
    elseif faction == HeroFactionType.FIRE then
        return HeroFoodType.MOON
    elseif faction == HeroFactionType.ABYSS then
        return HeroFoodType.MOON
    elseif faction == HeroFactionType.NATURE then
        return HeroFoodType.MOON
    elseif faction == HeroFactionType.DARK then
        return HeroFoodType.SUN
    elseif faction == HeroFactionType.LIGHT then
        return HeroFoodType.SUN
    end
end

---@return HeroFoodType
---@param faction HeroFactionType
function ClientConfigUtils.GetFoodFactionByFaction(faction)
    if faction == HeroFactionType.WATER then
        return HeroFoodType.WATER
    elseif faction == HeroFactionType.FIRE then
        return HeroFoodType.FIRE
    elseif faction == HeroFactionType.ABYSS then
        return HeroFoodType.ABYSS
    elseif faction == HeroFactionType.NATURE then
        return HeroFoodType.NATURE
    elseif faction == HeroFactionType.DARK then
        return HeroFoodType.DARK
    elseif faction == HeroFactionType.LIGHT then
        return HeroFoodType.LIGHT
    end
end

--- @return UnityEngine_Sprite
function ClientConfigUtils.GetGuildWarTowerSprite(isAlly, slotIndex, percent)
    local side = "allies"
    if isAlly == false then
        side = "enemy"
    end
    local towerType = ClientConfigUtils.GetGuildWarTowerTypeByPosition(slotIndex)
    local towerState = ClientConfigUtils.GetGuildWarTowerStateByHealthPercent(percent)
    local towerName = string.format("%s_tower_%d_%s", side, towerType, towerState)
    local sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.guildWarTower, towerName)
    return sprite
end

--- @return number
function ClientConfigUtils.GetGuildWarTowerTypeByPosition(position)
    local towerType = 3
    if position >= 6 and position <= 12 then
        towerType = 2
    elseif position >= 13 then
        towerType = 1
    end
    return towerType
end

--- @return string
function ClientConfigUtils.GetGuildWarTowerStateByHealthPercent(healthPercent)
    local towerState = "full"
    if healthPercent < 1 and healthPercent > 0 then
        towerState = "burning"
    elseif healthPercent == 0 then
        towerState = "destroy"
    end
    return towerState
end

--- @return boolean
function ClientConfigUtils.IsContainSkinByHeroId(heroId)
    ---@param skinDataEntry SkinDataEntry
    for _, skinDataEntry in pairs(ResourceMgr.GetServiceConfig():GetItems().skinDataEntries:GetItems()) do
        if ClientConfigUtils.GetHeroIdBySkinId(skinDataEntry.id) == heroId and ClientConfigUtils.IsSkinUnlock(skinDataEntry.id) then
            return true
        end
    end
    return false
end

--- @return List
function ClientConfigUtils.GetListSkinByHeroId(heroId)
    ---@type List
    local list = List()
    ---@param skinDataEntry SkinDataEntry
    for k, skinDataEntry in pairs(ResourceMgr.GetServiceConfig():GetItems().skinDataEntries:GetItems()) do
        if (ClientConfigUtils.GetHeroIdBySkinId(skinDataEntry.id) == heroId and ClientConfigUtils.IsSkinUnlock(skinDataEntry.id)) then
            list:Add(skinDataEntry.id)
        end
    end
    return list
end

--- @return Dictionary
--- @param heroBattleInfo HeroBattleInfo
--- @param teamPowerCalculator TeamPowerCalculator
function ClientConfigUtils.GetHeroStatDictByHeroBattleInfo(heroBattleInfo, teamPowerCalculator)
    if heroBattleInfo ~= nil then
        --- @type BattleTeam
        local defenderTeam = teamPowerCalculator.battle:GetDefenderTeam()
        local baseHero = defenderTeam:GetHeroByLineAndPosition(heroBattleInfo.isFrontLine, heroBattleInfo.position)
        return ClientConfigUtils.GetHeroStatDictionaryByBaseHero(baseHero)
    end
    return Dictionary()
end

function ClientConfigUtils.GetSpriteSkin(id)
    if id >= 100000 or id < 100 then
        local heroId = math.floor(id / 10)
        local tier = id % 10
        if tier == 4 then
            tier = 3
        end
        return ResourceLoadUtils.LoadHeroCardsIconSkinLevel(heroId, tier)
    elseif id > 1000 then
        return ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconSkin, ResourceMgr.AvatarSkinConfig():GetSkinBuyAvatarID(id))
    else
        return ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconAvatar, id)
    end
end

---@return List {current, next}
---@param optionList1 List
---@param optionList2 List
function ClientConfigUtils.GetListBaseItemOptionChange(optionList1, optionList2)
    local list = List()
    if optionList1 ~= nil then
        for _, v in ipairs(optionList1:GetItems()) do
            local data = {}
            data.current = v
            list:Add(data)
        end
    end
    if optionList2 ~= nil then
        local count1 = list:Count()
        ---@param v BaseItemOption
        for _, v in ipairs(optionList2:GetItems()) do
            local add = true
            if count1 > 0 then
                for i = 1, count1 do
                    local data = list:Get(i)
                    ---@type BaseItemOption
                    local current = data.current
                    if current.type == v.type then
                        local indexAmount = nil
                        if current.type == ItemOptionType.STAT_CHANGE then
                            indexAmount = 2
                        else
                            indexAmount = 1
                        end
                        local addNew = false
                        for i = 1, current.params:Count() do
                            if i ~= indexAmount and current.params[i] ~= v.params[i] then
                                addNew = true
                                break
                            end
                        end
                        if addNew == false then
                            data.next = v
                            add = false
                        end
                    end
                end
            end
            if add == true then
                local data = {}
                data.next = v
                list:Add(data)
            end
        end
    end
    return list
end

--- @param minorFeatureType MinorFeatureType
function ClientConfigUtils.CanAutoBattle(minorFeatureType)
    --[[    if zg.canPlayPVEMode then
            return true
        end]]
    local levelRequire, stageRequire = ClientConfigUtils.GetLevelStageRequire(minorFeatureType)
    local result = (levelRequire == nil and stageRequire == nil)
    return result
end

function ClientConfigUtils.CheckAutoNextBattleAndNotification()
    local minorFeatureType = MinorFeatureType.AUTO_BATTLE
    local levelRequire, requireStage = ClientConfigUtils.GetLevelStageRequire(minorFeatureType)
    if (levelRequire == nil and requireStage == nil) then
        return true
    end
    local showNotificationDenied = function(content)
        SmartPoolUtils.ShowShortNotification(content)
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end
    local campaignData = zg.playerData:GetCampaignData()
    local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)

    --if ResourceMgr.GetVipConfig():GetCurrentBenefits().autoNextBattle then
    --    return true
    --else
    --    local vipUnlock = ResourceMgr.GetVipConfig():RequireLevelAutoNextBattle()
    --    SmartPoolUtils.NotificationRequireVipOrLevelAndStage(vipUnlock, levelRequire, requireStage)
    --    return false
    --end
    if levelRequire ~= nil and levelRequire > basicInfoInBound.level then
        if requireStage >= campaignData.stageNext then
            local difficult, map, stage = ClientConfigUtils.GetIdFromStageId(requireStage)
            showNotificationDenied(StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("require_level_stage"), levelRequire, LanguageUtils.LocalizeDifficult(difficult), map, stage))
            return false
        else
            showNotificationDenied(string.format(LanguageUtils.LocalizeCommon("require_level_x"), levelRequire))
            return false
        end
    else
        if requireStage ~= nil and requireStage >= campaignData.stageNext then
            local difficult, map, stage = ClientConfigUtils.GetIdFromStageId(requireStage)
            showNotificationDenied(StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("require_stage_x"), LanguageUtils.LocalizeDifficult(difficult), map, stage))
            return false
        else
            return true
        end
    end
    return true
end

--- @param minorFeatureType MinorFeatureType
function ClientConfigUtils.CanSpeedUp(minorFeatureType)
    if zg.canPlayPVEMode then
        return true
    end
    local levelRequire, stageRequire = ClientConfigUtils.GetLevelStageRequire(minorFeatureType)
    local vip = ResourceMgr.GetVipConfig():GetCurrentBenefits()
    return (levelRequire == nil and stageRequire == nil)
end

--- @return boolean
--- @param gameMode GameMode
function ClientConfigUtils.CheckCanSkip(gameMode)
    local canSkip = false
    if (gameMode == GameMode.RAID or gameMode == GameMode.RAID_HERO_FRAGMENT)
            and ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.RAID, false) == true then
        canSkip = true
    else
        ---@type {level, stage}
        local require = ResourceMgr.GetMinorFeatureLock().dict:Get(MinorFeatureType.BATTLE_SKIP)
        local vip = ResourceMgr.GetVipConfig():GetCurrentBenefits()
        local playerLevel = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).level
        canSkip = vip.battleUnlockSkip or (require.level <= playerLevel and require.stage < zg.playerData:GetCampaignData().stageNext)
    end
    return canSkip
end

--- @return boolean
--- @param gameMode GameMode
function ClientConfigUtils.CheckCanSummonProphetTreeByGem()
    local currentVip = ResourceMgr.GetVipConfig():GetCurrentBenefits()
    return currentVip.prophetTreeUseGem
end

function ClientConfigUtils.SetSpeedOnStartBattle()
    local remoteConfig = zg.playerData.remoteConfig
    --if ClientConfigUtils.CanSpeedUp(MinorFeatureType.BATTLE_SPEED_UP_2) and remoteConfig.isTriggerX3 ~= true then
    --    PlayerSettingData.battleSpeed = 3
    --    remoteConfig.isTriggerX3 = true
    --elseif ClientConfigUtils.CanSpeedUp(MinorFeatureType.BATTLE_SPEED_UP) and remoteConfig.isTriggerX2 ~= true then
    --    PlayerSettingData.battleSpeed = 2
    --    remoteConfig.isTriggerX2 = true
    --elseif remoteConfig.battleSpeedUpLevel ~= nil then
    --    PlayerSettingData.battleSpeed = remoteConfig.battleSpeedUpLevel
    --else
    --    PlayerSettingData.battleSpeed = 2
    --end

    if remoteConfig.battleSpeedUpLevel ~= nil then
        PlayerSettingData.battleSpeed = remoteConfig.battleSpeedUpLevel
    else
        PlayerSettingData.battleSpeed = 2
    end

    remoteConfig.battleSpeedUpLevel = PlayerSettingData.battleSpeed
    zg.playerData:SaveRemoteConfig()
end

function ClientConfigUtils.ChangeSpeedUpAndSave(minorFeatureType, onChange, isMainBattle)
    if isMainBattle == true then
        if minorFeatureType == MinorFeatureType.BATTLE_SPEED_UP then
            if PlayerSettingData.battleSpeed == 1 then
                PlayerSettingData.battleSpeed = 2
            elseif PlayerSettingData.battleSpeed == 2 then
                PlayerSettingData.battleSpeed = 3
            else
                PlayerSettingData.battleSpeed = 1
            end
        end
    else
        if minorFeatureType == MinorFeatureType.BATTLE_SPEED_UP then
            if PlayerSettingData.battleSpeed ~= 2 then
                PlayerSettingData.battleSpeed = 2
            else
                PlayerSettingData.battleSpeed = 1
            end
        elseif minorFeatureType == MinorFeatureType.BATTLE_SPEED_UP_2 then
            if PlayerSettingData.battleSpeed ~= 3 then
                PlayerSettingData.battleSpeed = 3
            else
                PlayerSettingData.battleSpeed = 1
            end
        else
            PlayerSettingData.battleSpeed = 1
        end
    end

    if onChange then
        onChange()
    end
    if zg.playerData ~= nil and zg.playerData.remoteConfig ~= nil then
        zg.playerData.remoteConfig.battleSpeedUpLevel = PlayerSettingData.battleSpeed
        zg.playerData:SaveRemoteConfig()
    end
end

--- @param timeScale number
function ClientConfigUtils.SetTimeScale(timeScale)
    U_Time.timeScale = timeScale
    zg.audioMgr:ChangeSoundSpeed(timeScale)
end

--- @param tier number
function ClientConfigUtils.GetMinStarByTier(tier)
    local star = 4
    if tier == 2 then
        star = HeroConstants.SUMMONER_SKILL_TIER_1 + 1
    elseif tier == 3 then
        star = HeroConstants.SUMMONER_SKILL_TIER_2 + 1
    end
    return star
end

--- @param tier number
function ClientConfigUtils.GetMaxStarByTier(tier)
    local star = HeroConstants.SUMMONER_SKILL_TIER_1
    if tier == 2 then
        star = HeroConstants.SUMMONER_SKILL_TIER_2
    elseif tier == 3 then
        star = HeroConstants.SUMMONER_SKILL_TIER_3
    end
    return star
end

--- @param tier number
function ClientConfigUtils.GetStarByTier(tier, maxStar)
    local star = HeroConstants.SUMMONER_SKILL_TIER_1
    if tier == 2 then
        star = HeroConstants.SUMMONER_SKILL_TIER_2
    elseif tier == 3 then
        star = HeroConstants.SUMMONER_SKILL_TIER_3
    end
    return math.min(star, maxStar)
end

--- @param id MoneyType
function ClientConfigUtils.IsMoneyEvent(id)
    if id == MoneyType.EVENT_MID_AUTUMN_LANTERN
            or id == MoneyType.EVENT_MID_AUTUMN_MOON_CAKE
            or id == MoneyType.EVENT_HALLOWEEN_PUMPKIN
            or id == MoneyType.EVENT_HALLOWEEN_DICE
            or id == MoneyType.EVENT_CHRISTMAS_CANDY_BAR
            or id == MoneyType.EVENT_CHRISTMAS_BOX
            or id == MoneyType.EVENT_LUNAR_NEW_YEAR_ENVELOPE
    then
        return true
    end
    return false
end

--- @return boolean
function ClientConfigUtils.IsSkinUnlock(skinId)
    return ResourceMgr.GetServiceConfig().skinNotShowList:IsContainValue(skinId) == false
end

--- @return boolean
function ClientConfigUtils.IsDomainChestMoney(moneyType)
    return moneyType == MoneyType.DOMAIN_CHEST_LEVEL_1
            or moneyType == MoneyType.DOMAIN_CHEST_LEVEL_2
            or moneyType == MoneyType.DOMAIN_CHEST_LEVEL_3
            or moneyType == MoneyType.DOMAIN_CHEST_LEVEL_4
            or moneyType == MoneyType.DOMAIN_CHEST_LEVEL_5
end

--- @return boolean
function ClientConfigUtils.IsDomainArenaChestMoney(moneyType)
    return moneyType == MoneyType.ARENA_CHEST_1
            or moneyType == MoneyType.ARENA_CHEST_2
            or moneyType == MoneyType.ARENA_CHEST_3
end

--- @return boolean
function ClientConfigUtils.IsHeroSelectionChestMoney(moneyType)
    return moneyType == MoneyType.HERO_CHEST_NORMAL or
            moneyType == MoneyType.HERO_CHEST_PREMIUM
end

--- @return boolean
function ClientConfigUtils.IsArtifactSelectionChestMoney(moneyType)
    return moneyType == MoneyType.ARTIFACT_CHEST_DL or
            moneyType == MoneyType.ARTIFACT_CHEST_WFAN
end

--- @return boolean
function ClientConfigUtils.IsEventSeasonalChest(moneyType)
    return moneyType == MoneyType.EVENT_SEASONAL_GIFT_BOX
end

function ClientConfigUtils.IsDomainMode(gameMode)
    return gameMode == GameMode.DOMAINS
            or gameMode == GameMode.DOMAINS_RECORD
end

function ClientConfigUtils.IsKazetsuMode(gameMode)
    return gameMode == GameMode.EVENT_KAZETSU_TRIAL
end

function ClientConfigUtils.IsBossChallengeMode(gameMode)
    return gameMode == GameMode.EVENT_BOSS_CHALLENGE
end

--- @return number
--- @param arrConfigVersion []
function ClientConfigUtils.CompareVersion(arrClientVersion, arrConfigVersion)
    if arrClientVersion[1] < arrConfigVersion[1]
            or (arrClientVersion[1] == arrConfigVersion[1] and arrClientVersion[2] < arrConfigVersion[2])
            or (arrClientVersion[1] == arrConfigVersion[1] and arrClientVersion[2] == arrConfigVersion[2] and arrClientVersion[3] < arrConfigVersion[3]) then
        return -1 --- ProductVersion < Config Version
    elseif arrClientVersion[1] == arrConfigVersion[1]
            and arrClientVersion[2] == arrConfigVersion[2]
            and arrClientVersion[3] == arrConfigVersion[3] then
        return 0 --- ProductVersion == Config Version
    else
        --- ProductVersion > Config Version
        return 1
    end
end

--- @return Dictionary
function ClientConfigUtils.GetEventItemConfig()
    local eventItemDictConfig = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.EVENT_ITEM_CONFIG)
    if parsedData == nil then
        XDebug.Error(string.format(" csv nil %s", CsvPathConstants.EVENT_ITEM_CONFIG))
        return
    end
    for i = 1, #parsedData do
        local eventType = tonumber(parsedData[i].event_time_type)
        local moneyType = tonumber(parsedData[i].money_type)
        eventItemDictConfig:Add(moneyType, eventType)
    end
    return eventItemDictConfig
end

--- @return Dictionary
function ClientConfigUtils.GetHeroTextDetailConfig()
    local heroDetailTextDict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.HERO_TEXT_DETAIL)
    if parsedData then
        for i = 1, #parsedData do
            local heroId = tonumber(parsedData[i].hero_id)
            local textDetailList = List()
            local text1 = tonumber(parsedData[i].hero_text_detail_1)
            local text2 = tonumber(parsedData[i].hero_text_detail_2)
            if text1 then
                textDetailList:Add(text1)
            end
            if text2 and text2 ~= text1 then
                textDetailList:Add(text2)
            end
            heroDetailTextDict:Add(heroId, textDetailList)
        end
        return heroDetailTextDict
    else
        return nil
    end
end

--- @return number
function ClientConfigUtils.GetBattlePassSeasonOptimizeId(dataId)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.BATTLEPASS_SEASON_RESOURCE)
    if parsedData then
        for i = 1, #parsedData do
            if dataId == tonumber(parsedData[i].data_id) then
                return tonumber(parsedData[i].atlas_id)
            end
        end
        return parsedData[#parsedData].atlas_id
    else
        return dataId
    end
end

--- @return List
function ClientConfigUtils.GetListFeatureNotShow()
    local list = List()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.FEATURE_NOT_SHOW)
    for i = 1, #parsedData do
        local data = parsedData[i]
        local featureId = tonumber(data.feature_id)
        if featureId then
            list:Add(featureId)
        end
    end
    return list
end