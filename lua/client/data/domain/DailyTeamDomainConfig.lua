--- @class DailyTeamDomainConfig
DailyTeamDomainConfig = Class(DailyTeamDomainConfig)

function DailyTeamDomainConfig:Ctor(parsedData)
    ---@type number
    self.day = tonumber(parsedData.day)
    ---@type List
    self.classRequire = List()
    if parsedData.hero_class_required == "-1" then
        for i = 1, 5 do
            self.classRequire:Add(i)
        end
    else
        local class = parsedData.hero_class_required:Split(";")
        for i, v in ipairs(class) do
            self.classRequire:Add(tonumber(v))
        end
    end

    if parsedData.number_hero_required ~= nil then
        local heroNumber = parsedData.number_hero_required:Split(";")
        ---@type number
        self.minHero = tonumber(heroNumber[1])
        ---@type number
        self.maxHero = tonumber(heroNumber[2] or heroNumber[1])
    end
end