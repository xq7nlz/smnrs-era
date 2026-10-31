--- @class GuildWarConfig
GuildWarConfig = Class(GuildWarConfig)

function GuildWarConfig:Ctor()
    --- @type number
    self.numberMemberJoin = nil
    --- @type number
    self.numberMedal = nil
    --- @type number
    self.minAttackerHeroDeadRequirement = nil
    --- @type number
    self.maxRoundRequirement = nil
    --- @type number
    self.numberAttackPerBattle = nil
    self:_InitData()
end

function GuildWarConfig:_InitData()
    local parseData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.GUILD_WAR_CONFIG_PATH)
    self.numberMemberJoin = tonumber(parseData[1].number_member_join)
    self.numberMedal = tonumber(parseData[1].number_medal)
    self.minAttackerHeroDeadRequirement = tonumber(parseData[1].min_attacker_hero_dead_requirement)
    self.maxRoundRequirement = tonumber(parseData[1].max_round_requirement)
    self.numberAttackPerBattle = tonumber(parseData[1].number_attack_per_battle)
end