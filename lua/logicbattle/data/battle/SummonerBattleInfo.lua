--- @class SummonerBattleInfo
SummonerBattleInfo = Class(SummonerBattleInfo)

--- @return void
function SummonerBattleInfo:Ctor()
    --- @type number
    self.summonerId = nil
    --- @type number
    self.teamId = nil
    --- @type number
    self.star = nil
    --- @type number
    self.level = nil

    ---@type List List<number>
    self.skills = List()

    --- @type Dictionary Dictionary<number, number> key = HeroItemSlot
    self.items = Dictionary()

    ---@type boolean
    self.isDummy = false

    --- @type boolean
    self.isSummoner = true
end

---@return void
---@param teamId number
function SummonerBattleInfo:SetTeamId(teamId)
    self.teamId = teamId
end

---------------------------------------- Setters ----------------------------------------
---@return void
---@param teamId number
---@param summonerId number
---@param star number
---@param level number
function SummonerBattleInfo:SetInfo(teamId, summonerId, star, level)
    self.summonerId = summonerId
    self.teamId = teamId
    self.star = star
    self.level = level
    self:ValidateAfterSet()
end

--- @return void
--- @param skill1 number
--- @param skill2 number
--- @param skill3 number
--- @param skill4 number
function SummonerBattleInfo:SetSkills(skill1, skill2, skill3, skill4)
    self.skills = List()
    self.skills:Add(skill1)
    self.skills:Add(skill2)
    self.skills:Add(skill3)
    self.skills:Add(skill4)
end

--- @return void
--- @param skillList List<number>
function SummonerBattleInfo:SetSkillList(skillList)
    self.skills = List()
    self.skills:AddAll(skillList)
end

--- @return void
function SummonerBattleInfo:SetDummy(isDummy)
    self.isDummy = isDummy
end

function SummonerBattleInfo:ValidateAfterSet()
    if MathUtils.IsNumber(self.summonerId) == false or self.summonerId < 0 then
        assert(false)
    end

    if MathUtils.IsNumber(self.teamId) == false or self.teamId < 0 then
        assert(false)
    end

    if MathUtils.IsNumber(self.star) == false or self.star < 0 then
        assert(false)
    end

    if self.isDummy == false then
        if MathUtils.IsNumber(self.level) == false or self.level < 0 then
            assert(false)
        end
    end
end

------------------------------------------CSV----------------------------------------------------
--- @return void
--- @param data string
function SummonerBattleInfo:ParseCsv(data)
    self:ValidateBeforeParseCsv(data)

    self.summonerId = tonumber(data.hero_id)
    self.teamId = tonumber(data.team_id)
    self.star = tonumber(data.star)
    self.level = tonumber(data.level)

    for i = 1, ItemConstants.NUMBER_EQUIPMENT_SLOT do
        local itemId
        if data[ItemConstants.ITEM_TAG .. i] ~= nil then
            itemId = tonumber(data[ItemConstants.ITEM_TAG .. i])
        else
            itemId = ItemConstants.NO_EQUIPMENT
        end
        self.items:Add(i, itemId)
    end

    for i = 1, SkillConstants.NUMBER_SKILL do
        if data[SkillConstants.SUMMONER_SKILL_TAG .. i] == nil then
            assert(false)
        end

        local level = tonumber(data[SkillConstants.SUMMONER_SKILL_TAG .. i])

        if self.summonerId == HeroConstants.SUMMONER_NOVICE_ID then
            if level ~= self.star then
                assert(false)
            end
        end

        self.skills:Add(tonumber(level))
    end

    self:ValidateAfterSet()
end

function SummonerBattleInfo:ValidateBeforeParseCsv(data)
    if data.hero_id == nil then
        assert(false)
    end

    if data.team_id == nil then
        assert(data.team_id ~= nil)
    end

    if data.star == nil then
        assert(data.star ~= nil)
    end

    if data.level == nil then
        assert(data.level ~= nil)
    end
end

-------------------------------------IN BATTLE-----------------------------------------
--- @return BaseHero
function SummonerBattleInfo:CreateSummoner()
    local summonerLuaFile
    if self.summonerId == nil or self.summonerId == HeroConstants.SUMMONER_NOVICE_ID then
        summonerLuaFile = require(LuaPathConstants.SUMMONER_NOVICE_PATH)
    else
        summonerLuaFile = require(string.format(LuaPathConstants.SUMMONER_PATH, self.summonerId, self.summonerId))
    end

    local summoner = summonerLuaFile:CreateInstance()
    self:FillData(summoner)

    return summoner
end

--- @return BaseHero
---@param baseHero BaseHero
function SummonerBattleInfo:FillData(baseHero)
    baseHero.id = self.summonerId
    baseHero.teamId = self.teamId

    baseHero.star = self.star
    baseHero.level = self.level

    baseHero.isBoss = false
    baseHero.isSummoner = true
    baseHero.isDummy = self.isDummy

    baseHero.positionInfo:SetPosition(false, 1)

    for i = 1, self.skills:Count() do
        baseHero.skillLevels:Add(self.skills:Get(i))
    end
end