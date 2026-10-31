--- @class GuildConfig
GuildConfig = Class(GuildConfig)

--- @param tableData {guild_create_gem_price, guild_creator_level_requirement, min_character_of_name, max_character_of_name, max_character_of_description, leave_guild_block_duration, guild_leader_inactive_duration}
function GuildConfig:Ctor(tableData)
    --- @type number
    self.guildCreateGemPrice = nil
    --- @type number
    self.guildCreatorLevelRequire = nil
    --- @type number
    self.minCharacterOfName = nil
    --- @type number
    self.maxCharacterOfName = nil
    --- @type number
    self.maxCharacterOfDesc = nil
    --- @type number
    self.leaveGuildBlockDuration = nil
    --- @type number
    self.guildLeaderInactiveDuration = nil

    self:SetData(tableData[1])
end

--- @param tableData {guild_create_gem_price, guild_creator_level_requirement, min_character_of_name, max_character_of_name, max_character_of_description, leave_guild_block_duration, guild_leader_inactive_duration}
function GuildConfig:SetData(tableData)
    self.guildCreateGemPrice = tonumber(tableData.guild_create_gem_price)
    self.guildCreatorLevelRequire = tonumber(tableData.guild_creator_level_requirement)
    self.minCharacterOfName = tonumber(tableData.min_character_of_name)
    self.maxCharacterOfName = tonumber(tableData.max_character_of_name)
    self.maxCharacterOfDesc = tonumber(tableData.max_character_of_description)
    self.leaveGuildBlockDuration = tonumber(tableData.leave_guild_block_duration)
    self.guildLeaderInactiveDuration = tonumber(tableData.guild_leader_inactive_duration)
end