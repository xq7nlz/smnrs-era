require "lua.client.data.Domain.DailyTeamDomainConfig"
require "lua.client.data.Domain.DomainRewardConfig"

--- @class DomainConfig
DomainConfig = Class(DomainConfig)

function DomainConfig:Ctor()
    self.stamina = nil

    --- @type DomainRewardConfig
    self.domainRewardConfig = nil
end

function DomainConfig:GetStamina()
    if self.stamina == nil then
        local data = CsvReaderUtils.ReadAndParseLocalFile("csv/domains/domain_stamina_config.csv")
        self.stamina = tonumber(data[1].daily_stamina_number)
    end
    return self.stamina
end

--- @return DailyTeamDomainConfig
function DomainConfig:GetDomainConfigByDay(day)
    if self.dictDailyTeamConfig == nil then
        ---@type Dictionary
        self.dictDailyTeamConfig = Dictionary()
        require("lua.client.data.Domain.DailyTeamDomainConfig")
        local data = CsvReaderUtils.ReadAndParseLocalFile("csv/domains/daily_team_config.csv")
        for _, v in ipairs(data) do
            local config = DailyTeamDomainConfig(v)
            if config.minHero == nil then
                config.minHero = self.dictDailyTeamConfig:Get(1).minHero
            end
            if config.maxHero == nil then
                config.maxHero = self.dictDailyTeamConfig:Get(1).maxHero
            end
            self.dictDailyTeamConfig:Add(config.day, config)
        end
    end
    return self.dictDailyTeamConfig:Get(day)
end

--- @return DomainRewardConfig
function DomainConfig:GetDomainRewardConfig()
    if self.domainRewardConfig == nil then
        self.domainRewardConfig = DomainRewardConfig()
    end
    return self.domainRewardConfig
end

--- @return DomainRewardDayConfig
function DomainConfig:GetDomainRewardDayConfig(day)
    return self:GetDomainRewardConfig():GetDomainRewardDayConfig(day)
end

return DomainConfig