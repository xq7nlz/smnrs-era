--- @class DefenseFormationConfig
DefenseFormationConfig = Class(DefenseFormationConfig)

function DefenseFormationConfig:Ctor(parsedData)
    ---@type number
    self.id = tonumber(parsedData.id)
    ---@type number
    self.teamStat = -1
    if parsedData.team_stat ~= nil then
        self.teamStat = tonumber(parsedData.team_stat)
    end
    ---@type Dictionary
    self.dictHeroSlot = Dictionary()
    for i = 1, 5 do
        self.dictHeroSlot:Add(i, tonumber(parsedData[string.format("hero_%s", i)]))
    end
end

function DefenseFormationConfig:IsContainHero()
    local isContain = false
    for i, v in pairs(self.dictHeroSlot:GetItems()) do
        if v > 0 then
            isContain = true
            break
        end
    end
    return isContain
end