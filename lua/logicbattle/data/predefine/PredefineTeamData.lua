--- @class PredefineTeamData
PredefineTeamData = Class(PredefineTeamData)

--- @return void
function PredefineTeamData:Ctor()
    --- @type number
    self.teamId = BattleConstants.DEFENDER_TEAM_ID

    --- @type number
    self.teamSummonerId = nil

    --- @type number
    self.formationId = nil

    --- @type number
    self.teamLevelId = nil

    --- @type number
    self.teamStarId = nil

    --- @type number
    self.teamItemId = nil

    --- @type number
    self.teamMasteryId = nil

    --- @type Dictionary --<number, number> <index, idHero>
    self.heroList = Dictionary()

    --- @type number
    self.bossSlotId = nil
end

--- @return void
--- @param teamId number
function PredefineTeamData:SetTeamId(teamId)
    self.teamId = teamId
end

--- @return void
--- @param teamSummonerId number
function PredefineTeamData:SetTeamSummonerId(teamSummonerId)
    self.teamSummonerId = teamSummonerId
end

--- @return void
--- @param formationId number
function PredefineTeamData:SetFormationId(formationId)
    self.formationId = formationId
end

--- @return void
--- @param teamLevelId number
function PredefineTeamData:SetTeamLevelId(teamLevelId)
    self.teamLevelId = teamLevelId
end

--- @return void
--- @param teamStarId number
function PredefineTeamData:SetTeamStarId(teamStarId)
    self.teamStarId = teamStarId
end

--- @return void
--- @param teamItemId number
function PredefineTeamData:SetTeamItemId(teamItemId)
    self.teamItemId = teamItemId
end

--- @return void
--- @param teamMasteryId number
function PredefineTeamData:SetTeamMasteryId(teamMasteryId)
    self.teamMasteryId = teamMasteryId
end

--- @return void
--- @param heroList Dictionary<number, number> <index, idHero>
function PredefineTeamData:SetHeroList(heroList)
    self.heroList = heroList
end

--- @return void
--- @param bossSlotId number
function PredefineTeamData:SetBossSlotId(bossSlotId)
    self.bossSlotId = bossSlotId
end

--- @param buffer UnifiedNetwork_ByteBuf
function PredefineTeamData:ReadBuffer(buffer)
    self:SetFormationId(buffer:GetByte())
    self:SetTeamSummonerId(buffer:GetInt())
    self:SetTeamLevelId(buffer:GetInt())
    self:SetTeamStarId(buffer:GetInt())
    self:SetTeamItemId(buffer:GetInt())
    self:SetTeamMasteryId(buffer:GetInt())
    self:SetBossSlotId(buffer:GetInt())
    local sizeListHero = buffer:GetByte()
    for i = 1, sizeListHero do
        self.heroList:Add(i, buffer:GetInt())
    end
end

--- @param json string
function PredefineTeamData:ParseJson(json)
    self:SetFormationId(json['0'])
    self:SetTeamSummonerId(json['1'])
    self:SetTeamLevelId(json['2'])
    self:SetTeamStarId(json['3'])
    self:SetTeamItemId(json['6'])
    self:SetTeamMasteryId(json['7'])
    self:SetBossSlotId(json['4'])
    for i, v in pairs(json['5']) do
        self.heroList:Add(i, v)
    end
end

function PredefineTeamData:ParseCsv(data)
    self:SetFormationId(tonumber(data[PredefineConstants.FORMATION_ID_TAG]))

    if data[PredefineConstants.PREDEFINE_SUMMONER_ID_TAG] ~= nil then
        self:SetTeamSummonerId(tonumber(data[PredefineConstants.PREDEFINE_SUMMONER_ID_TAG]))
    else
        self:SetTeamSummonerId(0)
    end

    self:SetTeamLevelId(tonumber(data[PredefineConstants.PREDEFINE_TEAM_LEVEL_ID_TAG]))

    self:SetTeamStarId(tonumber(data[PredefineConstants.PREDEFINE_TEAM_STAR_ID_TAG]))

    self:SetTeamItemId(tonumber(data[PredefineConstants.PREDEFINE_TEAM_ITEM_ID_TAG]))

    self:SetTeamMasteryId(tonumber(data[PredefineConstants.PREDEFINE_TEAM_MASTERY_ID_TAG]))

    if data[PredefineConstants.PREDEFINE_BOSS_SLOT_ID_TAG] ~= nil then
        self:SetBossSlotId(tonumber(data[PredefineConstants.PREDEFINE_BOSS_SLOT_ID_TAG]))
    else
        self:SetBossSlotId(PredefineConstants.NON_BOSS_SLOT)
    end

    for i = 1, BattleConstants.NUMBER_SLOT do
        self.heroList:Add(i, tonumber(data[PredefineConstants.PREDEFINE_HERO_SLOT_TAG .. i]))
    end
end

--- @return PredefineTeamData
--- @param buffer UnifiedNetwork_ByteBuf
function PredefineTeamData.CreateByBuffer(buffer)
    local teamData = PredefineTeamData()
    teamData:ReadBuffer(buffer)
    return teamData
end

--- @return PredefineTeamData
--- @param json string
function PredefineTeamData.CreateByJson(json)
    local teamData = PredefineTeamData()
    teamData:ParseJson(json)
    return teamData
end

--- @return PredefineTeamData
--- @param data string
function PredefineTeamData.CreateByCsv(data)
    local teamData = PredefineTeamData()
    teamData:ParseCsv(data)
    return teamData
end