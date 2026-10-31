--- @class Hero60005_Skill4_Data Carnifex
Hero60005_Skill4_Data = Class(Hero60005_Skill4_Data, BaseSkillData)

--- @return void
function Hero60005_Skill4_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type List<number>
    self.chanceAndBonus = List()
end

--- @return BaseSkillData
function Hero60005_Skill4_Data:CreateInstance()
    return Hero60005_Skill4_Data()
end

--- @return void
function Hero60005_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    local i = 1
    while true do
        if TableUtils.IsContainKey(parsedData, "bonus_basic_attack_chance_" .. i) then
            assert(parsedData["bonus_basic_attack_chance_" .. i] ~= nil, "bonus_basic_attack_chance = " .. i)
            assert(parsedData["bonus_basic_attack_number_" .. i] ~= nil, "bonus_basic_attack_number = " .. i)
            i = i + 1
        else
            assert(i >= 1, "number stat = " .. i)
            break
        end
    end
end

--- @return void
function Hero60005_Skill4_Data:ParseCsv(parsedData)
    local i = 1
    while true do
        if TableUtils.IsContainKey(parsedData, "bonus_basic_attack_chance_" .. i) then
            local bonusInfo = {}
            bonusInfo.chance = tonumber(parsedData["bonus_basic_attack_chance_" .. i])
            bonusInfo.number = tonumber(parsedData["bonus_basic_attack_number_" .. i])
            self.chanceAndBonus:Add(bonusInfo)
            i = i + 1
        else
            break
        end
    end
end

return Hero60005_Skill4_Data