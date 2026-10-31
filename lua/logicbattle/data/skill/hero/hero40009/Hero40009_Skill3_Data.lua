--- @class Hero40009_Skill3_Data Sylph
Hero40009_Skill3_Data = Class(Hero40009_Skill3_Data, BaseSkillData)

--- @return void
function Hero40009_Skill3_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type List<number>
    self.bonusAttackMultiplierList = List()
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40009_Skill3_Data:CreateInstance()
    return Hero40009_Skill3_Data()
end

--- @return void
function Hero40009_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.number_bonus_attack ~= nil, "number_bonus_attack = nil")
end

--- @return void
function Hero40009_Skill3_Data:ParseCsv(parsedData)
    self.numberBonusAttack = tonumber(parsedData.number_bonus_attack)

    local i = 1
    while i <= self.numberBonusAttack do
        local damageMultiplier = tonumber(parsedData["damage_multiplier_" .. i])
        self.bonusAttackMultiplierList:Add(damageMultiplier)
        i = i + 1
    end
end

return Hero40009_Skill3_Data